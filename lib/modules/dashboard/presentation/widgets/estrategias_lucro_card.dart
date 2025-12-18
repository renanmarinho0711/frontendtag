import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
class EstrategiasLucroCard extends StatelessWidget {
  final Map<String, dynamic> estrategiasData;
  
  const EstrategiasLucroCard({
    super.key,
    required this.estrategiasData,
  });
  
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).success, ThemeColors.of(context).tealMainOverlay60],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).greenMainOverlay30,
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 8 : 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          AppSizes.paddingXlAlt.get(isMobile, isTablet),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    AppSizes.paddingXsLg.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceOverlay20,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 8 : 10,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconSmallLg.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(
                  width: AppSizes.paddingSmLg.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lucro com Estratégias',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 18,
                            mobileFontSize: 14,
                            tabletFontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: AppSizes.paddingMicro.get(isMobile, isTablet),
                      ),
                      Text(
                        '${estratégiasData['ativas']} Estratégias ativas',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 13,
                            mobileFontSize: 11,
                            tabletFontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).surfaceOverlay90,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 6,
                        tablet: 8,
                        desktop: 8,
                      ),
                      vertical: AppSizes.paddingXsAlt5.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 6 : 10,
                      ),
                      border: Border.all(color: ThemeColors.of(context).surfaceOverlay30),
                    ),
                    child: Text(
                      (estrategiasData['crescimento']).toString(),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                          mobileFontSize: 11,
                          tabletFontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                AppSizes.paddingBaseLg.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).surfaceOverlay15,
                borderRadius: BorderRadius.circular(
                  isMobile ? 14 : 16,
                ),
                border: Border.all(color: ThemeColors.of(context).surfaceOverlay30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildGanhoInfo(
                      context,
                      'Ganho Mensal',
                      Icons.calendar_month_rounded,
                      'R\$ ${estratégiasData['ganho_mensal'].toStringAsFixed(2)}',
                      'em ${estratégiasData['produtos_afetados']} produtos',
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 8,
                      tablet: 12,
                      desktop: 16,
                    ),
                  ),
                  Expanded(
                    child: _buildGanhoInfo(
                      context,
                      'Ganho Hoje',
                      Icons.today_rounded,
                      'R\$ ${estratégiasData['ganho_hoje'].toStringAsFixed(2)}',
                      '+15% vs. ontem',
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

  Widget _buildGanhoInfo(BuildContext context, String title, IconData icon, String value, String subtitle) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 2,
          tablet: 3,
          desktop: 4,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: ThemeColors.of(context).surfaceOverlay90,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 15,
                  tablet: 16,
                  desktop: 17,
                ),
              ),
              SizedBox(
                width: AppSizes.extraSmallPadding.get(isMobile, isTablet),
              ),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12.5,
                    ),
                    color: ThemeColors.of(context).surfaceOverlay90,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 2,
              tablet: 3,
              desktop: 4,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 17,
                mobileFontSize: 15,
                tabletFontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title == 'Ganho Hoje')
                Icon(
                  Icons.trending_up_rounded,
                  color: ThemeColors.of(context).surfaceOverlay80,
                  size: 10,
                ),
              if (title == 'Ganho Hoje') const SizedBox(width: 4),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay80,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




