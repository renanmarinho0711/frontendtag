# -*- coding: utf-8 -*-
"""
============================================================================
Script: find_encoding_issues.py
Descricao: Scanner robusto de problemas de encoding em arquivos Dart
           Identifica caracteres corrompidos em textos de UI
Autor: TagBean Team
Data: 17/12/2025
============================================================================
"""

import os
import re
import sys
from datetime import datetime
from pathlib import Path
from collections import defaultdict
from typing import List, Dict, Tuple, Optional

# Configuracoes
SEARCH_PATH = r"D:\tagbean\frontend\lib"
OUTPUT_FILE = r"D:\tagbean\frontend\RELATORIO_ENCODING_ISSUES.md"

# =============================================================================
# PADROES DE ENCODING CORROMPIDO
# Quando UTF-8 e interpretado como Latin-1/Windows-1252, os caracteres 
# acentuados aparecem como sequencias de 2 bytes incorretas
# =============================================================================

ENCODING_PATTERNS = {
    # Vogais minusculas com acento
    'Ã¡': ('á', 'a com acento agudo'),
    'Ã ': ('à', 'a com crase'),
    'Ã¢': ('â', 'a com circunflexo'),
    'Ã£': ('ã', 'a com til'),
    'Ã¤': ('ä', 'a com trema'),
    'Ã©': ('é', 'e com acento agudo'),
    'Ã¨': ('è', 'e com crase'),
    'Ãª': ('ê', 'e com circunflexo'),
    'Ã«': ('ë', 'e com trema'),
    'Ã­': ('í', 'i com acento agudo'),
    'Ã¬': ('ì', 'i com crase'),
    'Ã®': ('î', 'i com circunflexo'),
    'Ã¯': ('ï', 'i com trema'),
    'Ã³': ('ó', 'o com acento agudo'),
    'Ã²': ('ò', 'o com crase'),
    'Ã´': ('ô', 'o com circunflexo'),
    'Ãµ': ('õ', 'o com til'),
    'Ã¶': ('ö', 'o com trema'),
    'Ãº': ('ú', 'u com acento agudo'),
    'Ã¹': ('ù', 'u com crase'),
    'Ã»': ('û', 'u com circunflexo'),
    'Ã¼': ('ü', 'u com trema'),
    
    # Cedilha
    'Ã§': ('ç', 'c com cedilha'),
    'Ã‡': ('Ç', 'C com cedilha maiusculo'),
    
    # Vogais maiusculas com acento
    'Ã€': ('À', 'A com crase'),
    'Ã': ('Á', 'A com acento agudo'),
    'Ã‚': ('Â', 'A com circunflexo'),
    'Ãƒ': ('Ã', 'A com til'),
    'Ã„': ('Ä', 'A com trema'),
    'Ã‰': ('É', 'E com acento agudo'),
    'Ãˆ': ('È', 'E com crase'),
    'ÃŠ': ('Ê', 'E com circunflexo'),
    'Ã‹': ('Ë', 'E com trema'),
    'Ã': ('Í', 'I com acento agudo'),
    'ÃŒ': ('Ì', 'I com crase'),
    'ÃŽ': ('Î', 'I com circunflexo'),
    'Ã': ('Ï', 'I com trema'),
    'Ã"': ('Ó', 'O com acento agudo'),
    'Ã': ('Ò', 'O com crase'),
    'Ã"': ('Ô', 'O com circunflexo'),
    'Ã•': ('Õ', 'O com til'),
    'Ã–': ('Ö', 'O com trema'),
    'Ãš': ('Ú', 'U com acento agudo'),
    'Ã™': ('Ù', 'U com crase'),
    'Ã›': ('Û', 'U com circunflexo'),
    'Ãœ': ('Ü', 'U com trema'),
    
    # N com til
    'Ã±': ('ñ', 'n com til'),
    'Ã': ('Ñ', 'N com til maiusculo'),
    
    # Simbolos
    'Â£': ('£', 'Simbolo libra'),
    'Â©': ('©', 'Simbolo copyright'),
    'Â®': ('®', 'Simbolo registered'),
    'Â°': ('°', 'Simbolo grau'),
    'Âº': ('º', 'Ordinal masculino'),
    'Âª': ('ª', 'Ordinal feminino'),
    
    # Aspas e travessoes corrompidos
    'â€œ': ('"', 'Aspas duplas abertura'),
    'â€': ('"', 'Aspas duplas fechamento'),
    'â€˜': (''', 'Aspas simples abertura'),
    'â€™': (''', 'Aspas simples fechamento'),
    'â€"': ('–', 'Travessao en-dash'),
    'â€"': ('—', 'Travessao em-dash'),
    'â€¦': ('…', 'Reticencias'),
    
    # Outros problemas comuns
    'Ã¿': ('ÿ', 'y com trema'),
    'Ã½': ('ý', 'y com acento'),
}

