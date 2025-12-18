#!/usr/bin/env python3
import sys
sys.path.insert(0, 'd:\\tagbean\\frontend')

from fix_flutter_issues import AnalyzerParser

parser = AnalyzerParser()
issues = parser.parse_file('analyze_with_deps.txt')

print(f"Total de issues lidas: {len(issues)}")
summary = parser.get_summary()
print(f"Sumário: {summary}")

if len(issues) > 0:
    print("\nPrimeiros 5 issues:")
    for issue in issues[:5]:
        print(f"  {issue.issue_type} - {issue.rule} - {issue.file_path}:{issue.line}")
