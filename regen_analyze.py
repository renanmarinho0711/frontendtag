#!/usr/bin/env python3
import subprocess
import os

os.chdir('d:\\tagbean\\frontend')

# Run flutter analyze
result = subprocess.run(
    ['C:\\temp_flutter\\flutter\\bin\\flutter.bat', 'analyze'],
    capture_output=True,
    text=True,
    encoding='utf-8'
)

# Force write as UTF-8 (NOT UTF-16)
content = result.stdout
if result.stderr:
    content += result.stderr

# Remove BOM if present
if content.startswith('\ufeff'):
    content = content[1:]

# Write ONLY UTF-8
with open('analyze_with_deps.txt', 'w', encoding='utf-8', errors='replace') as f:
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
