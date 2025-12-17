/// Design System Central - TagBean
///
/// Arquivo único de importação para todo o design system.
/// Ação invés de importar cada arquivo separadamente, importe apenas este.
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
export 'theme/theme_provider.dart';
export 'theme/theme_selector_dialog.dart';
export 'theme/gradients.dart';
export 'theme/module_gradients.dart';
export 'theme/shadows.dart';

// Theme - Tipografia e Dimensões
export 'theme/typography.dart';
export 'theme/sizes.dart';
export 'theme/spacing.dart';
export 'theme/borders.dart';

// Theme - Módulos e Categorias
export 'theme/icons.dart';
export 'theme/category_themes.dart';
export 'theme/module_theme.dart';

// Components
export 'components/cards/card_widgets.dart';
export 'components/dialogs/dialog_widgets.dart';
export 'components/common/common_widgets.dart';





