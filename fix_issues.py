#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import os
from pathlib import Path

# Padrões de correção para type casting

corrections = [
    # Pattern: data['field'] sem type cast - String
    (r"(\w+)\['(\w+)'\]\s*(?=[,)].*String)", r"(\1['\2'] as String?)"),
    (r"(\w+)\['(\w+)'\]\s*(?=[,)].*String\?)", r"(\1['\2'] as String?)"),
    
    # Pattern: data['field'] sem type cast - Color
    (r"(\w+)\['cor'\](?![\s]*as)", r"(\1['cor'] as Color?)"),
    (r"(\w+)\['color'\](?![\s]*as)", r"(\1['color'] as Color?)"),
    
    # Pattern: data['field'] sem type cast - IconData
    (r"(\w+)\['icon'\](?![\s]*as)", r"(\1['icon'] as IconData?)"),
    (r"(\w+)\['icone'\](?![\s]*as)", r"(\1['icone'] as IconData?)"),
    
    # Pattern: data['field'] sem type cast - List<Color>
    (r"LinearGradient\(colors:\s*(\w+)\['gradient'\]", r"LinearGradient(colors: (\1['gradient'] as List<Color>?)"),
    
    # Pattern: Undefined context em métodos estáticos
    (r"Widget\s+_(\w+)\(String", r"Widget _\1(BuildContext context, String"),
]

def fix_file(filepath):
    """Corrige um arquivo Dart específico"""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        original = content
        
        # Aplicar correções
        for pattern, replacement in corrections:
            content = re.sub(pattern, replacement, content)
        
        if content != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"Erro ao processar {filepath}: {e}")
        return False

def main():
    lib_path = Path('d:\\tagbean\\frontend\\lib')
    
    fixed_count = 0
    for dart_file in lib_path.rglob('*.dart'):
        if fix_file(str(dart_file)):
            fixed_count += 1
            print(f"✓ Corrigido: {dart_file.relative_to(lib_path)}")
    
    print(f"\nTotal de arquivos corrigidos: {fixed_count}")

if __name__ == '__main__':
    main()
