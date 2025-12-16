mport 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
class WelcomeSection extends ConsumerWidget {
  final String userName;
  
  const WelcomeSection({
    super.key,
    required this.userName,
  });
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 12) {
      return 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Obt�m dados din�micos do dashboard
    final dashboardState = ref.watch(dashboardProvider);
    final activeStrategies = dashboardState.data.strategiesStats.activeCount;
    final totalProducts = dashboardState.data.storeStats.productsCount;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.of(context).greenMaterial,
            ThemeColors.of(context).greenDark,
            ThemeColors.of(context).greenDark.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 24 : 28),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.4),
            blurRadius: isMobile ? 20 : 30,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: ThemeColors.of(context).greenDark.withValues(alpha: 0.2),
            blurRadius: isMobile ? 40 : 60,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Padr�o decorativo de fundo
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ThemeColors.of(context).surfaceOverlay10,
                    ThemeColors.of(context).transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ThemeColors.of(context).surface.withValues(alpha: 0.08),
                    ThemeColors.of(context).transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Conte�do principal
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXlLg.get(isMobile, isTablet),
              vertical: AppSizes.paddingXs.get(isMobile, isTablet),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Se��o de boas-vindas
                Expanded(
                  flex: isMobile ? 1 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge de boas-vindas
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 12,
                          vertical: isMobile ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).surfaceOverlay15,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ThemeColors.of(context).surfaceOverlay30,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '??',
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Bem-vindo de volta!',
                              style: TextStyle(
                                color: ThemeColors.of(context).surfaceOverlay95,
                                fontSize: AppTextStyles.fontSizeMicro.get(isMobile, isTablet),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingXs.get(isMobile, isTablet),
                      ),
                      
                      // Nome do usu�rio com sauda��o
                      Row(
                        children: [
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_getGreeting()}, ',
                                    style: TextStyle(
                                      color: ThemeColors.of(context).surfaceOverlay90,
                                      fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3,
                                      height: 1.1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: userName,
                                    style: TextStyle(
                                      color: ThemeColors.of(context).surface,
                                      fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 4 : 6),
                      
                      // Informa��o de estrat�gias ativas
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: ThemeColors.of(context).surfaceOverlay80,
                              size: isMobile ? 12 : 16,
                            ),
                            SizedBox(width: isMobile ? 4 : 6),
                            Text(
                              '$activeStrategies estrat�gias ativas',
                              style: TextStyle(
                                color: ThemeColors.of(context).surfaceOverlay90,
                                fontSize: AppTextStyles.fontSizeXxs.get(isMobile, isTablet),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: isMobile ? 4 : 8),
                            Text(
                              '�',
                              style: TextStyle(
                                color: ThemeColors.of(context).surfaceOverlay50,
                                fontSize: isMobile ? 10 : 12,
                              ),
                            ),
                            SizedBox(width: isMobile ? 4 : 8),
                            Icon(
                              Icons.inventory_2_outlined,
                              color: ThemeColors.of(context).surfaceOverlay80,
                              size: isMobile ? 12 : 16,
                            ),
                            SizedBox(width: isMobile ? 4 : 6),
                            Text(
                              '$totalProducts produtos',
                              style: TextStyle(
                                color: ThemeColors.of(context).surfaceOverlay90,
                                fontSize: AppTextStyles.fontSizeXxs.get(isMobile, isTablet),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (!isMobile) ...[
                  const SizedBox(width: 16),
                  
                  // Informa��es de m�tricas (din�micas do backend)
                  Expanded(
                    child: Builder(
                    builder: (context) {
                      final stats = dashboardState.data.strategiesStats;
                      final storeStats = dashboardState.data.storeStats;
                      
                      // Formata valores monet�rios
                      String formatCurrency(double value) {
                        final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
                        final parts = formatted.split(',');
                        final intPart = parts[0].replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]}.',
                        );
                        return 'R\$ $intPart,${parts[1]}';
                      }
                      
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ganho Mensal
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: ThemeColors.of(context).blueMaterial,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Ganho Mensal',
                                      style: TextStyle(
                                        color: ThemeColors.of(context).surfaceOverlay70,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      formatCurrency(stats.monthlyGain),
                                      style: TextStyle(
                                        color: ThemeColors.of(context).surface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(width: 12),
                          
                          // Ganho Hoje
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.today_rounded,
                                color: ThemeColors.of(context).greenMaterial,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ganho Hoje',
                                    style: TextStyle(
                                      color: ThemeColors.of(context).surfaceOverlay70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        formatCurrency(stats.todayGain),
                                        style: TextStyle(
                                          color: ThemeColors.of(context).surface,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        stats.growthPercentage.startsWith('+') || stats.growthPercentage.startsWith('-')
                                            ? stats.growthPercentage
                                            : '+${stats.growthPercentage}',
                                        style: TextStyle(
                                          color: stats.growthPercentage.startsWith('-')
                                              ? ThemeColors.of(context).error
                                              : ThemeColors.of(context).greenMaterial,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          
                          // Desempenho Hoje
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                color: ThemeColors.of(context).greenMaterial,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Desempenho Hoje',
                                    style: TextStyle(
                                      color: ThemeColors.of(context).surfaceOverlay70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    storeStats.todaySalesCount > 0
                                        ? '${storeStats.todaySalesCount} vendas'
                                        : 'Sem vendas',
                                    style: TextStyle(
                                      color: ThemeColors.of(context).surface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMetricCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: ThemeColors.of(context).grey500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}





