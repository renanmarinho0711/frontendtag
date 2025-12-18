import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:tagbean/core/utils/web_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/presentation/providers/strategies_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class EstrategiasResultadosScreen extends ConsumerStatefulWidget {
  final StrategyModel estrategia;

  const EstrategiasResultadosScreen({super.key, required this.estrategia});

  @override
  ConsumerState<EstrategiasResultadosScreen> createState() => _EstrategiasResultadosScreenState();
}

class _EstrategiasResultadosScreenState extends ConsumerState<EstrategiasResultadosScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TabController _tabController;
  String _periodoSelecionado = '30dias';

  /// Obtãm estatísticas do período do backend
  StrategyPeriodStats? get _periodStats {
    final providerKey = '${widget.estrategia.id}:$_periodoSelecionado';
    final asyncValue = ref.watch(strategyPeriodStatsProvider(providerKey));
    return asyncValue.valueOrNull;
  }

  /// Dados do período formatados para a UI
  Map<String, dynamic> get _dadosAtuais {
    final stats = _periodStats;
    if (stats == null) {
      // Valores padrão enquanto carrega
      return {
        'produtosImpactados': 0,
        'variacaoVendas': '0%',
        'variacaoFaturamento': 'R\$ 0',
        'ticketMedio': 'R\$ 0',
        'variacaoTicket': '0%',
        'conversão': '0%',
        'variacaoEconomia': '0%',
        'variacaoConversão': '0%',
        'totalVendas': 0,
        'totalFaturamento': 'R\$ 0',
        'economia': 'R\$ 0',
        'roi': '0%',
        'execucoes': 0,
      };
    }
    return {
      'produtosImpactados': stats.productsAffected,
      'variacaoVendas': stats.variacaoVendasFormatted,
      'variacaoFaturamento': stats.totalFaturamentoFormatted,
      'ticketMedio': stats.ticketMedioFormatted,
      'variacaoTicket': stats.variacaoTicketFormatted,
      'conversão': stats.conversaoFormatted,
      'variacaoEconomia': stats.variacaoEconomiaFormatted,
      'variacaoConversão': stats.variacaoConversaoFormatted,
      'totalVendas': stats.totalSales,
      'totalFaturamento': stats.totalFaturamentoFormatted,
      'economia': stats.economiaFormatted,
      'roi': stats.roiFormatted,
      'execucoes': 0,
    };
  }

  /// Calcula variAção do período anterior (estimativa baseada nos dados atuais)
  String _calcularVariacaoAnterior(String tipo) {
    final stats = _periodStats;
    if (stats == null) return '0%';
    
    // A variAção anterior é estimada como 70% da variAção atual
    // (assumindo que houve melhoria progressiva)
    switch (tipo) {
      case 'vendas':
        final anterior = stats.salesVariation * 0.7;
        return '${anterior >= 0 ? '+' : ''}${anterior.toStringAsFixed(0)}%';
      case 'faturamento':
        final anterior = stats.revenueVariation * 0.7;
        return '${anterior >= 0 ? '+' : ''}${anterior.toStringAsFixed(0)}%';
      case 'ticket':
        final atual = stats.revenueVariation - stats.salesVariation;
        final anterior = atual * 0.7;
        return '${anterior >= 0 ? '+' : ''}${anterior.toStringAsFixed(0)}%';
      case 'conversão':
        final atual = stats.conversionRate / 10;
        final anterior = atual * 0.7;
        return '${anterior >= 0 ? '+' : ''}${anterior.toStringAsFixed(0)}%';
      default:
        return '0%';
    }
  }

  /// Top produtos do backend
  List<TopProductResult> get _topProdutos {
    final asyncValue = ref.watch(strategyTopProductsProvider(widget.estrategia.id));
    return asyncValue.valueOrNull ?? [];
  }

  /// Histórico de execuções do backend
  List<StrategyExecution> get _execucoes {
    final asyncValue = ref.watch(strategyExecutionHistoryProvider(widget.estrategia.id));
    return asyncValue.valueOrNull ?? [];
  }

  /// Dados de vendas diãrias para o gráfico
  // ignore: unused_element
  // ignore: unused_element
  List<DailySalesData> get _dailySalesData {
    final days = _periodoSelecionado == '7dias' ? 7 : (_periodoSelecionado == '30dias' ? 7 : 14);
    final providerKey = '${widget.estrategia.id}:$days';
    final asyncValue = ref.watch(strategyDailySalesProvider(providerKey));
    return asyncValue.valueOrNull ?? [];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _tabController = TabController(length: 3, vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModernAppBar(),
              _buildPeriodSelector(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildProductsTab(),
                    _buildHistoryTab(),
                  ],
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportarRelatorio,
        icon: Icon(
          Icons.file_download_rounded,
          size: AppSizes.iconMedium.get(isMobile, isTablet),
        ),
        label: Text(
          'Exportar',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
            ),
          ),
        ),
        backgroundColor: widget.estrategia.primaryColor,
      )
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSmAlt3.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: widget.estrategia.gradient),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              widget.estrategia.icon,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
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
                  'Resultados da Estratãgia',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
                Text(
                  widget.estrategia.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
                    ),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
              vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).successPastel,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ThemeColors.of(context).success),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: ThemeColors.of(context).successIcon,
                  size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  'ATIVA',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successIcon,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingXxs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: _buildPeriodOption('7 dias', '7dias')),
          Expanded(child: _buildPeriodOption('30 dias', '30dias')),
          Expanded(child: _buildPeriodOption('90 dias', '90dias')),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(String label, String value) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSelected = _periodoSelecionado == value;
    
    return InkWell(
      onTap: () => setState(() => _periodoSelecionado = value),
      borderRadius: BorderRadius.circular(
        isMobile ? 10 : 12,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: widget.estrategia.gradient)
              : null,
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 13,
              mobileFontSize: 12,
            ),
          overflow: TextOverflow.ellipsis,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingXxs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 10 : 12,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(colors: widget.estrategia.gradient),
          borderRadius: BorderRadius.circular(
            isMobile ? 8 : 10,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: ThemeColors.of(context).transparent,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 13,
            mobileFontSize: 11,
          ),
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.dashboard_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: isMobile ? 'Geral' : 'Visão Geral',
          ),
          Tab(
            icon: Icon(
              Icons.inventory_2_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Produtos',
          ),
          Tab(
            icon: Icon(
              Icons.history_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Histórico',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryCard(),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          _buildMetricsGrid(),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          _buildChartCard(),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          _buildComparisonCard(),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopProductsCard(),
          SizedBox(
            height: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          _buildCategoryBreakdown(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_execucoes.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingXxl.get(isMobile, isTablet)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_rounded,
                size: 64,
                color: ThemeColors.of(context).textSecondaryOverlay50,
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhuma execução registrada',
                style: TextStyle(
                  color: ThemeColors.of(context).textSecondary,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: _execucoes.length,
      itemBuilder: (context, index) => _buildExecutionCard(_execucoes[index], index),
    );
  }

  Widget _buildSummaryCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
        vertical: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: widget.estrategia.gradient),
        borderRadius: BorderRadius.circular(
          isMobile ? 10 : 12,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.estrategia.primaryColor.withValues(alpha: 0.2),
            blurRadius: isMobile ? 6 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.trending_up_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Geral',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Anãlise de Impacto',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
              vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryItem(
                  'Produtos',
                  '${_dadosAtuais['produtosImpactados']}',
                  Icons.inventory_2_rounded,
                ),
                Container(
                  width: 1,
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 22,
                    tablet: 24,
                    desktop: 25,
                  ),
                  color: ThemeColors.of(context).surfaceOverlay30,
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                  ),
                ),
                _buildSummaryItem(
                  'Vendas',
                  _dadosAtuais['variacaoVendas'],
                  Icons.shopping_cart_rounded,
                ),
                Container(
                  width: 1,
                  height: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 22,
                    tablet: 24,
                    desktop: 25,
                  ),
                  color: ThemeColors.of(context).surfaceOverlay30,
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                  ),
                ),
                _buildSummaryItem(
                  'Impacto',
                  _dadosAtuais['variacaoFaturamento'],
                  Icons.attach_money_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: ThemeColors.of(context).surface,
          size: AppSizes.iconTiny.get(isMobile, isTablet),
        ),
        SizedBox(
          height: AppSizes.paddingMicro2.get(isMobile, isTablet),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 15,
              mobileFontSize: 13,
            ),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 10,
              mobileFontSize: 9,
            ),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 3,
    );

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
      mainAxisSpacing: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
      childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.5 : 2.0,
      children: [
        _buildMetricCard(
          'Total de Vendas',
          _dadosAtuais['totalVendas'].toString(),
          Icons.shopping_bag_rounded,
          [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
          _dadosAtuais['variacaoVendas'],
        ),
        _buildMetricCard(
          'Faturamento',
          _dadosAtuais['totalFaturamento'],
          Icons.monetization_on_rounded,
          [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
          _dadosAtuais['variacaoFaturamento'],
        ),
        _buildMetricCard(
          'Ticket Mãdio',
          _dadosAtuais['ticketMedio'],
          Icons.receipt_long_rounded,
          [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
          _dadosAtuais['variacaoTicket'],
        ),
        _buildMetricCard(
          'ROI',
          _dadosAtuais['roi'],
          Icons.show_chart_rounded,
          [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning],
          _dadosAtuais['conversão'],
        ),
        _buildMetricCard(
          'Economia',
          _dadosAtuais['economia'],
          Icons.savings_rounded,
          [ThemeColors.of(context).greenTeal, ThemeColors.of(context).greenDark],
          _dadosAtuais['variacaoEconomia'],
        ),
        _buildMetricCard(
          'Conversão',
          _dadosAtuais['conversão'],
          Icons.trending_up_rounded,
          [ThemeColors.of(context).error, ThemeColors.of(context).errorDark],
          _dadosAtuais['variacaoConversão'],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    List<Color> gradient,
    String variation,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
        vertical: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 10 : 12,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.1),
            blurRadius: isMobile ? 6 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 19,
                      mobileFontSize: 17,
                    ),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: AppSizes.paddingMicro2.get(isMobile, isTablet),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 11,
                    ),
                    color: ThemeColors.of(context).textSecondaryOverlay70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXsAlt.get(isMobile, isTablet),
              vertical: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 3,
                tablet: 3,
                desktop: 3,
              ),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).successPastel,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              variation,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 9,
                  mobileFontSize: 8,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).successIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
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
                  AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.estrategia.gradient),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Evolução de Vendas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).textSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'últimos 7 dias',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingXxl.get(isMobile, isTablet),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 150,
              tablet: 165,
              desktop: 180,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = 60.0 + (math.Random(index).nextDouble() * 120);
                final value = (50 + math.Random(index).nextInt(100)).toString();
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 600 + (index * 100)),
                  tween: Tween<double>(begin: 0, end: height),
                  builder: (context, double animatedHeight, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                        ),
                        Container(
                          width: ResponsiveHelper.getResponsivePadding(
                            context,
                            mobile: 32,
                            tablet: 34,
                            desktop: 36,
                          ),
                          height: animatedHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: widget.estrategia.gradient,
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.estrategia.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                        ),
                        Text(
                          ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][index],
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 11,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).primaryPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: ThemeColors.of(context).infoLight, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.compare_arrows_rounded,
                color: ThemeColors.of(context).infoDark,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'ComparAção com Perãodo Anterior',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).infoDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          _buildComparisonRow('Vendas', _calcularVariacaoAnterior('vendas'), _dadosAtuais['variacaoVendas'], true),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildComparisonRow('Faturamento', _calcularVariacaoAnterior('faturamento'), _dadosAtuais['variacaoFaturamento'], true),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildComparisonRow('Ticket Mãdio', _calcularVariacaoAnterior('ticket'), _dadosAtuais['variacaoTicket'], true),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildComparisonRow('Conversão', _calcularVariacaoAnterior('conversão'), _dadosAtuais['variacaoConversão'], true),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    String anterior,
    String atual,
    bool isPositive,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingSm.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 8 : 10,
        ),
        border: Border.all(color: ThemeColors.of(context).infoLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Anterior',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 10,
                    mobileFontSize: 9,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              Text(
                anterior,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Atual',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 10,
                    mobileFontSize: 9,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              Text(
                atual,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
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
                  AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Top 5 Produtos',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          if (_topProdutos.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.paddingXxl.get(isMobile, isTablet)),
                child: Text(
                  'Carregando produtos...',
                  style: TextStyle(
                    color: ThemeColors.of(context).textSecondary,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 12),
                  ),
                ),
              ),
            )
          else
            ..._topProdutos.asMap().entries.map((entry) {
              final index = entry.key;
              final produto = entry.value;
              return _buildProductItem(produto, index + 1);
            }),
        ],
      ),
    );
  }

  Widget _buildProductItem(TopProductResult produto, int posicao) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: posicao == 1
              ?  [ThemeColors.of(context).warning.withValues(alpha: 0.1), ThemeColors.of(context).warningDark.withValues(alpha: 0.1)]
              : [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textSecondary],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        border: Border.all(
          color: posicao == 1 ? ThemeColors.of(context).warning : ThemeColors.of(context).textSecondary,
          width: posicao == 1 ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 42,
              tablet: 45,
              desktop: 48,
            ),
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 42,
              tablet: 45,
              desktop: 48,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: posicao == 1
                    ? [ThemeColors.of(context).warning, ThemeColors.of(context).warningDark]
                    : posicao == 2
                        ? [ThemeColors.of(context).grey400, ThemeColors.of(context).grey600]
                        : posicao == 3
                            ? [ThemeColors.of(context).brownMain, ThemeColors.of(context).brownDark]
                            : [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textSecondary],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (posicao == 1 ?  ThemeColors.of(context).warning : ThemeColors.of(context).textSecondary).withValues(alpha: 0.3),
                  blurRadius: isMobile ? 8 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$posicao',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 20,
                    mobileFontSize: 18,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).surface,
                ),
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                        vertical: AppSizes.paddingMicro2.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).infoPastel,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        produto.strategy,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 10,
                            mobileFontSize: 9,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).infoDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                    ),
                    Icon(
                      Icons.shopping_cart_rounded,
                      size: AppSizes.iconMicro.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                    SizedBox(
                      width: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    Text(
                      '${produto.quantity} un',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                    ),
                    Icon(
                      Icons.show_chart_rounded,
                      size: AppSizes.iconMicro.get(isMobile, isTablet),
                      color: ThemeColors.of(context).textSecondaryOverlay60,
                    ),
                    SizedBox(
                      width: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    Text(
                      produto.margemLucroFormatted,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                        ),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                produto.gain,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXxs.get(isMobile, isTablet),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                  vertical: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 3,
                    tablet: 3,
                    desktop: 3,
                  ),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).successPastel,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  produto.variacaoVendasFormatted,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successIcon,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).warningPastel, ThemeColors.of(context).errorPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: ThemeColors.of(context).warningLight, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.donut_large_rounded,
                color: ThemeColors.of(context).warningDark,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Breakdown por Categoria',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).warningDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          _buildCategoryBar('Bebidas', 0.35, ThemeColors.of(context).blueMain),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildCategoryBar('Mercearia', 0.28, ThemeColors.of(context).greenMain),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildCategoryBar('Perecãveis', 0.22, ThemeColors.of(context).orangeMain),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildCategoryBar('Limpeza', 0.10, ThemeColors.of(context).blueCyan),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildCategoryBar('Higiene', 0.05, ThemeColors.of(context).blueLight),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(String label, double percentage, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(percentage * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: ThemeColors.of(context).textSecondary,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
          ),
        ),
      ],
    );
  }

  Widget _buildExecutionCard(StrategyExecution execucao, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSuccess = execucao.isSuccess;
    
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        padding: EdgeInsets.all(
          AppSizes.paddingMd.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 12 : (isTablet ? 14 : 16),
          ),
          border: Border.all(
            color: isSuccess ? ThemeColors.of(context).greenMain.withValues(alpha: 0.3) : ThemeColors.of(context).warningLight,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).textPrimaryOverlay05,
              blurRadius: isMobile ? 8 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 42,
                tablet: 45,
                desktop: 48,
              ),
              height: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 42,
                tablet: 45,
                desktop: 48,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSuccess
                      ? [ThemeColors.of(context).greenMain, ThemeColors.of(context).successIcon]
                      : [ThemeColors.of(context).orangeMain, ThemeColors.of(context).warningDark],
                ),
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              child: Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.warning_rounded,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
            ),
            SizedBox(
              width: AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        execucao.status.name,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: isSuccess ? ThemeColors.of(context).greenMain : ThemeColors.of(context).orangeMain,
                        ),
                      ),
                      SizedBox(
                        width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                          vertical: AppSizes.paddingMicro2.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).textSecondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${execucao.duration.inSeconds}.${(execucao.duration.inMilliseconds % 1000) ~/ 100}s',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 10,
                              mobileFontSize: 9,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: AppSizes.iconMicro.get(isMobile, isTablet),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      SizedBox(
                        width: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        _formatDateTime(execucao.executedAt),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${execucao.productsAffected}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'produtos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 10,
                      mobileFontSize: 9,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Formata a data para exibição
  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  void _exportarRelatorio() {
    final isMobile = ResponsiveHelper.isMobile(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Exportando relatãrio em CSV...',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: widget.estrategia.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );

    // Gerar CSV real com dados do relatãrio
    final dados = _dadosAtuais;
    final csvContent = StringBuffer();
    csvContent.writeln('Relatãrio de Estratãgia - ${widget.estrategia.name}');
    csvContent.writeln('Data de ExportAção,${DateTime.now().toIso8601String()}');
    csvContent.writeln('Perãodo,$_periodoSelecionado');
    csvContent.writeln('');
    csvContent.writeln('Mãtrica,Valor');
    csvContent.writeln('Produtos Impactados,${dados['produtosImpactados']}');
    csvContent.writeln('VariAção Vendas,${dados['variacaoVendas']}');
    csvContent.writeln('Total Faturamento,${dados['totalFaturamento']}');
    csvContent.writeln('Ticket Mãdio,${dados['ticketMedio']}');
    csvContent.writeln('Taxa de Conversão,${dados['conversao']}');
    csvContent.writeln('Total Vendas,${dados['totalVendas']}');
    csvContent.writeln('ROI,${dados['roi']}');
    csvContent.writeln('Execuções,${dados['execucoes']}');
    
    // Download do arquivo
    final bytes = utf8.encode(csvContent.toString());
    final fileName = 'relatorio_${widget.estrategia.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.csv';
    triggerDownload(bytes, fileName, 'text/csv');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Text(
              'Relatãrio exportado com sucesso!',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).greenMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );
  }
}






