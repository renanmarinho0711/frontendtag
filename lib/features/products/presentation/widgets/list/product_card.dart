import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

/// Card de produto individual para a lista de produtos
class ProductCard extends StatelessWidget {
  final ProductModel produto;
  final int index;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget Function(ProductModel) menuBuilder;

  const ProductCard({
    super.key,
    required this.produto,
    required this.index,
    this.isSelectionMode = false,
    this.isSelected = false,
    required this.onTap,
    required this.onLongPress,
    required this.menuBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 900;
    final hasTag = produto.hasTag;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.08)
              : ThemeColors.of(context).surface,
          borderRadius: AppRadius.card,
          boxShadow: AppShadows.mediumCard,
          border: isSelected
              ? Border.all(color: ThemeColors.of(context).brandPrimaryGreen, width: 2)
              : null,
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: AppRadius.card,
            child: Padding(
              padding:
                  EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
              child: Row(
                children: [
                  // Checkbox para modo de sele��o
                  if (isSelectionMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onTap(),
                      activeColor: ThemeColors.of(context).brandPrimaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  _buildProductIcon(isMobile, isTablet),
                  SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
                  Expanded(
                    child: _buildProductInfo(isMobile, isTablet, hasTag),
                  ),
                  _buildPriceSection(isMobile, isTablet),
                  SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                  menuBuilder(produto),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductIcon(bool isMobile, bool isTablet) {
    return Container(
      width: AppSizes.iconHeroMd.get(isMobile, isTablet),
      height: AppSizes.iconHeroMd.get(isMobile, isTablet),
      decoration: BoxDecoration(
        gradient: AppGradients.fromBaseColor(context, produto.cor),
        borderRadius: AppRadius.lg,
      ),
      child: Icon(
        produto.icone,
        color: ThemeColors.of(context).surface,
        size: AppSizes.iconLarge.get(isMobile, isTablet),
      ),
    );
  }

  Widget _buildProductInfo(bool isMobile, bool isTablet, bool hasTag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          produto.nome,
          style: TextStyle(
            fontSize: AppTextStyles.fontSizeMdAlt2.get(isMobile, isTablet),
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        SizedBox(height: AppSizes.paddingXsAlt5.get(isMobile, isTablet)),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXsAlt3.get(isMobile, isTablet),
                  vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: produto.cor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.xs,
                ),
                child: Text(
                  produto.categoria,
                  style: TextStyle(
                    fontSize:
                        AppTextStyles.fontSizeMicroAlt2.get(isMobile, isTablet),
                    fontWeight: FontWeight.w600,
                    color: produto.cor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: const Text('•',
                  style: TextStyle(color: ThemeColors.of(context).textSecondary)),
            ),
            Icon(
              Icons.qr_code_rounded,
              size: AppSizes.iconMicroAlt.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondary,
            ),
            SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: Text(
                produto.codigo,
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeXxsAlt.get(isMobile, isTablet),
                  color: ThemeColors.of(context).textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.paddingXsAlt3.get(isMobile, isTablet)),
        _buildTagBadge(hasTag, isMobile, isTablet),
      ],
    );
  }

  Widget _buildTagBadge(bool hasTag, bool isMobile, bool isTablet) {
    if (hasTag) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXsAlt3.get(isMobile, isTablet),
          vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).successLight,
          borderRadius: AppRadius.xs,
          border: Border.all(color: ThemeColors.of(context).success),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.label_rounded,
              size: AppSizes.iconMicroAlt.get(isMobile, isTablet),
              color: ThemeColors.of(context).successIcon,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: Text(
                produto.tag ?? '',
                style: TextStyle(
                  fontSize:
                      AppTextStyles.fontSizeMicroAlt2.get(isMobile, isTablet),
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.of(context).successIcon,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXsAlt3.get(isMobile, isTablet),
          vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).warningLight,
          borderRadius: AppRadius.xs,
          border: Border.all(color: ThemeColors.of(context).warning),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.label_off_rounded,
              size: AppSizes.iconMicroAlt.get(isMobile, isTablet),
              color: ThemeColors.of(context).warningDark,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              'Sem etiqueta',
              style: TextStyle(
                fontSize:
                    AppTextStyles.fontSizeMicroAlt2.get(isMobile, isTablet),
                fontWeight: FontWeight.w600,
                color: ThemeColors.of(context).warningDark,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPriceSection(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (produto.preco <= 0) ...[
          // Alerta visual para produto sem pre�o
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXsAlt3.get(isMobile, isTablet),
              vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).warningLight,
              borderRadius: AppRadius.xs,
              border: Border.all(color: ThemeColors.of(context).warning),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_rounded,
                  size: AppSizes.iconMicroAlt.get(isMobile, isTablet),
                  color: ThemeColors.of(context).warningDark,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'Sem pre�o',
                  style: TextStyle(
                    fontSize:
                        AppTextStyles.fontSizeMicroAlt2.get(isMobile, isTablet),
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).warningDark,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Text(
            'R\$ ${produto.preco.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeXlAlt.get(isMobile, isTablet),
              fontWeight: FontWeight.bold,
              color: produto.cor,
            ),
          ),
        ],
        if (produto.precoKg != null && produto.preco > 0) ...[
          SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
          Text(
            'R\$ ${produto.precoKg!.toStringAsFixed(2)}/kg',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeXxsAlt.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}





