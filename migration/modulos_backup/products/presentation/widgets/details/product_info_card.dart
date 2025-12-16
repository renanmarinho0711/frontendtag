mport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

/// Card de informações gerais do produto
class ProductInfoCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onEdit;

  const ProductInfoCard({
    super.key,
    required this.product,
    this.onEdit,
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
        color: AppThemeColors.surface,
        borderRadius: AppRadius.card,
        boxShadow: isMobile ? AppShadows.cardMobile : AppShadows.cardDesktop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isMobile, isTablet),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
          _buildInfoRow(
            context,
            'Código de Barras',
            product.codigo ?? product.id,
            Icons.qr_code_rounded,
            isMobile,
            isTablet,
            showCopy: true,
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            'Preço Unitário',
            'R\$ ${product.preco.toStringAsFixed(2)}',
            Icons.attach_money_rounded,
            isMobile,
            isTablet,
            valueColor: product.cor ?? AppThemeColors.brandPrimaryGreen,
          ),
          if (product.precoKg != null) ...[
            _buildDivider(context),
            _buildInfoRow(
              context,
              'Preço por Kg',
              'R\$ ${product.precoKg!.toStringAsFixed(2)}',
              Icons.monitor_weight_rounded,
              isMobile,
              isTablet,
            ),
          ],
          _buildDivider(context),
          _buildInfoRow(
            context,
            'Status',
            product.statusLabel,
            product.isAtivo
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            isMobile,
            isTablet,
            valueColor: product.isAtivo
                ? AppThemeColors.success
                : AppThemeColors.textSecondary,
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            'Ãšltima Atualização',
            product.dataAtualizacao != null
                ? _formatDate(product.dataAtualizacao!)
                : (product.ultimaAtualizacao ?? 'Não disponível'),
            Icons.access_time_rounded,
            isMobile,
            isTablet,
          ),
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
            gradient: AppGradients.metrics(AppThemeColors.brandPrimaryGreen),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.info_rounded,
            color: AppThemeColors.surface,
            size: AppSizes.iconSmall.get(isMobile, isTablet),
          ),
        ),
        SizedBox(
          width: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        Expanded(
          child: Text(
            'Informações Gerais',
            style: AppTextStyles.h3.copyWith(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 14,
                tabletFontSize: 15,
              ),
            ),
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              color: product.cor ?? AppThemeColors.brandPrimaryGreen,
            ),
            onPressed: onEdit,
            tooltip: 'Editar informações',
          ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: ResponsiveHelper.getResponsiveHeight(
        context,
        mobile: 20,
        tablet: 22,
        desktop: 24,
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isMobile,
    bool isTablet, {
    Color? valueColor,
    bool showCopy = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
          color: AppThemeColors.textSecondary,
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 10,
            tablet: 11,
            desktop: 12,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                    tabletFontSize: 10,
                  ),
                  color: AppThemeColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                    tabletFontSize: 13,
                  ),
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppThemeColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (showCopy)
          IconButton(
            icon: Icon(
              Icons.copy_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              color: AppThemeColors.textSecondary,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Copiar $label',
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

