import 'package:flutter/material.dart';

/// Classe helper para valores responsivos
class ResponsiveSize {
  final double mobile;
  final double tablet;
  final double desktop;

  const ResponsiveSize({
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

  /// Converte para EdgeInsets.all()
  EdgeInsets toEdgeInsetsAll(bool isMobile, [bool isTablet = false]) {
    return EdgeInsets.all(get(isMobile, isTablet));
  }

  /// Converte para EdgeInsets.symmetric(horizontal)
  EdgeInsets toEdgeInsetsHorizontal(bool isMobile, [bool isTablet = false]) {
    return EdgeInsets.symmetric(horizontal: get(isMobile, isTablet));
  }

  /// Converte para EdgeInsets.symmetric(vertical)
  EdgeInsets toEdgeInsetsVertical(bool isMobile, [bool isTablet = false]) {
    return EdgeInsets.symmetric(vertical: get(isMobile, isTablet));
  }
}

/// Tamanhos padronizados da aplicação
/// 
/// Centraliza todos os valores de tamanho usados na aplicação.
/// Use .get(isMobile, isTablet) para valores responsivos.
/// 
/// Uso: 
/// ```dart
/// AppSizes.logo.get(isMobile, isTablet)
/// AppSizes.iconMedium // valores fixos
/// ```
class AppSizes {
  AppSizes._();

  // ========== LOGO ==========
  
  static const ResponsiveSize logo = ResponsiveSize(
    mobile: 55.0,
    tablet: 65.0,
    desktop: 68.0,
  );
  
  /// Fallback icon size (quando logo não carrega)
  static const double logoFallbackMultiplier = 0.6;
  
  // ========== BOTÕES ==========
  
  static const ResponsiveSize buttonHeight = ResponsiveSize(
    mobile: 46.0,
    tablet: 46.0,
    desktop: 46.0,
  );
  
  // ========== ÍCONES ========== (agora em ResponsiveSize abaixo)
  
  // ========== CHECKBOX / RADIO ==========
  
  static const double checkboxSize = 20.0;
  
  // ========== LOADING INDICATORS ==========
  
  static const double loadingIndicatorSize = 24.0;
  static const double loadingIndicatorStroke = 2.5;
  
  // ========== CONTAINERS RESPONSIVOS ==========
  
  /// Largura máxima do card de login
  static const ResponsiveSize loginCardMaxWidth = ResponsiveSize(
    mobile: 380.0,
    tablet: 410.0,
    desktop: 420.0,
  );
  
  /// Padding do card de login
  static const ResponsiveSize loginCardPadding = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  /// Padding horizontal da tela
  static const ResponsiveSize screenPaddingHorizontal = ResponsiveSize(
    mobile: 20.0,
    tablet: 40.0,
    desktop: 60.0,
  );
  
  /// Padding vertical da tela
  static const double screenPaddingVertical = 12.0;
  
  // ========== ESPAÇAMENTO ENTRE ELEMENTOS (RESPONSIVO) ==========
  
  /// Espaçamento entre header e card
  static const ResponsiveSize headerToCard = ResponsiveSize(
    mobile: 16.0,
    tablet: 14.0,
    desktop: 12.0,
  );
  
  /// Espaçamento entre card e footer
  static const ResponsiveSize cardToFooter = ResponsiveSize(
    mobile: 12.0,
    tablet: 10.0,
    desktop: 8.0,
  );
  
  /// Espaçamento logo → título no header
  static const ResponsiveSize headerLogoToTitle = ResponsiveSize(
    mobile: 14.0,
    tablet: 12.0,
    desktop: 10.0,
  );
  
  /// Espaçamento título → subtítulo no header
  static const ResponsiveSize headerTitleToSubtitle = ResponsiveSize(
    mobile: 8.0,
    tablet: 7.0,
    desktop: 6.0,
  );
  
  /// Espaçamento título → campos no card
  static const ResponsiveSize cardTitleToFields = ResponsiveSize(
    mobile: 12.0,
    tablet: 12.0,
    desktop: 12.0,
  );
  
  /// Espaçamento entre campos
  static const ResponsiveSize fieldToField = ResponsiveSize(
    mobile: 10.0,
    tablet: 10.0,
    desktop: 10.0,
  );
  
  /// Espaçamento campos → botão
  static const ResponsiveSize fieldsToButton = ResponsiveSize(
    mobile: 16.0,
    tablet: 14.0,
    desktop: 14.0,
  );
  
  /// Espaçamento botão → demo
  static const ResponsiveSize buttonToDemo = ResponsiveSize(
    mobile: 12.0,
    tablet: 10.0,
    desktop: 10.0,
  );
  
  /// Padding do container de subtítulo (horizontal)
  static const ResponsiveSize subtitlePaddingHorizontal = ResponsiveSize(
    mobile: 14.0,
    tablet: 14.0,
    desktop: 14.0,
  );
  
  /// Padding do container de subtítulo (vertical)
  static const ResponsiveSize subtitlePaddingVertical = ResponsiveSize(
    mobile: 5.0,
    tablet: 5.0,
    desktop: 5.0,
  );
  
  // ========== APP BAR ==========
  
  /// Altura do AppBar
  static const ResponsiveSize appBarHeight = ResponsiveSize(
    mobile: 60.0,
    tablet: 65.0,
    desktop: 70.0,
  );
  
  /// Padding horizontal do AppBar (já existe no spacing, mas aqui por consistência)
  static const ResponsiveSize appBarHorizontalPadding = ResponsiveSize(
    mobile: 16.0,
    tablet: 20.0,
    desktop: 24.0,
  );
  
  /// Espaçamento entre elementos do AppBar
  static const ResponsiveSize appBarElementSpacing = ResponsiveSize(
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );
  
  /// Padding do logo dentro do AppBar
  static const ResponsiveSize appBarLogoPadding = ResponsiveSize(
    mobile: 6.0,
    tablet: 7.0,
    desktop: 8.0,
  );
  
  /// Tamanho do ícone do logo no AppBar
  static const ResponsiveSize appBarLogoIconSize = ResponsiveSize(
    mobile: 20.0,
    tablet: 22.0,
    desktop: 24.0,
  );
  
  /// Largura da search bar
  static const double searchBarWidth = 300.0;
  static const double searchBarHeight = 42.0;
  
  // ========== ESPAÇAMENTOS FIXOS ==========
  
  /// Espaçamento entre label e input
  static const double fieldLabelToInput = 8.0;
  
  /// Footer spacing
  static const double footerTextSpacing = 6.0;
  
  // ========== BORDER WIDTH ==========
  
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;
  
  // ========== MISC ==========
  
  /// Tamanho do ícone dentro do input (prefixIcon)
  static const double inputIconPadding = 10.0;

  // ========== BOTTOM NAVIGATION ==========
  
  /// Largura de cada item no bottom nav mobile
  static const double bottomNavItemWidth = 90.0;

  // ========== TOKENS GENÉRICOS REUTILIZÁVEIS (MAIS USADOS) ==========
  
  /// Padding pequeno responsivo (usado 7x em lista)
  static const ResponsiveSize smallPadding = ResponsiveSize(
    mobile: 8.0,
    tablet: 9.0,
    desktop: 10.0,
  );
  
  /// Padding pequeno-médio responsivo (usado 21x em adicionar + lista)
  static const ResponsiveSize smallMediumPadding = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );
  
  /// Padding médio responsivo (usado 18x em dashboard + adicionar)
  static const ResponsiveSize mediumPadding = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );
  
