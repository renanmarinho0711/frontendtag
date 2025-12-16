mport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Widget para feedback visual de ações do usuário
/// Exibe snackbars, toasts e indicadores de progresso de forma consistente
class ActionFeedback {
  ActionFeedback._();

  /// Mostra snackbar de sucesso
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.lightImpact();
    _showSnackBar(
      context,
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: ThemeColors.of(context).statusActive,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Mostra snackbar de erro
  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    HapticFeedback.heavyImpact();
    _showSnackBar(
      context,
      message: message,
      icon: Icons.error_rounded,
      backgroundColor: ThemeColors.of(context).statusBlocked,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Mostra snackbar de aviso
  static void showWarning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.mediumImpact();
    _showSnackBar(
      context,
      message: message,
      icon: Icons.warning_rounded,
      backgroundColor: ThemeColors.of(context).statusPending,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Mostra snackbar informativo
  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context,
      message: message,
      icon: Icons.info_rounded,
      backgroundColor: ThemeColors.of(context).roleManager,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Mostra snackbar de recurso em desenvolvimento
  static void showComingSoon(BuildContext context, {String? featureName}) {
    final message = featureName != null
        ? '$featureName estará disponível em breve!'
        : 'Recurso em desenvolvimento!';
    
    _showSnackBar(
      context,
      message: message,
      icon: Icons.construction_rounded,
      backgroundColor: ThemeColors.of(context).roleAdmin,
      duration: const Duration(seconds: 2),
    );
  }

  /// Mostra snackbar de ação não disponível
  static void showNotAvailable(BuildContext context, String reason) {
    _showSnackBar(
      context,
      message: reason,
      icon: Icons.block_rounded,
      backgroundColor: ThemeColors.of(context).statusInactive,
      duration: const Duration(seconds: 2),
    );
  }

  /// Mostra indicador de loading em overlay
  static OverlayEntry showLoading(
    BuildContext context, {
    String? message,
  }) {
    final overlay = OverlayEntry(
      builder: (context) => _LoadingOverlay(message: message),
    );
    
    Overlay.of(context).insert(overlay);
    return overlay;
  }

  /// Mostra toast rápido (sem ação)
  static void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ThemeColors.of(context).textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay20,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: ThemeColors.of(context).surface, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: ThemeColors.of(context).surface,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}

/// Overlay de loading
class _LoadingOverlay extends StatelessWidget {
  final String? message;

  const _LoadingOverlay({this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ThemeColors.of(context).textSecondary,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.of(context).overlay20,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColors.of(context).grey700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget de confirmação inline
class InlineConfirmation extends StatefulWidget {
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Color? confirmColor;

  const InlineConfirmation({
    super.key,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    required this.onConfirm,
    required this.onCancel,
    this.confirmColor,
  });

  @override
  State<InlineConfirmation> createState() => _InlineConfirmationState();
}

class _InlineConfirmationState extends State<InlineConfirmation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeColors.of(context).grey300!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(widget.cancelLabel),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: widget.onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.confirmColor ?? ThemeColors.of(context).statusActive,
                    foregroundColor: ThemeColors.of(context).surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(widget.confirmLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





