import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

/// Header da lista de produtos com gradiente e estatísticas
class ProductsHeader extends StatelessWidget {
  final int totalProdutos;
  final int produtosComTag;
  final int produtosSemTag;
  final VoidCallback? onBack;
  final Function(String)? onQuickFilter;

  const ProductsHeader({
    super.key,
    required this.totalProdutos,
    required this.produtosComTag,
    required this.produtosSemTag,
    this.onBack,
    this.onQuickFilter,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: ModuleGradients.produtos,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.elevatedCard,
      ),
      child: Row(
        children: [
          _buildBackButton(context, isMobile, isTablet),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildIcon(isMobile, isTablet),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          _buildTitle(isMobile, isTablet),
          if (!isMobile) ..._buildStats(isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: AppGradients.overlayWhite20,
        borderRadius: AppRadius.iconButtonMedium,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppThemeColors.surface),
        iconSize: AppSizes.iconMedium.get(isMobile, isTablet),
        onPressed: () {
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.of(context).pop();
          }
        },
        tooltip: 'Voltar',
      ),
    );
  }

  Widget _buildIcon(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      decoration: const BoxDecoration(
        color: AppGradients.overlayWhite20,
        borderRadius: AppRadius.button,
      ),
      child: Icon(
        Icons.inventory_2_rounded,
        color: AppThemeColors.surface,
        size: AppSizes.iconLarge.get(isMobile, isTablet),
      ),
    );
  }

  Widget _buildTitle(bool isMobile, bool isTablet) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produtos',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeXl.get(isMobile, isTablet),
              fontWeight: FontWeight.bold,
              color: AppThemeColors.surface,
              letterSpacing: -0.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
          Text(
            'Gestão de catálogo e precificação',
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
              color: AppGradients.overlayWhite80,
              letterSpacing: 0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStats(bool isMobile, bool isTablet) {
    return [
      _buildCompactStat(
        '$totalProdutos',
        Icons.inventory_2_rounded,
        AppThemeColors.infoLight,
        () => onQuickFilter?.call('total'),
        isMobile,
        isTablet,
      ),
      const SizedBox(width: AppSpacing.sm),
      _buildCompactStat(
        '$produtosComTag',
        Icons.label_rounded,
        AppThemeColors.success,
        () => onQuickFilter?.call('com_tag'),
        isMobile,
        isTablet,
      ),
      const SizedBox(width: AppSpacing.sm),
      _buildCompactStat(
        '$produtosSemTag',
        Icons.label_off_rounded,
        AppThemeColors.warningLight,
        () => onQuickFilter?.call('sem_tag'),
        isMobile,
        isTablet,
      ),
    ];
  }

  Widget _buildCompactStat(
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isMobile,
    bool isTablet,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.sm,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
          vertical: AppSizes.paddingXs.get(isMobile, isTablet),
        ),
        decoration: const BoxDecoration(
          color: AppGradients.overlayWhite20,
          borderRadius: AppRadius.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: AppThemeColors.surface,
                size: AppSizes.iconSmall.get(isMobile, isTablet)),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTextStyles.fontSizeMdAlt2.get(isMobile, isTablet),
                fontWeight: FontWeight.bold,
                color: AppThemeColors.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
