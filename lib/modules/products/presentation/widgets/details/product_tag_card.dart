mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Card exibindo informa��es de tag vinculada ao produto
class ProductTagCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onViewTagDetails;
  final VoidCallback? onBindTag;

  const ProductTagCard({
    super.key,
    required this.product,
    this.onViewTagDetails,
    this.onBindTag,
  });

  bool get hasTag => product.tagId != null;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: hasTag
            ? ThemeColors.of(context).successBackground
            : ThemeColors.of(context).warningBackground,
        borderRadius: AppRadius.card,
        border: Border.all(
          color:
              hasTag ? ThemeColors.of(context).successBorder : ThemeColors.of(context).warningBorder,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context, isMobile, isTablet),
          if (hasTag) ...[
            SizedBox(
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            _buildTagDetails(context, isMobile, isTablet),
            SizedBox(
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 14,
              ),
            ),
            _buildViewTagButton(context, isMobile, isTablet),
          ] else ...[
            SizedBox(
              height: AppSizes.paddingMdAlt3.get(isMobile, isTablet),
            ),
            _buildBindTagButton(context, isMobile, isTablet),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isTablet) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
            AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color: ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow:
                hasTag ? AppShadows.successGlow : AppShadows.warningGlow,
          ),
          child: Icon(
            hasTag ? Icons.label_rounded : Icons.label_off_rounded,
            color: hasTag ? ThemeColors.of(context).success : ThemeColors.of(context).warning,
            size: AppSizes.iconLarge.get(isMobile, isTablet),
          ),
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasTag ? 'Tag Associada' : 'Sem Tag',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 14,
                    tabletFontSize: 15,
                  ),
                  fontWeight: FontWeight.bold,
                  color: hasTag
                      ? ThemeColors.of(context).successText
                      : ThemeColors.of(context).warningText,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                hasTag
                    ? 'Este produto possui tag sincronizada'
                    : 'Este produto n�o possui tag associada',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                    tabletFontSize: 11,
                  ),
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagDetails(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt3.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildTagInfoRow(context, 'ID', product.tagId ?? ''),
          const SizedBox(height: AppSpacing.sm),
          _buildTagInfoRow(context, 'Status', '🟢 Online'),
          const SizedBox(height: AppSpacing.sm),
          _buildTagInfoRow(
            context,
            'Última Sincroniza��o',
            product.dataAtualizacao != null
                ? _formatDate(product.dataAtualizacao!)
                : (product.ultimaAtualizacao ?? 'N�o dispon�vel'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTagInfoRow(context, 'Bateria', '85%'),
        ],
      ),
    );
  }

  Widget _buildTagInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
                tabletFontSize: 11,
              ),
              color: ThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
                tabletFontSize: 11,
              ),
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildViewTagButton(
      BuildContext context, bool isMobile, bool isTablet) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (onViewTagDetails != null) {
            onViewTagDetails!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.open_in_new_rounded,
                        color: ThemeColors.of(context).surface),
                    SizedBox(width: AppSpacing.md),
                    Text('Abrindo detalhes da tag...'),
                  ],
                ),
                backgroundColor: ThemeColors.of(context).success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        icon: const Icon(Icons.open_in_new_rounded, size: 16),
        label: const Text(
          'Ver Detalhes da Tag',
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          foregroundColor: ThemeColors.of(context).surface,
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
        ),
      ),
    );
  }

  Widget _buildBindTagButton(
      BuildContext context, bool isMobile, bool isTablet) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (onBindTag != null) {
            onBindTag!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.qr_code_scanner_rounded,
                        color: ThemeColors.of(context).surface),
                    SizedBox(width: AppSpacing.md),
                    Text('Abrindo associa��o de tag...'),
                  ],
                ),
                backgroundColor: ThemeColors.of(context).warning,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
        label: const Text(
          'Associar Tag Agora',
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.of(context).warning,
          foregroundColor: ThemeColors.of(context).surface,
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}




