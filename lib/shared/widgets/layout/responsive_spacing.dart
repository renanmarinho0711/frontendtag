import 'package:flutter/material.dart';

import 'package:tagbean/core/utils/responsive_helper.dart';

/// Espaçamentos padronizados responsivos
enum SpacingSize { tiny, small, medium, large, xLarge }

/// Extensão de mapeamento de espaçamento
extension SpacingSizeValues on SpacingSize {
  /// Retorna valores [mobile, tablet, desktop] para cada tamanho
  (double, double, double) get values => switch (this) {
    SpacingSize.tiny => (2, 3, 4),
    SpacingSize.small => (4, 6, 8),
    SpacingSize.medium => (8, 12, 16),
    SpacingSize.large => (16, 20, 24),
    SpacingSize.xLarge => (24, 32, 40),
  };
}

/// Widget helper para espaçamentos responsivos
class ResponsiveSpacing {
  ResponsiveSpacing._();

  /// Calcula valor responsivo a partir do contexto
  static double _getSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.25,
      desktop: desktop ?? mobile * 1.5,
    );
  }

  /// Cria SizedBox vertical com tamanho responsivo
  static Widget _buildVerticalSpacer(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(
      height: _getSize(
        context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ),
    );
  }

  /// Cria SizedBox horizontal com tamanho responsivo
  static Widget _buildHorizontalSpacer(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(
      width: _getSize(
        context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ),
    );
  }

  // ==================== Vertical Spacers ====================

  static Widget verticalTiny(BuildContext context) =>
      _buildVerticalSpacer(context, mobile: 2, tablet: 3, desktop: 4);

  static Widget verticalSmall(BuildContext context) =>
      _buildVerticalSpacer(context, mobile: 4, tablet: 6, desktop: 8);

  static Widget verticalMedium(BuildContext context) =>
      _buildVerticalSpacer(context, mobile: 8, tablet: 12, desktop: 16);

  static Widget verticalLarge(BuildContext context) =>
      _buildVerticalSpacer(context, mobile: 16, tablet: 20, desktop: 24);

  static Widget verticalXLarge(BuildContext context) =>
      _buildVerticalSpacer(context, mobile: 24, tablet: 32, desktop: 40);

  static Widget vertical(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) =>
      _buildVerticalSpacer(context, mobile: mobile, tablet: tablet, desktop: desktop);

  // ==================== Horizontal Spacers ====================

  static Widget horizontalTiny(BuildContext context) =>
      _buildHorizontalSpacer(context, mobile: 2, tablet: 3, desktop: 4);

  static Widget horizontalSmall(BuildContext context) =>
      _buildHorizontalSpacer(context, mobile: 4, tablet: 6, desktop: 8);

  static Widget horizontalMedium(BuildContext context) =>
      _buildHorizontalSpacer(context, mobile: 8, tablet: 12, desktop: 16);

  static Widget horizontalLarge(BuildContext context) =>
      _buildHorizontalSpacer(context, mobile: 16, tablet: 20, desktop: 24);

  static Widget horizontalXLarge(BuildContext context) =>
      _buildHorizontalSpacer(context, mobile: 24, tablet: 32, desktop: 40);

  static Widget horizontal(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) =>
      _buildHorizontalSpacer(context, mobile: mobile, tablet: tablet, desktop: desktop);

  // ==================== EdgeInsets ====================

  static EdgeInsets all(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = _getSize(context, mobile: mobile, tablet: tablet, desktop: desktop);
    return EdgeInsets.all(value);
  }

  static EdgeInsets symmetric(
    BuildContext context, {
    double horizontalMobile = 0,
    double verticalMobile = 0,
    double? horizontalTablet,
    double? verticalTablet,
    double? horizontalDesktop,
    double? verticalDesktop,
  }) {
    final h = _getSize(
      context,
      mobile: horizontalMobile,
      tablet: horizontalTablet,
      desktop: horizontalDesktop,
    );
    final v = _getSize(
      context,
      mobile: verticalMobile,
      tablet: verticalTablet,
      desktop: verticalDesktop,
    );
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  static EdgeInsets screenPadding(BuildContext context) => symmetric(
    context,
    horizontalMobile: 16,
    verticalMobile: 16,
    horizontalTablet: 24,
    verticalTablet: 20,
    horizontalDesktop: 32,
    verticalDesktop: 24,
  );

  static EdgeInsets cardPadding(BuildContext context) =>
      all(context, mobile: 12, tablet: 16, desktop: 20);

  static EdgeInsets listItemPadding(BuildContext context) =>
      symmetric(
        context,
        horizontalMobile: 16,
        verticalMobile: 12,
      );
}




/// Gap responsivo com padrão builder simples
class ResponsiveGap extends StatelessWidget {
  final double mobile;
  final double? tablet;
  final double? desktop;
  final Axis axis;

  const ResponsiveGap({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.axis = Axis.vertical,
  });

  const ResponsiveGap.vertical({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : axis = Axis.vertical;

  const ResponsiveGap.horizontal({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : axis = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveSpacing._getSize(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );

    return axis == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}






