import 'package:flutter/material.dart';
import 'package:tagbean/core/theme/app_colors.dart';
import 'package:tagbean/core/theme/app_typography.dart';
import 'package:tagbean/core/theme/app_spacing.dart';
import 'package:tagbean/core/theme/app_shadows.dart';

/// # Botões Customizados do TagBean
/// 
/// Sistema unificado de botões com variantes e estados.
/// 
/// ## Variantes e Cores:
/// - **Primary**: Fundo AppColors.primary, texto branco. CTA principal.
/// - **Secondary**: Fundo AppColors.secondary, texto branco. Ação secundária.
/// - **Outline**: Fundo transparente, borda AppColors.primary, texto AppColors.primary. Ação alternativa.
/// - **Ghost**: Fundo transparente, sem borda, texto AppColors.primary. Ação menos prioritária.
/// - **Danger**: Fundo AppColors.error, texto branco. Ação destrutiva (excluir, remover).
/// 
/// ## Tamanhos:
/// - **Small**: 32px altura
/// - **Medium**: 40px altura (padrão)
/// - **Large**: 48px altura
/// 
/// ## Estados:
/// - Normal, Hover, Pressed, Disabled, Loading
/// 
/// ## Acessibilidade:
/// - Botões desabilitados usam AppColors.grey300 (fundo) e AppColors.grey500 (texto)
/// - Outline/ghost desabilitado: texto AppColors.grey400
/// - Danger outline/ghost: borda/texto AppColors.error
enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
  outlineDanger, // Novo: outline destrutivo
  ghostDanger,   // Novo: ghost destrutivo
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final EdgeInsets? padding;
  
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
  });
  
  /// Botão primário - atalho
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
  }) : variant = AppButtonVariant.primary;
  
  /// Botão secundário - atalho
  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
  }) : variant = AppButtonVariant.secondary;
  
  /// Botão outline - atalho
  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
  }) : variant = AppButtonVariant.outline;
  
  /// Botão ghost - atalho
  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
  }) : variant = AppButtonVariant.ghost;
  
  /// Botão danger - atalho
  const AppButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
  }) : variant = AppButtonVariant.danger;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading || onPressed == null ? null : onPressed,
          borderRadius: AppSpacing.borderRadiusSm,
          splashColor: _getSplashColor(isDark),
          highlightColor: _getHighlightColor(isDark),
          child: Container(
            padding: padding ?? _getPadding(),
            decoration: BoxDecoration(
              color: _getBackgroundColor(isDark),
              borderRadius: AppSpacing.borderRadiusSm,
              border: _getBorder(isDark),
              boxShadow: _getShadow(),
            ),
            child: Center(
              child: isLoading
                  ? _buildLoadingIndicator(isDark)
                  : _buildContent(isDark),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContent(bool isDark) {
    final hasIcon = icon != null;
    final textStyle = _getTextStyle(isDark);
    
    if (hasIcon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _getIconSize(),
            color: textStyle.color,
          ),
          AppSpacing.gapHorizontalSm,
          Text(label, style: textStyle),
        ],
      );
    }
    
    return Text(label, style: textStyle);
  }
  
  Widget _buildLoadingIndicator(bool isDark) {
    return SizedBox(
      width: _getIconSize(),
      height: _getIconSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          _getTextStyle(isDark).color!,
        ),
      ),
    );
  }
  
  double _getHeight() {
    return switch (size) {
      AppButtonSize.small => 32,
      AppButtonSize.medium => 40,
      AppButtonSize.large => 48,
    };
  }
  
  EdgeInsets _getPadding() {
    return switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    };
  }
  
  double _getIconSize() {
    return switch (size) {
      AppButtonSize.small => 16,
      AppButtonSize.medium => 20,
      AppButtonSize.large => 24,
    };
  }
  
  TextStyle _getTextStyle(bool isDark) {
    final baseStyle = switch (size) {
      AppButtonSize.small => AppTypography.labelSmall(),
      AppButtonSize.medium => AppTypography.labelMedium(),
      AppButtonSize.large => AppTypography.labelLarge(),
    };
    
    final isDisabled = onPressed == null;
    
    Color textColor = switch (variant) {
      AppButtonVariant.primary => isDisabled
          ? AppColors.grey500
          : AppColors.white,
      AppButtonVariant.secondary => isDisabled
          ? AppColors.grey500
          : AppColors.white,
      AppButtonVariant.outline => isDisabled
          ? AppColors.grey400
          : isDark ? AppColors.primaryLight : AppColors.primary,
      AppButtonVariant.ghost => isDisabled
          ? AppColors.grey400
          : isDark ? AppColors.primaryLight : AppColors.primary,
      AppButtonVariant.danger => isDisabled
          ? AppColors.grey500
          : AppColors.white,
      AppButtonVariant.outlineDanger => isDisabled
          ? AppColors.grey400
          : AppColors.error,
      AppButtonVariant.ghostDanger => isDisabled
          ? AppColors.grey400
          : AppColors.error,
    };
    
    return baseStyle.copyWith(
      color: textColor,
      fontWeight: FontWeight.w600,
    );
  }
  
  Color? _getBackgroundColor(bool isDark) {
    final isDisabled = onPressed == null;
    
    return switch (variant) {
      AppButtonVariant.primary => isDisabled
          ? AppColors.grey300
          : AppColors.primary,
      AppButtonVariant.secondary => isDisabled
          ? AppColors.grey300
          : AppColors.secondary,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.danger => isDisabled
          ? AppColors.grey300
          : AppColors.error,
      AppButtonVariant.outlineDanger => Colors.transparent,
      AppButtonVariant.ghostDanger => Colors.transparent,
    };
  }
  
  Border? _getBorder(bool isDark) {
    final isDisabled = onPressed == null;
    
    return switch (variant) {
      AppButtonVariant.outline => Border.all(
          color: isDisabled
              ? AppColors.grey300
              : isDark ? AppColors.primaryLight : AppColors.primary,
          width: 1.5,
        ),
      AppButtonVariant.outlineDanger => Border.all(
          color: isDisabled
              ? AppColors.grey300
              : AppColors.error,
          width: 1.5,
        ),
      _ => null,
    };
  }
  
  List<BoxShadow>? _getShadow() {
    if (onPressed == null) return null;
    
    return switch (variant) {
      AppButtonVariant.primary || 
      AppButtonVariant.secondary || 
      AppButtonVariant.danger => AppShadows.buttonShadow,
      _ => null,
    };
  }
  
  Color _getSplashColor(bool isDark) {
    return switch (variant) {
      AppButtonVariant.primary || 
      AppButtonVariant.secondary ||
      AppButtonVariant.danger => AppColors.white.withOpacity(0.2),
      AppButtonVariant.outlineDanger ||
      AppButtonVariant.ghostDanger => AppColors.error.withOpacity(0.1),
      _ => AppColors.primary.withOpacity(0.1),
    };
  }
  
  Color _getHighlightColor(bool isDark) {
    return switch (variant) {
      AppButtonVariant.primary || 
      AppButtonVariant.secondary ||
      AppButtonVariant.danger => AppColors.white.withOpacity(0.1),
      AppButtonVariant.outlineDanger ||
      AppButtonVariant.ghostDanger => AppColors.error.withOpacity(0.05),
      _ => AppColors.primary.withOpacity(0.05),
    };
  }
}
