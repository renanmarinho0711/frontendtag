mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Modelo para item do hist�rico de pre�os
class PriceHistoryItemData {
  final DateTime data;
  final double precoAnterior;
  final double precoNovo;
  final String? usuario;
  final String? motivo;

  PriceHistoryItemData({
    required this.data,
    required this.precoAnterior,
    required this.precoNovo,
    this.usuario,
    this.motivo,
  });
}

/// Card de hist�rico de pre�os do produto
class PriceHistoryCard extends StatelessWidget {
  final List<PriceHistoryItemData> historico;
  final bool showAll;
  final VoidCallback? onToggleShowAll;
  final int previewCount;

  const PriceHistoryCard({
    super.key,
    required this.historico,
    this.showAll = false,
    this.onToggleShowAll,
    this.previewCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final historicoExibir =
        showAll ? historico : historico.take(previewCount).toList();

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.card,
        boxShadow: isMobile ? AppShadows.softCard : AppShadows.mediumCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isMobile, isTablet),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          if (historico.isEmpty)
            _buildEmptyState(context, isMobile, isTablet)
          else ...[
            ...historicoExibir.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == historicoExibir.length - 1;

              return Column(
                children: [
                  _buildHistoryItem(context, item, isMobile, isTablet),
                  if (!isLast)
                    Divider(
                      height: ResponsiveHelper.getResponsiveHeight(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
                ],
              );
            }),
            if (historico.length > previewCount && onToggleShowAll != null) ...[
              SizedBox(
                height: AppSizes.paddingMdAlt3.get(isMobile, isTablet),
              ),
              _buildToggleButton(context, isMobile, isTablet),
            ],
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
            AppSizes.paddingXs.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            gradient: AppGradients.primaryHeader,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.history_rounded,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconSmall.get(isMobile, isTablet),
          ),
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
          child: Text(
            'Hist�rico de Pre�os',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 14,
                tabletFontSize: 15,
              ),
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isMobile, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(
              Icons.history_rounded,
              size: AppSizes.iconHero.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondaryOverlay50,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nenhum hist�rico dispon�vel',
              style: AppTextStyles.body.responsive(isMobile, isTablet).copyWith(
                    color: ThemeColors.of(context).textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    PriceHistoryItemData item,
    bool isMobile,
    bool isTablet,
  ) {
    final isAumento = item.precoNovo > item.precoAnterior;
    final percentChange =
        ((item.precoNovo - item.precoAnterior) / item.precoAnterior * 100);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDate(item.data),
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                    tabletFontSize: 10,
                  ),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.usuario ?? 'Sistema',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 10,
                    mobileFontSize: 9,
                    tabletFontSize: 9,
                  ),
                  color: ThemeColors.of(context).textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'R\$ ${item.precoAnterior.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: AppSizes.iconMicroAlt.get(isMobile, isTablet),
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              Flexible(
                child: Text(
                  'R\$ ${item.precoNovo.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                    fontWeight: FontWeight.bold,
                    color: isAumento
                        ? ThemeColors.of(context).error
                        : ThemeColors.of(context).success,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
          ),
          decoration: BoxDecoration(
            color:
                isAumento ? ThemeColors.of(context).errorLight : ThemeColors.of(context).successLight,
            borderRadius: AppRadius.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAumento
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 10,
                color: isAumento ? ThemeColors.of(context).error : ThemeColors.of(context).success,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${percentChange.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 10,
                    mobileFontSize: 9,
                    tabletFontSize: 9,
                  ),
                  fontWeight: FontWeight.bold,
                  color:
                      isAumento ? ThemeColors.of(context).error : ThemeColors.of(context).success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(
      BuildContext context, bool isMobile, bool isTablet) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onToggleShowAll,
        icon: Icon(
          showAll ? Icons.expand_less_rounded : Icons.expand_more_rounded,
          size: 18,
        ),
        label: Text(
          showAll
              ? 'Ver Menos'
              : 'Ver Hist�rico Completo (${historico.length})',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 13,
              mobileFontSize: 12,
              tabletFontSize: 12,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          side: BorderSide(color: ThemeColors.of(context).borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: isMobile ? AppRadius.sm : AppRadius.md,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}




