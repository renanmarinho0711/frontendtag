import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Widget de estado vazio para listas de produtos
class ProductsEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const ProductsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? ThemeColors.of(context).textTertiary;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: color,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.of(context).textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
                  foregroundColor: ThemeColors.of(context).surface,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Factory para estado de nenhum produto pendente
  factory ProductsEmptyState.pendentes({VoidCallback? onImport}) {
    return ProductsEmptyState(
      icon: Icons.check_circle_outline_rounded,
      title: 'Todos vinculados!',
      subtitle: 'Todos os produtos j� possuem tags vinculadas.',
      // iconColor: Removed hardcoded color - uses ThemeColors.of(context).textTertiary
    );
  }

  /// Factory para estado de nenhum produto vinculado
  factory ProductsEmptyState.vinculados({VoidCallback? onScan}) {
    return ProductsEmptyState(
      icon: Icons.label_off_rounded,
      title: 'Nenhuma vinculação',
      subtitle: 'Ainda não há produtos vinculados a tags. Escaneie para começar.',
      actionLabel: 'Escanear',
      onAction: onScan,
      // iconColor: Removed hardcoded color - uses ThemeColors.of(context).textTertiary
    );
  }

  /// Factory para estado de carregando
  factory ProductsEmptyState.loading() {
    return ProductsEmptyState(
      icon: Icons.hourglass_empty_rounded,
      title: 'Carregando...',
      subtitle: 'Buscando produtos...',
    );
  }
}




