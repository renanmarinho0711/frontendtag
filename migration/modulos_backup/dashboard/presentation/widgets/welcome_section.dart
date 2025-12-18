import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

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
    
    // Obtém dados dinâmicos do dashboard
    final dashboardState = ref.watch(dashboardProvider);
    final activeStrategies = dashboardState.data.strategiesStats.activeCount;
    final totalProducts = dashboardState.data.storeStats.productsCount;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppThemeColors.greenMaterial,
            AppThemeColors.greenDark,
            AppThemeColors.greenDark.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 24 : 28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.greenMaterial.withValues(alpha: 0.4),
            blurRadius: isMobile ? 20 : 30,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppThemeColors.greenDark.withValues(alpha: 0.2),
            blurRadius: isMobile ? 40 : 60,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Padrão decorativo de fundo
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppThemeColors.surfaceOverlay10,
                    AppThemeColors.transparent,
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
                    AppThemeColors.surface.withValues(alpha: 0.08),
                    AppThemeColors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Conteúdo principal
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXlLg.get(isMobile, isTablet),
              vertical: AppSizes.paddingXs.get(isMobile, isTablet),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Seção de boas-vindas
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
                          color: AppThemeColors.surfaceOverlay15,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppThemeColors.surfaceOverlay30,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '👋',
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Bem-vindo de volta!',
                              style: TextStyle(
                                color: AppThemeColors.surfaceOverlay95,
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
                      
                      // Nome do usuário com saudação
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
                                      color: AppThemeColors.surfaceOverlay90,
                                      fontSize: AppTextStyles.fontSizeLg.get(isMobile, isTablet),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3,
                                      height: 1.1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: userName,
                                    style: TextStyle(
                                      color: AppThemeColors.surface,
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
                      
                      // Informação de estratégias ativas
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: AppThemeColors.surfaceOverlay80,
                              size: isMobile ? 12 : 16,
                            ),
                            SizedBox(width: isMobile ? 4 : 6),
                            Text(
                              '$activeStrategies estratégias ativas',
                              style: TextStyle(
                                color: AppThemeColors.surfaceOverlay90,
                                fontSize: AppTextStyles.fontSizeXxs.get(isMobile, isTablet),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: isMobile ? 4 : 8),
                            Text(
                              '•',
                              style: TextStyle(
                                color: AppThemeColors.surfaceOverlay50,
                                fontSize: isMobile ? 10 : 12,
                              ),
                            ),
                            SizedBox(width: isMobile ? 4 : 8),
                            Icon(
                              Icons.inventory_2_outlined,
                              color: AppThemeColors.surfaceOverlay80,
                              size: isMobile ? 12 : 16,
                            ),
                            SizedBox(width: isMobile ? 4 : 6),
                            Text(
                              '$totalProducts produtos',
                              style: TextStyle(
                                color: AppThemeColors.surfaceOverlay90,
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
                  
                  // Informações de métricas (dinâmicas do backend)
                  Expanded(
                    child: Builder(
                    builder: (context) {
                      final stats = dashboardState.data.strategiesStats;
                      final storeStats = dashboardState.data.storeStats;
                      
                      // Formata valores monetários
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
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  color: AppThemeColors.blueMaterial,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Ganho Mensal',
                                      style: TextStyle(
                                        color: AppThemeColors.surfaceOverlay70,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      formatCurrency(stats.monthlyGain),
                                      style: const TextStyle(
                                        color: AppThemeColors.surface,
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
                              const Icon(
                                Icons.today_rounded,
                                color: AppThemeColors.greenMaterial,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Ganho Hoje',
                                    style: TextStyle(
                                      color: AppThemeColors.surfaceOverlay70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        formatCurrency(stats.todayGain),
                                        style: const TextStyle(
                                          color: AppThemeColors.surface,
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
                                              ? AppThemeColors.error
                                              : AppThemeColors.greenMaterial,
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
                              const Icon(
                                Icons.trending_up_rounded,
                                color: AppThemeColors.greenMaterial,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Desempenho Hoje',
                                    style: TextStyle(
                                      color: AppThemeColors.surfaceOverlay70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    storeStats.todaySalesCount > 0
                                        ? '${storeStats.todaySalesCount} vendas'
                                        : 'Sem vendas',
                                    style: const TextStyle(
                                      color: AppThemeColors.surface,
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
  
  // ignore: unused_element
  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.neutralBlack.withValues(alpha: 0.05),
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
            style: const TextStyle(fontSize: 12, color: AppThemeColors.grey500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


