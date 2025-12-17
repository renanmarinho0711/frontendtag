import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/data/providers/performance_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class PrevisaoIAConfigScreen extends ConsumerStatefulWidget {
  const PrevisaoIAConfigScreen({super.key});

  @override
  ConsumerState<PrevisaoIAConfigScreen> createState() => _PrevisaoIAConfigScreenState();
}

class _PrevisaoIAConfigScreenState extends ConsumerState<PrevisaoIAConfigScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildConfigTab(),
                    _buildPesosTab(),
                    _buildPrevisoesTab(),
                  ],
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (ref.watch(aiForecastProvider).fabExpanded) ...[
                FloatingActionButton(
                  heroTag: 'treinar',
                  onPressed: _treinarModelo,
                  backgroundColor: ThemeColors.of(context).blueMain,
                  tooltip: 'Treinar Modelo IA',
                  child: Icon(
                    Icons.psychology_rounded,
                    size: AppSizes.iconLarge.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                FloatingActionButton.extended(
                  heroTag: 'salvar',
                  onPressed: _salvarConfiguracoes,
                  icon: Icon(
                    Icons.save_rounded,
                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Salvar',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                    ),
                  ),
                  backgroundColor: ThemeColors.of(context).success,
                ),
              ],
            ],
          ),
          Positioned(
            right: 0,
            bottom: 66,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () {
                setState(() {
                  ref.read(aiForecastProvider.notifier).toggleFabExpanded();
                });
              },
              backgroundColor: ThemeColors.of(context).textSecondary,
              child: Icon(
                ref.watch(aiForecastProvider).fabExpanded ? Icons.close_rounded : Icons.add_rounded,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
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
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
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
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]),
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Previso com IA',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Machine Learning Avanado',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            onPressed: _showInfoDialog,
            color: ThemeColors.of(context).textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(AppSizes.paddingXxs.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : (isTablet ? 14 : 16)),
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
          gradient: LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark]),
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 11),
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.settings_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Config',
          ),
          Tab(
            icon: Icon(Icons.tune_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Pesos',
          ),
          Tab(
            icon: Icon(Icons.insights_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Previses',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            child: Column(
              children: [
                _buildHeader(),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildStatusCard(),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildConfigCard(),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildModeloCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesosTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPesosInfoCard(),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildPesosCard(),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildDistribuicaoChart(),
        ],
      ),
    );
  }

  Widget _buildPrevisoesTab() {
    final state = ref.watch(aiForecastProvider);
    final predictions = state.predictions;
    
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      itemCount: predictions.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
        child: _buildPrevisaoDetalhada(predictions[index], index),
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]),
        borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.4),
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 10 : 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.psychology_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Motor de IA',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                Text(
                  ref.watch(aiForecastProvider).isEngineActive ? 'Previses ativadas' : 'Previses desativadas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).surfaceOverlay70,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.1,
            child: Switch(
              value: ref.watch(aiForecastProvider).isEngineActive,
              onChanged: (value) => ref.read(aiForecastProvider.notifier).setEngineActive(value),
              activeThumbColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
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
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).greenMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: ThemeColors.of(context).greenMain,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Modelo Treinado',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                    Text(
                      'Última atualizAção: 22/11/2025 s 03:15',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                      overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ThemeColors.of(context).greenMain, ThemeColors.of(context).greenDark]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.of(context).greenMain.withValues(alpha: 0.3),
                      blurRadius: isMobile ? 8 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'ATIVO',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
          const Divider(),
          SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: _buildMetric('Produtos', '1.247', Icons.inventory_2_rounded, ThemeColors.of(context).blueMain)),
              Container(width: 1, height: ResponsiveHelper.getResponsivePadding(context, mobile: 45, tablet: 47, desktop: 50), color: ThemeColors.of(context).textSecondary),
              Expanded(child: _buildMetric('Preciso', '87%', Icons.trending_up_rounded, ThemeColors.of(context).greenMain)),
              Container(width: 1, height: ResponsiveHelper.getResponsivePadding(context, mobile: 45, tablet: 47, desktop: 50), color: ThemeColors.of(context).textSecondary),
              Expanded(child: _buildMetric('Previses', '45', Icons.lightbulb_rounded, ThemeColors.of(context).orangeMain)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: AppSizes.iconLarge.get(isMobile, isTablet),
        ),
        SizedBox(height: AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).textSecondaryOverlay70,
          ),
        ),
      ],
    );
  }

  Widget _buildConfigCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
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
                padding: EdgeInsets.all(AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Parâmetros do Modelo',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                color: ThemeColors.of(context).blueMain,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Perodo Histórico de Anlise',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                ),
                child: Text(
                  '${ref.watch(aiForecastProvider).historicalPeriod} dias',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).blueMain,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
          Slider(
            value: ref.watch(aiForecastProvider).historicalPeriod.toDouble(),
            min: 30,
            max: 365,
            divisions: 67,
            label: '${ref.watch(aiForecastProvider).historicalPeriod} dias',
            onChanged: (value) => ref.read(aiForecastProvider.notifier).setHistoricalPeriod(value.toInt()),
            activeColor: ThemeColors.of(context).blueMain,
          ),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: ThemeColors.of(context).infoDark,
                ),
                SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                Expanded(
                  child: Text(
                    'Quanto maior o perodo, mais precisa a previso',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).infoDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assessment_rounded,
                color: ThemeColors.of(context).blueCyan,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Nvel de Confiança Mnimo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                ),
                child: Text(
                  '${ref.watch(aiForecastProvider).confidenceLevel.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).blueCyan,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
          Slider(
            value: ref.watch(aiForecastProvider).confidenceLevel,
            min: 50,
            max: 95,
            divisions: 45,
            label: '${ref.watch(aiForecastProvider).confidenceLevel.toStringAsFixed(0)}%',
            onChanged: (value) => ref.read(aiForecastProvider.notifier).setConfidenceLevel(value),
            activeColor: ThemeColors.of(context).blueCyan,
          ),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).primaryPastel,
              borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                  color: ThemeColors.of(context).primaryDark,
                ),
                SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                Expanded(
                  child: Text(
                    'Previses abaixo deste nvel não sero exibidas',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeloCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).warningPastel, ThemeColors.of(context).errorPastel]),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
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
                Icons.psychology_rounded,
                color: ThemeColors.of(context).warningDark,
                size: AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Treinar Modelo de IA',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).warningDark,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          Text(
            'Execute o treinamento para atualizar o modelo com dados mais recentes e melhorar a preciso das previses.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
            overflow: TextOverflow.ellipsis,
              height: 1.5,
            ),
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: ref.watch(aiForecastProvider).isTraining ? null : _treinarModelo,
              icon: ref.watch(aiForecastProvider).isTraining
                  ? SizedBox(
                      width: AppSizes.iconSmall.get(isMobile, isTablet),
                      height: AppSizes.iconSmall.get(isMobile, isTablet),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).surface),
                      ),
                    )
                  : Icon(
                      Icons.play_arrow_rounded,
                      size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                    ),
              label: Text(
                ref.watch(aiForecastProvider).isTraining ? 'Treinando...' : 'Iniciar Treinamento',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                overflow: TextOverflow.ellipsis,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
                ),
                backgroundColor: ThemeColors.of(context).warningDark,
                foregroundColor: ThemeColors.of(context).surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesosInfoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).infoPastel,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        border: Border.all(color: ThemeColors.of(context).infoLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_rounded,
            color: ThemeColors.of(context).infoDark,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Text(
              'Ajuste a importncia de cada fator na previso.  O total deve somar 100%.',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
              overflow: TextOverflow.ellipsis,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesosCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ?  15 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ?  15 : 20,
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
                padding: EdgeInsets.all(AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Peso dos Fatores',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Text(
                '${ref.watch(aiForecastProvider).factors.fold<double>(0.0, (sum, f) => sum + f.weight).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).blueCyan,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
          ...ref.watch(aiForecastProvider).factors.map((factor) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.cardPadding.get(isMobile, isTablet)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          factor.name,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                          vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${factor.weight.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).blueCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
                  Slider(
                    value: factor.weight,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${factor.weight.toStringAsFixed(0)}%',
                    onChanged: (value) => ref.read(aiForecastProvider.notifier).updateFactorWeight(factor.id, value),
                    activeColor: ThemeColors.of(context).blueCyan,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDistribuicaoChart() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
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
                padding: EdgeInsets.all(AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: ThemeColors.of(context).blueMain,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Text(
                'Distribuição Visual',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
          ...ref.watch(aiForecastProvider).factors.map((factor) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSizes.iconMicro.get(isMobile, isTablet),
                    height: AppSizes.iconMicro.get(isMobile, isTablet),
                    decoration: BoxDecoration(
                      color: _getColorForFator(factor.name),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
                  Expanded(
                    child: Text(
                      factor.name,
                      style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${factor.weight.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPrevisaoDetalhada(ForecastPredictionModel produto, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final IconData icone = produto.trend == 'alta'
        ? Icons.trending_up_rounded
        : produto.trend == 'baixa'
            ? Icons.trending_down_rounded
            : Icons.trending_flat_rounded;

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
        padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
          border: Border.all(color: produto.color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: produto.color.withValues(alpha: 0.15),
              blurRadius: isMobile ? 15 : 20,
              offset: Offset(0, isMobile ? 4 : 6),
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
                  padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [produto.color, produto.color.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    icone,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconLarge.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produto.name,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                            color: produto.color,
                          ),
                          SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),
                          Text(
                            '${produto.confidence}% de confiana',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                            overflow: TextOverflow.ellipsis,
                              color: produto.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: _buildMetricBox('Vendas Atual', '${produto.currentSales} un', ThemeColors.of(context).textSecondary)),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: ThemeColors.of(context).textSecondaryOverlay60,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Expanded(child: _buildMetricBox('Previso', '${produto.predictedSales} un', produto.color)),
              ],
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: _buildInfoChip('Impacto', produto.impact, Icons.attach_money_rounded)),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Expanded(child: _buildInfoChip('Elasticidade', produto.elasticity, Icons.show_chart_rounded)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
        vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
        border: Border.all(color: ThemeColors.of(context).textSecondary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconTiny.get(isMobile, isTablet),
            color: ThemeColors.of(context).textSecondary,
          ),
          SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForFator(String fator) {
    switch (fator) {
      case 'Histórico de Vendas':
        return ThemeColors.of(context).blueMain;
      case 'Sazonalidade':
        return ThemeColors.of(context).greenMain;
      case 'Eventos & Calendrio':
        return ThemeColors.of(context).orangeMain;
      case 'Clima & Temperatura':
        return ThemeColors.of(context).orangeDark;
      case 'Concorrncia':
        return ThemeColors.of(context).blueCyan;
      default:
        return ThemeColors.of(context).textSecondary;
    }
  }

  void _treinarModelo() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan)),
            SizedBox(height: AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
            Text(
              'Treinando Modelo de IA',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
            Text(
              'Analisando ${ref.read(aiForecastProvider).historicalPeriod} dias de histórico...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    // Executar treinamento via provider
    await ref.read(aiForecastProvider.notifier).startTraining();
    
    if (!mounted) return;
    
    Navigator.pop(context); // Fecha o dialog
    
    final newState = ref.read(aiForecastProvider);
    final hasError = newState.error != null;
    final precision = newState.modelStatus?.precision ?? 0;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasError ? 'Erro no Treinamento' : 'Modelo Treinado com Sucesso!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    hasError 
                        ? newState.error! 
                        : 'Preciso alcanada: ${precision.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: hasError ? ThemeColors.of(context).error : ThemeColors.of(context).greenMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showInfoDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
        icon: Icon(
          Icons.psychology_rounded,
          color: ThemeColors.of(context).blueCyan,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Motor de Inteligncia Artificial',
          style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
          overflow: TextOverflow.ellipsis,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sistema avanado de Machine Learning para previso de demanda:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
              Text(
                '? Analisa histórico de vendas e padres de comportamento',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Considera sazonalidade, eventos e clima',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Prev demanda futura com alta preciso (85-92%)',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Sugere ajustes de preço e estoque proativamente',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Aprende continuamente com novos dados',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Entendi',
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _salvarConfiguracoes() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    await ref.read(aiForecastProvider.notifier).saveConfigurations();
    if (!mounted) return;

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
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Text(
              'Configurações do motor de IA salvas com sucesso',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
      ),
    );
  }
}







