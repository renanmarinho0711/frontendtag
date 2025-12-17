# -*- coding: utf-8 -*-
"""
============================================================================
Script: fix_encoding_issues.py
Descricao: Corrige problemas de encoding em arquivos Dart
           Apenas corrige palavras em contexto de texto (UI)
           NAO corrige variaveis ou identificadores de codigo
Autor: TagBean Team
Data: 17/12/2025
============================================================================

REGRAS DE CORRECAO:
- Corrige apenas palavras com espaco ANTES e espaco/aspas/pontuacao DEPOIS
- Exemplo: " sao " -> " são "
- Exemplo: " informacao'" -> " informação'"
- NAO corrige: "informacaoDoSistema" (variavel camelCase)
- NAO corrige: "numero.valor" (acesso a propriedade)
============================================================================
"""

import os
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from collections import defaultdict

# Configuracoes
SEARCH_PATH = r"D:\tagbean\frontend\lib"
OUTPUT_FILE = r"D:\tagbean\frontend\RELATORIO_CORRECOES.md"
DRY_RUN = False  # Se True, apenas mostra o que seria corrigido sem alterar arquivos

# =============================================================================
# MAPEAMENTO DE CORRECOES
# Padrao corrompido -> Caractere correto
# =============================================================================

CORRECTIONS = {
    # Vogais minusculas com acento
    'Ã¡': 'á',
    'Ã ': 'à',
    'Ã¢': 'â',
    'Ã£': 'ã',
    'Ã¤': 'ä',
    'Ã©': 'é',
    'Ã¨': 'è',
    'Ãª': 'ê',
    'Ã«': 'ë',
    'Ã­': 'í',
    'Ã¬': 'ì',
    'Ã®': 'î',
    'Ã¯': 'ï',
    'Ã³': 'ó',
    'Ã²': 'ò',
    'Ã´': 'ô',
    'Ãµ': 'õ',
    'Ã¶': 'ö',
    'Ãº': 'ú',
    'Ã¹': 'ù',
    'Ã»': 'û',
    'Ã¼': 'ü',
    
    # Cedilha
    'Ã§': 'ç',
    'Ã‡': 'Ç',
    
    # Vogais maiusculas com acento
    'Ã€': 'À',
    'Ã': 'Á',
    'Ã‚': 'Â',
    'Ãƒ': 'Ã',
    'Ã„': 'Ä',
    'Ã‰': 'É',
    'Ãˆ': 'È',
    'ÃŠ': 'Ê',
    'Ã‹': 'Ë',
    'ÃŒ': 'Ì',
    'ÃŽ': 'Î',
    'Ã': 'Ò',
    'Ã"': 'Ó',
    'Ã"': 'Ô',
    'Ã•': 'Õ',
    'Ã–': 'Ö',
    'Ã™': 'Ù',
    'Ãš': 'Ú',
    'Ã›': 'Û',
    'Ãœ': 'Ü',
    
    # N com til
    'Ã±': 'ñ',
    "Ã'": 'Ñ',
    
    # Simbolos
    'Â£': '£',
    'Â©': '©',
    'Â®': '®',
    'Â°': '°',
    'Âº': 'º',
    'Âª': 'ª',
    
    # Aspas e travessoes corrompidos
    'â€œ': '"',
    'â€': '"',
    "â€˜": "'",
    "â€™": "'",
    'â€"': '–',
    'â€"': '—',
    'â€¦': '…',
}

# Caracteres que indicam que a palavra e texto (nao variavel)
# Antes da palavra corrompida
VALID_BEFORE = [
    ' ',      # espaco
    '"',      # aspas duplas
    "'",      # aspas simples
    '(',      # parenteses
    '[',      # colchetes
    '{',      # chaves
    '\n',     # nova linha
    '\t',     # tab
    ':',      # dois pontos (para labels)
    ',',      # virgula
    '>',      # maior que (fechamento de tag)
]

# Depois da palavra corrompida
VALID_AFTER = [
    ' ',      # espaco
    '"',      # aspas duplas
    "'",      # aspas simples
    ')',      # parenteses
    ']',      # colchetes
    '}',      # chaves
    '\n',     # nova linha
    '\t',     # tab
    ',',      # virgula
    '.',      # ponto final
    '!',      # exclamacao
    '?',      # interrogacao
    ':',      # dois pontos
    ';',      # ponto e virgula
    '<',      # menor que (abertura de tag)
    '\\n',    # newline escapado em string
    '\\',     # barra invertida
]


