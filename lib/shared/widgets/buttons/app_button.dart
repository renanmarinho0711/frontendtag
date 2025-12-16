mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Botão principal customizado do app
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
  });

  /// Factory para botão primário
  factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
  }) =>
      AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        isExpanded: isExpanded,
        icon: icon,
        variant: AppButtonVariant.primary,
        size: size,
      );

  /// Factory para botão secundário
  factory AppButton.secondary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
  }) =>
      AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        isExpanded: isExpanded,
        icon: icon,
        variant: AppButtonVariant.secondary,
        size: size,
      );

  /// Factory para botão outline
  factory AppButton.outline({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
  }) =>
      AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        isExpanded: isExpanded,
        icon: icon,
        variant: AppButtonVariant.outline,
        size: size,
      );

  /// Factory para botão texto
  factory AppButton.text({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
  }) =>
      AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        variant: AppButtonVariant.text,
        size: size,
      );

  /// Factory para botão de perigo (delete, etc.)
  factory AppButton.danger({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
  }) =>
      AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        isExpanded: isExpanded,
        icon: icon,
        variant: AppButtonVariant.danger,
        size: size,
      );

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final padding = _getPadding();
    final textStyle = _getTextStyle(context);

    Widget button;

    if (icon != null) {
      button = switch (variant) {
        AppButtonVariant.primary ||
        AppButtonVariant.danger =>
          ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: _buildIcon(),
            label: _buildLabel(textStyle),
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
          ),
        AppButtonVariant.secondary => FilledButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: _buildIcon(),
            label: _buildLabel(textStyle),
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
          ),
        AppButtonVariant.outline => OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: _buildIcon(),
            label: _buildLabel(textStyle),
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
          ),
        AppButtonVariant.text => TextButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: _buildIcon(),
            label: _buildLabel(textStyle),
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
          ),
      };
    } else {
      button = switch (variant) {
        AppButtonVariant.primary ||
        AppButtonVariant.danger =>
          ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
            child: _buildLabel(textStyle),
          ),
        AppButtonVariant.secondary => FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
            child: _buildLabel(textStyle),
          ),
        AppButtonVariant.outline => OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
            child: _buildLabel(textStyle),
          ),
        AppButtonVariant.text => TextButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle.copyWith(padding: WidgetStatePropertyAll(padding)),
            child: _buildLabel(textStyle),
          ),
      };
    }

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: size == AppButtonSize.small ? 14 : 18,
        height: size == AppButtonSize.small ? 14 : 18,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).white70),
        ),
      );
    }
    return Icon(icon, size: size == AppButtonSize.small ? 16 : 20);
  }

  Widget _buildLabel(TextStyle? textStyle) {
    if (isLoading && icon == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size == AppButtonSize.small ? 14 : 18,
            height: size == AppButtonSize.small ? 14 : 18,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).white70),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: textStyle),
        ],
      );
    }
    return Text(label, style: textStyle);
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: ThemeColors.of(context).surface,
        ),
      AppButtonVariant.secondary => FilledButton.styleFrom(
          backgroundColor: ThemeColors.of(context).primaryPastel,
          foregroundColor: theme.primaryColor,
        ),
      AppButtonVariant.outline => OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          side: BorderSide(color: theme.primaryColor),
        ),
      AppButtonVariant.text => TextButton.styleFrom(
          foregroundColor: theme.primaryColor,
        ),
      AppButtonVariant.danger => ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: ThemeColors.of(context).surface,
        ),
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      AppButtonSize.large => const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 16,
        ),
    };
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    return switch (size) {
      AppButtonSize.small => theme.textTheme.labelSmall,
      AppButtonSize.medium => theme.textTheme.labelLarge,
      AppButtonSize.large => theme.textTheme.titleMedium,
    };
  }
}

/// Variantes do botão
enum AppButtonVariant {
  primary,
  secondary,
  outline,
  text,
  danger,
}

/// Tamanhos do botão
enum AppButtonSize {
  small,
  medium,
  large,
}




