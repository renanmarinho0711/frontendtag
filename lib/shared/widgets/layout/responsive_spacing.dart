mport 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

/// Widget helper para espaçamentos responsivos
class ResponsiveSpacing {
  ResponsiveSpacing._();

  // ==================== Vertical ====================

  static Widget verticalTiny(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 2, tablet: 3, desktop: 4),
    );
  }

  static Widget verticalSmall(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 4, tablet: 6, desktop: 8),
    );
  }

  static Widget verticalMedium(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 8, tablet: 12, desktop: 16),
    );
  }

  static Widget verticalLarge(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
    );
  }

  static Widget verticalXLarge(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 24, tablet: 32, desktop: 40),
    );
  }

  // ==================== Horizontal ====================

  static Widget horizontalTiny(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 2, tablet: 3, desktop: 4),
    );
  }

  static Widget horizontalSmall(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 4, tablet: 6, desktop: 8),
    );
  }

  static Widget horizontalMedium(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 8, tablet: 12, desktop: 16),
    );
  }

  static Widget horizontalLarge(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
    );
  }

  static Widget horizontalXLarge(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 24, tablet: 32, desktop: 40),
    );
  }

  // ==================== Custom ====================

  static Widget vertical(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: mobile,
        tablet: tablet ?? mobile * 1.25,
        desktop: desktop ?? mobile * 1.5,
      ),
    );
  }

  static Widget horizontal(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return SizedBox(
      width: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: mobile,
        tablet: tablet ?? mobile * 1.25,
        desktop: desktop ?? mobile * 1.5,
      ),
    );
  }

  // ==================== EdgeInsets ====================

  static EdgeInsets all(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.25,
      desktop: desktop ?? mobile * 1.5,
    );
    return EdgeInsets.all(value);
  }

  static EdgeInsets symmetric(BuildContext context, {
    double horizontalMobile = 0,
    double verticalMobile = 0,
    double? horizontalTablet,
    double? verticalTablet,
    double? horizontalDesktop,
    double? verticalDesktop,
  }) {
    final h = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: horizontalMobile,
      tablet: horizontalTablet ?? horizontalMobile * 1.25,
      desktop: horizontalDesktop ?? horizontalMobile * 1.5,
    );
    final v = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: verticalMobile,
      tablet: verticalTablet ?? verticalMobile * 1.25,
      desktop: verticalDesktop ?? verticalMobile * 1.5,
    );
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  static EdgeInsets screenPadding(BuildContext context) {
    return symmetric(
      context,
      horizontalMobile: 16,
      verticalMobile: 16,
      horizontalTablet: 24,
      verticalTablet: 20,
      horizontalDesktop: 32,
      verticalDesktop: 24,
    );
  }

  static EdgeInsets cardPadding(BuildContext context) {
    return all(context, mobile: 12, tablet: 16, desktop: 20);
  }

  static EdgeInsets listItemPadding(BuildContext context) {
    return symmetric(
      context,
      horizontalMobile: 16,
      verticalMobile: 12,
    );
  }
}

/// Gap responsivo (alternativa usando Gap package)
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
    final size = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.25,
      desktop: desktop ?? mobile * 1.5,
    );

    return axis == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}



