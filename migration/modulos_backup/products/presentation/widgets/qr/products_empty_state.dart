mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

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
    final color = iconColor ?? AppThemeColors.textTertiary;
    
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppThemeColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppThemeColors.textSecondary,
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
                  backgroundColor: AppThemeColors.brandPrimaryGreen,
                  foregroundColor: AppThemeColors.surface,
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
      subtitle: 'Todos os produtos já possuem tags vinculadas.',
      iconColor: AppThemeColors.success,
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
      iconColor: AppThemeColors.warning,
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

