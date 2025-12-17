import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Widget reutilizãvel para diálogos de confirmação
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool isDangerous;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? (isDangerous ? colors.error : colors.primary),
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: colors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(
            cancelText ?? 'Cancelar',
            style: TextStyle(
              color: colors.grey600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? colors.error : colors.primary,
            foregroundColor: colors.surface,
          ),
          child: Text(confirmText ?? 'Confirmar'),
        ),
      ],
    );
  }

  /// Mãtodo estático para mostrar o diálogo
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon,
        iconColor: iconColor,
        isDangerous: isDangerous,
      ),
    );
  }
}

/// Widget reutilizãvel para diálogos de alerta/informAção
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final IconData? icon;
  final Color? iconColor;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {    final colors = ThemeColors.of(context);    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? colors.info,
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: colors.textSecondary,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText ?? 'OK'),
        ),
      ],
    );
  }

  /// Mãtodo estático para mostrar o diálogo
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}

/// Widget reutilizãvel para diálogos de loading
class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Mãtodo estático para mostrar o diálogo
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// Mãtodo estático para ocultar o diálogo
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Helper para diálogos comuns
class DialogHelper {
  DialogHelper._();

  /// Diãlogo de confirmação de exclusão
  static Future<bool?> confirmDelete(
    BuildContext context, {
    String? itemName,
  }) {
    return ConfirmDialog.show(
      context,
      title: 'Confirmar Exclusão',
      message: itemName != null
          ? 'Tem certeza que deseja excluir "$itemName"? Esta Ação não pode ser desfeita.'
          : 'Tem certeza que deseja excluir?',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      icon: Icons.delete_rounded,
      isDangerous: true,
    );
  }

  /// Diãlogo de confirmação de cancelamento
  static Future<bool?> confirmCancel(BuildContext context) {
    return ConfirmDialog.show(
      context,
      title: 'Cancelar',
      message: 'Tem certeza que deseja cancelar?',
      confirmText: 'Sim',
      cancelText: 'Não',
      icon: Icons.cancel_rounded,
    );
  }

  /// Diãlogo de alterações não salvas
  static Future<bool?> confirmUnsavedChanges(BuildContext context) {
    return ConfirmDialog.show(
      context,
      title: 'Alterações não salvas',
      message: 'você tem alterações não salvas. Deseja descartã-las?',
      confirmText: 'Sair',
      cancelText: 'Continuar editando',
      icon: Icons.warning_rounded,
      iconColor: const Color(0xFFFFA000),
    );
  }

  /// Diãlogo de sucesso
  static Future<void> showSuccess(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return InfoDialog.show(
      context,
      title: title ?? 'Sucesso',
      message: message,
      icon: Icons.check_circle_rounded,
      iconColor: const Color(0xFF4CAF50),
    );
  }

  /// Diãlogo de erro
  static Future<void> showError(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return InfoDialog.show(
      context,
      title: title ?? 'Erro',
      message: message,
      icon: Icons.error_rounded,
      iconColor: const Color(0xFFE53935),
    );
  }

  /// Diãlogo de aviso
  static Future<void> showWarning(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return InfoDialog.show(
      context,
      title: title ?? 'atenção',
      message: message,
      icon: Icons.warning_rounded,
      iconColor: const Color(0xFFFFA000),
    );
  }

  /// Diãlogo de informAção
  static Future<void> showInfo(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return InfoDialog.show(
      context,
      title: title ?? 'InformAção',
      message: message,
      icon: Icons.info_rounded,
      iconColor: const Color(0xFF2196F3),
    );
  }
}




