#!/usr/bin/env python3
import os
import re
from pathlib import Path

# Arquivos que precisam de import corrigido
files_to_fix = [
    'lib/core/widgets/app_button.dart',
    'lib/core/widgets/app_card.dart',
    'lib/core/widgets/app_loading.dart',
    'lib/core/widgets/app_text_field.dart',
]

# Mapeamento de imports errados para corretos
import_fixes = {
    "package:tagbean/core/theme/app_colors.dart": "package:tagbean/design_system/theme/colors.dart",
    "package:tagbean/core/theme/app_typography.dart": "package:tagbean/design_system/theme/typography.dart",
    "package:tagbean/core/theme/app_spacing.dart": "package:tagbean/design_system/theme/spacing.dart",
    "package:tagbean/core/theme/app_shadows.dart": "package:tagbean/design_system/theme/shadows.dart",
    "package:tagbean/core/theme/app_icons.dart": "package:tagbean/design_system/theme/icons.dart",
    "package:tagbean/core/theme/app_borders.dart": "package:tagbean/design_system/theme/borders.dart",
}

# Mapeamento de classe/função para import
class_to_import = {
    "AppColors": "package:tagbean/design_system/design_system.dart",
    "AppTypography": "package:tagbean/design_system/design_system.dart",
    "AppSpacing": "package:tagbean/design_system/design_system.dart",
    "AppShadows": "package:tagbean/design_system/design_system.dart",
    "AppIcons": "package:tagbean/design_system/design_system.dart",
    "AppBorders": "package:tagbean/design_system/design_system.dart",
}

for file_path in files_to_fix:
    full_path = Path(file_path)
    if full_path.exists():
        print(f"Processando {file_path}...")
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Fazer substituições
        for old_import, new_import in import_fixes.items():
            content = content.replace(f"import '{old_import}';", f"import '{new_import}';")
        
        # Adicionar imports necessários se faltarem
        has_design_system_import = "import 'package:tagbean/design_system/design_system.dart';" in content
        if not has_design_system_import and any(cls in content for cls in class_to_import.keys()):
            # Adicionar import no início após outros imports
            lines = content.split('\n')
            import_idx = 0
            for i, line in enumerate(lines):
                if line.startswith('import '):
                    import_idx = i + 1
            
            lines.insert(import_idx, "import 'package:tagbean/design_system/design_system.dart';")
            content = '\n'.join(lines)
        
        with open(full_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  ✓ Atualizado")
    else:
        print(f"  ✗ Arquivo não encontrado: {file_path}")

print("\nConcluído!")