# Padroes regex adicionais para detectar sequencias suspeitas
SUSPICIOUS_PATTERNS = [
    # Padrao generico: Ã seguido de caractere especial
    (r'Ã[\x80-\xBF]', 'Sequencia Ã + byte alto'),
    # Padrao generico: Â seguido de caractere especial
    (r'Â[\x80-\xBF]', 'Sequencia Â + byte alto'),
    # Padrao: â€ seguido de caractere (aspas/travessoes corrompidos)
    (r'â€[\x80-\xBF]', 'Sequencia aspas/travessao corrompido'),
]

# Padroes de UI em Dart - onde textos sao exibidos ao usuario
UI_PATTERNS = [
    r"Text\s*\(",
    r"title\s*:",
    r"label\s*:",
    r"hint\s*:",
    r"hintText\s*:",
    r"labelText\s*:",
    r"helperText\s*:",
    r"errorText\s*:",
    r"tooltip\s*:",
    r"semanticLabel\s*:",
    r"message\s*:",
    r"content\s*:",
    r"subtitle\s*:",
    r"description\s*:",
    r"placeholder\s*:",
    r"AppBar\s*\(",
    r"SnackBar\s*\(",
    r"AlertDialog\s*\(",
    r"showDialog\s*\(",
    r"Toast",
    r"\.text\s*=",
    r"'[^']*'",
    r'"[^"]*"',
]

class EncodingIssue:
    """Representa um problema de encoding encontrado"""
    def __init__(self, file_path: str, line_number: int, line_content: str, 
                 patterns_found: List[Tuple[str, str, str]], is_ui_text: bool):
        self.file_path = file_path
        self.line_number = line_number
        self.line_content = line_content
        self.patterns_found = patterns_found  # [(pattern, correction, description)]
        self.is_ui_text = is_ui_text

