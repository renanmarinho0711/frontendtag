import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Provider global para o FeedbackService
final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService();
});

/// Servi�o centralizado para feedback do usu�rio
/// 
/// Gerencia SnackBars, Dialogs, Toasts e outros feedbacks visuais
class FeedbackService {
  /// GlobalKey para acessar o ScaffoldMessengerState
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Contexto para dialogs (do NavigationService)
  BuildContext? Function()? contextProvider;

  /// Configura o provedor de contexto
  void setContextProvider(BuildContext? Function() provider) {
    contextProvider = provider;
  }

  /// ScaffoldMessengerState atual
  ScaffoldMessengerState? get messenger => scaffoldMessengerKey.currentState;

  /// Exibe um SnackBar de sucesso
  void showSuccess(String message, {Duration? duration}) {
    final colors = _getThemeColors();
    _showSnackBar(
      message: message,
      backgroundColor: colors?.success ?? AppThemeColors.success,
      icon: Icons.check_circle_outline,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Exibe um SnackBar de erro
  void showError(String message, {Duration? duration, VoidCallback? onRetry}) {
    final colors = _getThemeColors();
    _showSnackBar(
      message: message,
      backgroundColor: colors?.error ?? AppThemeColors.error,
      icon: Icons.error_outline,
      duration: duration ?? const Duration(seconds: 4),
      action: onRetry != null
          ? SnackBarAction(
              label: 'Tentar novamente',
              textColor: colors?.surface ?? AppThemeColors.surface,
              onPressed: onRetry,
            )
          : null,
    );
  }

  /// Exibe um SnackBar de aviso
  void showWarning(String message, {Duration? duration}) {
    final colors = _getThemeColors();
    _showSnackBar(
      message: message,
      backgroundColor: colors?.warningDark ?? AppThemeColors.warningDark,
      icon: Icons.warning_amber_outlined,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Exibe um SnackBar de informação
  void showInfo(String message, {Duration? duration}) {
    final colors = _getThemeColors();
    _showSnackBar(
      message: message,
      backgroundColor: colors?.primary ?? AppThemeColors.primary,
      icon: Icons.info_outline,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Exibe um SnackBar de carregamento (não fecha automaticamente)
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showLoading(
      String message) {
    final colors = _getThemeColors();
    return _showSnackBar(
      message: message,
      backgroundColor: colors?.grey800 ?? AppThemeColors.grey800,
      icon: null,
      duration: const Duration(days: 1), // Não fecha automaticamente
      showProgressIndicator: true,
    );
  }

  /// Esconde o SnackBar atual
  void hideCurrentSnackBar() {
    messenger?.hideCurrentSnackBar();
  }

  /// Esconde todos os SnackBars
  void clearSnackBars() {
    messenger?.clearSnackBars();
  }

  /// Obtém as cores do tema atual via context (se disponível)
  ThemeColorsData? _getThemeColors() {
    final context = contextProvider?.call();
    if (context == null) return null;
    try {
      return ThemeColors.of(context);
    } catch (_) {
      return null;
    }
  }

  /// Exibe um SnackBar customizado
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _showSnackBar({
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    bool showProgressIndicator = false,
  }) {
    final colors = _getThemeColors();
    final surfaceColor = colors?.surface ?? AppThemeColors.surface;
    
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (showProgressIndicator) ...[
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(surfaceColor),
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (icon != null) ...[
            Icon(icon, color: surfaceColor, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: surfaceColor),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
      action: action,
    );

    return messenger?.showSnackBar(snackBar);
  }

  /// Exibe um Dialog de confirmação
  Future<bool> showConfirmation({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    final context = contextProvider?.call();
    if (context == null) return false;

    final colors = ThemeColors.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDangerous ? colors.error : (confirmColor ?? colors.primary),
              foregroundColor: colors.surface,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Exibe um Dialog de confirma��o de exclus�o
  Future<bool> showDeleteConfirmation({
    required String itemName,
    String? additionalMessage,
  }) {
    return showConfirmation(
      title: 'Confirmar Exclus�o',
      message:
          'Tem certeza que deseja excluir "$itemName"?${additionalMessage != null ? '\n\n$additionalMessage' : ''}',
      confirmText: 'Excluir',
      isDangerous: true,
    );
  }

  /// Exibe um Dialog de alerta
  Future<void> showAlert({
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    final context = contextProvider?.call();
    if (context == null) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Exibe um Dialog com input de texto
  Future<String?> showInputDialog({
    required String title,
    String? message,
    String? initialValue,
    String? hintText,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final context = contextProvider?.call();
    if (context == null) return null;

    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message != null) ...[
              Text(message),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    controller.dispose();
    return result;
  }

  /// Exibe um Dialog de loading
  void showLoadingDialog({String message = 'Aguarde...'}) {
    final context = contextProvider?.call();
    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 24),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  /// Esconde o Dialog de loading
  void hideLoadingDialog() {
    final context = contextProvider?.call();
    if (context == null) return;

    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Exibe op��es em um BottomSheet
  Future<T?> showOptions<T>({
    required String title,
    required List<OptionItem<T>> options,
  }) async {
    final context = contextProvider?.call();
    if (context == null) return null;

    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(height: 1),
            ...options.map(
              (option) => ListTile(
                leading:
                    option.icon != null ? Icon(option.icon) : null,
                title: Text(option.label),
                subtitle:
                    option.subtitle != null ? Text(option.subtitle!) : null,
                onTap: () => Navigator.of(context).pop(option.value),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Item de op��o para o BottomSheet de op��es
class OptionItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const OptionItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}




