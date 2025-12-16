import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Card compacto de alertas que usa dados do DashboardProvider
/// Mostra a quantidade de alertas pendentes e permite navegar para detalhes
class CompactAlertsCard extends ConsumerWidget {
  final VoidCallback onTap;
  
  /// Lista de alertas customizados (opcional)
  /// Se não fornecida, usa dados do DashboardProvider
  final List<DashboardAlert>? customAlerts;
  
  const CompactAlertsCard({
    super.key,
    required this.onTap,
    this.customAlerts,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Usa alertas customizados ou do provider
    final List<DashboardAlert> alerts = customAlerts ?? ref.watch(dashboardAlertsProvider);
    final alertCount = alerts.length;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        isMobile ? 14 : (isTablet ? 15 : 16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ThemeColors.of(context).alertWarningStart, ThemeColors.of(context).alertWarningEnd],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
          ),
          border: Border.all(color: ThemeColors.of(context).errorLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).redMain.withValues(alpha: 0.15),
              blurRadius: isMobile ? 15 : 20,
              offset: const Offset(0, 5),
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
                      color: ThemeColors.of(context).redMain,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 8 : 10,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_rounded,
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
                          'Alertas Pendentes',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 15,
                              mobileFontSize: 13,
                              tabletFontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingMicro.get(isMobile, isTablet),
                        ),
                        Text(
                          'Requer atenção imediata',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 9,
                              tabletFontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).redMain,
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
                        padding: EdgeInsets.all(
                          AppSizes.paddingSmAlt.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).redMain,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$alertCount',
                          style: TextStyle(
                            color: ThemeColors.of(context).surface,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 12,
                              tabletFontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surface,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Clique para ver todos os alertas',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 10,
                            tabletFontSize: 11,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.paddingXs.get(isMobile, isTablet),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: AppSizes.iconTiny.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
