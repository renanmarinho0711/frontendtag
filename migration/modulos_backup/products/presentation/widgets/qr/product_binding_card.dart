import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

/// Card de produto para lista de pendentes/vinculados
class ProductBindingCard extends StatelessWidget {
  final ProductModel produto;
  final bool isPendente;
  final VoidCallback? onTap;
  final VoidCallback? onBindTag;
  final VoidCallback? onUnbindTag;

  const ProductBindingCard({
    super.key,
    required this.produto,
    required this.isPendente,
    this.onTap,
    this.onBindTag,
    this.onUnbindTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPendente 
            ? AppThemeColors.warning.withValues(alpha: 0.3)
            : AppThemeColors.success.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.neutralBlack.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppThemeColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Imagem do produto
                _buildProductImage(),
                const SizedBox(width: AppSpacing.lg),
                // Informações
                Expanded(
                  child: _buildProductInfo(),
                ),
                // Ações
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppThemeColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemeColors.border),
      ),
      child: produto.imagem != null && produto.imagem!.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.network(
              produto.imagem!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
            ),
          )
        : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.inventory_2_outlined,
        color: AppThemeColors.textTertiary,
        size: 28,
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome
        Text(
          produto.nome,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppThemeColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        // Código
        Row(
          children: [
            const Icon(
              Icons.qr_code_2_rounded,
              size: 14,
              color: AppThemeColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              produto.codigo,
              style: const TextStyle(
                fontSize: 12,
                color: AppThemeColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        // Preço ou Tag
        if (isPendente)
          _buildPriceChip()
        else
          _buildTagChip(),
      ],
    );
  }

  Widget _buildPriceChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'R\$ ${produto.preco.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppThemeColors.brandPrimaryGreen,
        ),
      ),
    );
  }

  Widget _buildTagChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppThemeColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.label_rounded,
            size: 14,
            color: AppThemeColors.success,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            produto.tag ?? 'Vinculada',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppThemeColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (isPendente) {
      return IconButton(
        onPressed: onBindTag,
        style: IconButton.styleFrom(
          backgroundColor: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(
          Icons.link_rounded,
          color: AppThemeColors.brandPrimaryGreen,
        ),
        tooltip: 'Vincular tag',
      );
    } else {
      return IconButton(
        onPressed: onUnbindTag,
        style: IconButton.styleFrom(
          backgroundColor: AppThemeColors.warning.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(
          Icons.link_off_rounded,
          color: AppThemeColors.warning,
        ),
        tooltip: 'Desvincular',
      );
    }
  }
}

