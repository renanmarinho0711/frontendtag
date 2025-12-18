import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

/// # Cards Padronizados do TagBean
/// 
/// Sistema unificado de cards com variantes.
/// 
/// ## Variantes:
/// - **Elevated**: Com sombra (padrão)
/// - **Outlined**: Com borda
/// - **Filled**: Preenchido com cor sutil
/// - **Ghost**: Sem borda ou sombra
enum AppCardVariant {
  elevated,
  outlined,
  filled,
  ghost,
}

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.width,
    this.height,
  });
  
  /// Card elevado - atalho
  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.width,
    this.height,
  }) : variant = AppCardVariant.elevated;
  
  /// Card com borda - atalho
  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.width,
    this.height,
  }) : variant = AppCardVariant.outlined;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(AppSpacing.paddingMd),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getBackgroundColor(isDark),
        borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusMd),
        border: _getBorder(isDark),
        boxShadow: _getShadow(),
      ),
      child: child,
    );
    
    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusMd),
          child: content,
        ),
      );
    }
    
    if (margin != null) {
      return Padding(
        padding: margin!,
        child: content,
      );
    }
    
    return content;
  }
  
  Color _getBackgroundColor(bool isDark) {
    return switch (variant) {
      AppCardVariant.elevated || 
      AppCardVariant.outlined => isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      AppCardVariant.filled => isDark 
          ? AppColors.grey800.withOpacity(0.5)
          : AppColors.grey100,
      AppCardVariant.ghost => Colors.transparent,
    };
  }
  
  Border? _getBorder(bool isDark) {
    return switch (variant) {
      AppCardVariant.outlined => Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      _ => null,
    };
  }
  
  List<BoxShadow>? _getShadow() {
    return switch (variant) {
      AppCardVariant.elevated => AppShadows.cardShadow,
      _ => null,
    };
  }
}
