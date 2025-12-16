mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Widget reutiliz�vel para di�logos de confirma��o
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? (isDangerous ? AppThemeColors.error : AppThemeColors.primary),
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
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
          color: AppThemeColors.textSecondary,
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
              color: AppThemeColors.grey600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? AppThemeColors.error : AppThemeColors.primary,
            foregroundColor: AppThemeColors.surface,
          ),
          child: Text(confirmText ?? 'Confirmar'),
        ),
      ],
    );
  }

  /// M�todo est�tico para mostrar o di�logo
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

/// Widget reutiliz�vel para di�logos de alerta/informa��o
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
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? AppThemeColors.info,
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
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
          color: AppThemeColors.textSecondary,
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

  /// M�todo est�tico para mostrar o di�logo
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

/// Widget reutiliz�vel para di�logos de loading
class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
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
                color: AppThemeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// M�todo est�tico para mostrar o di�logo
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// M�todo est�tico para ocultar o di�logo
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Helper para di�logos comuns
class DialogHelper {
  DialogHelper._();

  /// Di�logo de confirma��o de exclus�o
  static Future<bool?> confirmDelete(
    BuildContext context, {
    String? itemName,
  }) {
    return ConfirmDialog.show(
      context,
      title: 'Confirmar Exclus�o',
      message: itemName != null
          ? 'Tem certeza que deseja excluir "$itemName"? Esta a��o n�o pode ser desfeita.'
          : 'Tem certeza que deseja excluir?',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      icon: Icons.delete_rounded,
      isDangerous: true,
    );
  }

  /// Di�logo de confirma��o de cancelamento
  static Future<bool?> confirmCancel(BuildContext context) {
    return ConfirmDialog.show(
      context,
      title: 'Cancelar',
      message: 'Tem certeza que deseja cancelar?',
      confirmText: 'Sim',
      cancelText: 'N�o',
      icon: Icons.cancel_rounded,
    );
  }

  /// Di�logo de altera��es n�o salvas
  static Future<bool?> confirmUnsavedChanges(BuildContext context) {
    return ConfirmDialog.show(
      context,
      title: 'Altera��es n�o salvas',
      message: 'Voc� tem altera��es n�o salvas. Deseja descart�-las?',
      confirmText: 'Sair',
      cancelText: 'Continuar editando',
      icon: Icons.warning_rounded,
      iconColor: AppThemeColors.warning,
    );
  }

  /// Di�logo de sucesso
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
      iconColor: AppThemeColors.success,
    );
  }

  /// Di�logo de erro
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
      iconColor: AppThemeColors.error,
    );
  }

  /// Di�logo de aviso
  static Future<void> showWarning(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return InfoDialog.show(
      context,
      title: title ?? 'Aten��o',
      message: message,
      icon: Icons.warning_rounded,
      iconColor: AppThemeColors.warning,
    );
  }

  /// Di�logo de informa��o
  static Future<void> showInfo(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return InfoDialog.show(
      context,
      title: title ?? 'Informa��o',
      message: message,
      icon: Icons.info_rounded,
      iconColor: AppThemeColors.info,
    );
  }
}




