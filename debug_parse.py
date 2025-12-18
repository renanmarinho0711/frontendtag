#!/usr/bin/env python3
import re

# O padrão usado no script
pattern = r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)'

issues = []
with open('analyze_with_deps.txt', 'r', encoding='utf-8') as f:
    for i, line in enumerate(f, 1):
        match = re.match(pattern, line)
        if match:
            issues.append({
                'line_num': i,
                'severity': match.group(1),
                'message': match.group(2)[:50],
                'file': match.group(3)
            })

print(f"Total de issues encontradas: {len(issues)}")
print("\nPrimeiras 10:")
for issue in issues[:10]:
    print(f"  Linha {issue['line_num']}: {issue['severity']} - {issue['message']} ({issue['file']})")

print(f"\nÚltimas 10:")
for issue in issues[-10:]:
    print(f"  Linha {issue['line_num']}: {issue['severity']} - {issue['message']} ({issue['file']})")
