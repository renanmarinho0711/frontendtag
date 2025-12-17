#!/usr/bin/env python3
"""
Script para analisar e corrigir os type casting errors em import_export_models.dart
"""

import re

# Read the file
with open('lib/features/import_export/data/models/import_export_models.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Pattern 1: "json['key'] as Type" where Type is String or similar
# Problem: should be "((json['key']) as String?) ?? ''"

# Pattern 2: "json['key'] ?? json['other'] as Type"
# Problem: should be "(((json['key'] ?? json['other']) as Type?) ?? default)"

# Pattern 3: For lines that are just receiving json access with ?? 0 or ?? false
# They're mostly fine if they have defaults

# Let's be strategic and fix the most common patterns

patterns = [
    # Fix 1: fileName pattern
    {
        'old': "      fileName: json['fileName'] ?? json['nome'] as String,",
        'new': "      fileName: (((json['fileName'] ?? json['nome']) as String?) ?? ''),"
    },
    # Fix 2: id pattern
    {
        'old': "      id: json['id'] as String,",
        'new': "      id: ((json['id']) as String?) ?? '',"
    },
    # Fix 3: totalRecords pattern
    {
        'old': "      totalRecords: json['totalRecords'] ?? json['total'] as int,",
        'new': "      totalRecords: (((json['totalRecords'] ?? json['total']) as int?) ?? 0),"
    },
    # Fix 4: successCount pattern
    {
        'old': "      successCount: json['successCount'] ?? json['sucesso'] as int,",
        'new': "      successCount: (((json['successCount'] ?? json['sucesso']) as int?) ?? 0),"
    },
    # Fix 5: duration
    {
        'old': "      duration: json['duration'] ?? json['duracao'] as String,",
        'new': "      duration: (((json['duration'] ?? json['duracao']) as String?) ?? ''),"
    },
]

for pattern in patterns:
    if pattern['old'] in content:
        content = content.replace(pattern['old'], pattern['new'])
        print(f"Replaced: {pattern['old'][:50]}...")
    else:
        print(f"NOT FOUND: {pattern['old'][:50]}...")

# Save
with open('lib/features/import_export/data/models/import_export_models.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Done!")
