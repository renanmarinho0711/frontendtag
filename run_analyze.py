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

# Write to file
with open('analyze_with_deps.txt', 'w', encoding='utf-8') as f:
    f.write(result.stdout)
    if result.stderr:
        f.write(result.stderr)

print("Análise salva em analyze_with_deps.txt")
