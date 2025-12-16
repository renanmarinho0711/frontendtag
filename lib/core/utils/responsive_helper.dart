import 'package:flutter/material.dart';

/// OTIMIZADO: Cache de MediaQuery para evitar chamadas excessivas
class ResponsiveHelper {
  // Breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1025;
  
  // Breakpoints adicionais
  static const double smallMobileMaxWidth = 360;
  static const double largeMobileMaxWidth = 480;
  static const double smallTabletMaxWidth = 768;

  // OTIMIZAÇÃO: Cache de valores do MediaQuery
  static double _getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Verificações de dispositivo (OTIMIZADO)
  static bool isMobile(BuildContext context) =>
      _getScreenWidth(context) < mobileMaxWidth;

  static bool isTablet(BuildContext context) {
    final width = _getScreenWidth(context);
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) =>
      _getScreenWidth(context) >= desktopMinWidth;

  // Verificações adicionais
  static bool isSmallMobile(BuildContext context) =>
      _getScreenWidth(context) < smallMobileMaxWidth;

  static bool isLargeMobile(BuildContext context) {
    final width = _getScreenWidth(context);
    return width >= largeMobileMaxWidth && width < mobileMaxWidth;
  }

  static bool isSmallTablet(BuildContext context) {
    final width = _getScreenWidth(context);
    return width >= mobileMaxWidth && width < smallTabletMaxWidth;
  }

  static bool isLargeTablet(BuildContext context) {
    final width = _getScreenWidth(context);
    return width >= smallTabletMaxWidth && width < tabletMaxWidth;
  }