  /// Padding de card padrão (usado 10x em adicionar)
  static const ResponsiveSize cardPadding = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  /// Padding extra pequeno responsivo
  static const ResponsiveSize tinyPadding = ResponsiveSize(
    mobile: 3.0,
    tablet: 4.0,
    desktop: 4.0,
  );
  
  /// Padding muito pequeno responsivo
  static const ResponsiveSize extraSmallPadding = ResponsiveSize(
    mobile: 4.0,
    tablet: 5.0,
    desktop: 6.0,
  );
  
  /// Padding pequeno-médio alternativo
  static const ResponsiveSize smallMediumAltPadding = ResponsiveSize(
    mobile: 6.0,
    tablet: 7.0,
    desktop: 8.0,
  );

  // ========== PRODUTOS DASHBOARD MODULE ==========
  
  /// Padding do header principal do dashboard
  static const ResponsiveSize dashboardHeaderPadding = ResponsiveSize(
    mobile: 6.0,
    tablet: 8.0,
    desktop: 10.0,
  );
  
  /// Padding dos cards do dashboard
  static const ResponsiveSize dashboardCardPadding = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  /// Padding interno dos cards de estatísticas
  static const ResponsiveSize dashboardStatPadding = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );
  
  /// Espaçamento entre cards do dashboard
  static const ResponsiveSize dashboardCardSpacing = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );
  
  /// Espaçamento entre seções do dashboard
  static const ResponsiveSize dashboardSectionSpacing = ResponsiveSize(
    mobile: 16.0,
    tablet: 20.0,
    desktop: 24.0,
  );
  
  /// Padding de elementos pequenos (ícones, badges)
  static const ResponsiveSize dashboardSmallPadding = ResponsiveSize(
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );
  
  /// Espaçamento entre elementos inline (ex: ícone + texto)
  static const ResponsiveSize dashboardInlineSpacing = ResponsiveSize(
    mobile: 4.0,
    tablet: 5.0,
    desktop: 6.0,
  );

  // ========== TOKENS ADICIONAIS V8 (100% PADDING COVERAGE) ==========
  
  /// 876x - MAIS USADO NO PROJETO!
  static const ResponsiveSize paddingBase = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );
  
  /// 499x - 2º MAIS USADO
  static const ResponsiveSize paddingMd = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );
  
  /// 242x
  static const ResponsiveSize paddingLg = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  /// 197x
  static const ResponsiveSize paddingXxs = ResponsiveSize(
    mobile: 3.0,
    tablet: 4.0,
    desktop: 4.0,
  );
  
  /// 195x
  static const ResponsiveSize paddingSm = ResponsiveSize(
    mobile: 12.0,
    tablet: 13.0,
    desktop: 14.0,
  );
  
  /// 193x
  static const ResponsiveSize paddingXs = ResponsiveSize(
    mobile: 6.0,
    tablet: 7.0,
    desktop: 8.0,
  );
  
  /// 192x
  static const ResponsiveSize paddingMdAlt = ResponsiveSize(
    mobile: 14.0,
    tablet: 15.0,
    desktop: 16.0,
  );
  
  /// 178x
  static const ResponsiveSize paddingSmAlt = ResponsiveSize(
    mobile: 8.0,
    tablet: 9.0,
    desktop: 10.0,
  );
  
  /// 161x
  static const ResponsiveSize paddingXsAlt = ResponsiveSize(
    mobile: 5.0,
    tablet: 6.0,
    desktop: 6.0,
  );
  
  /// 105x
  static const ResponsiveSize paddingXsAlt2 = ResponsiveSize(
    mobile: 7.0,
    tablet: 8.0,
    desktop: 8.0,
  );
  
  /// 103x
  static const ResponsiveSize paddingXl = ResponsiveSize(
    mobile: 20.0,
    tablet: 22.0,
    desktop: 24.0,
  );
  
  /// 65x
  static const ResponsiveSize paddingSmAlt2 = ResponsiveSize(
    mobile: 9.0,
    tablet: 9.0,
    desktop: 10.0,
  );
  
  /// 59x
  static const ResponsiveSize paddingSmAlt3 = ResponsiveSize(
    mobile: 9.0,
    tablet: 10.0,
    desktop: 10.0,
  );
  
  /// 48x
  static const ResponsiveSize paddingLgAlt = ResponsiveSize(
    mobile: 18.0,
    tablet: 19.0,
    desktop: 20.0,
  );
  
  /// 45x
  static const ResponsiveSize paddingXsAlt3 = ResponsiveSize(
    mobile: 7.0,
    tablet: 7.0,
    desktop: 8.0,
  );
  
  /// 43x
  static const ResponsiveSize paddingXsAlt4 = ResponsiveSize(
    mobile: 5.0,
    tablet: 5.0,
    desktop: 6.0,
  );
  
  /// 42x
  static const ResponsiveSize paddingXlAlt = ResponsiveSize(
    mobile: 16.0,
    tablet: 20.0,
    desktop: 24.0,
  );
  
  /// 41x
  static const ResponsiveSize paddingMdLg = ResponsiveSize(
    mobile: 14.0,
    tablet: 16.0,
    desktop: 18.0,
  );
  
  /// 40x
  static const ResponsiveSize paddingLgAlt2 = ResponsiveSize(
    mobile: 18.0,
    tablet: 21.0,
    desktop: 24.0,
  );
  
  /// 35x
  static const ResponsiveSize paddingMicro = ResponsiveSize(
    mobile: 2.0,
    tablet: 3.0,
    desktop: 3.0,
  );
  
  // ===== V8.2 - PADDING COM FLOAT (424 adicionais!) =====
  
  /// 65x
  static const ResponsiveSize paddingSmFloat = ResponsiveSize(
    mobile: 9.0,
    tablet: 9.5,
    desktop: 10.0,
  );
  
  /// 45x
  static const ResponsiveSize paddingXsFloat = ResponsiveSize(
    mobile: 7.0,
    tablet: 7.5,
    desktop: 8.0,
  );
  
  /// 42x
  static const ResponsiveSize paddingXsFloat2 = ResponsiveSize(
    mobile: 5.0,
    tablet: 5.5,
    desktop: 6.0,
  );
  
  /// 24x
  static const ResponsiveSize paddingMdAlt2 = ResponsiveSize(
    mobile: 14.0,
    tablet: 16.0,
    desktop: 16.0,
  );
  
  /// 21x (cada)
  static const ResponsiveSize paddingSmLg = ResponsiveSize(
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );
  
  static const ResponsiveSize paddingMicro2 = ResponsiveSize(
    mobile: 2.0,
    tablet: 2.0,
    desktop: 2.0,
  );
  
  /// 19x
  static const ResponsiveSize paddingLgAlt3 = ResponsiveSize(
    mobile: 16.0,
    tablet: 17.0,
    desktop: 18.0,
  );
  
  /// 17x (cada)
  static const ResponsiveSize paddingXsAlt5 = ResponsiveSize(
    mobile: 4.0,
    tablet: 5.0,
    desktop: 5.0,
  );
  
  static const ResponsiveSize paddingXxl = ResponsiveSize(
    mobile: 24.0,
    tablet: 26.0,
    desktop: 28.0,
  );
  
  /// 16x
  static const ResponsiveSize paddingXsAlt6 = ResponsiveSize(
    mobile: 4.0,
    tablet: 5.0,
    desktop: 6.0,
  );
  
  /// 14x
  static const ResponsiveSize paddingBaseLg = ResponsiveSize(
    mobile: 10.0,
    tablet: 12.0,
    desktop: 14.0,
  );
  
  /// 10x (cada)
  static const ResponsiveSize paddingXlAlt2 = ResponsiveSize(
    mobile: 20.0,
    tablet: 24.0,
    desktop: 24.0,
  );
  
  static const ResponsiveSize paddingBaseAlt = ResponsiveSize(
    mobile: 10.0,
    tablet: 12.0,
    desktop: 12.0,
  );
  
  /// 9x
  static const ResponsiveSize paddingXsLg = ResponsiveSize(
    mobile: 6.0,
    tablet: 8.0,
    desktop: 10.0,
  );
  
  /// 8x (cada)
  static const ResponsiveSize paddingMicroFloat = ResponsiveSize(
    mobile: 2.0,
    tablet: 2.75,
    desktop: 3.0,
  );
  
  static const ResponsiveSize paddingXxsFloat = ResponsiveSize(
    mobile: 3.0,
    tablet: 3.5,
    desktop: 4.0,
  );
  
  /// 7x (cada)
  static const ResponsiveSize paddingXlLg = ResponsiveSize(
    mobile: 18.0,
    tablet: 20.0,
    desktop: 24.0,
  );
  
  static const ResponsiveSize paddingXxlAlt = ResponsiveSize(
    mobile: 20.0,
    tablet: 24.0,
    desktop: 28.0,
  );
  
  static const ResponsiveSize paddingMdAlt3 = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 14.0,
  );
  
  /// 6x
  static const ResponsiveSize padding2Xl = ResponsiveSize(
    mobile: 24.0,
    tablet: 28.0,
    desktop: 32.0,
  );
  
  // Aliases para compatibilidade V7
  static const ResponsiveSize mediumSmallPadding = paddingSm;
  static const ResponsiveSize mediumLargePadding = paddingMdLg;
  static const ResponsiveSize largePadding = paddingLg;
  static const ResponsiveSize extraLargePadding = paddingXl;
  
  // ========== ÍCONES RESPONSIVOS (V7+V8 - 100% COVERAGE) ==========
  
  /// 235x - MAIS USADO
  static const ResponsiveSize iconMedium = ResponsiveSize(
    mobile: 18.0,
    tablet: 20.0,
    desktop: 22.0,
  );
  
  /// 222x - 2º MAIS USADO
  static const ResponsiveSize iconMediumSmall = ResponsiveSize(
    mobile: 17.0,
    tablet: 18.0,
    desktop: 19.0,
  );
  
  /// 160x - 3º MAIS USADO
  static const ResponsiveSize iconSmall = ResponsiveSize(
    mobile: 15.0,
    tablet: 16.0,
    desktop: 17.0,
  );
  
  // ========== ESPAÇAMENTOS RESPONSIVOS (V8 - 100% COVERAGE) ==========
  
  /// 197x - MAIS USADO
  static const ResponsiveSize spacingBase = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );
  
  /// 91x
  static const ResponsiveSize spacingMdFloat = ResponsiveSize(
    mobile: 7.0,
    tablet: 7.5,
    desktop: 8.0,
  );
  
  /// 60x
  static const ResponsiveSize spacingXsFloat = ResponsiveSize(
    mobile: 3.0,
    tablet: 3.5,
    desktop: 4.0,
  );
  
  /// 58x
  static const ResponsiveSize spacingMdAlt = ResponsiveSize(
    mobile: 14.0,
    tablet: 15.0,
    desktop: 16.0,
  );
  
  /// 57x
  static const ResponsiveSize spacingMd = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );
  
  /// 37x
  static const ResponsiveSize spacingSmFloat = ResponsiveSize(
    mobile: 5.0,
    tablet: 5.5,
    desktop: 6.0,
  );
  
  /// 23x (cada)
  static const ResponsiveSize spacingLg = ResponsiveSize(
    mobile: 18.0,
    tablet: 19.0,
    desktop: 20.0,
  );
  
  static const ResponsiveSize spacingXs = ResponsiveSize(
    mobile: 6.0,
    tablet: 7.0,
    desktop: 8.0,
  );
  
  /// 14x
  static const ResponsiveSize spacingSmFloat2 = ResponsiveSize(
    mobile: 9.0,
    tablet: 9.5,
    desktop: 10.0,
  );
  
  /// 12x
  static const ResponsiveSize spacingXsAlt = ResponsiveSize(
    mobile: 4.0,
    tablet: 5.0,
    desktop: 6.0,
  );
  
  /// 11x
  static const ResponsiveSize spacingSm = ResponsiveSize(
    mobile: 12.0,
    tablet: 13.0,
    desktop: 14.0,
  );
  
  /// 8x (cada)
  static const ResponsiveSize spacingMicroFloat = ResponsiveSize(
    mobile: 2.5,
    tablet: 2.75,
    desktop: 3.0,
  );
  
  static const ResponsiveSize spacingMicro = ResponsiveSize(
    mobile: 2.0,
    tablet: 2.0,
    desktop: 2.0,
  );
  
  /// 7x (cada)
  static const ResponsiveSize spacingXl = ResponsiveSize(
    mobile: 20.0,
    tablet: 22.0,
    desktop: 24.0,
  );
  
  static const ResponsiveSize spacingSmAlt = ResponsiveSize(
    mobile: 8.0,
    tablet: 9.0,
    desktop: 10.0,
  );
  
  // ===== V8.2 - SPACING ADICIONAIS (49 ocorrências!) =====
  
  /// 6x (cada)
  static const ResponsiveSize spacingMicroAlt = ResponsiveSize(
    mobile: 2.0,
    tablet: 3.0,
    desktop: 4.0,
  );
  
  static const ResponsiveSize spacingXxsAlt = ResponsiveSize(
    mobile: 3.0,
    tablet: 4.0,
    desktop: 4.0,
  );
  
  static const ResponsiveSize spacingLgAlt = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  /// 5x (cada)
  static const ResponsiveSize spacingMicroFloat2 = ResponsiveSize(
    mobile: 2.0,
    tablet: 2.5,
    desktop: 2.0,
  );
  
  static const ResponsiveSize spacingXsAlt2 = ResponsiveSize(
    mobile: 5.0,
    tablet: 6.0,
    desktop: 6.0,
  );
  
  /// 3x (cada)
  static const ResponsiveSize spacingXxsAlt2 = ResponsiveSize(
    mobile: 3.0,
    tablet: 4.0,
    desktop: 5.0,
  );
  
  static const ResponsiveSize spacingBaseLg = ResponsiveSize(
    mobile: 10.0,
    tablet: 12.0,
    desktop: 14.0,
  );
  
  /// 2x (cada)
  static const ResponsiveSize spacingSmLg = ResponsiveSize(
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );
  
  static const ResponsiveSize spacingXxs = ResponsiveSize(
    mobile: 4.0,
    tablet: 4.0,
    desktop: 4.0,
  );
  
  static const ResponsiveSize spacing3Xl = ResponsiveSize(
    mobile: 70.0,
    tablet: 75.0,
    desktop: 80.0,
  );
  
  static const ResponsiveSize spacingNanoFloat = ResponsiveSize(
    mobile: 1.5,
    tablet: 1.75,
    desktop: 2.0,
  );
  
  static const ResponsiveSize spacingXxsFloat = ResponsiveSize(
    mobile: 3.0,
    tablet: 3.5,
    desktop: 3.0,
  );
  
  static const ResponsiveSize spacingBaseAlt = ResponsiveSize(
    mobile: 2.0,
    tablet: 9.0,
    desktop: 10.0,
  );
  
  static const ResponsiveSize spacingNanoAlt = ResponsiveSize(
    mobile: 1.0,
    tablet: 3.5,
    desktop: 4.0,
  );
  
  /// 1x
  static const ResponsiveSize spacingNano = ResponsiveSize(
    mobile: 1.0,
    tablet: 2.0,
    desktop: 2.0,
  );
  
  /// 117x
  static const ResponsiveSize iconMediumAlt = ResponsiveSize(
    mobile: 20.0,
    tablet: 21.0,
    desktop: 22.0,
  );
  
  /// 76x
  static const ResponsiveSize iconLarge = ResponsiveSize(
    mobile: 22.0,
    tablet: 24.0,
    desktop: 26.0,
  );
  
  /// Icon size for hero sections
  static const ResponsiveSize iconHero = ResponsiveSize(
    mobile: 48.0,
    tablet: 56.0,
    desktop: 64.0,
  );
  
  /// 75x
  static const ResponsiveSize iconTiny = ResponsiveSize(
    mobile: 14.0,
    tablet: 15.0,
    desktop: 16.0,
  );
  
  /// 63x
  static const ResponsiveSize iconMediumLarge = ResponsiveSize(
    mobile: 22.0,
    tablet: 23.0,
    desktop: 24.0,
  );
  
  /// 35x
  static const ResponsiveSize iconExtraSmall = ResponsiveSize(
    mobile: 12.0,
    tablet: 13.0,
    desktop: 14.0,
  );
  
  /// 30x
  static const ResponsiveSize iconSmallAlt = ResponsiveSize(
    mobile: 17.0,
    tablet: 17.0,
    desktop: 18.0,
  );
  
  /// 24x
  static const ResponsiveSize iconTinyAlt = ResponsiveSize(
    mobile: 15.0,
    tablet: 15.0,
    desktop: 16.0,
  );
  
  /// 22x
  static const ResponsiveSize iconExtraLarge = ResponsiveSize(
    mobile: 28.0,
    tablet: 30.0,
    desktop: 32.0,
  );
  
  /// 20x - Hero/Banner icons
  static const ResponsiveSize iconHeroMd = ResponsiveSize(
    mobile: 48.0,
    tablet: 52.0,
    desktop: 56.0,
  );
  
  /// 19x
  static const ResponsiveSize iconHeroSm = ResponsiveSize(
    mobile: 42.0,
    tablet: 45.0,
    desktop: 48.0,
  );
  
  /// 17x
  static const ResponsiveSize iconHeroLg = ResponsiveSize(
    mobile: 50.0,
    tablet: 53.0,
    desktop: 56.0,
  );
  
  /// 15x
  static const ResponsiveSize iconHeroXl = ResponsiveSize(
    mobile: 56.0,
    tablet: 60.0,
    desktop: 64.0,
  );
  
  /// 12x
  static const ResponsiveSize iconExtraSmallAlt = ResponsiveSize(
    mobile: 13.0,
    tablet: 13.0,
    desktop: 14.0,
  );
  
  /// 11x
  static const ResponsiveSize iconMediumLargeAlt = ResponsiveSize(
    mobile: 22.0,
    tablet: 24.0,
    desktop: 24.0,
  );
  
  /// 10x
  static const ResponsiveSize iconSmallMedium = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );
  
  /// 9x (cada)
  static const ResponsiveSize iconMicro = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );
  
  static const ResponsiveSize iconLargeAlt = ResponsiveSize(
    mobile: 26.0,
    tablet: 27.0,
    desktop: 28.0,
  );
  
  // ===== V8.2 - ICONS COM FLOAT (174 adicionais!) =====
  
  /// 30x - Float values!
  static const ResponsiveSize iconSmallMediumFloat = ResponsiveSize(
    mobile: 17.0,
    tablet: 17.5,
    desktop: 18.0,
  );
  
  /// 24x
  static const ResponsiveSize iconTinyFloat = ResponsiveSize(
    mobile: 15.0,
    tablet: 15.5,
    desktop: 16.0,
  );
  
  /// 12x
  static const ResponsiveSize iconExtraSmallFloat = ResponsiveSize(
    mobile: 13.0,
    tablet: 13.5,
    desktop: 14.0,
  );
  
  /// 8x (cada)
  static const ResponsiveSize iconMicroFloat = ResponsiveSize(
    mobile: 9.0,
    tablet: 9.5,
    desktop: 10.0,
  );
  
  static const ResponsiveSize iconExtraSmallAlt2 = ResponsiveSize(
    mobile: 11.0,
    tablet: 12.0,
    desktop: 12.0,
  );
  
  /// 7x
  static const ResponsiveSize iconExtraSmallFloat2 = ResponsiveSize(
    mobile: 11.0,
    tablet: 11.5,
    desktop: 12.0,
  );
  
  /// 6x (cada)
  static const ResponsiveSize iconLargeFloat = ResponsiveSize(
    mobile: 24.0,
    tablet: 25.0,
    desktop: 26.0,
  );
  
  static const ResponsiveSize iconExtraLargeAlt = ResponsiveSize(
    mobile: 32.0,
    tablet: 34.0,
    desktop: 36.0,
  );
  
  static const ResponsiveSize iconHero2Xl = ResponsiveSize(
    mobile: 60.0,
    tablet: 65.0,
    desktop: 70.0,
  );
  
  static const ResponsiveSize iconHeroSmAlt = ResponsiveSize(
    mobile: 42.0,
    tablet: 46.0,
    desktop: 48.0,
  );
  
  static const ResponsiveSize iconMediumSmallFloat2 = ResponsiveSize(
    mobile: 19.0,
    tablet: 19.5,
    desktop: 20.0,
  );
  
  /// 5x (cada)
  static const ResponsiveSize iconSmallMediumAlt = ResponsiveSize(
    mobile: 18.0,
    tablet: 20.0,
    desktop: 22.0,
  );
  
  static const ResponsiveSize iconMediumAlt2 = ResponsiveSize(
    mobile: 20.0,
    tablet: 22.0,
    desktop: 22.0,
  );
  
  static const ResponsiveSize iconExtraSmallAlt3 = ResponsiveSize(
    mobile: 13.0,
    tablet: 14.0,
    desktop: 14.0,
  );
  
  static const ResponsiveSize iconMediumLargeFloat = ResponsiveSize(
    mobile: 22.0,
    tablet: 24.0,
    desktop: 26.0,
  );
  
  /// 3x (cada)
  static const ResponsiveSize iconSmallLg = ResponsiveSize(
    mobile: 16.0,
    tablet: 20.0,
    desktop: 22.0,
  );
  
  static const ResponsiveSize iconHero3Xl = ResponsiveSize(
    mobile: 64.0,
    tablet: 72.0,
    desktop: 80.0,
  );
  
  static const ResponsiveSize iconNano = ResponsiveSize(
    mobile: 7.0,
    tablet: 8.0,
    desktop: 8.0,
  );
  
  static const ResponsiveSize iconMicroAlt = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 11.0,
  );
  
  // ========== DIVIDERS ==========
  
  /// Espessura padrão de dividers
  static const double dividerThickness = 1.0;

  // ========== SYNC STATS ==========
  
  /// Altura do divider entre stats de sync
  static const ResponsiveSize syncStatDividerHeight = ResponsiveSize(
    mobile: 25.0,
    tablet: 28.0,
    desktop: 30.0,
  );

  // ========== ÍCONES (TAMANHOS ALTERNATIVOS) ==========
  
  static const double iconXs = 14.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 28.0;

  // ========== NOTIFICATION BUTTON ==========
  
  static const double notificationButtonSize = 32.0;
  static const double notificationButtonSizeMobile = 30.0;

  // ========== SYNC DIVIDERS ==========
  
  static const double syncDividerThickness = 1.0;
  static const ResponsiveSize syncDividerHeight = ResponsiveSize(
    mobile: 25.0,
    tablet: 28.0,
    desktop: 30.0,
  );

  // ========== PRODUCT EDIT SCREEN ==========
  
  /// Padding do card principal de edição
  static const ResponsiveSize productEditCardPadding = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );

  /// Espaçamento entre seções do formulário
  static const ResponsiveSize productEditSectionSpacing = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );

  /// Padding do header/título da tela
  static const ResponsiveSize productEditHeaderPadding = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );

  /// Padding horizontal da tela de edição
  static const ResponsiveSize productEditScreenHorizontal = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );

  /// Padding vertical da tela de edição
  static const ResponsiveSize productEditScreenVertical = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );

  /// Espaçamento entre ícone e título em cards
  static const ResponsiveSize productEditIconToTitle = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  /// Padding pequeno para ícones em containers
  static const ResponsiveSize productEditIconPadding = ResponsiveSize(
    mobile: 6.0,
    tablet: 7.0,
    desktop: 8.0,
  );

  /// Padding para botões de ação
  static const ResponsiveSize productEditButtonPaddingHorizontal = ResponsiveSize(
    mobile: 8.0,
    tablet: 9.0,
    desktop: 10.0,
  );

  static const ResponsiveSize productEditButtonPaddingVertical = ResponsiveSize(
    mobile: 4.0,
    tablet: 5.0,
    desktop: 6.0,
  );

  /// Padding de inputs/campos de formulário
  static const ResponsiveSize productEditInputPadding = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  /// Espaçamento pequeno entre elementos relacionados
  static const ResponsiveSize productEditSmallSpacing = ResponsiveSize(
    mobile: 3.0,
    tablet: 4.0,
    desktop: 5.0,
  );

  /// Padding para diálogos
  static const ResponsiveSize dialogButtonPadding = ResponsiveSize(
    mobile: 20.0,
    tablet: 24.0,
    desktop: 24.0,
  );

  static const ResponsiveSize dialogButtonPaddingVertical = ResponsiveSize(
    mobile: 10.0,
    tablet: 12.0,
    desktop: 12.0,
  );

  /// Padding de botões de formulário
  static const ResponsiveSize formButtonPaddingHorizontal = ResponsiveSize(
    mobile: 12.0,
    tablet: 13.0,
    desktop: 14.0,
  );

  static const ResponsiveSize formButtonPaddingVertical = ResponsiveSize(
    mobile: 8.0,
    tablet: 9.0,
    desktop: 10.0,
  );

  /// Padding de botões primários grandes
  static const ResponsiveSize primaryButtonPaddingVertical = ResponsiveSize(
    mobile: 14.0,
    tablet: 15.0,
    desktop: 16.0,
  );

  /// Espaçamento entre ícone de alerta e texto
  static const ResponsiveSize alertIconSpacing = ResponsiveSize(
    mobile: 11.0,
    tablet: 12.0,
    desktop: 13.0,
  );

  /// Largura do ícone de tag grande
  static const ResponsiveSize tagIconSize = ResponsiveSize(
    mobile: 24.0,
    tablet: 26.0,
    desktop: 28.0,
  );

  /// Padding para campos de formulário (EdgeInsets.all)
  static const ResponsiveSize formFieldSpacing = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 14.0,
  );

  /// Padding vertical denso para botões de formulário
  static const ResponsiveSize formButtonPaddingVerticalDense = ResponsiveSize(
    mobile: 12.0,
    tablet: 13.0,
    desktop: 14.0,
  );

  /// Espaçamento entre botões agrupados
  static const ResponsiveSize buttonGroupSpacing = ResponsiveSize(
    mobile: 8.0,
    tablet: 9.0,
    desktop: 10.0,
  );

  /// Offset vertical para ícones de prefixo em campos multiline
  /// Usado para alinhar ícone ao topo em TextFormField com maxLines > 1
  static const double descriptionIconOffset = 40.0;

  // ========== GRID ASPECT RATIOS (Proporções de Grid Cards) ==========
  
  /// Aspect ratio para cards de alertas críticos
  /// Aspect ratio para cards de alerta (igual ao padrão de estratégias)
  /// Valores maiores = cards mais largos/baixos (menos altura)
  /// Mobile 1.2, Desktop 1.4 para manter consistência com estratégias
  static const ResponsiveSize alertCardAspectRatio = ResponsiveSize(
    mobile: 1.2,
    tablet: 1.3,
    desktop: 1.4,
  );
  
  /// Aspect ratio para cards de ações rápidas (igual ao padrão de estratégias)
  /// Valores menores = cards mais altos (mais espaço vertical)
  /// Mobile 1.2, Desktop 1.4 para manter consistência com estratégias
  static const ResponsiveSize actionCardAspectRatio = ResponsiveSize(
    mobile: 1.2,
    tablet: 1.3,
    desktop: 1.4,
  );
  
  /// Aspect ratio para cards de estatísticas superiores
  /// Valores maiores = cards mais largos
  /// IMPORTANTE: Valores finais ajustados para eliminar 18px overflow
  static const ResponsiveSize statCardAspectRatio = ResponsiveSize(
    mobile: 4.2,  // Mobile: extremamente horizontal para eliminar 18px overflow
    tablet: 4.8,
    desktop: 5.5, // Desktop: ultra horizontal
  );
  
  /// Aspect ratio para cards de categoria (Bebidas, Mercearia, Perecíveis, Limpeza)
  /// Usado no módulo Categorias Menu
  static const ResponsiveSize categoryCardAspectRatio = ResponsiveSize(
    mobile: 1.5,  // Mobile: 2 colunas, mais horizontal
    tablet: 1.3,  // Tablet: 4 colunas, ligeiramente mais vertical
    desktop: 1.3, // Desktop: 4 colunas, mesmo ratio tablet
  );
  
  /// Border width responsivo para cards e containers
  static const ResponsiveSize borderWidthResponsive = ResponsiveSize(
    mobile: 1.25,
    tablet: 1.5,
    desktop: 1.5,
  );
  
  /// Aspect ratio para cards de produtos em destaque
  static const ResponsiveSize productCardAspectRatio = ResponsiveSize(
    mobile: 1.8,
    tablet: 1.6,
    desktop: 1.5,
  );
  
  /// Aspect ratio para metric cards compactos
  static const ResponsiveSize metricCardAspectRatio = ResponsiveSize(
    mobile: 1.8,
    tablet: 1.6,
    desktop: 1.5,
  );

  // ========== PRODUTOS DASHBOARD ESPECÍFICO ==========

  /// Aspect ratio para Welcome Section (header principal)
  static const ResponsiveSize welcomeCardAspectRatio = ResponsiveSize(
    mobile: 3.5,
    tablet: 4.0,
    desktop: 4.5,
  );

  /// Aspect ratio para cards de métricas em tempo real
  static const ResponsiveSize realtimeMetricAspectRatio = ResponsiveSize(
    mobile: 2.8,
    tablet: 3.2,
    desktop: 3.5,
  );

  /// Altura dos dividers em listas de categorias
  static const ResponsiveSize categoryDividerHeight = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );

  /// Largura de cards de produtos em destaque (horizontal scroll)
  static const ResponsiveSize featuredProductCardWidth = ResponsiveSize(
    mobile: 180.0,
    tablet: 200.0,
    desktop: 220.0,
  );

  /// Altura de cards de produtos em destaque
  static const ResponsiveSize featuredProductCardHeight = ResponsiveSize(
    mobile: 140.0,
    tablet: 160.0,
    desktop: 180.0,
  );

  /// Padding do welcome metric box
  static const ResponsiveSize welcomeMetricPadding = ResponsiveSize(
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );

  /// Espaçamento entre welcome metrics
  static const ResponsiveSize welcomeMetricSpacing = ResponsiveSize(
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );

  /// Altura do alerta crítico card
  static const ResponsiveSize alertCardHeight = ResponsiveSize(
    mobile: 90.0,
    tablet: 95.0,
    desktop: 100.0,
  );

  /// Aspect ratio para categoria rich items
  static const ResponsiveSize categoriaRichAspectRatio = ResponsiveSize(
    mobile: 4.5,
    tablet: 5.0,
    desktop: 5.5,
  );

  /// Tamanho do ícone de categoria grande
  static const ResponsiveSize categoriaIconLarge = ResponsiveSize(
    mobile: 28.0,
    tablet: 30.0,
    desktop: 32.0,
  );

  // ========== DASHBOARD METRICS CARDS ==========

  /// Padding interno de metric cards (pequenos stats no topo)
  static const ResponsiveSize metricCardInternalPadding = ResponsiveSize(
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );

  /// Espaçamento entre ícone e valor em metric cards
  static const ResponsiveSize metricIconToValue = ResponsiveSize(
    mobile: 6.0,
    tablet: 7.0,
    desktop: 8.0,
  );

  /// Espaçamento entre valor e label em metric cards
  static const ResponsiveSize metricValueToLabel = ResponsiveSize(
    mobile: 2.0,
    tablet: 3.0,
    desktop: 4.0,
  );

  /// Espaçamento entre label e badge de crescimento
  static const ResponsiveSize metricLabelToBadge = ResponsiveSize(
    mobile: 5.0,
    tablet: 6.0,
    desktop: 6.0,
  );

  // ========== WELCOME SECTION ==========

  /// Padding do welcome section principal
  static const ResponsiveSize welcomeSectionPadding = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );

  /// Espaçamento entre header e métricas no welcome
  static const ResponsiveSize welcomeHeaderToMetrics = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );

  // ========== SECTION HEADERS ==========

  /// Padding do container de ícone em section headers
  static const ResponsiveSize sectionHeaderIconPadding = ResponsiveSize(
    mobile: 8.0,
    tablet: 9.0,
    desktop: 10.0,
  );

  /// Espaçamento entre ícone e texto em section headers
  static const ResponsiveSize sectionHeaderIconToText = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  /// Margin bottom de section headers
  static const ResponsiveSize sectionHeaderMarginBottom = ResponsiveSize(
    mobile: 16.0,
    tablet: 18.0,
    desktop: 20.0,
  );

  // ========== CATEGORIA ITEMS ==========

  /// Padding de cada item de categoria
  static const ResponsiveSize categoryItemPadding = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );

  /// Padding do container de ícone de categoria
  static const ResponsiveSize categoryIconPadding = ResponsiveSize(
    mobile: 10.0,
    tablet: 11.0,
    desktop: 12.0,
  );

  /// Espaçamento entre ícone e conteúdo em categoria
  static const ResponsiveSize categoryIconToContent = ResponsiveSize(
    mobile: 12.0,
    tablet: 14.0,
    desktop: 16.0,
  );
}




