mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Badge para exibir nmeros ou status
class AppBadge extends StatelessWidget {
  final String? text;
  final int? count;
  final Color? backgroundColor;
  final Color? textColor;
  final double size;
  final bool showZero;
  final Widget? child;

  const AppBadge({
    super.key,
    this.text,
    this.count,
    this.backgroundColor,
    this.textColor,
    this.size = 18,
    this.showZero = false,
    this.child,
  });

  /// Factory para badge com contador
  factory AppBadge.count({
    required int count,
    Color? backgroundColor,
    Color? textColor,
    bool showZero = false,
    Widget? child,
  }) =>
      AppBadge(
        count: count,
        backgroundColor: backgroundColor,
        textColor: textColor,
        showZero: showZero,
        child: child,
      );

  /// Factory para badge de status
  factory AppBadge.status({
    required String status,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'online':
      case 'active':
      case 'success':
        bgColor = ThemeColors.of(context).greenMaterial;
        break;
      case 'offline':
      case 'inactive':
      case 'error':
        bgColor = ThemeColors.of(context).redMain;
        break;
      case 'warning':
      case 'pending':
        bgColor = ThemeColors.of(context).orangeMaterial;
        break;
      default:
        bgColor = ThemeColors.of(context).grey500;
    }

    return AppBadge(
      text: status,
      backgroundColor: backgroundColor ?? bgColor,
      textColor: textColor ?? ThemeColors.of(context).surface,
    );
  }

  /// Factory para badge circular (dot)
  factory AppBadge.dot({
    Color? color,
    double size = 8,
  }) =>
      AppBadge(
        backgroundColor: color ?? ThemeColors.of(context).redMain,
        size: size,
      );

  @override
  Widget build(BuildContext context) {
    // Se tem child, posiciona badge no canto
    if (child != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child!,
          Positioned(
            right: -4,
            top: -4,
            child: _buildBadge(context),
          ),
        ],
      );
    }

    return _buildBadge(context);
  }

  Widget _buildBadge(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.error;
    final fgColor = textColor ?? ThemeColors.of(context).surface;

    // Se no tem texto nem count,  um dot
    if (text == null && count == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
      );
    }

    // No mostrar se count  0 e showZero  false
    if (count != null && count == 0 && !showZero) {
      return const SizedBox.shrink();
    }

    final displayText = text ?? _formatCount(count!);

    return Container(
      constraints: BoxConstraints(
        minWidth: size,
        minHeight: size,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: displayText.length > 2 ? 6 : 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: fgColor,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count > 99) return '99+';
    if (count > 9) return count.toString();
    return count.toString();
  }
}

/// Badge de notificao para cones
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final bool showZero;

  const NotificationBadge({
    super.key,
    required this.child,
    required this.count,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) {
      return child;
    }

    return AppBadge.count(
      count: count,
      showZero: showZero,
      child: child,
    );
  }
}

/// Badge de status para itens de lista
class StatusBadge extends StatelessWidget {
  final String status;
  final bool showLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getStatusInfo(status);

    if (!showLabel) {
      return AppBadge.dot(color: color);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color.alphaBlend(color.withValues(alpha: 0.1), ThemeColors.of(context).surface),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.alphaBlend(color.withValues(alpha: 0.3), ThemeColors.of(context).surface)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return (ThemeColors.of(context).greenMaterial, 'Online');
      case 'offline':
        return (ThemeColors.of(context).redMain, 'Offline');
      case 'active':
      case 'ativo':
        return (ThemeColors.of(context).greenMaterial, 'Ativo');
      case 'inactive':
      case 'inativo':
        return (ThemeColors.of(context).grey500, 'Inativo');
      case 'pending':
      case 'pendente':
        return (ThemeColors.of(context).orangeMaterial, 'Pendente');
      case 'syncing':
      case 'sincronizando':
        return (ThemeColors.of(context).blueMaterial, 'Sincronizando');
      case 'error':
      case 'erro':
        return (ThemeColors.of(context).redMain, 'Erro');
      case 'success':
      case 'sucesso':
        return (ThemeColors.of(context).greenMaterial, 'Sucesso');
      default:
        return (ThemeColors.of(context).grey500, status);
    }
  }
}





