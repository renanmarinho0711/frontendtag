#!/usr/bin/env python3
import re
from pathlib import Path

# Lê o arquivo
with open('analyze_with_deps.txt', 'r', encoding='utf-8') as f:
    content = f.read()

# Tenta com o padrão
pattern = r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)'

issues_regex = []
for line in content.split('\n'):
    if line and not line.isspace():
        match = re.match(pattern, line)
        if match:
            issues_regex.append(match)

print(f"Com regex direto: {len(issues_regex)} issues encontradas")

# Agora vai tentar parsedr usando o código do script (simulado)
class DummyAnalyzer:
    def __init__(self):
        self.pattern = r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)'
    
    def parse_file(self, file_path):
        # Copiar exatamente do script
        encodings = ['utf-16', 'utf-16-le', 'utf-8', 'cp1252', 'latin-1']
        content = None
        for enc in encodings:
            try:
                with open(file_path, 'r', encoding=enc) as f:
                    content = f.read()
                if '\x00' not in content:
                    break
            except (UnicodeDecodeError, UnicodeError):
                continue
        if content is None:
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                content = f.read()
        
        # Agora vê o tamanho do conteúdo
        print(f"Conteúdo lido com sucesso: {len(content)} caracteres")
        print(f"Primeiros 200 chars: {repr(content[:200])}")
        
        issues = []
        for line in content.split('\n'):
            if not line or line.isspace():
                continue
            
            match = re.match(self.pattern, line)
            if match:
                issues.append(match.groups())
        
        return issues

analyzer = DummyAnalyzer()
issues = analyzer.parse_file('analyze_with_deps.txt')
print(f"\nCom parse_file do script: {len(issues)} issues")
