import 'package:flutter/material.dart';
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
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: AppSpacing.xl),
          // Conexão visual
          _buildConnectionVisual(context),
          const SizedBox(height: AppSpacing.xl),
          // Detalhes
          _buildDetails(context),
          const SizedBox(height: AppSpacing.xl),
          // Botões
          _buildButtons(context),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ThemeColors.of(context).brandPrimaryGreen,
                ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.8),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.link_rounded,
            color: ThemeColors.of(context).surface,
            size: 36,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Confirmar Vinculação',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Revise os dados antes de confirmar',
          style: TextStyle(
            fontSize: 13,
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionVisual(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tag
        _buildItemBadge(context, icon: Icons.label_rounded,
          label: 'Tag',
          value: tagId ?? '-',
          color: ThemeColors.of(context).blueMaterial,
        ),
        // Conector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.sync_alt_rounded,
            color: ThemeColors.of(context).brandPrimaryGreen,
            size: 28,
          ),
        ),
        // Produto
        _buildItemBadge(context, icon: Icons.inventory_2_rounded,
          label: 'Produto',
          value: produto?.nome ?? '-',
          color: ThemeColors.of(context).blueMaterial,
        ),
      ],
    );
  }

  Widget _buildItemBadge(BuildContext context, {
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
              color: ThemeColors.of(context).textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    if (produto == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow(context, 'Código', produto!.codigo),
          const Divider(height: 16),
          _buildDetailRow(context, 'Preço', 'R\$ ${produto!.preco.toStringAsFixed(2)}'),
          if (produto!.categoria.isNotEmpty) ...[
            const Divider(height: 16),
            _buildDetailRow(context, 'Categoria', produto!.categoria),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ThemeColors.of(context).textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isProcessing ? null : onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: ThemeColors.of(context).textTertiary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: ThemeColors.of(context).textSecondary,
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
              backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isProcessing
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(ThemeColors.of(context).surface),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Confirmar',
                      style: TextStyle(
                        color: ThemeColors.of(context).surface,
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

