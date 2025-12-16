mport 'package:flutter/material.dart';
import 'theme_colors.dart';
import 'theme_colors_dynamic.dart';

/// Classe helper para fontSize responsivo
class ResponsiveFontSize {
  final double mobile;
  final double tablet;
  final double desktop;

  const ResponsiveFontSize({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  /// Retorna o valor adequado baseado no breakpoint
  double get(bool isMobile, [bool isTablet = false]) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
}

/// Estilos de texto padronizados da aplica��o
/// 
/// Centraliza todos os estilos de texto base.
/// Para adaptar para mobile/tablet, use .responsive() ou .copyWith()
/// 
/// Uso:
/// ```dart
/// Text('T�tulo', style: AppTextStyles.h1.responsive(isMobile))
/// Text('Label', style: AppTextStyles.fieldLabel)
/// ```
class AppTextStyles {
  AppTextStyles._();

  // ========== T�TULOS ==========
  
  /// T�tulo principal (Hero) - Desktop
  static const TextStyle h1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.8,
    color: AppThemeColors.surface,
  );

  /// T�tulo secund�rio - Desktop
  static const TextStyle h2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppThemeColors.textPrimary,
  );

  /// T�tulo terci�rio - Desktop
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppThemeColors.textPrimary,
  );

  // ========== LABELS ==========
  
  /// Label para campos de formul�rio
  static const TextStyle fieldLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.textSecondary,
  );

  // ========== INPUTS ==========
  
  /// Texto dentro de inputs
  static const TextStyle input = TextStyle(
    fontSize: 15,
    color: AppThemeColors.textPrimary,
  );

  // ========== BOT�ES ==========
  
  /// Texto de bot�es prim�rios
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.8,
    color: AppThemeColors.surface,
  );

  /// Texto de bot�es de texto (TextButton)
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.brandPrimaryGreen,
  );

  // ========== CORPO DE TEXTO ==========
  
  /// Texto corpo padr�o
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppThemeColors.textSecondary,
  );


  /// Body text medio (alias)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: AppThemeColors.textPrimary,
  );

  /// Body text pequeno
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: AppThemeColors.textSecondary,
  );
  /// Texto pequeno (caption)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppThemeColors.textTertiary,
  );

  /// Texto muito pequeno
  static const TextStyle tiny = TextStyle(
    fontSize: 10,
    color: AppThemeColors.textTertiary,
  );

  // ========== ESPECIAIS ==========
  
  /// Badge/Tag text
  static const TextStyle badge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.surface,
  );

  /// SubT�tulo/Slogan (ex: "PRE�O INTELIGENTE")
  static const TextStyle subtitle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppThemeColors.surface,
  );

  /// Footer text principal
  static const TextStyle footer = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppThemeColors.surface,
  );

  /// Footer text secund�rio
  static const TextStyle footerSecondary = TextStyle(
    fontSize: 12,
    color: AppThemeColors.surface,
  );

  // ========== HELPERS PARA INFO/DEMO ==========
  
  /// Texto de informa��o (como credenciais demo) - T�tulo
  static const TextStyle infoTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.infoText,
  );

  /// Texto de informa��o (como credenciais demo) - valor
  static const TextStyle infoValue = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.infoText,
  );

  /// Texto de informa��o - label pequena
  static const TextStyle infoLabel = TextStyle(
    fontSize: 10,
    color: AppThemeColors.textTertiary,
  );

  // ========== DASHBOARD STYLES ==========
  
  /// T�tulo de cards no dashboard (branco, bold)
  static const TextStyle dashboardCardTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.white,
  );
  
  /// SubT�tulo de cards no dashboard (branco transl�cido)
  static const TextStyle dashboardCardSubtitle = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w500,
    color: AppThemeColors.white70,
  );
  
  /// Valor de m�trica grande (n�meros destacados)
  static const TextStyle metricValue = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.white,
  );
  
  /// Label de m�trica (acima ou abaixo do valor)
  static const TextStyle metricLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppThemeColors.white70,
  );
  
  /// Valor de m�trica pequena
  static const TextStyle metricValueSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.white,
  );
  
  /// Label de categoria no dashboard
  static const TextStyle categoryLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.textPrimary,
  );
  
  /// Valor num�rico de categoria
  static const TextStyle categoryValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.textPrimary,
  );

  // ========== V7 TEXT STYLES (RESPONSIVE FONT SIZE PATTERNS) ==========
  
  /// Pequeno (11-12-13)
  static const TextStyle small = TextStyle(
    fontSize: 11,
    color: AppThemeColors.textSecondary,
  );
  
  /// Regular (13-14-15)
  static const TextStyle regular = TextStyle(
    fontSize: 13,
    color: AppThemeColors.textPrimary,
  );
  
  /// Body grande (16-17-18)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppThemeColors.textPrimary,
  );
  
  /// T�tulo (20-22-24)
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.textPrimary,
  );
  
  /// Heading/Cabe�alho (24-26-28)
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.textPrimary,
  );

  // ========== DASHBOARD SPECIFIC STYLES ==========

  /// Valor de estat�stica (grande, destaque)
  static const TextStyle statValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  /// Label de estat�stica (pequeno, secund�rio)
  static const TextStyle statLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.textSecondary,
  );

  /// T�tulo de estrat�gia
  static const TextStyle strategyTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.textPrimary,
  );

  /// Valor de estrat�gia
  static const TextStyle strategyValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  /// Label de estrat�gia
  static const TextStyle strategyLabel = TextStyle(
    fontSize: 11,
    color: AppThemeColors.textSecondary,
  );

  /// Label de sync
  static const TextStyle syncLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.textSecondary,
  );

  // ========== PRODUCT EDIT SPECIFIC STYLES ==========

  /// T�tulo de se��o em card (ex: "Informa��es Gerais", "Precifica��o")
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppThemeColors.textPrimary,
  );

  /// Label de valor/pre�o em hist�rico
  static const TextStyle valueLabel = TextStyle(
    fontSize: 11,
    color: AppThemeColors.textTertiary,
  );

  /// Valor em hist�rico/card (ex: R$ 10,00)
  static const TextStyle valueText = TextStyle(
    fontSize: 12,
    color: AppThemeColors.textSecondary,
  );

  /// Texto de a��o em dialogs (descri��o)
  static const TextStyle dialogContent = TextStyle(
    fontSize: 14,
    color: AppThemeColors.textSecondary,
  );

  /// T�tulo de dialog
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppThemeColors.textPrimary,
  );

  /// Texto de bot�o em dialog/a��o
  static const TextStyle dialogButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// Texto de item de dropdown
  static const TextStyle dropdownItem = TextStyle(
    fontSize: 14,
    color: AppThemeColors.textPrimary,
  );

  /// Texto de contagem/badge (ex: "3 altera��es")
  static const TextStyle countLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppThemeColors.infoText,
  );

  // ========== SNACKBAR STYLES ==========

  /// T�tulo em SnackBar (ex: "Produto Exclu�do!")
  static const TextStyle snackbarTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppThemeColors.surface,
  );

  /// Mensagem em SnackBar (ex: "Altera��es salvas com sucesso")
  static const TextStyle snackbarMessage = TextStyle(
    fontSize: 12,
    color: AppThemeColors.surface,
  );

  // ========== FORM CONTROLS ==========

  /// Texto de dropdown (categoria, status, etc.) - vers�o aprimorada do dropdownItem
  static const TextStyle dropdownText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppThemeColors.textPrimary,
  );

  // ========== RESPONSIVE FONT SIZES (V8 - 100% COVERAGE) ==========
  // Tokens para substituir ResponsiveHelper.getResponsiveFontSize()
  
  /// 586x - MAIS USADO NO PROJETO!
  static const ResponsiveFontSize fontSizeBase = ResponsiveFontSize(
    mobile: 13.0,
    tablet: 13.0,
    desktop: 14.0,
  );
  
  /// 389x - 2� MAIS USADO
  static const ResponsiveFontSize fontSizeBaseAlt = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 13.0,
    desktop: 13.0,
  );
  
  /// 337x - 3� MAIS USADO
  static const ResponsiveFontSize fontSizeSm = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 12.0,
    desktop: 13.0,
  );
  
  /// 294x
  static const ResponsiveFontSize fontSizeXs = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 11.0,
    desktop: 12.0,
  );
  
  /// 221x
  static const ResponsiveFontSize fontSizeSmAlt = ResponsiveFontSize(
    mobile: 13.0,
    tablet: 12.0,
    desktop: 12.0,
  );
  
  /// 184x
  static const ResponsiveFontSize fontSizeXxs = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 10.0,
    desktop: 11.0,
  );
  
  /// 181x
  static const ResponsiveFontSize fontSizeXsAlt = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 11.0,
    desktop: 11.0,
  );
  
  /// 128x
  static const ResponsiveFontSize fontSizeXsAlt2 = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 10.0,
    desktop: 10.0,
  );
  
  /// 122x
  static const ResponsiveFontSize fontSizeMd = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 14.0,
    desktop: 15.0,
  );
  
  /// 114x
  static const ResponsiveFontSize fontSizeMdAlt = ResponsiveFontSize(
    mobile: 15.0,
    tablet: 15.0,
    desktop: 16.0,
  );
  
  /// 113x
  static const ResponsiveFontSize fontSizeLg = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 16.0,
    desktop: 18.0,
  );
  
  /// 103x
  static const ResponsiveFontSize fontSizeLgAlt = ResponsiveFontSize(
    mobile: 18.0,
    tablet: 16.0,
    desktop: 17.0,
  );
  
  /// 80x
  static const ResponsiveFontSize fontSizeMicro = ResponsiveFontSize(
    mobile: 9.0,
    tablet: 9.0,
    desktop: 10.0,
  );
  
  /// 74x
  static const ResponsiveFontSize fontSizeMdAlt2 = ResponsiveFontSize(
    mobile: 15.0,
    tablet: 14.0,
    desktop: 14.0,
  );
  
  /// 69x
  static const ResponsiveFontSize fontSizeXl = ResponsiveFontSize(
    mobile: 18.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  /// 66x
  static const ResponsiveFontSize fontSizeXlAlt = ResponsiveFontSize(
    mobile: 20.0,
    tablet: 18.0,
    desktop: 19.0,
  );
  
  /// 61x
  static const ResponsiveFontSize fontSizeMdLg = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 14.0,
    desktop: 16.0,
  );
  
  /// 59x
  static const ResponsiveFontSize fontSizeLgAlt2 = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 15.0,
    desktop: 15.0,
  );
  
  /// 57x
  static const ResponsiveFontSize fontSizeSmLg = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 12.0,
    desktop: 14.0,
  );
  
  /// 56x
  static const ResponsiveFontSize fontSizeMdLgAlt = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 14.0,
    desktop: 15.0,
  );
  
  /// 55x
  static const ResponsiveFontSize fontSizeXsLg = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 11.0,
    desktop: 13.0,
  );
  
  /// 53x
  static const ResponsiveFontSize fontSizeBaseAlt2 = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 12.0,
    desktop: 13.0,
  );
  
  /// 49x
  static const ResponsiveFontSize fontSizeMicroAlt = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 9.0,
    desktop: 9.0,
  );
  
  /// 43x
  static const ResponsiveFontSize fontSizeSmAlt2 = ResponsiveFontSize(
    mobile: 13.0,
    tablet: 11.0,
    desktop: 12.0,
  );
  
  /// 33x
  static const ResponsiveFontSize fontSizeMicroLg = ResponsiveFontSize(
    mobile: 9.0,
    tablet: 9.0,
    desktop: 11.0,
  );
  
  /// 32x
  static const ResponsiveFontSize fontSizeXsAlt3 = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 9.0,
    desktop: 10.0,
  );
  
  /// 29x (cada)
  static const ResponsiveFontSize fontSizeMdAlt3 = ResponsiveFontSize(
    mobile: 17.0,
    tablet: 15.0,
    desktop: 16.0,
  );
  
  static const ResponsiveFontSize fontSizeMdAlt4 = ResponsiveFontSize(
    mobile: 15.0,
    tablet: 15.0,
    desktop: 17.0,
  );
  
  /// 28x (cada)
  static const ResponsiveFontSize fontSizeXsAlt4 = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 10.0,
    desktop: 11.0,
  );
  
  static const ResponsiveFontSize fontSizeXxsLg = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 10.0,
    desktop: 12.0,
  );
  
  /// 25x
  static const ResponsiveFontSize fontSizeLgAlt3 = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 16.0,
    desktop: 17.0,
  );
  
  /// 23x (cada)
  static const ResponsiveFontSize fontSizeTiny = ResponsiveFontSize(
    mobile: 8.0,
    tablet: 8.0,
    desktop: 9.0,
  );
  
  static const ResponsiveFontSize fontSizeBaseXl = ResponsiveFontSize(
    mobile: 13.0,
    tablet: 13.0,
    desktop: 15.0,
  );
  
  /// 21x
  static const ResponsiveFontSize fontSizeMdAlt5 = ResponsiveFontSize(
    mobile: 15.0,
    tablet: 13.0,
    desktop: 14.0,
  );
  
  /// 19x
  static const ResponsiveFontSize fontSizeMdAlt6 = ResponsiveFontSize(
    mobile: 17.0,
    tablet: 17.0,
    desktop: 18.0,
  );
  
  /// 18x
  static const ResponsiveFontSize fontSizeMicroAlt2 = ResponsiveFontSize(
    mobile: 9.0,
    tablet: 8.0,
    desktop: 8.0,
  );
  
  /// 14x (cada)
  static const ResponsiveFontSize fontSizeXxsAlt = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 8.0,
    desktop: 9.0,
  );
  
  static const ResponsiveFontSize fontSizeTinyLg = ResponsiveFontSize(
    mobile: 8.0,
    tablet: 8.0,
    desktop: 10.0,
  );
  
  /// 13x (cada)
  static const ResponsiveFontSize fontSizeLgAlt4 = ResponsiveFontSize(
    mobile: 18.0,
    tablet: 15.0,
    desktop: 16.0,
  );
  
  static const ResponsiveFontSize fontSizeMdXl = ResponsiveFontSize(
    mobile: 15.0,
    tablet: 15.0,
    desktop: 18.0,
  );
  
  /// 11x (cada)
  static const ResponsiveFontSize fontSizeXxl = ResponsiveFontSize(
    mobile: 24.0,
    tablet: 20.0,
    desktop: 22.0,
  );
  
  static const ResponsiveFontSize fontSizeXlAlt2 = ResponsiveFontSize(
    mobile: 20.0,
    tablet: 20.0,
    desktop: 24.0,
  );
  
  /// 10x (cada)
  static const ResponsiveFontSize fontSizeXlAlt3 = ResponsiveFontSize(
    mobile: 22.0,
    tablet: 19.0,
    desktop: 20.0,
  );
  
  static const ResponsiveFontSize fontSizeLgXl = ResponsiveFontSize(
    mobile: 19.0,
    tablet: 19.0,
    desktop: 22.0,
  );
  
  // ===== V8.2 - FONT SIZE ADICIONAIS (124 ocorr�ncias!) =====
  
  /// 9x
  static const ResponsiveFontSize fontSizeMdAlt7 = ResponsiveFontSize(
    mobile: 17.0,
    tablet: 16.0,
    desktop: 16.0,
  );
  
  /// 8x (cada)
  static const ResponsiveFontSize fontSizeXlAlt4 = ResponsiveFontSize(
    mobile: 20.0,
    tablet: 16.0,
    desktop: 18.0,
  );
  
  static const ResponsiveFontSize fontSizeLgXl2 = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 16.0,
    desktop: 20.0,
  );
  
  /// 7x (cada)
  static const ResponsiveFontSize fontSizeXxlAlt = ResponsiveFontSize(
    mobile: 22.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  static const ResponsiveFontSize fontSizeLgXl3 = ResponsiveFontSize(
    mobile: 18.0,
    tablet: 18.0,
    desktop: 22.0,
  );
  
  /// 6x (cada)
  static const ResponsiveFontSize fontSizeXlAlt5 = ResponsiveFontSize(
    mobile: 20.0,
    tablet: 17.0,
    desktop: 18.0,
  );
  
  static const ResponsiveFontSize fontSizeMdAlt8 = ResponsiveFontSize(
    mobile: 17.0,
    tablet: 17.0,
    desktop: 20.0,
  );
  
  /// 5x
  static const ResponsiveFontSize fontSizeXxlAlt2 = ResponsiveFontSize(
    mobile: 22.0,
    tablet: 22.0,
    desktop: 24.0,
  );
  
  /// 4x (cada)
  static const ResponsiveFontSize fontSizeLgAlt5 = ResponsiveFontSize(
    mobile: 18.0,
    tablet: 14.0,
    desktop: 16.0,
  );
  
  static const ResponsiveFontSize fontSizeMdLg2 = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 14.0,
    desktop: 18.0,
  );
  
  static const ResponsiveFontSize fontSizeXsXl = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 11.0,
    desktop: 14.0,
  );
  
  /// 3x
  static const ResponsiveFontSize fontSizeTinyAlt = ResponsiveFontSize(
    mobile: 7.0,
    tablet: 7.0,
    desktop: 8.0,
  );
  
  /// 2x (cada)
  static const ResponsiveFontSize fontSizeLgAlt6 = ResponsiveFontSize(
    mobile: 19.0,
    tablet: 16.0,
    desktop: 18.0,
  );
  
  static const ResponsiveFontSize fontSizeTinyAlt2 = ResponsiveFontSize(
    mobile: 8.0,
    tablet: 7.0,
    desktop: 7.0,
  );
  
  static const ResponsiveFontSize fontSizeBaseAlt3 = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 11.0,
    desktop: 13.0,
  );
  
  static const ResponsiveFontSize fontSizeLgAlt7 = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 16.0,
    desktop: 19.0,
  );
  
  static const ResponsiveFontSize fontSizeSmXl = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 12.0,
    desktop: 16.0,
  );
  
  static const ResponsiveFontSize fontSizeMicroXl = ResponsiveFontSize(
    mobile: 9.0,
    tablet: 9.0,
    desktop: 12.0,
  );
  
  static const ResponsiveFontSize fontSize3Xl = ResponsiveFontSize(
    mobile: 32.0,
    tablet: 28.0,
    desktop: 30.0,
  );
  
  static const ResponsiveFontSize fontSize3XlAlt = ResponsiveFontSize(
    mobile: 28.0,
    tablet: 28.0,
    desktop: 32.0,
  );
  
  static const ResponsiveFontSize fontSizeXxlAlt3 = ResponsiveFontSize(
    mobile: 22.0,
    tablet: 20.0,
    desktop: 21.0,
  );
  
  static const ResponsiveFontSize fontSizeXlXxl = ResponsiveFontSize(
    mobile: 20.0,
    tablet: 20.0,
    desktop: 22.0,
  );
  
  static const ResponsiveFontSize fontSizeXxlAlt4 = ResponsiveFontSize(
    mobile: 24.0,
    tablet: 21.0,
    desktop: 22.0,
  );
  
  static const ResponsiveFontSize fontSizeXlXxl2 = ResponsiveFontSize(
    mobile: 21.0,
    tablet: 21.0,
    desktop: 24.0,
  );
  
  /// 1x (cada)
  static const ResponsiveFontSize fontSizeMdAlt9 = ResponsiveFontSize(
    mobile: 15.0,
    tablet: 12.0,
    desktop: 13.0,
  );
  
  static const ResponsiveFontSize fontSizeLgAlt8 = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 12.0,
    desktop: 15.0,
  );
  
  static const ResponsiveFontSize fontSizeXsAlt5 = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 8.0,
    desktop: 10.0,
  );
  
  static const ResponsiveFontSize fontSizeSmXl2 = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 12.0,
    desktop: 15.0,
  );
  
  static const ResponsiveFontSize fontSizeTinyXl = ResponsiveFontSize(
    mobile: 8.0,
    tablet: 8.0,
    desktop: 11.0,
  );
  
  static const ResponsiveFontSize fontSizeXxlAlt5 = ResponsiveFontSize(
    mobile: 24.0,
    tablet: 18.0,
    desktop: 21.0,
  );

  // ========== PRODUTOS DASHBOARD SPECIFIC ==========

  /// Welcome section T�tulo principal
  static const ResponsiveFontSize fontSizeWelcomeTitle = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 15.0,
    desktop: 16.0,
  );

  /// Welcome section subT�tulo
  static const ResponsiveFontSize fontSizeWelcomeSubtitle = ResponsiveFontSize(
    mobile: 9.0,
    tablet: 9.5,
    desktop: 10.0,
  );

  /// Welcome metric value (n�meros grandes)
  static const ResponsiveFontSize fontSizeWelcomeMetricValue = ResponsiveFontSize(
    mobile: 24.0,
    tablet: 26.0,
    desktop: 28.0,
  );

  /// Welcome metric label
  static const ResponsiveFontSize fontSizeWelcomeMetricLabel = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 12.0,
    desktop: 13.0,
  );

  /// Categoria nome (lista rica)
  static const ResponsiveFontSize fontSizeCategoriaTitle = ResponsiveFontSize(
    mobile: 16.0,
    tablet: 17.0,
    desktop: 18.0,
  );

  /// Categoria info secund�ria
  static const ResponsiveFontSize fontSizeCategoriaInfo = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 12.5,
    desktop: 13.0,
  );

  /// Categoria faturamento
  static const ResponsiveFontSize fontSizeCategoriaValue = ResponsiveFontSize(
    mobile: 15.0,
    tablet: 16.0,
    desktop: 17.0,
  );

  // ========== DASHBOARD STAT CARDS ==========

  /// Valor de estat�stica (n�meros grandes nos cards)
  static const ResponsiveFontSize fontSizeStatValue = ResponsiveFontSize(
    mobile: 18.0,
    tablet: 20.0,
    desktop: 22.0,
  );

  /// Label de estat�stica
  static const ResponsiveFontSize fontSizeStatLabel = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 12.0,
    desktop: 13.0,
  );

  /// Badge de crescimento (ex: "+12.5%")
  static const ResponsiveFontSize fontSizeStatBadge = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  // ========== SECTION HEADERS ==========

  /// T�tulo de se��o (ex: "Alertas Importantes")
  static const ResponsiveFontSize fontSizeSectionTitle = ResponsiveFontSize(
    mobile: 18.0,
    tablet: 20.0,
    desktop: 22.0,
  );

  /// Badge de contagem em section header (ex: "3")
  static const ResponsiveFontSize fontSizeSectionBadge = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 12.0,
    desktop: 13.0,
  );

  // ========== ALERT CARDS ==========

  /// T�tulo do alerta
  static const ResponsiveFontSize fontSizeAlertTitle = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 13.0,
    desktop: 14.0,
  );

  /// Descri��o do alerta
  static const ResponsiveFontSize fontSizeAlertDescription = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  /// Badge de quantidade no alerta
  static const ResponsiveFontSize fontSizeAlertBadge = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  // ========== QUICK ACTION CARDS ==========

  /// T�tulo da a��o
  static const ResponsiveFontSize fontSizeActionTitle = ResponsiveFontSize(
    mobile: 12.0,
    tablet: 13.0,
    desktop: 14.0,
  );

  /// SubT�tulo da a��o
  static const ResponsiveFontSize fontSizeActionSubtitle = ResponsiveFontSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  // ========== CATEGORIA ITEMS ==========

  /// Nome da categoria
  static const ResponsiveFontSize fontSizeCategoryName = ResponsiveFontSize(
    mobile: 14.0,
    tablet: 15.0,
    desktop: 16.0,
  );

  /// Info secund�ria da categoria (quantidade, tags)
  static const ResponsiveFontSize fontSizeCategoryInfo = ResponsiveFontSize(
    mobile: 11.0,
    tablet: 12.0,
    desktop: 13.0,
  );

  /// Valor de faturamento da categoria
  static const ResponsiveFontSize fontSizeCategoryValue = ResponsiveFontSize(
    mobile: 13.0,
    tablet: 14.0,
    desktop: 15.0,
  );

  /// Percentual da categoria
  static const ResponsiveFontSize fontSizeCategoryPercentage = ResponsiveFontSize(
    mobile: 9.0,
    tablet: 10.0,
    desktop: 11.0,
  );
}

