import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Status de importação
enum ImportStatus {
  pending('Pendente', AppThemeColors.orangeMaterial),
  processing('Processando', AppThemeColors.primary),
  completed('Concluído', AppThemeColors.success),
  completedWithErrors('Concluído c/ Erros', AppThemeColors.amberMain),
  failed('Falhou', AppThemeColors.error),
  partial('Parcial', AppThemeColors.amberMain);

  const ImportStatus(this.label, this.color);
  
  final String label;
  final Color color;

  /// Obtém a cor dinâmica do status (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    switch (this) {
      case ImportStatus.pending:
        return colors.orangeMaterial;
      case ImportStatus.processing:
        return colors.primary;
      case ImportStatus.completed:
        return colors.success;
      case ImportStatus.completedWithErrors:
        return colors.amberMain;
      case ImportStatus.failed:
        return colors.error;
      case ImportStatus.partial:
        return colors.amberMain;
    }
  }
}
