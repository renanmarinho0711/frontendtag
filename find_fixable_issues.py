#!/usr/bin/env python3
import re
from collections import defaultdict

# Padrão regex
pattern = r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)'

issues_by_rule = defaultdict(list)
issues_by_file = defaultdict(list)

with open('analyze_clean.txt', 'r', encoding='utf-8-sig', errors='ignore') as f:
    for line in f:
        match = re.match(pattern, line)
        if match:
            severity, message, file_path, line_num, col, rule = match.groups()
            
            issue_info = {
                'severity': severity,
                'message': message,
                'file': file_path,
                'line': int(line_num),
                'col': int(col),
                'rule': rule
            }
            
            issues_by_rule[rule].append(issue_info)
            issues_by_file[file_path].append(issue_info)

# Mostrar issues por arquivo (filtrando design_system)
print("=" * 80)
print("ISSUES FORA DO DESIGN_SYSTEM (mais fáceis de corrigir)")
print("=" * 80)

problematic_files = []
for file_path in sorted(issues_by_file.keys()):
    if 'design_system' not in file_path and 'theme' not in file_path:
        issues = issues_by_file[file_path]
        if len(issues) > 3:
            print(f"\n📄 {file_path} - {len(issues)} issues")
            for issue in issues[:3]:  # Mostrar apenas primeiras 3
                print(f"   L{issue['line']}: {issue['rule']} - {issue['message'][:60]}")
            problematic_files.append((file_path, len(issues)))

print("\n" + "=" * 80)
print("TOP 10 ARQUIVOS COM MAIS ISSUES (fora design_system)")
print("=" * 80)
for file_path, count in sorted(problematic_files, key=lambda x: x[1], reverse=True)[:10]:
    print(f"{count:3d} issues - {file_path}")

print("\n" + "=" * 80)
print("TOP REGRAS DE ISSUES")
print("=" * 80)
for rule in sorted(issues_by_rule.keys(), key=lambda r: len(issues_by_rule[r]), reverse=True)[:15]:
    count = len(issues_by_rule[rule])
    print(f"{count:3d} - {rule}")