/// Extension para adaptar estilos responsivamente
extension ResponsiveTextStyle on TextStyle {
  /// Ajusta fontSize baseado em mobile/tablet/desktop
  /// 
  /// Uso:
  /// ```dart
  /// AppTextStyles.h1.responsive(isMobile, isTablet)
  /// ```
  TextStyle responsive(bool isMobile, [bool isTablet = false]) {
    // Redu��o de 20% para mobile, 10% para tablet
    final mobileFactor = isMobile ? 0.8 : (isTablet ? 0.9 : 1.0);
    
    // Ajusta tamb�m letterSpacing proporcionalmente
    final newLetterSpacing = (letterSpacing ?? 0) * mobileFactor;
    
    return copyWith(
      fontSize: (fontSize ?? 14) * mobileFactor,
      letterSpacing: newLetterSpacing == 0 ? null : newLetterSpacing,
    );
  }

  /// Vers�o simplificada para ajuste manual de tamanhos espec�ficos
  /// �til para casos onde voc� precisa de controle granular (13/13/14)
  /// 
  /// Uso:
  /// ```dart
  /// AppTextStyles.dropdownText.withResponsiveSize(
  ///   mobile: 13, tablet: 13, desktop: 14,
  ///   isMobile: isMobile, isTablet: isTablet
  /// )
  /// ```
  TextStyle withResponsiveSize({
    required double mobile,
    required double tablet,
    required double desktop,
    required bool isMobile,
    bool isTablet = false,
  }) {
    final size = isMobile ? mobile : (isTablet ? tablet : desktop);
    return copyWith(fontSize: size);
  }
}




