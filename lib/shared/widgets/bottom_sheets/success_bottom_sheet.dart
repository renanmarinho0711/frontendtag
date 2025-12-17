import 'package:flutter/material.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Bottom sheet de sucesso para exibir aps ações bem-sucedidas
/// 
/// Exibe uma mensagem de sucesso com cone e oferece prximas ações.
/// 
/// Uso:
/// ```dart
/// final action = await SuccessBottomSheet.show(
///   context: context,
///   title: 'Produto Criado!',
///   subtitle: produto.name,
///   actions: [
///     SuccessAction(icon: Icons.visibility, label: 'Ver Detalhes', value: 'details'),
///     SuccessAction(icon: Icons.add, label: 'Adicionar Outro', value: 'add'),
///   ],
/// );
/// ```
class SuccessBottomSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<SuccessAction> actions;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const SuccessBottomSheet({
    super.key,
    this.icon = Icons.check_circle_rounded,
    required this.title,
    this.subtitle,
    required this.actions,
    this.iconColor,
    this.iconBackgroundColor,
  });

  /// Exibe o bottom sheet e retorna a ao selecionada
  static Future<String?> show({
    required BuildContext context,
    IconData icon = Icons.check_circle_rounded,
    required String title,
    String? subtitle,
    required List<SuccessAction> actions,
    Color? iconColor,
    Color? iconBackgroundColor,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SuccessBottomSheet(
        icon: icon,
        title: title,
        subtitle: subtitle,
        actions: actions,
        iconColor: iconColor,
        iconBackgroundColor: iconBackgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              
              // cone
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? colors.successOverlay10,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: iconColor ?? colors.success,
                ),
              ),
              const SizedBox(height: 16),
              
              // Ttulo
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              // Subttulo
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Ações
              ...actions.map((action) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildActionButton(context, action),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, SuccessAction action) {
    final colors = ThemeColors.of(context);
    final isHighlighted = action.highlighted ?? false;
    
    return SizedBox(
      width: double.infinity,
      child: isHighlighted
          ? ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, action.value),
              icon: Icon(action.icon),
              label: Text(action.label),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.surface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, action.value),
              icon: Icon(action.icon),
              label: Text(action.label),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: colors.borderLight),
              ),
            ),
    );
  }
}

/// Ação para o SuccessBottomSheet
class SuccessAction {
  final IconData icon;
  final String label;
  final String value;
  final bool? highlighted;

  const SuccessAction({
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted,
  });
}

/// Bottom sheet de menu contextual (long press)
/// 
/// Exibe opes de ao para um item especfico.
/// 
/// Uso:
/// ```dart
/// ContextMenuSheet.show(
///   context: context,
///   title: 'Produto XYZ',
///   actions: [
///     ContextAction(icon: Icons.edit, label: 'Editar', onTap: () => ...),
///     ContextAction(icon: Icons.delete, label: 'Excluir', onTap: () => ..., destructive: true),
///   ],
/// );
/// ```
class ContextMenuSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<ContextAction> actions;

  const ContextMenuSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.actions,
  });

  /// Exibe o menu contextual
  static Future<void> show({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<ContextAction> actions,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContextMenuSheet(
        title: title,
        subtitle: subtitle,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Ações
            ...actions.map((action) {
              if (action is _DividerAction) {
                return const Divider(height: 1);
              }
              return _buildActionTile(context, action);
            }),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, ContextAction action) {
    final colors = ThemeColors.of(context);
    final color = action.destructive 
        ? colors.error 
        : colors.textPrimary;
    
    return ListTile(
      leading: Icon(action.icon, color: color),
      title: Text(
        action.label,
        style: TextStyle(
          color: color,
          fontWeight: action.destructive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        action.onTap();
      },
    );
  }
}

/// Ação para o ContextMenuSheet
class ContextAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const ContextAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });
  
  /// Cria um divisor
  static ContextAction divider() => _DividerAction();
}

/// Ação de divisor interna
class _DividerAction extends ContextAction {
  _DividerAction() : super(
    icon: Icons.more_horiz,
    label: '',
    onTap: () {},
  );
}





