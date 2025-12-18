#!/usr/bin/env python3
import re

pattern = r'^\s+(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)'

with open('analyze_v3.txt', 'r', encoding='utf-8-sig', errors='ignore') as f:
    content = f.read()

matches = re.findall(pattern, content, re.MULTILINE)

print(f"Total: {len(matches)}")

errors = sum(1 for m in matches if m[0] == 'error')
warnings = sum(1 for m in matches if m[0] == 'warning')
infos = sum(1 for m in matches if m[0] == 'info')

print(f"Erros: {errors}")
print(f"Warnings: {warnings}")
print(f"Infos: {infos}")
print(f"Redução desde 2879: {2879 - len(matches)} ({round((2879 - len(matches)) / 2879 * 100, 1)}%)")

# Top issues
from collections import Counter
rules = [m[5] for m in matches]
top_rules = Counter(rules).most_common(10)

print("\nTop 10 Regras:")
for rule, count in top_rules:
    print(f"  {count:3d} - {rule}")
