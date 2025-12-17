import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Dialog de confirmao
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final bool isDangerous;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.confirmColor,
    this.isDangerous = false,
    this.icon,
  });

  /// Mostra o dialog e retorna true se confirmado
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
    bool isDangerous = false,
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        isDangerous: isDangerous,
        icon: icon,
      ),
    );
    return result ?? false;
  }

  /// Factory para confirmao de excluso
  static Future<bool> delete({
    required BuildContext context,
    required String itemName,
    String? additionalMessage,
  }) {
    return show(
      context: context,
      title: 'Confirmar Excluso',
      message:
          'Tem certeza que deseja excluir "$itemName"?${additionalMessage != null ? '\n\n$additionalMessage' : ''}',
      confirmText: 'Excluir',
      isDangerous: true,
      icon: Icons.delete_outline,
    );
  }

  /// Factory para confirmao de sada/descarte
  static Future<bool> discard({
    required BuildContext context,
    String? message,
  }) {
    return show(
      context: context,
      title: 'Descartar alteraes?',
      message: message ?? 'Voc tem alteraes no salvas. Deseja descartar?',
      confirmText: 'Descartar',
      isDangerous: true,
      icon: Icons.warning_amber_outlined,
    );
  }

  /// Factory para confirmao de logout
  static Future<bool> logout({
    required BuildContext context,
  }) {
    return show(
      context: context,
      title: 'Sair da conta?',
      message: 'Voc ser desconectado do aplicativo.',
      confirmText: 'Sair',
      isDangerous: true,
      icon: Icons.logout,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = ThemeColors.of(context);
    final buttonColor = isDangerous
        ? theme.colorScheme.error
        : (confirmColor ?? theme.primaryColor);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              if (icon != null || isDangerous) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDangerous ? colors.redPastel : Color.alphaBlend(colors.surface.withValues(alpha: 0.9), buttonColor),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ?? (isDangerous ? Icons.warning_amber_outlined : Icons.help_outline),
                    size: 40,
                    color: isDangerous ? colors.redMain : buttonColor,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Title
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Message
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.grey600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(cancelText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: colors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(confirmText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog com opes mltiplas
class OptionsDialog<T> extends StatelessWidget {
  final String title;
  final String? message;
  final List<DialogOption<T>> options;

  const OptionsDialog({
    super.key,
    required this.title,
    this.message,
    required this.options,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    required List<DialogOption<T>> options,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => OptionsDialog<T>(
        title: title,
        message: message,
        options: options,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = ThemeColors.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.grey600,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Options
              ...options.map(
                (option) => ListTile(
                  onTap: () => Navigator.of(context).pop(option.value),
                  leading: option.icon != null
                      ? Icon(option.icon, color: option.color)
                      : null,
                  title: Text(
                    option.label,
                    style: TextStyle(color: option.color),
                  ),
                  subtitle: option.subtitle != null
                      ? Text(option.subtitle!)
                      : null,
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Cancel
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opo para o OptionsDialog
class DialogOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Color? color;

  const DialogOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.color,
  });
}





