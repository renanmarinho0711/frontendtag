import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';

class CompactMetricsGrid extends ConsumerWidget {
  const CompactMetricsGrid({super.key});
  
  /// Formata número para exibição (ex: 1234 -> 1.234)
  String _formatNumber(int value) {
    if (value >= 1000) {
      return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      );
    }
    return value.toString();
  }
  
  /// Constrói a lista de estatísticas a partir dos dados reais
  List<Map<String, dynamic>> _buildEstatisticas(StoreStats stats, bool isLoading) {
    return [
      {
        'label': 'Produtos Ativos',
        'valor': isLoading ? '...' : _formatNumber(stats.productsCount),
        'icon': Icons.inventory_2_rounded,
        'cor': ThemeColors.of(context).blueMaterial,
        'mudanca': 'Total',
        'tipo': 'info',
      },
      {
        'label': 'Tags Criadas',
        'valor': isLoading ? '...' : _formatNumber(stats.tagsCount),
        'icon': Icons.label_rounded,
        'cor': ThemeColors.of(context).blueCyan,
        'mudanca': '${stats.boundTagsCount} vinculadas',
        'tipo': 'info',
      },
      {
        'label': 'Tags Vinculadas',
        'valor': isLoading ? '...' : _formatNumber(stats.boundTagsCount),
        'icon': Icons.link_rounded,
        'cor': ThemeColors.of(context).blueCyan,
        'mudanca': '${stats.bindingPercentage.toStringAsFixed(0)}%',
        'tipo': 'aumento',
      },
      {
        'label': 'Tags Disponíveis',
        'valor': isLoading ? '...' : _formatNumber(stats.availableTagsCount),
        'icon': Icons.label_outline_rounded,
        'cor': ThemeColors.of(context).greenMaterial,
        'mudanca': 'Livres',
        'tipo': 'info',
      },
    ];
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obter dados do provider
    final dashboardState = ref.watch(dashboardProvider);
    final storeStats = dashboardState.storeStats;
    
    // Construir estatísticas a partir dos dados reais
    final estatisticas = _buildEstatisticas(storeStats, dashboardState.isLoading);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador de loading ou erro
          if (dashboardState.isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(
                backgroundColor: ThemeColors.of(context).blueMaterialLight,
                valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueMaterial),
              ),
            ),
          if (dashboardState.hasError)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                dashboardState.errorMessage ?? 'Erro ao carregar dados',
                style: TextStyle(
                  color: ThemeColors.of(context).redMain,
                  fontSize: 11,
                ),
              ),
            ),
          // Grid de métricas
          isMobile && !ResponsiveHelper.isLandscape(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildMetricCard(context, estatisticas[0])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildMetricCard(context, estatisticas[1])),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                    Row(
                      children: [
                        Expanded(child: _buildMetricCard(context, estatisticas[2])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildMetricCard(context, estatisticas[3])),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: estatisticas.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < estatisticas.length - 1 ? 12 : 0),
                        child: _buildMetricCard(context, stat),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, Map<String, dynamic> stat) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isLoading = stat['valor'] == '...';

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (stat['cor'] as Color)Light,
              (stat['cor'] as Color)Light,
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: (stat['cor'] as Color)Light,
            width: AppSizes.borderWidthResponsive.get(isMobile, isTablet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              stat['icon'],
              color: stat['cor'],
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
            isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(stat['cor'] as Color),
                    ),
                  )
                : Text(
                    stat['valor'],
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: stat['cor'],
                      letterSpacing: -0.5,
                    ),
                  ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
            Text(
              stat['label'],
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 5.5, desktop: 6),
                vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 2.5, tablet: 2.75, desktop: 3),
              ),
              decoration: BoxDecoration(
                color: (stat['cor'] as Color)Light,
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stat['tipo'] == 'aumento')
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 9, tablet: 9.5, desktop: 10),
                      color: stat['cor'],
                    ),
                  if (stat['tipo'] == 'aumento')
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 2.5, tablet: 2.75, desktop: 3)),
                  Flexible(
                    child: Text(
                      stat['mudanca'],
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: stat['cor'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





