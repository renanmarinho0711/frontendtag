#!/usr/bin/env python3
import re

pattern = r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)'

with open('analyze_v2.txt', 'r', encoding='utf-8-sig', errors='ignore') as f:
    lines = f.readlines()

issues = []
for line in lines:
    match = re.match(pattern, line)
    if match:
        issues.append(line)

print(f"Total: {len(issues)}")

errors = sum(1 for i in issues if ' error ' in i)
warnings = sum(1 for i in issues if ' warning ' in i)
infos = sum(1 for i in issues if ' info ' in i)

print(f"Erros: {errors}")
print(f"Warnings: {warnings}")
print(f"Infos: {infos}")
print(f"Redução desde 2879: {2879 - len(issues)} ({round((2879 - len(issues)) / 2879 * 100, 1)}%)")

# Top issues
from collections import Counter
rules = [re.search(r' - (\w+)$', issue) for issue in issues]
rules = [m.group(1) for m in rules if m]
top_rules = Counter(rules).most_common(10)

print("\nTop 10 Regras:")
for rule, count in top_rules:
    print(f"  {count:3d} - {rule}")
