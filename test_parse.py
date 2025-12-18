import re

pattern = re.compile(
    r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)',
    re.IGNORECASE
)

test_line = "  error - Target of URI doesn't exist: 'package:get_it/get_it.dart' - lib\core\di\injection.dart:1:8 - uri_does_not_exist"

match = pattern.match(test_line)
if match:
    print("MATCH!")
    print(f"Groups: {match.groups()}")
else:
    print("NO MATCH")
    
# Try the file parsing
with open('analyze_complete_updated.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()
    count = 0
    for line in lines:
        if pattern.match(line.strip()):
            count += 1
    print(f"Found {count} matches")
