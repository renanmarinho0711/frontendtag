// Design System Central - TagBean
///
/// Arquivo único de importação para todo o design system.
/// Ao invés de importar cada arquivo separadamente, importe apenas este.
///
/// Uso:
/// ```dart
/// import 'package:tagbean/design_system/design_system.dart';
///
/// // Agora você tem acesso a tudo:
/// AppColors, TagBeanColors, AppRadius, AppSpacing, AppShadows,
/// AppTextStyles, AppThemeColors, AppSizes, AppIcons, ModuleThemes, etc.
/// ```

library design_system;

// Theme - Cores e Visuais (AppThemeColors é a fonte principal de verdade)
export 'theme/theme_colors.dart';
export 'theme/theme_colors_dynamic.dart';
export 'theme/gradients.dart';
export 'theme/colors.dart';
export 'theme/brand.dart';
// REMOVIDO: export 'theme/brand_colors.dart'; // Duplicado com brand.dart, causa ciclo de importacao

// Theme - Tipografia e Dimensões
export 'theme/typography.dart'; // AppTextStyles para estilos de texto dinamicos
export 'theme/shadows.dart'; // AppShadows para sombras dinamicas
export 'theme/sizes.dart';
export 'theme/spacing.dart';
export 'theme/borders.dart';

// Theme - Ícones
export 'theme/icons.dart';





