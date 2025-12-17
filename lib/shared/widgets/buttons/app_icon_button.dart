import 'package:flutter/material.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Botão de ícone customizado do app
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isLoading;
  final AppIconButtonVariant variant;
  final AppIconButtonSize size;
  final Color? color;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isLoading = false,
    this.variant = AppIconButtonVariant.standard,
    this.size = AppIconButtonSize.medium,
    this.color,
    this.backgroundColor,
  });

  /// Factory para botão preenchido
  factory AppIconButton.filled({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    bool isLoading = false,
    AppIconButtonSize size = AppIconButtonSize.medium,
    Color? color,
    Color? backgroundColor,
  }) =>
      AppIconButton(
        icon: icon,
        onPressed: onPressed,
        tooltip: tooltip,
        isLoading: isLoading,
        variant: AppIconButtonVariant.filled,
        size: size,
        color: color,
        backgroundColor: backgroundColor,
      );

  /// Factory para botão outline
  factory AppIconButton.outlined({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    bool isLoading = false,
    AppIconButtonSize size = AppIconButtonSize.medium,
    Color? color,
  }) =>
      AppIconButton(
        icon: icon,
        onPressed: onPressed,
        tooltip: tooltip,
        isLoading: isLoading,
        variant: AppIconButtonVariant.outlined,
        size: size,
        color: color,
      );

  /// Factory para botão tonal
  factory AppIconButton.tonal({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    bool isLoading = false,
    AppIconButtonSize size = AppIconButtonSize.medium,
    Color? color,
    Color? backgroundColor,
  }) =>
      AppIconButton(
        icon: icon,
        onPressed: onPressed,
        tooltip: tooltip,
        isLoading: isLoading,
        variant: AppIconButtonVariant.tonal,
        size: size,
        color: color,
        backgroundColor: backgroundColor,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = ThemeColors.of(context);
    final iconSize = _getIconSize();
    final buttonSize = _getButtonSize();

    Widget iconWidget = isLoading
        ? SizedBox(
            width: iconSize - 4,
            height: iconSize - 4,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.primaryColor,
              ),
            ),
          )
        : Icon(icon, size: iconSize);

    Widget button = switch (variant) {
      AppIconButtonVariant.standard => IconButton(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          color: color,
          iconSize: iconSize,
          tooltip: tooltip,
        ),
      AppIconButtonVariant.filled => IconButton.filled(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          color: color ?? colors.surface,
          iconSize: iconSize,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.primaryColor,
          ),
        ),
      AppIconButtonVariant.outlined => IconButton.outlined(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          color: color ?? theme.primaryColor,
          iconSize: iconSize,
          tooltip: tooltip,
        ),
      AppIconButtonVariant.tonal => IconButton.filledTonal(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          color: color,
          iconSize: iconSize,
          tooltip: tooltip,
          style: backgroundColor != null
              ? IconButton.styleFrom(backgroundColor: backgroundColor)
              : null,
        ),
    };

    if (size != AppIconButtonSize.medium) {
      return SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: button,
      );
    }

    return button;
  }

  double _getIconSize() {
    return switch (size) {
      AppIconButtonSize.small => 18,
      AppIconButtonSize.medium => 24,
      AppIconButtonSize.large => 32,
    };
  }

  double _getButtonSize() {
    return switch (size) {
      AppIconButtonSize.small => 32,
      AppIconButtonSize.medium => 48,
      AppIconButtonSize.large => 56,
    };
  }
}

/// Variantes do botão de ícone
enum AppIconButtonVariant {
  standard,
  filled,
  outlined,
  tonal,
}

/// Tamanhos do botão de ícone
enum AppIconButtonSize {
  small,
  medium,
  large,
}




