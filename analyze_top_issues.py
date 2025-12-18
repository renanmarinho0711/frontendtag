import re
from collections import defaultdict

pattern = re.compile(
    r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)',
    re.IGNORECASE
)

issues_by_type = defaultdict(int)

with open('analyze_with_deps.txt', 'r', encoding='utf-8') as f:
    for line in f:
        m = pattern.match(line.strip())
        if m:
            rule = m.group(6)
            issues_by_type[rule] += 1

# Sort by count
sorted_issues = sorted(issues_by_type.items(), key=lambda x: x[1], reverse=True)

print("\n=== TOP 15 TIPOS DE ISSUES ===")
for rule, count in sorted_issues[:15]:
    print(f"{rule:40s} {count:4d}")

print(f"\nTotal de tipos diferentes: {len(issues_by_type)}")
