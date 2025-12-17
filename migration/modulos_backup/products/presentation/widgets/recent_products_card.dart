import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

class RecentProductsCard extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel)? onEdit;
  final Function(ProductModel)? onBindTag;
  final Function(ProductModel)? onDelete;
  final VoidCallback? onViewAll;

  const RecentProductsCard({
    super.key,
    required this.products,
    required this.onProductTap,
    this.onEdit,
    this.onBindTag,
    this.onDelete,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMobile = ResponsiveHelper.isMobile(context);
    final displayProducts = products.take(5).toList();

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppThemeColors.brandPrimaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Produtos Recentes',
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppThemeColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Ãšltimas atualizações',
                            style: TextStyle(
                              fontSize: isMobile ? 11 : 12,
                              color: AppThemeColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (onViewAll != null)
                Flexible(
                  child: TextButton(
                    onPressed: onViewAll,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            isMobile ? 'Ver tudo' : 'Ver histórico completo',
                            style: const TextStyle(
                              color: AppThemeColors.brandPrimaryGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppThemeColors.brandPrimaryGreen,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            children: displayProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return _buildProductItem(context, product, isLast: index == displayProducts.length - 1);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Constrói um item de produto conforme o prompt:
  /// ðŸ–¼ï¸ Coca-Cola 2L
  ///    R$ 12,90 â€¢ Bebidas â€¢ há 5 min
  ///    [Editar] [Vincular Tag]    â†’
  Widget _buildProductItem(BuildContext context, ProductModel product, {bool isLast = false}) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final hasTag = product.tagId != null && product.tagId!.isNotEmpty;
    final timeAgo = _getTimeAgo(product.dataAtualizacao);
    final categoria = product.categoria.isNotEmpty ? product.categoria : 'Sem categoria';

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Material(
        color: AppThemeColors.transparent,
        child: InkWell(
          onTap: () => onProductTap(product),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 12 : 14),
            decoration: BoxDecoration(
              color: AppThemeColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppThemeColors.border),
            ),
            child: Row(
              children: [
                // Product Icon/Image
                Container(
                  width: isMobile ? 48 : 56,
                  height: isMobile ? 48 : 56,
                  decoration: BoxDecoration(
                    color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: product.imagem != null && product.imagem!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.imagem!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.inventory_2_rounded,
                              color: AppThemeColors.brandPrimaryGreen,
                              size: isMobile ? 24 : 28,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.inventory_2_rounded,
                          color: AppThemeColors.brandPrimaryGreen,
                          size: isMobile ? 24 : 28,
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome do produto
                      Text(
                        product.nome,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.w600,
                          color: AppThemeColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // R$ 12,90 â€¢ Bebidas â€¢ há 5 min
                      Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        children: [
                          Text(
                            'R\$ ${product.preco.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 13,
                              fontWeight: FontWeight.bold,
                              color: AppThemeColors.brandPrimaryGreen,
                            ),
                          ),
                          const Text(
                            'â€¢',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppThemeColors.textTertiary,
                            ),
                          ),
                          Text(
                            categoria,
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 13,
                              color: AppThemeColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'â€¢ $timeAgo',
                            style: TextStyle(
                              fontSize: isMobile ? 11 : 12,
                              color: AppThemeColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // [Editar] [Vincular Tag] conforme prompt
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildActionChip(
                            label: 'Editar',
                            icon: Icons.edit_outlined,
                            color: AppThemeColors.textSecondary,
                            onTap: () => onEdit?.call(product),
                          ),
                          if (hasTag)
                            _buildTagBadge(product.tag)
                          else
                            _buildActionChip(
                              label: 'Vincular Tag',
                              icon: Icons.link_rounded,
                              color: AppThemeColors.orangeMain,
                              onTap: () => onBindTag?.call(product),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Arrow indicator
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppThemeColors.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagBadge(String? tagCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.qr_code_rounded, size: 12, color: AppThemeColors.brandPrimaryGreen),
          const SizedBox(width: AppSpacing.xs),
          Text(
            tagCode ?? 'Tag vinculada',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppThemeColors.brandPrimaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours}há';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

