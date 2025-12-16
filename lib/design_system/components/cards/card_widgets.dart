mport 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Card com gradiente padr�o reutiliz�vel
class GradientCard extends StatelessWidget {
  final List<Color> gradient;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final double? elevation;

  const GradientCard({
    super.key,
    required this.gradient,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveHelper.getResponsiveBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.primaryOverlay30,
            blurRadius: elevation ?? ResponsiveHelper.getResponsiveElevation(context) * 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppThemeColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? ResponsiveHelper.getResponsiveBorderRadius(context),
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
            child: child,
          ),
        ),
      ),
    );

    return card;
  }
}

/// Card de estat�stica reutiliz�vel
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradient;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return GradientCard(
      gradient: gradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppThemeColors.white70,
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                color: AppThemeColors.white70,
                size: isMobile ? 20 : 24,
              ),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              color: AppThemeColors.surface,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            SizedBox(height: isMobile ? 4 : 6),
            Text(
              subtitle!,
              style: TextStyle(
                color: AppThemeColors.white70,
                fontSize: isMobile ? 11 : 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Card de menu reutiliz�vel
class MenuCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool enabled;

  const MenuCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.trailing,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: GradientCard(
        gradient: gradient,
        onTap: enabled ? onTap : null,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 10 : 12),
              decoration: BoxDecoration(
                color: AppThemeColors.surfaceOverlay20,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppThemeColors.surface,
                size: isMobile ? 24 : 28,
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppThemeColors.surface,
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: AppThemeColors.white70,
                        fontSize: isMobile ? 12 : 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: isMobile ? 8 : 12),
              trailing!,
            ] else ...[
              SizedBox(width: isMobile ? 8 : 12),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppThemeColors.white70,
                size: isMobile ? 16 : 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Card de informa��o reutiliz�vel
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      color: backgroundColor ?? AppThemeColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(context),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(context),
        ),
        child: Padding(
          padding: padding ??
              EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(context),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: isMobile ? 4 : 6),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: AppThemeColors.textSecondary,
                  ),
                ),
              ],
              if (child != null) ...[
                SizedBox(height: isMobile ? 12 : 16),
                child!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Card vazio (empty state)
class EmptyCard extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  const EmptyCard({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 24,
            tablet: 32,
            desktop: 40,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: isMobile ? 64 : 80,
                color: AppThemeColors.grey300,
              ),
            SizedBox(height: isMobile ? 16 : 20),
            Text(
              message,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: AppThemeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: isMobile ? 8 : 12),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  color: AppThemeColors.textSecondaryOverlay70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: isMobile ? 20 : 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}




