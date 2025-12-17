import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/features/strategies/presentation/screens/ai_suggestions_screen.dart';
import 'package:tagbean/features/strategies/presentation/providers/strategies_provider.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:tagbean/design_system/design_system.dart';

class SugestoesIACard extends ConsumerWidget {
  const SugestoesIACard({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obtém contagem de estratégias ativas do provider
    final strategiesState = ref.watch(strategiesProvider);
    final strategiesStats = ref.watch(strategiesStatsProvider);
    final activeStrategies = strategiesState.strategies.where((s) => s.status.isActive).toList();
    final affectedProducts = strategiesStats.affectedProductsCount;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SugestoesIaScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ThemeColors.of(context).suggestionCardStart, ThemeColors.of(context).suggestionCardEnd],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.3),
              blurRadius: isMobile ? 20 : 25,
              offset: Offset(0, isMobile ? 8 : 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 18,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingSmLg.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    child: Icon(
                      Icons.auto_fix_high_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconSmallMediumAlt.get(isMobile, isTablet),
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
                          'Sugestões Inteligentes',
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
                        ),
                        SizedBox(
                          height: AppSizes.paddingMicro.get(isMobile, isTablet),
                        ),
                        Text(
                          'IA analisou e sugere ajustes em $affectedProducts produtos',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 10,
                              tabletFontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).surfaceOverlay90,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: 4,
                      tablet: 6,
                      desktop: 8,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 6,
                        tablet: 8,
                        desktop: 9,
                      ),
                      vertical: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 3,
                        tablet: 4,
                        desktop: 5,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).redMain,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 6 : 8,
                      ),
                    ),
                    child: Text(
                      'NOVO',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 10,
                          mobileFontSize: 8,
                          tabletFontSize: 9,
                        ),
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildSugestaoTag(
                      context,
                      Icons.trending_up_rounded,
                      '23 aumentos',
                      ThemeColors.of(context).suggestionAumentosBackground,
                      ThemeColors.of(context).suggestionAumentosText,
                    ),
                  ),
                  SizedBox(width: isMobile ? 8 : 10),
                  Expanded(
                    child: _buildSugestaoTag(
                      context,
                      Icons.trending_down_rounded,
                      '24 promoções',
                      ThemeColors.of(context).suggestionPromocoesBackground,
                      ThemeColors.of(context).suggestionPromocoesText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSugestaoTag(BuildContext context, IconData icon, String text, Color bgColor, Color textColor) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 8,
          tablet: 10,
          desktop: 11,
        ),
        vertical: AppSizes.paddingXs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.iconTiny.get(isMobile, isTablet),
            color: textColor,
          ),
          SizedBox(
            width: AppSizes.extraSmallPadding.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 11,
                  mobileFontSize: 9,
                  tabletFontSize: 10,
                ),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

