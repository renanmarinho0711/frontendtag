import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/dashboard/presentation/providers/dashboard_provider.dart';

/// Card de Resumo do Dia com mtricas de negcio
/// Substitui CompactMetricsGrid com mtricas mais relevantes
class ResumoDoDoaCard extends ConsumerWidget {
  final VoidCallback? onVerDashboardCompleto;
  final VoidCallback? onVerProdutos;
  final VoidCallback? onVerVinculacao;

  const ResumoDoDoaCard({
    super.key,
    this.onVerDashboardCompleto,
    this.onVerProdutos,
    this.onVerVinculacao,
  });

  String _formatCurrency(double value) {
    if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}k';
    }
    return 'R\$ ${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Obtm dados do dashboard
    final dashboardState = ref.watch(dashboardProvider);
    final stats = dashboardState.data.strategiesStats;
    final storeStats = dashboardState.data.storeStats;

    // Mtricas do dia
    final lucroHoje = stats.todayGain;
    final variacao = stats.growthPercentage;
    final variacaoPositiva = !variacao.startsWith('-');
    final totalProdutos = storeStats.productsCount;
    // Usa boundTagsCount como proxy para produtos vinculados (tags vinculadas)
    final produtosVinculados = storeStats.boundTagsCount;
    final taxaVinculacao = totalProdutos > 0 
        ? ((produtosVinculados / totalProdutos) * 100).toInt() 
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay06,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.insights_rounded,
                    color: ThemeColors.of(context).surface,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Resumo do Dia',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 14,
                        tabletFontSize: 15,
                      ),
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).textPrimary,
                    ),
                  ),
                ),
                if (onVerDashboardCompleto != null)
                  TextButton.icon(
                    onPressed: onVerDashboardCompleto,
                    icon: Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: ThemeColors.of(context).blueMain,
                    ),
                    label: Text(
                      'Ver mais',
                      style: TextStyle(
                        fontSize: 12,
                        color: ThemeColors.of(context).blueMain,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),

            // Grid de mtricas 2x2
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildMetricaCard(
                      context: context,
                      icon: Icons.attach_money_rounded,
                      iconColor: ThemeColors.of(context).greenMain,
                      valor: _formatCurrency(lucroHoje),
                      label: 'Lucro Hoje',
                      onTap: onVerDashboardCompleto,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricaCard(
                      context: context,
                      icon: variacaoPositiva 
                          ? Icons.trending_up_rounded 
                          : Icons.trending_down_rounded,
                      iconColor: variacaoPositiva 
                          ? ThemeColors.of(context).greenMain 
                          : ThemeColors.of(context).redMain,
                      valor: variacao.startsWith('+') || variacao.startsWith('-') 
                          ? variacao 
                          : '+$variacao',
                      label: 'vs ontem',
                      valorColor: variacaoPositiva 
                          ? ThemeColors.of(context).greenMain 
                          : ThemeColors.of(context).redMain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildMetricaCard(
                      context: context,
                      icon: Icons.inventory_2_rounded,
                      iconColor: ThemeColors.of(context).blueMain,
                      valor: totalProdutos.toString(),
                      label: 'Produtos Ativos',
                      onTap: onVerProdutos,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricaCardComProgresso(
                      context: context,
                      icon: Icons.link_rounded,
                      iconColor: ThemeColors.of(context).greenMaterial,
                      valor: '$taxaVinculacao%',
                      label: 'Vinculados',
                      progresso: taxaVinculacao / 100,
                      onTap: onVerVinculacao,
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

  Widget _buildMetricaCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String valor,
    required String label,
    Color? valorColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const Spacer(),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ThemeColors.of(context).textSecondaryOverlay40,
                    size: 12,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              valor,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valorColor ?? ThemeColors.of(context).textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricaCardComProgresso({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String valor,
    required String label,
    required double progresso,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const Spacer(),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ThemeColors.of(context).textSecondaryOverlay40,
                    size: 12,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Meta: 100%',
                        style: TextStyle(
                          fontSize: 9,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progresso,
                          backgroundColor: iconColor.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




