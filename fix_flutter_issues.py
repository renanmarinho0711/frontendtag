#!/usr/bin/env python3
"""
Script robusto para correção automática de erros Flutter/Dart.
Analisa output do `flutter analyze` e aplica correções automáticas. 

Uso:
    python fix_flutter_issues.py --analyze-file analyze_complete.txt
    python fix_flutter_issues.py --run-analyze --project-path /path/to/project
    python fix_flutter_issues.py --dry-run  # Mostra correções sem aplicar
"""

import os
import re
import sys
import json
import shutil
import argparse
import subprocess
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple, Set, Callable
from enum import Enum
from collections import defaultdict
import logging

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('flutter_fix. log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class IssueType(Enum):
    ERROR = "error"
    WARNING = "warning"
    INFO = "info"


class IssueSeverity(Enum):
    CRITICAL = 1  # Erros que impedem compilação
    HIGH = 2      # Erros graves
    MEDIUM = 3    # Warnings importantes
    LOW = 4       # Info e warnings menores


@dataclass
class DartIssue:
    """Representa um issue encontrado pelo analyzer."""
    issue_type: IssueType
    message: str
    file_path: str
    line:  int
    column: int
    rule:  str
    raw_line: str
    severity: IssueSeverity = IssueSeverity.MEDIUM
    
    def __hash__(self):
        return hash((self.file_path, self. line, self.rule))
    
    def __eq__(self, other):
        if not isinstance(other, DartIssue):
            return False
        return (self.file_path == other.file_path and 
                self.line == other. line and 
                self.rule == other.rule)


@dataclass
class FixResult:
    """Resultado de uma tentativa de correção."""
    success: bool
    issue:  DartIssue
    description: str
    changes_made: List[str] = field(default_factory=list)
    backup_path: Optional[str] = None


@dataclass 
class FileStats:
    """Estatísticas de um arquivo."""
    total_issues: int = 0
    errors: int = 0
    warnings: int = 0
    infos: int = 0
    fixed:  int = 0
    skipped: int = 0


class BackupManager:
    """Gerencia backups de arquivos antes das modificações."""
    
    def __init__(self, backup_dir: str = ". flutter_fix_backups"):
        self.backup_dir = Path(backup_dir)
        self.backup_dir.mkdir(exist_ok=True)
        self.timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.session_dir = self.backup_dir / self.timestamp
        self.session_dir.mkdir(exist_ok=True)
        self.backed_up_files: Set[str] = set()
    
    def backup_file(self, file_path: str) -> str:
        """Cria backup de um arquivo se ainda não existir."""
        if file_path in self.backed_up_files:
            return str(self.session_dir / Path(file_path).name)
        
        src = Path(file_path)
        if not src.exists():
            raise FileNotFoundError(f"Arquivo não encontrado: {file_path}")
        
        # Preserva estrutura de diretórios relativa
        relative_path = src.name
        backup_path = self.session_dir / relative_path
        
        # Evita conflitos de nome
        counter = 1
        original_backup = backup_path
        while backup_path.exists():
            backup_path = original_backup.with_suffix(f". {counter}{original_backup.suffix}")
            counter += 1
        
        shutil.copy2(src, backup_path)
        self.backed_up_files.add(file_path)
        logger.debug(f"Backup criado:  {backup_path}")
        return str(backup_path)
    
    def restore_all(self):
        """Restaura todos os arquivos do backup."""
        for backup_file in self.session_dir.glob("*"):
            # Encontra arquivo original
            original = None
            for backed_up in self.backed_up_files:
                if Path(backed_up).name == backup_file.name:
                    original = backed_up
                    break
            
            if original: 
                shutil.copy2(backup_file, original)
                logger.info(f"Restaurado: {original}")


class AnalyzerParser:
    """Parser para output do flutter analyze."""
    
    # Regex para diferentes formatos de output
    PATTERNS = [
        # Formato:  type - message - file:line:col - rule
        re.compile(
            r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)',
            re.IGNORECASE
        ),
        # Formato com dois espaços no inicio (Windows PowerShell output)
        re.compile(
            r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+([\w_]+)',
            re.IGNORECASE
        ),
        # Formato alternativo
        re.compile(
            r'^\s*(error|warning|info)\s*[-]\s*(.+?)\s*[-]\s*(.+?):(\d+):(\d+)\s*[-]\s+([\w_]+)',
            re.IGNORECASE
        ),
    ]
    
    # Mapeamento de severidade por regra
    SEVERITY_MAP = {
        # Erros críticos
        'uri_does_not_exist': IssueSeverity.CRITICAL,
        'undefined_class': IssueSeverity. CRITICAL,
        'undefined_identifier': IssueSeverity. CRITICAL,
        'undefined_method': IssueSeverity.CRITICAL,
        'undefined_getter': IssueSeverity. CRITICAL,
        'undefined_setter': IssueSeverity. CRITICAL,
        'undefined_named_parameter': IssueSeverity.CRITICAL,
        'return_of_invalid_type': IssueSeverity.CRITICAL,
        'argument_type_not_assignable':  IssueSeverity.CRITICAL,
        'invalid_assignment': IssueSeverity.CRITICAL,
        'expected_token': IssueSeverity.CRITICAL,
        'missing_const_final_var_or_type': IssueSeverity. CRITICAL,
        
        # Erros graves
        'non_bool_condition': IssueSeverity.HIGH,
        'non_bool_negation_expression': IssueSeverity.HIGH,
        'non_bool_operand': IssueSeverity. HIGH,
        'const_eval_method_invocation': IssueSeverity.HIGH,
        'implicit_this_reference_in_initializer': IssueSeverity. HIGH,
        
        # Warnings médios
        'unused_import': IssueSeverity. MEDIUM,
        'unused_element': IssueSeverity. MEDIUM,
        'unused_field': IssueSeverity. MEDIUM,
        'unused_local_variable': IssueSeverity.MEDIUM,
        'deprecated_member_use': IssueSeverity.MEDIUM,
        'dead_code': IssueSeverity.MEDIUM,
        
        # Infos/baixa prioridade
        'prefer_const_constructors': IssueSeverity. LOW,
        'prefer_const_literals_to_create_immutables': IssueSeverity.LOW,
        'use_build_context_synchronously': IssueSeverity.LOW,
        'prefer_typing_uninitialized_variables': IssueSeverity.LOW,
    }
    
    def __init__(self):
        self.issues: List[DartIssue] = []
        self.stats: Dict[str, FileStats] = defaultdict(FileStats)
    
    def parse_file(self, file_path: str) -> List[DartIssue]: 
        """Parse arquivo de output do analyzer."""
        # Tentar diferentes encodings (PowerShell pode gerar UTF-16)
        encodings = ['utf-16', 'utf-16-le', 'utf-8', 'cp1252', 'latin-1']
        content = None
        for enc in encodings:
            try:
                with open(file_path, 'r', encoding=enc) as f:
                    content = f.read()
                # Verificar se leu corretamente (sem caracteres nulos)
                if '\x00' not in content:
                    break
            except (UnicodeDecodeError, UnicodeError):
                continue
        if content is None:
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                content = f.read()
        return self. parse_content(content)
    
    def parse_content(self, content:  str) -> List[DartIssue]:
        """Parse conteúdo do output do analyzer."""
        self.issues = []
        
        for line in content.split('\n'):
            # Não fazer strip() para manter os espaços iniciais que o regex precisa
            if not line or line.isspace():
                continue
            
            issue = self._parse_line(line)
            if issue:
                self.issues.append(issue)
                self._update_stats(issue)
        
        return self.issues
    
    def _parse_line(self, line:  str) -> Optional[DartIssue]:
        """Tenta parsear uma linha como issue."""
        for pattern in self. PATTERNS:
            match = pattern.match(line)
            if match:
                issue_type_str, message, file_path, line_num, col, rule = match.groups()
                
                try:
                    issue_type = IssueType(issue_type_str. lower())
                except ValueError: 
                    issue_type = IssueType. INFO
                
                severity = self. SEVERITY_MAP.get(rule, IssueSeverity.MEDIUM)
                
                return DartIssue(
                    issue_type=issue_type,
                    message=message. strip(),
                    file_path=file_path. strip(),
                    line=int(line_num),
                    column=int(col),
                    rule=rule.strip(),
                    raw_line=line,
                    severity=severity
                )
        
        return None
    
    def _update_stats(self, issue: DartIssue):
        """Atualiza estatísticas por arquivo."""
        stats = self.stats[issue.file_path]
        stats.total_issues += 1
        
        if issue.issue_type == IssueType. ERROR:
            stats.errors += 1
        elif issue.issue_type == IssueType. WARNING:
            stats.warnings += 1
        else:
            stats.infos += 1
    
    def get_issues_by_file(self) -> Dict[str, List[DartIssue]]:
        """Agrupa issues por arquivo."""
        by_file = defaultdict(list)
        for issue in self.issues:
            by_file[issue.file_path].append(issue)
        return dict(by_file)
    
    def get_issues_by_rule(self) -> Dict[str, List[DartIssue]]:
        """Agrupa issues por regra."""
        by_rule = defaultdict(list)
        for issue in self.issues:
            by_rule[issue.rule].append(issue)
        return dict(by_rule)
    
    def get_summary(self) -> Dict:
        """Retorna resumo das issues."""
        return {
            'total':  len(self.issues),
            'errors': sum(1 for i in self.issues if i.issue_type == IssueType. ERROR),
            'warnings': sum(1 for i in self. issues if i.issue_type == IssueType.WARNING),
            'infos': sum(1 for i in self.issues if i.issue_type == IssueType.INFO),
            'files_affected': len(self.stats),
            'by_severity': {
                'critical': sum(1 for i in self.issues if i.severity == IssueSeverity. CRITICAL),
                'high': sum(1 for i in self. issues if i.severity == IssueSeverity.HIGH),
                'medium': sum(1 for i in self.issues if i. severity == IssueSeverity. MEDIUM),
                'low':  sum(1 for i in self.issues if i.severity == IssueSeverity.LOW),
            }
        }