class EncodingScanner:
    """Scanner de problemas de encoding em arquivos Dart"""
    
    def __init__(self, search_path: str):
        self.search_path = Path(search_path)
        self.issues: List[EncodingIssue] = []
        self.files_scanned = 0
        self.files_with_issues = set()
        self.pattern_counts = defaultdict(int)
        
    def is_ui_line(self, line: str) -> bool:
        """Verifica se a linha contem texto de UI"""
        for pattern in UI_PATTERNS:
            if re.search(pattern, line):
                return True
        return False
    
    def find_encoding_issues_in_line(self, line: str) -> List[Tuple[str, str, str]]:
        """Encontra todos os padroes de encoding corrompido em uma linha"""
        found = []
        
        # Verificar padroes conhecidos
        for pattern, (correction, description) in ENCODING_PATTERNS.items():
            if pattern in line:
                found.append((pattern, correction, description))
                self.pattern_counts[pattern] += 1
        
        # Verificar padroes regex suspeitos
        for regex_pattern, description in SUSPICIOUS_PATTERNS:
            matches = re.findall(regex_pattern, line)
            for match in matches:
                if match not in [p[0] for p in found]:  # Evitar duplicatas
                    found.append((match, '?', description))
                    self.pattern_counts[match] += 1
        
        return found
    
    def scan_file(self, file_path: Path) -> List[EncodingIssue]:
        """Escaneia um arquivo em busca de problemas de encoding"""
        issues = []
        
        # Tentar diferentes encodings para ler o arquivo
        encodings_to_try = ['utf-8', 'utf-8-sig', 'latin-1', 'cp1252']
        content = None
        
        for encoding in encodings_to_try:
            try:
                with open(file_path, 'r', encoding=encoding) as f:
                    content = f.read()
                break
            except UnicodeDecodeError:
                continue
            except Exception as e:
                print(f"  [ERRO] Nao foi possivel ler {file_path}: {e}")
                return issues
        
        if content is None:
            print(f"  [ERRO] Nao foi possivel decodificar {file_path}")
            return issues
        
        lines = content.split('\n')
        
        for line_number, line in enumerate(lines, 1):
            patterns_found = self.find_encoding_issues_in_line(line)
            
            if patterns_found:
                is_ui = self.is_ui_line(line)
                issue = EncodingIssue(
                    file_path=str(file_path),
                    line_number=line_number,
                    line_content=line.rstrip(),
                    patterns_found=patterns_found,
                    is_ui_text=is_ui
                )
                issues.append(issue)
                self.files_with_issues.add(str(file_path))
        
        return issues
    
    def scan_directory(self) -> None:
        """Escaneia todos os arquivos .dart no diretorio"""
        print("=" * 60)
        print("  SCANNER DE PROBLEMAS DE ENCODING - DART")
        print("=" * 60)
        print()
        print(f"Diretorio: {self.search_path}")
        print()
        
        dart_files = list(self.search_path.rglob("*.dart"))
        total_files = len(dart_files)
        
        print(f"Encontrados {total_files} arquivos .dart")
        print()
        print("Analisando arquivos...")
        print()
        
        for i, file_path in enumerate(dart_files, 1):
            self.files_scanned += 1
            
            file_issues = self.scan_file(file_path)
            self.issues.extend(file_issues)
            
            if file_issues:
                relative_path = str(file_path).replace(str(self.search_path), "").lstrip("\\").lstrip("/")
                print(f"  [{len(self.issues)}] {relative_path} - {len(file_issues)} problemas")
            
            # Progress indicator
            if i % 100 == 0:
                print(f"    ... processados {i}/{total_files} arquivos")
        
        print()
        print("=" * 60)
        print("  ANALISE CONCLUIDA")
        print("=" * 60)
        print()
        print(f"Total de arquivos analisados: {self.files_scanned}")
        print(f"Arquivos com problemas: {len(self.files_with_issues)}")
        print(f"Total de problemas encontrados: {len(self.issues)}")
        print()

    def generate_report(self, output_file: str) -> None:
        """Gera o relatorio em Markdown"""
        
        base_path = str(self.search_path).replace("\\lib", "")
        
        with open(output_file, 'w', encoding='utf-8') as f:
            # Cabecalho
            f.write("# 📋 RELATORIO DE PROBLEMAS DE ENCODING\n")
            f.write("## TagBean Frontend - Arquivos Dart\n\n")
            f.write(f"**Data da Analise:** {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}\n\n")
            f.write(f"**Diretorio Analisado:** `{self.search_path}`\n\n")
            f.write(f"**Total de Arquivos Analisados:** {self.files_scanned}\n\n")
            f.write(f"**Arquivos com Problemas:** {len(self.files_with_issues)}\n\n")
            f.write(f"**Total de Ocorrencias:** {len(self.issues)}\n\n")
            f.write("---\n\n")
            
            # Resumo por tipo de problema
            f.write("## 📊 RESUMO POR TIPO DE PROBLEMA\n\n")
            f.write("| Padrao Corrompido | Correcao | Descricao | Ocorrencias |\n")
            f.write("|-------------------|----------|-----------|-------------|\n")
            
            sorted_patterns = sorted(self.pattern_counts.items(), key=lambda x: x[1], reverse=True)
            for pattern, count in sorted_patterns:
                if pattern in ENCODING_PATTERNS:
                    correction, description = ENCODING_PATTERNS[pattern]
                else:
                    correction, description = "?", "Sequencia suspeita"
                # Escapar caracteres para markdown
                pattern_escaped = pattern.replace("|", "\\|")
                f.write(f"| `{pattern_escaped}` | `{correction}` | {description} | {count} |\n")
            
            f.write("\n---\n\n")
            
            # Resumo por arquivo
            f.write("## 📁 RESUMO POR ARQUIVO\n\n")
            
            issues_by_file = defaultdict(list)
            for issue in self.issues:
                relative_path = issue.file_path.replace(str(self.search_path), "").lstrip("\\").lstrip("/")
                issues_by_file[relative_path].append(issue)
            
            sorted_files = sorted(issues_by_file.items(), key=lambda x: len(x[1]), reverse=True)
            
            f.write("| Arquivo | Problemas | Linhas Afetadas |\n")
            f.write("|---------|-----------|------------------|\n")
            
            for file_path, file_issues in sorted_files:
                lines = [str(i.line_number) for i in file_issues]
                lines_str = ", ".join(lines[:10])
                if len(lines) > 10:
                    lines_str += f" ... (+{len(lines)-10})"
                f.write(f"| `{file_path}` | {len(file_issues)} | {lines_str} |\n")
            
            f.write("\n---\n\n")
            
            # Detalhamento completo
            f.write("## 📝 DETALHAMENTO COMPLETO\n\n")
            
            for file_path, file_issues in sorted_files:
                f.write(f"### 📄 `{file_path}`\n\n")
                
                for issue in sorted(file_issues, key=lambda x: x.line_number):
                    f.write(f"#### Linha {issue.line_number}")
                    if issue.is_ui_text:
                        f.write(" 🖥️ (Texto de UI)")
                    f.write("\n\n")
                    
                    f.write("**Padroes encontrados:**\n")
                    for pattern, correction, description in issue.patterns_found:
                        f.write(f"- `{pattern}` → `{correction}` ({description})\n")
                    
                    f.write("\n**Codigo da linha:**\n")
                    f.write("```dart\n")
                    f.write(f"{issue.line_content}\n")
                    f.write("```\n\n")
                
                f.write("---\n\n")
            
            # Secao de correcoes sugeridas
            f.write("## 🛠️ COMO CORRIGIR\n\n")
            f.write("### Opcao 1: Correcao Manual\n\n")
            f.write("Para cada arquivo listado:\n")
            f.write("1. Abra o arquivo no VS Code\n")
            f.write("2. Use `Ctrl+H` para substituir\n")
            f.write("3. Substitua cada padrao corrompido pelo caractere correto\n")
            f.write("4. Salve o arquivo com encoding UTF-8\n\n")
            
            f.write("### Tabela de Substituicao Rapida\n\n")
            f.write("| Encontrar | Substituir por |\n")
            f.write("|-----------|----------------|\n")
            
            common_patterns = [
                ('Ã¡', 'á'), ('Ã£', 'ã'), ('Ã¢', 'â'),
                ('Ã©', 'é'), ('Ãª', 'ê'),
                ('Ã­', 'í'),
                ('Ã³', 'ó'), ('Ãµ', 'õ'), ('Ã´', 'ô'),
                ('Ãº', 'ú'),
                ('Ã§', 'ç'),
                ('Ã€', 'À'), ('Ã', 'Á'), ('Ãƒ', 'Ã'),
                ('Ã‰', 'É'), ('ÃŠ', 'Ê'),
                ('Ã"', 'Ó'), ('Ã•', 'Õ'),
                ('Ãš', 'Ú'),
                ('Ã‡', 'Ç'),
            ]
            
            for find, replace in common_patterns:
                if find in self.pattern_counts:
                    f.write(f"| `{find}` | `{replace}` |\n")
            
            f.write("\n### Opcao 2: Script de Correcao Automatica\n\n")
            f.write("Execute `fix_encoding_issues.py` para corrigir automaticamente todos os arquivos.\n\n")
            
            f.write("---\n\n")
            f.write("*Relatorio gerado automaticamente por `find_encoding_issues.py`*\n")
        
        print(f"Relatorio salvo em: {output_file}")


def main():
    """Funcao principal"""
    search_path = SEARCH_PATH
    output_file = OUTPUT_FILE
    
    # Permitir argumentos de linha de comando
    if len(sys.argv) > 1:
        search_path = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    
    if not os.path.exists(search_path):
        print(f"ERRO: Diretorio nao encontrado: {search_path}")
        sys.exit(1)
    
    scanner = EncodingScanner(search_path)
    scanner.scan_directory()
    scanner.generate_report(output_file)
    
    print()
    print("=" * 60)
    print("  SCRIPT FINALIZADO COM SUCESSO!")
    print("=" * 60)
    
    return len(scanner.issues)


if __name__ == "__main__":
    exit_code = main()
    sys.exit(0 if exit_code == 0 else 1)