  // Orientação
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Grid adaptável
  static int getGridCrossAxisCount(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 4,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Grid adaptável com orientação
  static int getGridCrossAxisCountWithOrientation(BuildContext context, {
    int mobilePortrait = 1,
    int mobileLandscape = 2,
    int tabletPortrait = 2,
    int tabletLandscape = 3,
    int desktopPortrait = 3,
    int desktopLandscape = 4,
  }) {
    final isPort = isPortrait(context);
    
    if (isMobile(context)) {
      return isPort ? mobilePortrait : mobileLandscape;
    }
    if (isTablet(context)) {
      return isPort ? tabletPortrait : tabletLandscape;
    }
    return isPort ? desktopPortrait : desktopLandscape;
  }

  // Padding adaptável
  static double getResponsivePadding(BuildContext context, {
    double mobile = 12,
    double tablet = 16,
    double desktop = 24,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Padding adaptável com tamanhos extras
  static double getResponsivePaddingExtended(BuildContext context, {
    double smallMobile = 8,
    double mobile = 12,
    double largeMobile = 14,
    double smallTablet = 16,
    double largeTablet = 20,
    double desktop = 24,
  }) {
    if (isSmallMobile(context)) return smallMobile;
    if (isLargeMobile(context)) return largeMobile;
    if (isMobile(context)) return mobile;
    if (isSmallTablet(context)) return smallTablet;
    if (isLargeTablet(context)) return largeTablet;
    return desktop;
  }

  // Margin adaptável
  static double getResponsiveMargin(BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Font size adaptável
  static double getResponsiveFontSize(BuildContext context, {
    required double baseFontSize,
    double? mobileFontSize,
    double? tabletFontSize,
  }) {
    if (isMobile(context)) return mobileFontSize ?? baseFontSize * 0.85;
    if (isTablet(context)) return tabletFontSize ?? baseFontSize * 0.92;
    return baseFontSize;
  }

  // Font size adaptável com tamanhos extras
  static double getResponsiveFontSizeExtended(BuildContext context, {
    required double baseFontSize,
    double? smallMobileFontSize,
    double? mobileFontSize,
    double? largeMobileFontSize,
    double? tabletFontSize,
  }) {
    if (isSmallMobile(context)) {
      return smallMobileFontSize ?? baseFontSize * 0.75;
    }
    if (isLargeMobile(context)) {
      return largeMobileFontSize ?? baseFontSize * 0.88;
    }
    if (isMobile(context)) {
      return mobileFontSize ?? baseFontSize * 0.85;
    }
    if (isTablet(context)) {
      return tabletFontSize ?? baseFontSize * 0.92;
    }
    return baseFontSize;
  }

  // Tamanho de ícone adaptável
  static double getResponsiveIconSize(BuildContext context, {
    double mobile = 20,
    double tablet = 24,
    double desktop = 28,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Tamanho de ícone adaptável com tamanhos extras
  static double getResponsiveIconSizeExtended(BuildContext context, {
    double smallMobile = 16,
    double mobile = 20,
    double largeMobile = 22,
    double tablet = 24,
    double desktop = 28,
  }) {
    if (isSmallMobile(context)) return smallMobile;
    if (isLargeMobile(context)) return largeMobile;
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Border radius adaptável
  static double getResponsiveBorderRadius(BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Elevation adaptável
  static double getResponsiveElevation(BuildContext context, {
    double mobile = 2,
    double tablet = 4,
    double desktop = 6,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Blur radius adaptável para shadows
  static double getResponsiveBlurRadius(BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Largura máxima de conteúdo
  static double getContentMaxWidth(BuildContext context) {
    if (isMobile(context)) return MediaQuery.of(context).size.width;
    if (isTablet(context)) return 900;
    return 1400;
  }

  // Altura de componentes
  static double getResponsiveHeight(BuildContext context, {
    double mobile = 40,
    double tablet = 48,
    double desktop = 56,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Largura de componentes
  static double getResponsiveWidth(BuildContext context, {
    double mobile = 200,
    double tablet = 300,
    double desktop = 400,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Aspect ratio adaptável
  static double getResponsiveAspectRatio(BuildContext context, {
    double mobile = 16 / 9,
    double tablet = 4 / 3,
    double desktop = 16 / 9,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Espaçamento entre itens
  static double getResponsiveSpacing(BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // App bar height
  static double getResponsiveAppBarHeight(BuildContext context) {
    if (isMobile(context)) return 56.0;
    if (isTablet(context)) return 64.0;
    return 72.0;
  }

  // Drawer width
  static double getResponsiveDrawerWidth(BuildContext context) {
    if (isMobile(context)) return MediaQuery.of(context).size.width * 0.75;
    if (isTablet(context)) return 300.0;
    return 320.0;
  }

  // Dialog width
  static double getResponsiveDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isMobile(context)) return screenWidth * 0.9;
    if (isTablet(context)) return screenWidth * 0.6;
    return screenWidth * 0.4;
  }

  // Card width
  static double getResponsiveCardWidth(BuildContext context, {
    double mobilePercent = 1.0,
    double tabletPercent = 0.48,
    double desktopPercent = 0.32,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isMobile(context)) return screenWidth * mobilePercent;
    if (isTablet(context)) return screenWidth * tabletPercent;
    return screenWidth * desktopPercent;
  }

  // Texto responsivo com máximo de linhas
  static int getResponsiveMaxLines(BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // SizedBox responsivo
  static SizedBox responsiveSizedBoxHeight(BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    return SizedBox(
      height: getResponsiveSpacing(
        context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ),
    );
  }

  static SizedBox responsiveSizedBoxWidth(BuildContext context, {
    double mobile = 8,
    double tablet = 12,
    double desktop = 16,
  }) {
    return SizedBox(
      width: getResponsiveSpacing(
        context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ),
    );
  }

  // EdgeInsets responsivo
  static EdgeInsets getResponsiveEdgeInsets(BuildContext context, {
    EdgeInsets mobile = const EdgeInsets.all(8),
    EdgeInsets tablet = const EdgeInsets.all(12),
    EdgeInsets desktop = const EdgeInsets.all(16),
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // EdgeInsets simétrico responsivo
  static EdgeInsets getResponsiveEdgeInsetsSymmetric(BuildContext context, {
    double mobileHorizontal = 12,
    double mobileVertical = 8,
    double tabletHorizontal = 16,
    double tabletVertical = 12,
    double desktopHorizontal = 24,
    double desktopVertical = 16,
  }) {
    if (isMobile(context)) {
      return EdgeInsets.symmetric(
        horizontal: mobileHorizontal,
        vertical: mobileVertical,
      );
    }
    if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: tabletHorizontal,
        vertical: tabletVertical,
      );
    }
    return EdgeInsets.symmetric(
      horizontal: desktopHorizontal,
      vertical: desktopVertical,
    );
  }

  // Text style responsivo
  static TextStyle getResponsiveTextStyle(BuildContext context, {
    required double baseFontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontSize: getResponsiveFontSize(
        context,
        baseFontSize: baseFontSize,
      ),
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Container constraints responsivos
  static BoxConstraints getResponsiveConstraints(BuildContext context, {
    double? mobileMinWidth,
    double? mobileMaxWidth,
    double? mobileMinHeight,
    double? mobileMaxHeight,
    double? tabletMinWidth,
    double? tabletMaxWidth,
    double? tabletMinHeight,
    double? tabletMaxHeight,
    double? desktopMinWidth,
    double? desktopMaxWidth,
    double? desktopMinHeight,
    double? desktopMaxHeight,
  }) {
    if (isMobile(context)) {
      return BoxConstraints(
        minWidth: mobileMinWidth ?? 0,
        maxWidth: mobileMaxWidth ?? double.infinity,
        minHeight: mobileMinHeight ?? 0,
        maxHeight: mobileMaxHeight ?? double.infinity,
      );
    }
    if (isTablet(context)) {
      return BoxConstraints(
        minWidth: tabletMinWidth ?? 0,
        maxWidth: tabletMaxWidth ?? double.infinity,
        minHeight: tabletMinHeight ?? 0,
        maxHeight: tabletMaxHeight ?? double.infinity,
      );
    }
    return BoxConstraints(
      minWidth: desktopMinWidth ?? 0,
      maxWidth: desktopMaxWidth ?? double.infinity,
      minHeight: desktopMinHeight ?? 0,
      maxHeight: desktopMaxHeight ?? double.infinity,
    );
  }

  // Obter largura da tela
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Obter altura da tela
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Porcentagem da largura da tela
  static double screenWidthPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  // Porcentagem da altura da tela
  static double screenHeightPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  // Device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // Safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // View insets (keyboard)
  static EdgeInsets getViewInsets(BuildContext context) {
    return MediaQuery.of(context).viewInsets;
  }

  // Verificar se o teclado está aberto
  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  // Text scale factor (usando textScaler)
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1.0);
  }

  // Ajustar tamanho baseado no text scale factor
  static double adjustForTextScale(BuildContext context, double baseSize) {
    final textScale = getTextScaleFactor(context);
    return baseSize / textScale;
  }

}

// Classe auxiliar para espaçamentos responsivos
class ResponsiveSpacing {
  // Espaçamento vertical pequeno
  static Widget verticalSmall(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: 8,
        tablet: 10,
        desktop: 12,
      ),
    );
  }

  // Espaçamento vertical médio
  static Widget verticalMedium(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: 16,
        tablet: 18,
        desktop: 20,
      ),
    );
  }

  // Espaçamento vertical grande
  static Widget verticalLarge(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: 24,
        tablet: 28,
        desktop: 32,
      ),
    );
  }

  // Espaçamento horizontal pequeno
  static Widget horizontalSmall(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: 8,
        tablet: 10,
        desktop: 12,
      ),
    );
  }

  // Espaçamento horizontal médio
  static Widget horizontalMedium(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: 16,
        tablet: 18,
        desktop: 20,
      ),
    );
  }

  // Espaçamento horizontal grande
  static Widget horizontalLarge(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: 24,
        tablet: 28,
        desktop: 32,
      ),
    );
  }
}


