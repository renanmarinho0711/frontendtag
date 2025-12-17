import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

/// Seção de ações Rápidas para a tela de detalhes do produto
class QuickActionsSection extends StatelessWidget {
  final Color productColor;
  final bool hasTag;
  final VoidCallback onChangePrice;
  final VoidCallback onAdjustStock;
  final VoidCallback onTagAction;
  final VoidCallback onViewSales;

  const QuickActionsSection({
    super.key,
    required this.productColor,
    required this.hasTag,
    required this.onChangePrice,
    required this.onAdjustStock,
    required this.onTagAction,
    required this.onViewSales,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.card,
        boxShadow: isMobile ? AppShadows.cardMobile : AppShadows.cardDesktop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isMobile, isTablet),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          _buildActionButtons(context, isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isTablet) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
            AppSizes.paddingXs.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            gradient: AppGradients.metrics(productColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.flash_on_rounded,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconSmall.get(isMobile, isTablet),
          ),
        ),
        SizedBox(
          width: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        Text(
          'Ações Rápidas',
          style: AppTextStyles.h3.copyWith(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 16,
              mobileFontSize: 14,
              tabletFontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, bool isMobile, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: QuickActionButton(
            icon: Icons.attach_money_rounded,
            label: 'Alterar\nPREÇO',
            color: ThemeColors.of(context).brandPrimaryGreen,
            onTap: onChangePrice,
          ),
        ),
        SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
        Expanded(
          child: QuickActionButton(
            icon: Icons.inventory_2_rounded,
            label: 'Ajustar\nEstoque',
            color: ThemeColors.of(context).blueMaterial,
            onTap: onAdjustStock,
          ),
        ),
        SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
        Expanded(
          child: QuickActionButton(
            icon: hasTag ? Icons.link_off_rounded : Icons.link_rounded,
            label: hasTag ? 'Gerenciar\nTag' : 'Vincular\nTag',
            color:
                hasTag ? ThemeColors.of(context).yellowGold : ThemeColors.of(context).blueCyan,
            onTap: onTagAction,
          ),
        ),
        SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
        Expanded(
          child: QuickActionButton(
            icon: Icons.bar_chart_rounded,
            label: 'Ver\nVendas',
            color: ThemeColors.of(context).cyanMain,
            onTap: onViewSales,
          ),
        ),
      ],
    );
  }
}

/// Botão de Ação rãpida individual
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            vertical: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                  fontWeight: FontWeight.w600,
                  color: color,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




