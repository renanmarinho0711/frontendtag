import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:intl/intl.dart';

/// Card compacto de status de sincronização
/// Exibe estatsticas de produtos e tags sincronizados
class CompactSyncCard extends ConsumerWidget {
  const CompactSyncCard({super.key});
  
  /// Formata nmero para exibio (ex: 1234 -> 1.234)
  String _formatNumber(int value) {
    if (value >= 1000) {
      return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      );
    }
    return value.toString();
  }
  
  /// Formata a data da Última sincronização
  String _formatLastSync(DateTime? date) {
    if (date == null) return 'Nunca sincronizado';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      return 'H ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'H ${difference.inHours}h';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Dados do dashboard
    final dashboardState = ref.watch(dashboardProvider);
    final storeStats = dashboardState.storeStats;
    final isLoading = dashboardState.isLoading;

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 12 : 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          AppSizes.paddingMdLg.get(isMobile, isTablet),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    AppSizes.paddingSmAlt.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
                  ),
                  child: Icon(
                    Icons.sync_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Última Sincronização',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 13,
                            tabletFontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).textPrimary,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingMicro.get(isMobile, isTablet),
                      ),
                      Text(
                        'Status: Concluda com sucesso',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 9,
                            tabletFontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingXsLg.get(isMobile, isTablet),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
                        ),
                        borderRadius: BorderRadius.circular(
                          isMobile ? 8 : 10,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: ThemeColors.of(context).surface,
                            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                          ),
                          SizedBox(
                            width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                          ),
                          Text(
                            'Sync',
                            style: TextStyle(
                              color: ThemeColors.of(context).surface,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 12,
                                mobileFontSize: 10,
                                tabletFontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingSm.get(isMobile, isTablet),
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).backgroundLight,
                borderRadius: BorderRadius.circular(
                  isMobile ? 8 : 10,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSyncStat(
                    context, 
                    isLoading ? '...' : _formatNumber(storeStats.productsCount), 
                    'Produtos', 
                    Icons.inventory_2_rounded,
                  ),
                  Container(
                    width: 1,
                    height: isMobile ? 25 : 30,
                    color: ThemeColors.of(context).border,
                  ),
                  _buildSyncStat(
                    context, 
                    isLoading ? '...' : _formatNumber(storeStats.tagsCount), 
                    'Tags', 
                    Icons.label_rounded,
                  ),
                  Container(
                    width: 1,
                    height: isMobile ? 25 : 30,
                    color: ThemeColors.of(context).border,
                  ),
                  _buildSyncStat(
                    context, 
                    isLoading ? '...' : '${storeStats.bindingPercentage.toStringAsFixed(0)}%', 
                    'Vnculo', 
                    Icons.link_rounded,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                    color: ThemeColors.of(context).textTertiary,
                  ),
                  SizedBox(
                    width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                  ),
                  Flexible(
                    child: Text(
                      _formatLastSync(storeStats.lastSyncDate),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 9,
                          tabletFontSize: 10,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).textTertiary,
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

  Widget _buildSyncStat(BuildContext context, String value, String label, IconData icon) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSizes.iconSmall.get(isMobile, isTablet),
          color: ThemeColors.of(context).textTertiary,
        ),
        SizedBox(
          height: AppSizes.paddingXxs.get(isMobile, isTablet),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 12,
              tabletFontSize: 13,
            ),
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 10,
              mobileFontSize: 8,
              tabletFontSize: 9,
            ),
            color: ThemeColors.of(context).textTertiary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}





