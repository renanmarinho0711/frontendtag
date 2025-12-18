#!/usr/bin/env python3
import subprocess
import os
import re

os.chdir('d:\\tagbean\\frontend')

# Run flutter analyze
result = subprocess.run(
    ['C:\\temp_flutter\\flutter\\bin\\flutter.bat', 'analyze'],
    capture_output=True,
    text=True,
    encoding='utf-8'
)

# Combine stdout and stderr
content = result.stdout
if result.stderr:
    content += result.stderr

# Remove BOM if present
if content.startswith('\ufeff'):
    content = content[1:]

# Skip everything before the first issue line (skip pub get output)
lines = content.split('\n')
start_idx = 0
for i, line in enumerate(lines):
    if re.match(r'^\s*(error|warning|info)\s+-', line):
        start_idx = i
        break

# If we found issues, keep only from that point
if start_idx > 0:
    content = '\n'.join(lines[start_idx:])
    print(f"Pulou {start_idx} linhas de output do pub get")

# Delete old file first to prevent encoding issues
import os
if os.path.exists('analyze_with_deps.txt'):
    os.remove('analyze_with_deps.txt')

# Write ONLY UTF-8 (NOT UTF-16)
with open('analyze_with_deps.txt', 'w', encoding='utf-8', errors='replace', newline='\n') as f:
    f.write(content)

print(f"Análise salva ({len(content)} bytes) - verificando...")

# Verify it's truly UTF-8
with open('analyze_with_deps.txt', 'rb') as f:
    raw = f.read(20)
    print(f"Primeiros 20 bytes: {raw}")
    # Se começar com BOM UTF-8, algo deu errado
    if raw.startswith(b'\xef\xbb\xbf'):
        print("AVISO: Arquivo tem BOM UTF-8")
    elif raw.startswith(b'\xff\xfe') or raw.startswith(b'\xfe\xff'):
        print("ERRO: Arquivo é UTF-16!")
    else:
        print("OK: Arquivo parece ser UTF-8 puro")
