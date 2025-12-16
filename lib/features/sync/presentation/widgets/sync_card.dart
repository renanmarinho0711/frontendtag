import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Card base reutilizável para o módulo de sincronização.
/// Fornece estilo consistente com suporte a responsividade.
class SyncCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final List<Color>? gradientColors;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const SyncCard({
    super.key,
    required this.child,
    this.borderColor,
    this.gradientColors,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final defaultPadding = EdgeInsets.all(
      AppSizes.paddingXlAlt.get(isMobile, isTablet),
    );

    final cardDecoration = BoxDecoration(
      color: gradientColors == null ? ThemeColors.of(context).surface : null,
      gradient: gradientColors != null
          ? LinearGradient(
              colors: gradientColors!,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.getResponsiveBorderRadius(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        ),
      ),
      border: borderColor != null
          ? Border.all(color: borderColor!, width: 1.5)
          : null,
      boxShadow: [
        BoxShadow(
          color: (borderColor ?? ThemeColors.of(context).textPrimary)Light,
          blurRadius: isMobile ? 15 : 20,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final content = Container(
      margin: margin,
      padding: padding ?? defaultPadding,
      decoration: cardDecoration,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        child: content,
      );
    }

    return content;
  }
}

/// Card com header e conteúdo para seções do módulo de sync.
class SyncSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Color> iconGradient;
  final Widget child;
  final Widget? trailing;
  final Color? borderColor;

  const SyncSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconGradient,
    required this.child,
    this.trailing,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return SyncCard(
      borderColor: borderColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: iconGradient),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getResponsiveBorderRadius(
                      context,
                      mobile: 10,
                      tablet: 11,
                      desktop: 12,
                    ),
                  ),
                ),
                child: Icon(
                  icon,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 15,
                        ),
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                          ),
                          color: ThemeColors.of(context).textSecondary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet)),
          // Content
          child,
        ],
      ),
    );
  }
}


