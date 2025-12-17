import re

errors = []
with open('analyze_fresh2.txt', 'r', encoding='utf-8', errors='ignore') as f:
    for line in f:
        if 'import_export_models.dart' in line and 'argument_type_not_assignable' in line:
            match = re.search(r':(\d+):', line)
            if match:
                line_num = int(match.group(1))
                errors.append(line_num)

errors = sorted(set(errors))
print(f"Total unique line numbers with errors: {len(errors)}")
print("Line numbers with errors:")
for line_num in errors[:50]:
    print(f"  {line_num}")
