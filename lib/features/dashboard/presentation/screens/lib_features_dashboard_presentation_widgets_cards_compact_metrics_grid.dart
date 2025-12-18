import 'package:flutter/material. dart';
import 'package: tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';

class CompactMetricsGrid extends StatelessWidget {
  const CompactMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper. isMobile(context);
    final isTablet = ResponsiveHelper. isTablet(context);

    final estatisticas = [
      _MetricData('Produtos Ativos', '1. 234', Icons.inventory_2_rounded, 
        ThemeColors.of(context).blueMaterial, '+12%', 'aumento'),
      _MetricData('Tags Criadas', '987', Icons.label_rounded,
        ThemeColors.of(context).blueCyan, '+8%', 'aumento'),
      _MetricData('Sincronizações', '42', Icons.sync_rounded,
        ThemeColors.of(context).blueCyan, '+3', 'aumento'),
      _MetricData('Categorias', '156', Icons.category_rounded,
        ThemeColors.of(context).blueCyan, '+5%', 'aumento'),
    ];

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt. get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color:  ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          AppSizes.paddingLg.get(isMobile, isTablet),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildGrid(context, estatisticas, isMobile),
    );
  }

  Widget _buildGrid(BuildContext context, List<_MetricData> stats, bool isMobile) {
    if (isMobile && ! ResponsiveHelper.isLandscape(context)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: _DashboardStatCard(data: stats[0])),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
              Expanded(child: _DashboardStatCard(data:  stats[1])),
            ],
          ),
          SizedBox(height: ResponsiveHelper. getResponsiveSpacing(context, mobile: 10)),
          Row(
            children: [
              Expanded(child: _DashboardStatCard(data: stats[2])),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
              Expanded(child: _DashboardStatCard(data: stats[3])),
            ],
          ),
        ],
      );
    }
    
    return Row(
      children: stats.asMap().entries.map((entry) {
        return Expanded(
          child:  Padding(
            padding: EdgeInsets.only(right: entry.key < stats.length - 1 ?  12 : 0),
            child: _DashboardStatCard(data: entry.value),
          ),
        );
      }).toList(),
    );
  }
}

class _MetricData {
  final String label;
  final String valor;
  final IconData icon;
  final Color cor;
  final String mudanca;
  final String tipo;

  const _MetricData(this.label, this.valor, this.icon, this.cor, this.mudanca, this.tipo);
}

class _DashboardStatCard extends StatelessWidget {
  final _MetricData data;

  const _DashboardStatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    // ...  implementação do card individual
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child:  Opacity(opacity: value, child: child),
        );
      },
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Container(
      padding:  EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            data.cor.withValues(alpha: 0.1),
            data.cor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        border: Border.all(
          color: data.cor.withValues(alpha: 0.3),
          width: AppSizes.borderWidthResponsive.get(isMobile, isTablet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, color: data.cor, size: AppSizes.iconMediumLarge.get(isMobile, isTablet)),
          const SizedBox(height: 8),
          Text(data.valor, style: TextStyle(fontWeight: FontWeight.bold, color: data.cor)),
          const SizedBox(height: 4),
          Text(data.label, style: TextStyle(color:  ThemeColors.of(context).textSecondary)),
        ],
      ),
    );
  }
}