class EncodingFixer:
    """Corrige problemas de encoding em arquivos Dart"""
    
    def __init__(self, search_path: str, dry_run: bool = False):
        self.search_path = Path(search_path)
        self.dry_run = dry_run
        self.corrections_made: List[Dict] = []
        self.files_modified = set()
        self.files_scanned = 0
        self.total_corrections = 0
        self.skipped_variables = 0
        
    def is_valid_text_context(self, content: str, start_pos: int, end_pos: int) -> bool:
        """
        Verifica se a posicao esta em contexto de texto (nao variavel)
        Retorna True se a palavra tem caractere valido antes E depois
        """
        # Verificar caractere antes
        if start_pos > 0:
            char_before = content[start_pos - 1]
            valid_before = char_before in VALID_BEFORE
        else:
            # Inicio do arquivo - considerar valido
            valid_before = True
        
        # Verificar caractere depois
        if end_pos < len(content):
            char_after = content[end_pos]
            valid_after = char_after in VALID_AFTER
            
            # Verificar tambem sequencias escapadas como \n
            if end_pos + 1 < len(content) and content[end_pos:end_pos+2] == '\\n':
                valid_after = True
        else:
            # Fim do arquivo - considerar valido
            valid_after = True
        
        return valid_before and valid_after
    
    def is_inside_string(self, content: str, pos: int) -> bool:
        """
        Verifica se a posicao esta dentro de uma string literal
        Isso ajuda a identificar textos de UI
        """
        # Contar aspas antes da posicao
        before = content[:pos]
        
        # Contar aspas simples nao escapadas
        single_quotes = 0
        i = 0
        while i < len(before):
            if before[i] == "'" and (i == 0 or before[i-1] != '\\'):
                single_quotes += 1
            i += 1
        
        # Contar aspas duplas nao escapadas
        double_quotes = 0
        i = 0
        while i < len(before):
            if before[i] == '"' and (i == 0 or before[i-1] != '\\'):
                double_quotes += 1
            i += 1
        
        # Se numero impar de aspas, estamos dentro de uma string
        return (single_quotes % 2 == 1) or (double_quotes % 2 == 1)
    
    def fix_line(self, line: str, line_number: int, file_path: str) -> Tuple[str, List[Dict]]:
        """
        Corrige uma linha, retornando a linha corrigida e lista de correcoes
        """
        corrections = []
        result = line
        
        for corrupted, correct in CORRECTIONS.items():
            if corrupted not in result:
                continue
            
            # Encontrar todas as ocorrencias
            start = 0
            while True:
                pos = result.find(corrupted, start)
                if pos == -1:
                    break
                
                end_pos = pos + len(corrupted)
                
                # Verificar se esta em contexto de texto valido
                if self.is_valid_text_context(result, pos, end_pos):
                    # Fazer a correcao
                    old_text = result[max(0, pos-10):min(len(result), end_pos+10)]
                    result = result[:pos] + correct + result[end_pos:]
                    new_text = result[max(0, pos-10):min(len(result), pos+len(correct)+10)]
                    
                    corrections.append({
                        'file': file_path,
                        'line': line_number,
                        'corrupted': corrupted,
                        'correct': correct,
                        'context_before': old_text,
                        'context_after': new_text,
                    })
                    
                    # Ajustar posicao para proxima busca
                    start = pos + len(correct)
                else:
                    # Pular - provavelmente e uma variavel
                    self.skipped_variables += 1
                    start = end_pos
        
        return result, corrections
    
    def fix_file(self, file_path: Path) -> bool:
        """
        Corrige um arquivo, retornando True se houve modificacoes
        """
        try:
            # Tentar ler arquivo com diferentes encodings
            content = None
            encoding_used = None
            for enc in ['utf-8', 'utf-8-sig', 'latin-1', 'cp1252']:
                try:
                    with open(file_path, 'r', encoding=enc) as f:
                        content = f.read()
                    encoding_used = enc
                    break
                except UnicodeDecodeError:
                    continue
            
            if content is None:
                print(f"  [ERRO] Nao foi possivel decodificar {file_path}")
                return False
            
            lines = content.split('\n')
            new_lines = []
            file_corrections = []
            modified = False
            
            for i, line in enumerate(lines, 1):
                new_line, corrections = self.fix_line(line, i, str(file_path))
                new_lines.append(new_line)
                
                if corrections:
                    file_corrections.extend(corrections)
                    modified = True
            
            if modified and not self.dry_run:
                # Salvar arquivo corrigido
                new_content = '\n'.join(new_lines)
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
            
            if file_corrections:
                self.corrections_made.extend(file_corrections)
                self.files_modified.add(str(file_path))
                self.total_corrections += len(file_corrections)
            
            return modified
            
        except Exception as e:
            print(f"  [ERRO] Falha ao processar {file_path}: {e}")
            return False
    
    def run(self) -> None:
        """Executa a correcao em todos os arquivos .dart"""
        print("=" * 70)
        print("  CORRETOR DE PROBLEMAS DE ENCODING - DART")
        print("=" * 70)
        print()
        
        if self.dry_run:
            print("  *** MODO DRY-RUN: Nenhum arquivo sera modificado ***")
            print()
        
        print(f"Diretorio: {self.search_path}")
        print()
        
        dart_files = list(self.search_path.rglob("*.dart"))
        total_files = len(dart_files)
        
        print(f"Encontrados {total_files} arquivos .dart")
        print()
        print("Processando arquivos...")
        print()
        
        for i, file_path in enumerate(dart_files, 1):
            self.files_scanned += 1
            relative_path = str(file_path).replace(str(self.search_path), "").lstrip("\\").lstrip("/")
            
            modified = self.fix_file(file_path)
            
            if modified:
                count = len([c for c in self.corrections_made if c['file'] == str(file_path)])
                print(f"  [OK] {relative_path} - {count} correcoes")
            
            if i % 100 == 0:
                print(f"    ... processados {i}/{total_files} arquivos")
        
        print()
        print("=" * 70)
        print("  CORRECAO CONCLUIDA")
        print("=" * 70)
        print()
        print(f"Total de arquivos analisados: {self.files_scanned}")
        print(f"Arquivos modificados: {len(self.files_modified)}")
        print(f"Total de correcoes realizadas: {self.total_corrections}")
        print(f"Variaveis/identificadores ignorados: {self.skipped_variables}")
        print()
    
    def generate_report(self, output_file: str) -> None:
        """Gera relatorio das correcoes realizadas"""
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("# 📋 RELATORIO DE CORRECOES DE ENCODING\n")
            f.write("## TagBean Frontend - Arquivos Dart\n\n")
            f.write(f"**Data da Correcao:** {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}\n\n")
            f.write(f"**Modo:** {'DRY-RUN (simulacao)' if self.dry_run else 'EXECUCAO REAL'}\n\n")
            f.write(f"**Diretorio:** `{self.search_path}`\n\n")
            f.write(f"**Total de Arquivos Analisados:** {self.files_scanned}\n\n")
            f.write(f"**Arquivos Modificados:** {len(self.files_modified)}\n\n")
            f.write(f"**Total de Correcoes:** {self.total_corrections}\n\n")
            f.write(f"**Variaveis Ignoradas:** {self.skipped_variables}\n\n")
            f.write("---\n\n")
            
            # Resumo por tipo de correcao
            f.write("## 📊 RESUMO POR TIPO DE CORRECAO\n\n")
            f.write("| Padrao Corrompido | Correcao | Quantidade |\n")
            f.write("|-------------------|----------|------------|\n")
            
            correction_counts = defaultdict(int)
            for c in self.corrections_made:
                key = f"{c['corrupted']} -> {c['correct']}"
                correction_counts[key] += 1
            
            for key, count in sorted(correction_counts.items(), key=lambda x: x[1], reverse=True):
                parts = key.split(' -> ')
                f.write(f"| `{parts[0]}` | `{parts[1]}` | {count} |\n")
            
            f.write("\n---\n\n")
            
            # Resumo por arquivo
            f.write("## 📁 ARQUIVOS MODIFICADOS\n\n")
            
            corrections_by_file = defaultdict(list)
            for c in self.corrections_made:
                relative_path = c['file'].replace(str(self.search_path), "").lstrip("\\").lstrip("/")
                corrections_by_file[relative_path].append(c)
            
            f.write("| Arquivo | Correcoes |\n")
            f.write("|---------|----------|\n")
            
            for file_path, corrections in sorted(corrections_by_file.items(), key=lambda x: len(x[1]), reverse=True):
                f.write(f"| `{file_path}` | {len(corrections)} |\n")
            
            f.write("\n---\n\n")
            
            # Detalhamento por arquivo
            f.write("## 📝 DETALHAMENTO DAS CORRECOES\n\n")
            
            for file_path, corrections in sorted(corrections_by_file.items()):
                f.write(f"### 📄 `{file_path}`\n\n")
                f.write("| Linha | Antes | Depois |\n")
                f.write("|-------|-------|--------|\n")
                
                for c in sorted(corrections, key=lambda x: x['line']):
                    before = c['context_before'].replace('|', '\\|').replace('\n', ' ')
                    after = c['context_after'].replace('|', '\\|').replace('\n', ' ')
                    if len(before) > 50:
                        before = before[:50] + "..."
                    if len(after) > 50:
                        after = after[:50] + "..."
                    f.write(f"| {c['line']} | `{before}` | `{after}` |\n")
                
                f.write("\n")
            
            f.write("---\n\n")
            f.write("*Relatorio gerado automaticamente por `fix_encoding_issues.py`*\n")
        
        print(f"Relatorio salvo em: {output_file}")


def main():
    """Funcao principal"""
    search_path = SEARCH_PATH
    output_file = OUTPUT_FILE
    dry_run = DRY_RUN
    
    # Processar argumentos de linha de comando
    if '--dry-run' in sys.argv:
        dry_run = True
    
    if '--help' in sys.argv or '-h' in sys.argv:
        print("Uso: python fix_encoding_issues.py [opcoes]")
        print()
        print("Opcoes:")
        print("  --dry-run    Simula as correcoes sem modificar arquivos")
        print("  --help, -h   Mostra esta ajuda")
        print()
        return 0
    
    if not os.path.exists(search_path):
        print(f"ERRO: Diretorio nao encontrado: {search_path}")
        return 1
    
    fixer = EncodingFixer(search_path, dry_run)
    fixer.run()
    fixer.generate_report(output_file)
    
    print()
    print("=" * 70)
    if dry_run:
        print("  SIMULACAO FINALIZADA!")
        print("  Execute sem --dry-run para aplicar as correcoes")
    else:
        print("  CORRECOES APLICADAS COM SUCESSO!")
    print("=" * 70)
    
    return 0


if __name__ == "__main__":
    sys.exit(main())
