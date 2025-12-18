import re

pattern = re.compile(
    r'^\s*(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\w+)',
    re.IGNORECASE
)

with open('analyze_with_deps.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()
    count = 0
    errors = 0
    warnings = 0
    infos = 0
    
    for line in lines:
        if pattern.match(line.strip()):
            count += 1
            if line.strip().startswith('error'):
                errors += 1
            elif line.strip().startswith('warning'):
                warnings += 1
            else:
                infos += 1
    
    print(f"\n=== CONTAGEM DE ISSUES ===")
    print(f"Total: {count}")
    print(f"  Erros: {errors}")
    print(f"  Warnings: {warnings}")
    print(f"  Infos: {infos}")
    print(f"\nRedução desde 2879: {2879 - count} ({((2879-count)/2879)*100:.1f}%)")