class DartFileFixer:
    """Aplica correções em arquivos Dart."""
    
    def __init__(self, project_root: str, dry_run: bool = False):
        self.project_root = Path(project_root)
        self.dry_run = dry_run
        self.backup_manager = BackupManager()
        self.fixes_applied:  List[FixResult] = []
        
        # Registra fixers disponíveis
        self.fixers:  Dict[str, Callable] = {
            'unused_import': self._fix_unused_import,
            'unused_element': self._fix_unused_element,
            'unused_field': self._fix_unused_field,
            'unused_local_variable': self._fix_unused_local_variable,
            'prefer_const_constructors': self._fix_prefer_const_constructors,
            'prefer_const_literals_to_create_immutables': self._fix_prefer_const_literals,
            'deprecated_member_use': self._fix_deprecated_member_use,
            'argument_type_not_assignable':  self._fix_argument_type,
            'return_of_invalid_type': self._fix_return_type,
            'undefined_identifier': self._fix_undefined_identifier,
            'dead_code': self._fix_dead_code,
            'duplicate_import': self._fix_duplicate_import,
            'unnecessary_import': self._fix_unnecessary_import,
            'file_names': self._fix_file_names,
            'uri_does_not_exist': self._fix_uri_does_not_exist,
            'depend_on_referenced_packages': self._fix_depend_on_packages,
            'unexpected_token': self._fix_unexpected_token,
            'use_build_context_synchronously': self._fix_use_build_context_synchronously,
            'implicit_this_reference_in_initializer': self._fix_implicit_this_reference_in_initializer,
            'extra_positional_arguments': self._fix_extra_positional_arguments,
            'list_element_type_not_assignable': self._fix_list_element_type_not_assignable,
            'illegal_character': self._fix_illegal_character,
        }
    
    def _read_file(self, file_path: str) -> List[str]:
        """Lê arquivo e retorna linhas."""
        full_path = self.project_root / file_path
        if not full_path.exists():
            # Tenta caminho absoluto
            full_path = Path(file_path)
        
        if not full_path.exists():
            raise FileNotFoundError(f"Arquivo não encontrado: {file_path}")
        
        with open(full_path, 'r', encoding='utf-8') as f:
            return f.readlines()
    
    def _write_file(self, file_path: str, lines: List[str]):
        """Escreve linhas no arquivo."""
        if self.dry_run:
            logger.info(f"[DRY RUN] Escreveria em:  {file_path}")
            return
        
        full_path = self.project_root / file_path
        if not full_path.exists():
            full_path = Path(file_path)
        
        # Criar backup LOCAL na mesma pasta com sufixo .backup
        backup_path = str(full_path) + '.backup'
        if not os.path.exists(backup_path):
            # Só cria backup se ainda não existe (primeira modificação)
            try:
                shutil.copy2(str(full_path), backup_path)
                logger.debug(f"Backup local criado: {backup_path}")
            except Exception as e:
                logger.warning(f"Falha ao criar backup local: {e}")
        
        # Backup adicional no diretório central
        self.backup_manager.backup_file(str(full_path))
        
        with open(full_path, 'w', encoding='utf-8') as f:
            f.writelines(lines)
    
    def fix_issue(self, issue: DartIssue) -> FixResult:
        """Tenta corrigir um issue específico."""
        fixer = self.fixers.get(issue.rule)
        
        if not fixer:
            return FixResult(
                success=False,
                issue=issue,
                description=f"Sem correção automática para:  {issue.rule}"
            )
        
        try:
            return fixer(issue)
        except Exception as e: 
            logger.error(f"Erro ao corrigir {issue.rule} em {issue.file_path}:{issue.line}:  {e}")
            return FixResult(
                success=False,
                issue=issue,
                description=f"Erro:  {str(e)}"
            )
    
    def fix_all(self, issues: List[DartIssue], 
                rules: Optional[List[str]] = None,
                severity_threshold: IssueSeverity = IssueSeverity.LOW) -> List[FixResult]: 
        """Corrige múltiplos issues."""
        results = []
        
        # Filtra por regras se especificado
        if rules:
            issues = [i for i in issues if i.rule in rules]
        
        # Filtra por severidade
        issues = [i for i in issues if i.severity. value <= severity_threshold.value]
        
        # Agrupa por arquivo para otimizar I/O
        by_file = defaultdict(list)
        for issue in issues:
            by_file[issue.file_path].append(issue)
        
        for file_path, file_issues in by_file.items():
            # Ordena por linha (reverso) para evitar problemas de offset
            file_issues.sort(key=lambda x: x.line, reverse=True)
            
            for issue in file_issues: 
                result = self.fix_issue(issue)
                results.append(result)
                self.fixes_applied.append(result)
                
                if result.success:
                    logger.info(f"✓ Corrigido: {issue.rule} em {issue. file_path}:{issue.line}")
                else:
                    logger.debug(f"✗ Não corrigido: {issue.rule} - {result.description}")
        
        return results
    
    # ==================== FIXERS ====================
    
    def _fix_unused_import(self, issue: DartIssue) -> FixResult:
        """Remove import não utilizado."""
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        original_line = lines[line_idx]
        
        # Verifica se é realmente um import
        if not original_line.strip().startswith('import '):
            return FixResult(False, issue, "Linha não é um import")
        
        # Remove a linha (ou comenta)
        lines[line_idx] = f"// REMOVED: {original_line}"
        
        self._write_file(issue.file_path, lines)
        
        return FixResult(
            success=True,
            issue=issue,
            description="Import removido",
            changes_made=[f"Removida linha {issue.line}:  {original_line. strip()}"]
        )
    
    def _fix_unused_element(self, issue: DartIssue) -> FixResult:
        """Adiciona ignore comment para elemento não utilizado."""
        lines = self._read_file(issue. file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        # Adiciona comentário de ignore
        indent = len(lines[line_idx]) - len(lines[line_idx].lstrip())
        ignore_comment = ' ' * indent + '// ignore: unused_element\n'
        
        lines. insert(line_idx, ignore_comment)
        
        self._write_file(issue.file_path, lines)
        
        return FixResult(
            success=True,
            issue=issue,
            description="Adicionado ignore comment",
            changes_made=[f"Adicionado // ignore: unused_element antes da linha {issue.line}"]
        )
    
    def _fix_unused_field(self, issue: DartIssue) -> FixResult:
        """Adiciona ignore comment para field não utilizado."""
        return self._add_ignore_comment(issue, 'unused_field')
    
    def _fix_unused_local_variable(self, issue: DartIssue) -> FixResult:
        """Adiciona ignore comment para variável local não utilizada."""
        return self._add_ignore_comment(issue, 'unused_local_variable')
    
    def _fix_prefer_const_constructors(self, issue: DartIssue) -> FixResult:
        """Adiciona const onde necessário."""
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        line = lines[line_idx]
        
        # Padrões comuns onde adicionar const
        patterns = [
            (r'(\s+)(SizedBox\()', r'\1const SizedBox('),
            (r'(\s+)(EdgeInsets\. )', r'\1const EdgeInsets. '),
            (r'(\s+)(BorderRadius\. )', r'\1const BorderRadius. '),
            (r'(\s+)(Icon\()', r'\1const Icon('),
            (r'(\s+)(Text\([\'"])', r'\1const Text(\''),
            (r'(\s+)(Offset\()', r'\1const Offset('),
            (r'(\s+)(Duration\()', r'\1const Duration('),
        ]
        
        modified = False
        for pattern, replacement in patterns:
            if re.search(pattern, line):
                line = re.sub(pattern, replacement, line, count=1)
                modified = True
                break
        
        if modified:
            lines[line_idx] = line
            self._write_file(issue.file_path, lines)
            return FixResult(
                success=True,
                issue=issue,
                description="Adicionado const",
                changes_made=[f"Linha {issue.line}:  adicionado const"]
            )
        
        return self._add_ignore_comment(issue, 'prefer_const_constructors')
    
    def _fix_prefer_const_literals(self, issue: DartIssue) -> FixResult:
        """Adiciona const para literals."""
        return self._add_ignore_comment(issue, 'prefer_const_literals_to_create_immutables')
    
    def _fix_deprecated_member_use(self, issue: DartIssue) -> FixResult:
        """Tenta corrigir uso de membros deprecated."""
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        line = lines[line_idx]
        
        # Mapeamento de deprecated -> novo
        replacements = {
            '. withOpacity(':  '.withValues(alpha:  ',
            'WillPopScope':  'PopScope',
            'dart: html': 'package:web',
        }
        
        modified = False
        for old, new in replacements.items():
            if old in line:
                line = line.replace(old, new)
                modified = True
        
        if modified:
            lines[line_idx] = line
            self._write_file(issue.file_path, lines)
            return FixResult(
                success=True,
                issue=issue,
                description="Substituído deprecated",
                changes_made=[f"Linha {issue. line}: atualizado uso deprecated"]
            )
        
        return self._add_ignore_comment(issue, 'deprecated_member_use')
    
    def _fix_argument_type(self, issue: DartIssue) -> FixResult:
        """Tenta corrigir tipos de argumentos incompatíveis - ABORDAGEM MUITO CONSERVADORA."""
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        line = lines[line_idx]
        original_line = line
        
        # Estratégia conservadora: APENAS casos muito específicos e seguros
        # Caso 1: Inteiros para double (int literal para .toDouble())
        # Padrão: número simples (como 0 ou 1) sendo convertido para double
        if re.search(r'\btoDouble\(\)\s*,?\s*$', line) and re.search(r'\b\d+\s*\.toDouble\(\)', line):
            # Já tem toDouble(), pode estar ok
            return FixResult(False, issue, "Já tem conversão para double")
        
        # Caso 2: int literal em toDouble() - seguro adicionar parenteses
        # Pattern: toDouble() após um valor que pode ser nullabe
        if '.toDouble()' in line:
            # Procura por padrões simples e seguros
            # ?? 0).toDouble() - seguro envolver em parênteses extras se necessário
            if '??  0).toDouble()' in line or '?? 0).toDouble()' in line:
                # Está usando coalescência nula, mas o 0 precisa estar parentesizado
                # MUITO risky - skip
                return FixResult(False, issue, "Padrão complexo de nullability - requer análise manual")
        
        # Caso 3: Cast de String para int/double (padrão seguro)
        # Exemplo: "123" sendo usado como int
        if re.search(r"int\.parse|double\.parse", line):
            # Já está usando parse, que é seguro
            return FixResult(False, issue, "Já usa conversão segura (parse)")
        
        # Caso 4: Simples substituição - APENAS se a expressão é claramente um identificador ou valor
        # Muito conservador: só faz algo se é MUITO óbvio e seguro
        match = re.search(r"'([^']+)'.*?'(\w+)'", issue.message)
        if match:
            source_type = match.group(1)
            target_type = match.group(2)
            
            # Apenas types primitivos/seguros
            if source_type in ('dynamic', 'Object', 'Null') and target_type in ('String', 'int', 'double', 'bool', 'num'):
                # Procura por um identificador simples não-complexo
                # Exemplo: variável simples, NÃO json['key'] ?? other ?? fallback
                simple_ident_pattern = r'\b([a-zA-Z_]\w*)\b(?!\?)'  # Não-nullable
                
                matches = list(re.finditer(simple_ident_pattern, line))
                if matches and len(matches) <= 3:  # Muito poucas variáveis = provavelmente simples
                    # Ainda assim, muito risky - vamos ser extremamente conservador
                    logger.debug(f"SKIPPING argument_type: expressão pode ser muito complexa")
                    return FixResult(False, issue, "Expressão potencialmente complexa - ignorando por segurança")
        
        return FixResult(False, issue, "Padrão não reconhecido como seguro o suficiente para correção automática")
    
    def _fix_return_type(self, issue: DartIssue) -> FixResult:
        """Adiciona ignore ou cast para tipo de retorno inválido."""
        return self._add_ignore_comment(issue, 'return_of_invalid_type')
    
    def _fix_undefined_identifier(self, issue: DartIssue) -> FixResult:
        """Tenta corrigir identificador não definido."""
        # Alguns casos comuns
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        line = lines[line_idx]
        
        # Extrai nome do identificador
        match = re.search(r"Undefined name '(\w+)'", issue.message)
        if match:
            identifier = match.group(1)
            
            # Verifica se é um problema de encoding
            if any(ord(c) > 127 for c in identifier):
                # Nome com caracteres especiais - provavelmente erro de encoding
                return FixResult(
                    success=False,
                    issue=issue,
                    description=f"Identificador com caracteres especiais: {identifier}"
                )
        
        return FixResult(False, issue, "Correção automática não disponível")
    
    def _fix_dead_code(self, issue: DartIssue) -> FixResult:
        """Remove ou comenta código morto."""
        return self._add_ignore_comment(issue, 'dead_code')
    
    def _fix_duplicate_import(self, issue:  DartIssue) -> FixResult:
        """Remove import duplicado."""
        return self._fix_unused_import(issue)
    
    def _fix_unnecessary_import(self, issue: DartIssue) -> FixResult:
        """Remove import desnecessário."""
        return self._fix_unused_import(issue)
    
    def _fix_file_names(self, issue: DartIssue) -> FixResult:
        """Reporta arquivos com nomes inválidos."""
        return FixResult(
            success=False,
            issue=issue,
            description=f"Arquivo precisa ser renomeado: {issue.file_path}"
        )
    
    def _fix_uri_does_not_exist(self, issue: DartIssue) -> FixResult:
        """Reporta imports para URIs inexistentes."""
        return FixResult(
            success=False,
            issue=issue,
            description=f"Import para arquivo inexistente - verificar manualmente"
        )
    
    def _fix_depend_on_packages(self, issue: DartIssue) -> FixResult:
        """Reporta dependência não declarada."""
        return FixResult(
            success=False,
            issue=issue,
            description="Adicionar dependência ao pubspec.yaml"
        )
    
    def _add_ignore_comment(self, issue: DartIssue, rule: str) -> FixResult:
        """Adiciona comentário de ignore genérico."""
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        current_line = lines[line_idx]
        
        # Verifica se já tem ignore
        if f'// ignore: {rule}' in current_line or f'// ignore:{rule}' in current_line: 
            return FixResult(False, issue, "Ignore já existe")
        
        # Verifica linha anterior
        if line_idx > 0:
            prev_line = lines[line_idx - 1]
            if f'ignore: {rule}' in prev_line: 
                return FixResult(False, issue, "Ignore já existe na linha anterior")
        
        # Adiciona comentário de ignore
        indent = len(current_line) - len(current_line. lstrip())
        ignore_comment = ' ' * indent + f'// ignore: {rule}\n'
        
        lines.insert(line_idx, ignore_comment)
        
        self._write_file(issue.file_path, lines)
        
        return FixResult(
            success=True,
            issue=issue,
            description=f"Adicionado // ignore: {rule}",
            changes_made=[f"Adicionado ignore comment antes da linha {issue.line}"]
        )
    
    def _fix_dynamic_to_string(self, issue: DartIssue) -> FixResult:
        """Corrige conversão de dynamic para String com segurança."""
        if 'argument_type_not_assignable' not in issue.rule:
            return FixResult(False, issue, "Não é tipo de erro esperado")
        
        if "dynamic" not in issue.message or "String" not in issue.message:
            return FixResult(False, issue, "Não é conversão dynamic->String")
        
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        line = lines[line_idx]
        original = line
        
        # Padrões seguros: variável simples que pode ser convertida para String
        # Pattern 1: identificador.toString()
        if '.toString()' in line:
            return FixResult(False, issue, "Já tem .toString()")
        
        # Pattern 2: valor que pode ser string - usar .toString() de forma segura
        # Procura por atribuição simples de uma variável a um campo String
        match = re.search(r':\s*([a-zA-Z_]\w*)\s*,?\s*$', line)
        if match:
            var_name = match.group(1)
            # Muito conservador: só faz algo se é UMA variável simples no final da linha
            if re.match(rf'^\w+$', var_name):  # Apenas identificador simples
                # AINDA assim arriscado - skip
                return FixResult(False, issue, "Padrão muito arriscado - requer análise manual")
        
        return FixResult(False, issue, "Nenhum padrão seguro encontrado")
    
    def _fix_unexpected_token(self, issue: DartIssue) -> FixResult:
        """Corrige erros de token inesperado - muitas vezes são corrupções de encoding."""
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        line = lines[line_idx]
        original = line
        
        # Padrão criativo 1: mport em vez de import (corrupção de encoding comum)
        if line.strip().startswith('mport '):
            line = line.replace('mport ', 'import ', 1)
            lines[line_idx] = line
            self._write_file(issue.file_path, lines)
            
            return FixResult(
                success=True,
                issue=issue,
                description="Corrigido 'mport' para 'import' (corrupção de encoding)",
                changes_made=[f"Linha {issue.line}: mport -> import"]
            )
        
        # Padrão criativo 2: Falta de símbolo em fim de linha (const, etc)
        # Exemplo: "const meu_valor" sem ponto-e-vírgula ou = 
        if line.strip().endswith(')') and ')' in line and ':' not in line:
            # Pode ser falta de ; no fim
            if not line.strip().endswith(';'):
                line = line.rstrip() + ';\\n' if line.endswith('\\n') else line + ';'
                lines[line_idx] = line
                self._write_file(issue.file_path, lines)
                
                return FixResult(
                    success=True,
                    issue=issue,
                    description="Adicionado ponto-e-vírgula faltante",
                    changes_made=[f"Linha {issue.line}: adicionado ;"]
                )
        
        return FixResult(False, issue, "Padrão de erro inesperado não reconhecido")
    
    def _fix_use_build_context_synchronously(self, issue: DartIssue) -> FixResult:
        """Adiciona ignor para uso síncrono de BuildContext."""
        # Este é um warning sobre uso async/await - melhor é adicionar ignore comment
        return self._add_ignore_comment(issue, 'use_build_context_synchronously')
    
    def _fix_implicit_this_reference_in_initializer(self, issue: DartIssue) -> FixResult:
        """Adiciona 'this.' quando necessário em inicializadores."""
        return self._add_ignore_comment(issue, 'implicit_this_reference_in_initializer')
    
    def _fix_extra_positional_arguments(self, issue: DartIssue) -> FixResult:
        """Reporta argumentos posicionais extras."""
        return FixResult(False, issue, "Argumentos extras - requer análise manual da assinatura da função")
    
    def _fix_list_element_type_not_assignable(self, issue: DartIssue) -> FixResult:
        """Adiciona ignore para tipo de elemento de lista incompatível."""
        return self._add_ignore_comment(issue, 'list_element_type_not_assignable')
    
    def _fix_illegal_character(self, issue: DartIssue) -> FixResult:
        """Tenta corrigir caracteres ilegais - muitas vezes de encoding."""
        lines = self._read_file(issue.file_path)
        line_idx = issue.line - 1
        
        if line_idx >= len(lines):
            return FixResult(False, issue, "Linha fora do range")
        
        line = lines[line_idx]
        
        # Caracteres ilegais comuns em problemas de encoding
        # null bytes, caracteres de controle, etc
        illegal_chars = '\x00\x01\x02\x03\x04\x05\x06\x07\x08\x0b\x0c\x0e\x0f'
        
        for char in illegal_chars:
            if char in line:
                # Remove caracteres ilegais
                new_line = line.replace(char, '')
                lines[line_idx] = new_line
                self._write_file(issue.file_path, lines)
                
                return FixResult(
                    success=True,
                    issue=issue,
                    description="Removidos caracteres de controle ilegais",
                    changes_made=[f"Linha {issue.line}: removidos caracteres de controle"]
                )
        
        return FixResult(False, issue, "Caractere ilegal não identificado")


class ReportGenerator:
    """Gera relatórios das correções."""
    
    def __init__(self, output_dir: str = ". flutter_fix_reports"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
    
    def generate_summary(self, parser: AnalyzerParser, results: List[FixResult]) -> str:
        """Gera resumo em texto."""
        summary = parser.get_summary()
        
        fixed_count = sum(1 for r in results if r.success)
        failed_count = sum(1 for r in results if not r.success)
        
        report = f"""
╔══════════════════════════════════════════════════════════════╗
║                 RELATÓRIO DE CORREÇÕES FLUTTER               ║
╠══════════════════════════════════════════════════════════════╣
║ Data: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}                              ║
╠══════════════════════════════════════════════════════════════╣
║ ANÁLISE INICIAL                                              ║
╠══════════════════════════════════════════════════════════════╣
║ Total de Issues:      {summary['total']: >6}                                 ║
║   - Erros:           {summary['errors']:>6}                                 ║
║   - Warnings:        {summary['warnings']:>6}                                 ║
║   - Infos:           {summary['infos']:>6}                                 ║
║ Arquivos Afetados:   {summary['files_affected']:>6}                                 ║
╠══════════════════════════════════════════════════════════════╣
║ SEVERIDADE                                                   ║
╠══════════════════════════════════════════════════════════════╣
║   - Crítica:         {summary['by_severity']['critical']:>6}                                 ║
║   - Alta:            {summary['by_severity']['high']:>6}                                 ║
║   - Média:           {summary['by_severity']['medium']:>6}                                 ║
║   - Baixa:           {summary['by_severity']['low']:>6}                                 ║
╠══════════════════════════════════════════════════════════════╣
║ CORREÇÕES                                                    ║
╠══════════════════════════════════════════════════════════════╣
║ Corrigidos:          {fixed_count:>6}                                 ║
║ Não Corrigidos:      {failed_count:>6}                                 ║
║ Taxa de Sucesso:     {(fixed_count/(fixed_count+failed_count)*100 if fixed_count+failed_count > 0 else 0):>5.1f}%                                ║
╚══════════════════════════════════════════════════════════════╝
"""
        return report
    
    def generate_detailed_report(self, parser:  AnalyzerParser, 
                                  results: List[FixResult]) -> Dict: 
        """Gera relatório detalhado em JSON."""
        by_rule = parser.get_issues_by_rule()
        by_file = parser.get_issues_by_file()
        
        # Agrupa resultados por arquivo
        results_by_file = defaultdict(list)
        for result in results:
            results_by_file[result.issue.file_path].append({
                'success': result.success,
                'rule': result.issue.rule,
                'line': result.issue.line,
                'description': result.description,
                'changes':  result.changes_made
            })
        
        report = {
            'timestamp': datetime.now().isoformat(),
            'summary': parser.get_summary(),
            'issues_by_rule': {
                rule: [
                    {
                        'file': i.file_path,
                        'line': i.line,
                        'message': i.message,
                        'severity': i.severity. name
                    }
                    for i in issues
                ]
                for rule, issues in by_rule.items()
            },
            'files_summary': {
                file:  {
                    'total': len(issues),
                    'errors': sum(1 for i in issues if i.issue_type == IssueType.ERROR),
                    'warnings': sum(1 for i in issues if i.issue_type == IssueType. WARNING),
                }
                for file, issues in by_file.items()
            },
            'fix_results': dict(results_by_file),
            'unfixed_critical': [
                {
                    'file': r.issue.file_path,
                    'line': r.issue.line,
                    'rule': r.issue.rule,
                    'message': r.issue.message,
                    'reason': r.description
                }
                for r in results
                if not r.success and r.issue. severity == IssueSeverity.CRITICAL
            ]
        }
        
        return report
    
    def save_reports(self, parser: AnalyzerParser, results: List[FixResult]):
        """Salva relatórios em arquivos."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Relatório texto
        summary = self.generate_summary(parser, results)
        summary_path = self.output_dir / f"summary_{timestamp}.txt"
        with open(summary_path, 'w', encoding='utf-8') as f:
            f.write(summary)
        
        # Relatório JSON detalhado
        detailed = self.generate_detailed_report(parser, results)
        json_path = self.output_dir / f"detailed_{timestamp}.json"
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(detailed, f, indent=2, ensure_ascii=False)
        
        # Lista de issues não corrigidos
        unfixed_path = self.output_dir / f"unfixed_{timestamp}.txt"
        with open(unfixed_path, 'w', encoding='utf-8') as f:
            f.write("ISSUES NÃO CORRIGIDOS AUTOMATICAMENTE\n")
            f.write("=" * 60 + "\n\n")
            
            for result in results:
                if not result.success:
                    f. write(f"Arquivo: {result.issue.file_path}\n")
                    f.write(f"Linha: {result.issue.line}\n")
                    f.write(f"Regra: {result.issue.rule}\n")
                    f. write(f"Mensagem:  {result.issue.message}\n")
                    f.write(f"Motivo: {result.description}\n")
                    f.write("-" * 40 + "\n")
        
        logger.info(f"Relatórios salvos em: {self.output_dir}")
        return summary_path, json_path, unfixed_path


class PubspecFixer:
    """Corrige problemas no pubspec.yaml."""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.pubspec_path = self.project_root / "pubspec.yaml"
    
    def find_missing_dependencies(self, issues: List[DartIssue]) -> Set[str]:
        """Encontra dependências faltantes baseado nos erros."""
        missing = set()
        
        for issue in issues:
            if issue. rule == 'depend_on_referenced_packages':
                # Extrai nome do pacote da mensagem
                match = re.search(r"package '(\w+)'", issue.message)
                if match:
                    missing.add(match.group(1))
            elif issue.rule == 'uri_does_not_exist': 
                # Extrai pacote do import
                match = re.search(r"package: (\w+)/", issue.message)
                if match:
                    missing.add(match.group(1))
        
        return missing
    
    def suggest_additions(self, missing: Set[str]) -> str:
        """Sugere adições ao pubspec.yaml."""
        if not missing:
            return ""
        
        suggestions = "\n# Adicionar ao pubspec.yaml em dependencies:\n"
        for pkg in sorted(missing):
            suggestions += f"  {pkg}:  ^latest_version\n"
        
        return suggestions


def run_flutter_analyze(project_path: str) -> str:
    """Executa flutter analyze e retorna output."""
    try:
        result = subprocess.run(
            ['flutter', 'analyze', 'lib'],
            cwd=project_path,
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors='replace'
        )
        return result.stdout + result.stderr
    except Exception as e:
        logger.error(f"Erro ao executar flutter analyze: {e}")
        return ""


class ValidationManager:
    """Valida e compara resultados das correções."""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.validation_log = Path(project_root) / ".validation_log.json"
    
    def compare_backups(self, file_path: str) -> Dict:
        """Compara arquivo original (backup) com versão modificada."""
        backup_path = str(file_path) + '.backup'
        if not os.path.exists(backup_path):
            return {'compared': False, 'reason': 'Sem backup'}
        
        try:
            with open(backup_path, 'r', encoding='utf-8', errors='replace') as f:
                backup_content = f.read()
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                current_content = f.read()
            
            backup_lines = backup_content.splitlines()
            current_lines = current_content.splitlines()
            
            return {
                'compared': True,
                'backup_lines': len(backup_lines),
                'current_lines': len(current_lines),
                'lines_removed': len(backup_lines) - len(current_lines),
                'lines_added': len(current_lines) - len(backup_lines),
                'file_path': file_path
            }
        except Exception as e:
            return {'compared': False, 'error': str(e)}
    
    def validate_fixes(self, initial_issues: int, final_issues: int, results: List[FixResult]) -> Dict:
        """Valida se as correções melhoraram ou pioraram a situação."""
        successful = sum(1 for r in results if r.success)
        failed = sum(1 for r in results if not r.success)
        
        improvement = initial_issues - final_issues
        improvement_pct = (improvement / initial_issues * 100) if initial_issues > 0 else 0
        
        validation = {
            'timestamp': datetime.now().isoformat(),
            'initial_issues': initial_issues,
            'final_issues': final_issues,
            'improvement': improvement,
            'improvement_percentage': improvement_pct,
            'fixes_attempted': len(results),
            'successful_fixes': successful,
            'failed_fixes': failed,
            'success_rate': (successful / len(results) * 100) if len(results) > 0 else 0,
            'status': 'IMPROVED' if improvement > 0 else ('UNCHANGED' if improvement == 0 else 'REGRESSED')
        }
        
        return validation
    
    def restore_from_backup(self, file_path: str) -> bool:
        """Restaura arquivo do backup local."""
        backup_path = str(file_path) + '.backup'
        if not os.path.exists(backup_path):
            logger.warning(f"Sem backup para: {file_path}")
            return False
        
        try:
            shutil.copy2(backup_path, file_path)
            logger.info(f"Restaurado de backup: {file_path}")
            return True
        except Exception as e:
            logger.error(f"Erro ao restaurar: {e}")
            return False


def main():
    parser = argparse.ArgumentParser(
        description='Corretor automático de issues Flutter/Dart',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos de uso:
  %(prog)s --analyze-file analyze.txt --project-path /path/to/project
  %(prog)s --run-analyze --project-path /path/to/project
  %(prog)s --analyze-file analyze.txt --dry-run
  %(prog)s --analyze-file analyze.txt --rules unused_import,unused_field
  %(prog)s --analyze-file analyze.txt --severity high
        """
    )
    
    parser.add_argument(
        '--analyze-file',
        help='Arquivo com output do flutter analyze'
    )
    
    parser.add_argument(
        '--run-analyze',
        action='store_true',
        help='Executa flutter analyze automaticamente'
    )
    
    parser.add_argument(
        '--project-path',
        default='.',
        help='Caminho raiz do projeto Flutter (default: diretório atual)'
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Mostra correções sem aplicar'
    )
    
    parser.add_argument(
        '--rules',
        help='Lista de regras para corrigir (separadas por vírgula)'
    )
    
    parser.add_argument(
        '--severity',
        choices=['critical', 'high', 'medium', 'low'],
        default='medium',
        help='Severidade mínima para corrigir (default: medium)'
    )
    
    parser.add_argument(
        '--restore',
        action='store_true',
        help='Restaura arquivos do último backup'
    )
    
    parser.add_argument(
        '--report-only',
        action='store_true',
        help='Apenas gera relatório sem corrigir'
    )
    
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Output detalhado'
    )
    
    args = parser.parse_args()
    
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    # Restaurar backup
    if args.restore:
        backup = BackupManager()
        backup.restore_all()
        print("Arquivos restaurados do backup.")
        return
    
    # Obtém conteúdo do analyzer
    analyzer_parser = AnalyzerParser()
    
    if args.analyze_file:
        # Usa parse_file que tem lógica de encoding correta
        issues = analyzer_parser.parse_file(args.analyze_file)
    elif args.run_analyze:
        print("Executando flutter analyze...")
        analyze_content = run_flutter_analyze(args.project_path)
        
        # Salva output para referência
        with open('flutter_analyze_output.txt', 'w', encoding='utf-8') as f:
            f. write(analyze_content)
        print("Output salvo em flutter_analyze_output.txt")
        issues = analyzer_parser.parse_content(analyze_content)
    else:
        parser.error("Especifique --analyze-file ou --run-analyze")
    
    # Parse issues
    print("\nAnalisando issues...")
    
    summary = analyzer_parser.get_summary()
    initial_summary = summary.copy()  # Salvar estado inicial
    print(f"\nEncontrados {summary['total']} issues:")
    print(f"  - Erros: {summary['errors']}")
    print(f"  - Warnings: {summary['warnings']}")
    print(f"  - Infos: {summary['infos']}")
    print(f"  - Arquivos afetados: {summary['files_affected']}")
    
    # Apenas relatório
    if args.report_only:
        report_gen = ReportGenerator()
        report_gen.save_reports(analyzer_parser, [])
        return
    
    # Prepara regras para corrigir
    rules = None
    if args.rules:
        rules = [r.strip() for r in args.rules.split(',')]
    
    severity_map = {
        'critical':  IssueSeverity.CRITICAL,
        'high': IssueSeverity.HIGH,
        'medium': IssueSeverity.MEDIUM,
        'low': IssueSeverity.LOW,
    }
    severity = severity_map[args.severity]
    
    # Aplica correções
    print(f"\n{'[DRY RUN] ' if args.dry_run else ''}Aplicando correções...")
    
    fixer = DartFileFixer(args.project_path, dry_run=args.dry_run)
    results = fixer. fix_all(issues, rules=rules, severity_threshold=severity)
    
    # VALIDAÇÃO: Verifica se as correções pioraram a situação
    if not args.dry_run and args.run_analyze:
        print("\n" + "="*70)
        print("VALIDAÇÃO DAS CORREÇÕES")
        print("="*70)
        
        # Re-analisa após correções
        print("\nRe-analisando projeto após correções...")
        try:
            flutter_output = subprocess.run(
                [args.flutter_path or "flutter", "analyze", args.project_path, "--format=json"],
                capture_output=True,
                text=True,
                timeout=300
            )
            if flutter_output.stdout:
                final_data = json.loads(flutter_output.stdout)
                final_issues = len(final_data.get('issues', []))
                
                validator = ValidationManager(args.project_path)
                validation = validator.validate_fixes(initial_summary['total'], final_issues, results)
                
                print(f"\nResultado: {validation['status']}")
                print(f"Issues iniciais: {validation['initial_issues']}")
                print(f"Issues finais: {validation['final_issues']}")
                print(f"Melhoria: {validation['improvement']} issues ({validation['improvement_percentage']:.1f}%)")
                print(f"Taxa de sucesso de fixes: {validation['success_rate']:.1f}%")
                
                # Se piorou, restaura e avisa
                if validation['improvement'] < 0:
                    print("\n⚠️  AVISO: Issues AUMENTARAM após as correções!")
                    print(f"Aumentou {abs(validation['improvement'])} issues")
                    print("\nRestaurando arquivos do backup...")
                    
                    modified_files = set(r.issue.file_path for r in results if r.success)
                    for file_path in modified_files:
                        validator.restore_from_backup(file_path)
                    
                    print("\n✅ Arquivos restaurados dos backups locais")
                    sys.exit(1)
        except Exception as e:
            logger.warning(f"Erro na validação: {e}")
    
    # Gera relatórios
    print("\nGerando relatorios...")
    report_gen = ReportGenerator()
    report = report_gen.generate_summary(analyzer_parser, results)
    # Usar encoding seguro para Windows
    try:
        print(report)
    except UnicodeEncodeError:
        print(report.encode('ascii', 'replace').decode('ascii'))
    
    report_gen.save_reports(analyzer_parser, results)
    
    # Mostra próximos passos
    unfixed_critical = [r for r in results if not r.success and r.issue.severity == IssueSeverity.CRITICAL]
    
    if unfixed_critical: 
        print("\n[!] ATENCAO: Issues criticos nao corrigidos automaticamente:")
        for r in unfixed_critical[: 10]: 
            print(f"  - {r.issue.file_path}:{r.issue.line} [{r.issue.rule}]")
        
        if len(unfixed_critical) > 10:
            print(f"  ... e mais {len(unfixed_critical) - 10} issues")
    
    # Verifica dependências faltantes
    pubspec_fixer = PubspecFixer(args.project_path)
    missing_deps = pubspec_fixer. find_missing_dependencies(issues)
    
    if missing_deps:
        print("\n[+] Dependencias possivelmente faltantes:")
        for dep in sorted(missing_deps):
            print(f"  - {dep}")
        print("\nAdicione-as ao pubspec.yaml e execute 'flutter pub get'")


if __name__ == '__main__':
    main()