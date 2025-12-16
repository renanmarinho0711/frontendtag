mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

/// Card de confirmação de vinculação tag-produto
class BindingConfirmationCard extends StatelessWidget {
  final String? tagId;
  final ProductModel? produto;
  final bool isProcessing;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Animation<double>? scaleAnimation;

  const BindingConfirmationCard({
    super.key,
    this.tagId,
    this.produto,
    this.isProcessing = false,
    this.onConfirm,
    this.onCancel,
    this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.dashboardSectionGap),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: AppSpacing.xl),
          // Conexão visual
          _buildConnectionVisual(),
          const SizedBox(height: AppSpacing.xl),
          // Detalhes
          _buildDetails(),
          const SizedBox(height: AppSpacing.xl),
          // Botões
          _buildButtons(),
        ],
      ),
    );

    if (scaleAnimation != null) {
      return ScaleTransition(
        scale: scaleAnimation!,
        child: content,
      );
    }
    return content;
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppThemeColors.brandPrimaryGreen,
                AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.8),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.link_rounded,
            color: AppThemeColors.surface,
            size: 36,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Confirmar Vinculação',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppThemeColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Revise os dados antes de confirmar',
          style: TextStyle(
            fontSize: 13,
            color: AppThemeColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionVisual() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tag
        _buildItemBadge(
          icon: Icons.label_rounded,
          label: 'Tag',
          value: tagId ?? '-',
          color: AppThemeColors.blueMaterial,
        ),
        // Conector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: const Icon(
            Icons.sync_alt_rounded,
            color: AppThemeColors.brandPrimaryGreen,
            size: 28,
          ),
        ),
        // Produto
        _buildItemBadge(
          icon: Icons.inventory_2_rounded,
          label: 'Produto',
          value: produto?.nome ?? '-',
          color: AppThemeColors.blueMaterial,
        ),
      ],
    );
  }

  Widget _buildItemBadge({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    if (produto == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppThemeColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow('Código', produto!.codigo),
          const Divider(height: 16),
          _buildDetailRow('Preço', 'R\$ ${produto!.preco.toStringAsFixed(2)}'),
          if (produto!.categoria.isNotEmpty) ...[
            const Divider(height: 16),
            _buildDetailRow('Categoria', produto!.categoria),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppThemeColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppThemeColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isProcessing ? null : onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppThemeColors.textTertiary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: AppThemeColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isProcessing ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColors.brandPrimaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppThemeColors.surface),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_rounded, color: AppThemeColors.surface),
                    const SizedBox(width: AppSpacing.sm),
                    const Text(
                      'Confirmar',
                      style: TextStyle(
                        color: AppThemeColors.surface,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}

