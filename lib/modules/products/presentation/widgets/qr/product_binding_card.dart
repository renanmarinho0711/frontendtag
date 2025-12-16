mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
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
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPendente 
            ? ThemeColors.of(context).warning.withValues(alpha: 0.3)
            : ThemeColors.of(context).success.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: ThemeColors.of(context).transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Imagem do produto
                _buildProductImage(context),
                const SizedBox(width: AppSpacing.lg),
                // Informa��es
                Expanded(
                  child: _buildProductInfo(context),
                ),
                // A��es
                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: ThemeColors.of(context).backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.of(context).border),
      ),
      child: produto.imagem != null && produto.imagem!.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.network(
              produto.imagem!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImagePlaceholder(context),
            ),
          )
        : _buildImagePlaceholder(context),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Center(
      child: const Icon(
        Icons.inventory_2_outlined,
        color: ThemeColors.of(context).textTertiary,
        size: 28,
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome
        Text(
          produto.nome,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: ThemeColors.of(context).textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        // C�digo
        Row(
          children: [
            const Icon(
              Icons.qr_code_2_rounded,
              size: 14,
              color: ThemeColors.of(context).textTertiary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              produto.codigo,
              style: TextStyle(
                fontSize: 12,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        // Pre�o ou Tag
        if (isPendente)
          _buildPriceChip(context)
        else
          _buildTagChip(context),
      ],
    );
  }

  Widget _buildPriceChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'R\$ ${produto.preco.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: ThemeColors.of(context).brandPrimaryGreen,
        ),
      ),
    );
  }

  Widget _buildTagChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.label_rounded,
            size: 14,
            color: ThemeColors.of(context).success,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            produto.tag ?? 'Vinculada',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ThemeColors.of(context).success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (isPendente) {
      return IconButton(
        onPressed: onBindTag,
        style: IconButton.styleFrom(
          backgroundColor: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(
          Icons.link_rounded,
          color: ThemeColors.of(context).brandPrimaryGreen,
        ),
        tooltip: 'Vincular tag',
      );
    } else {
      return IconButton(
        onPressed: onUnbindTag,
        style: IconButton.styleFrom(
          backgroundColor: ThemeColors.of(context).warning.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(
          Icons.link_off_rounded,
          color: ThemeColors.of(context).warning,
        ),
        tooltip: 'Desvincular',
      );
    }
  }
}




