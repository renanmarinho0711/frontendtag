import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/providers/environmental_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

class HorarioPicoConfigScreen extends ConsumerStatefulWidget {
  const HorarioPicoConfigScreen({super.key});

  @override
  ConsumerState<HorarioPicoConfigScreen> createState() => _HorarioPicoConfigScreenState();
}

class _HorarioPicoConfigScreenState extends ConsumerState<HorarioPicoConfigScreen>
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
    final peakHoursState = ref.watch(peakHoursProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernAppBar(peakHoursState),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildConfigTab(peakHoursState),
                  _buildHorariosTab(peakHoursState),
                  _buildHistoricoTab(peakHoursState),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (peakHoursState.fabExpanded)
            FloatingActionButton.extended(
              heroTag: 'save',
              onPressed: _salvarConfiguracoes,
              icon: Icon(
                Icons.save_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              label: Text(
                'Salvar',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              backgroundColor: ThemeColors.of(context).orangeDark,
            ),
          Positioned(
            right: 0,
            bottom: peakHoursState.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () {
                ref.read(peakHoursProvider.notifier).toggleFabExpanded();
              },
              backgroundColor: ThemeColors.of(context).textSecondary,
              child: Icon(
                peakHoursState.fabExpanded ? Icons.close_rounded : Icons.add_rounded,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar(PeakHoursState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
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
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).orangeDark, ThemeColors.of(context).orangeDeep],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.schedule_rounded,
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
                  'Hor?rio de Pico',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Otimiza??o por Fluxo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColors.of(context).orangeDark, ThemeColors.of(context).orangeDeep],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
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
              Icons.settings_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Config',
          ),
          Tab(
            icon: Icon(
              Icons.access_time_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Hor?rios',
          ),
          Tab(
            icon: Icon(
              Icons.history_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Hist?rico',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab(PeakHoursState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildOpcoesCard(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildDiasSemanaCard(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildGraficoFluxoCard(),
        ],
      ),
    );
  }

  Widget _buildHorariosTab(PeakHoursState state) {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: state.peakHours.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        child: _buildHorarioCard(state.peakHours[index], index),
      ),
    );
  }

  Widget _buildHistoricoTab(PeakHoursState state) {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: state.history.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        child: _buildExecucaoCard(state.history[index], index),
      ),
    );
  }

  Widget _buildHeader(PeakHoursState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).orangeDark, ThemeColors.of(context).orangeDeep],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).orangeDark.withValues(alpha: 0.4),
            blurRadius: isMobile ? 20 : 25,
            offset: Offset(0, isMobile ? 10 : 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                isMobile ? 14 : 16,
              ),
            ),
            child: Icon(
              Icons.trending_up_rounded,
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
                Text(
                  'Otimiza??o por Fluxo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 17,
                      mobileFontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  state.isStrategyActive ? 'Sistema ativo' : 'Sistema inativo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                    ),
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
              value: state.isStrategyActive,
              onChanged: (value) {
                ref.read(peakHoursProvider.notifier).setStrategyActive(value);
              },
              activeColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcoesCard(PeakHoursState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
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
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).blueMainLight,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: ThemeColors.of(context).blueMain,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Op??es Gerais',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          _buildOpcaoSwitch(
            'Aplicar em Finais de Semana',
            'Ajustes tamb?m nos s?bados e domingos',
            Icons.weekend_rounded,
            state.aplicarFinaisSemana,
            (v) => ref.read(peakHoursProvider.notifier).setAplicarFinaisSemana(v),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildOpcaoSwitch(
            'Notificar Ajustes',
            'Receber alertas quando pre?os forem alterados',
            Icons.notifications_active_rounded,
            state.notificarAjustes,
            (v) => ref.read(peakHoursProvider.notifier).setNotificarAjustes(v),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcaoSwitch(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: value ? ThemeColors.of(context).blueMainLight : ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(
          isMobile ? 10 : 12,
        ),
        border: Border.all(
          color: value ? ThemeColors.of(context).blueMainLight : ThemeColors.of(context).textSecondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: value ? ThemeColors.of(context).blueMain : ThemeColors.of(context).textSecondaryOverlay70,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXxs.get(isMobile, isTablet),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ThemeColors.of(context).blueMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiasSemanaCard(PeakHoursState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
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
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).blueCyanLight,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: ThemeColors.of(context).blueCyan,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Dias da Semana',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          ...state.weekDays.map((dia) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                  vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: dia.ativo ? ThemeColors.of(context).primaryPastel : ThemeColors.of(context).textSecondary,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                  border: Border.all(
                    color: dia.ativo ? ThemeColors.of(context).primaryLight : ThemeColors.of(context).textSecondary,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: dia.ativo,
                      onChanged: (v) {
                        ref.read(peakHoursProvider.notifier).setWeekDayActive(dia.id, v ?? false);
                      },
                      activeColor: ThemeColors.of(context).blueCyan,
                    ),
                    Expanded(
                      child: Text(
                        dia.dia,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 15,
                            mobileFontSize: 14,
                          ),
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
                        color: ThemeColors.of(context).primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dia.movimentoFormatted,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGraficoFluxoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).blueIndigoLight, ThemeColors.of(context).primaryPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        border: Border.all(color: ThemeColors.of(context).blueIndigoLight, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.show_chart_rounded,
                color: ThemeColors.of(context).blueIndigoDark,
                size: AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Fluxo Estimado (24h)',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).blueIndigoDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 100,
              tablet: 110,
              desktop: 120,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(24, (index) {
                final height = _getFluxoHeight(index);
                return Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(
                          width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                          height: height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ThemeColors.of(context).blueIndigo,
                                ThemeColors.of(context).blueCyan,
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.paddingMicro.get(isMobile, isTablet),
                      ),
                      if (index % 3 == 0)
                        Text(
                          '${index}h?',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 8,
                              mobileFontSize: 7,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  double _getFluxoHeight(int hora) {
    if (hora >= 0 && hora < 6) return 20.0;
    if (hora >= 6 && hora < 9) return 80.0;
    if (hora >= 9 && hora < 12) return 60.0;
    if (hora >= 12 && hora < 14) return 100.0;
    if (hora >= 14 && hora < 17) return 40.0;
    if (hora >= 17 && hora < 19) return 75.0;
    if (hora >= 19 && hora < 22) return 95.0;
    return 35.0;
  }

  Widget _buildHorarioCard(PeakHourModel horario, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
        padding: EdgeInsets.all(
          AppSizes.cardPadding.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
          ),
          border: Border.all(color: horario.corLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: horario.corLight,
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
                  padding: EdgeInsets.all(
                    AppSizes.paddingSm.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [horario.cor, horario.cor.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 12 : 14,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: horario.corLight,
                        blurRadius: isMobile ? 10 : 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    horario.icone,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconLarge.get(isMobile, isTablet),
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
                            horario.periodo,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 15,
                                mobileFontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(
                            width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                              vertical: AppSizes.paddingMicro2.get(isMobile, isTablet),
                            ),
                            decoration: BoxDecoration(
                              color: horario.corLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              horario.horario,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 10,
                                  mobileFontSize: 9,
                                ),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: horario.cor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        'Movimento: ${horario.tipo}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                          ),
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
                    vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [horario.cor, horario.corDark],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: horario.corLight,
                        blurRadius: isMobile ? 8 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    horario.ajusteFormatted,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 17,
                        mobileFontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).surface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingSm.get(isMobile, isTablet),
            ),
            Text(
              horario.descricao,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
            if (!horario.isNoAdjustment) ...[
              SizedBox(
                height: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: horario.produtos.map((p) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: horario.corLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: horario.corLight),
                    ),
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        color: horario.cor,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ajustar percentual',
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
                          color: horario.corLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          horario.ajusteFormatted,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 13,
                              mobileFontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: horario.cor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: horario.ajuste,
                    min: -20,
                    max: 30,
                    divisions: 50,
                    label: horario.ajusteFormatted,
                    onChanged: (v) {
                      ref.read(peakHoursProvider.notifier).updatePeakHourAdjustment(horario.id, v);
                    },
                    activeColor: horario.cor,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExecucaoCard(PeakHourHistoryModel exec, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(
          AppSizes.paddingMdLg.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : 16,
          ),
          border: Border.all(color: ThemeColors.of(context).successLight),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).textPrimaryOverlay05,
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).successLight,
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: ThemeColors.of(context).successIcon,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
            ),
            SizedBox(
              width: AppSizes.paddingSm.get(isMobile, isTablet),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exec.data,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Text(
                    '${exec.periodo} - ${exec.tipo}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${exec.ajustes}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).successIcon,
                  ),
                ),
                Text(
                  'ajustes',
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

  void _showInfoDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
        ),
        icon: Icon(
          Icons.schedule_rounded,
          color: ThemeColors.of(context).orangeDark,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Hor?rio de Pico',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 17,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sistema inteligente que otimiza pre?os baseado no fluxo de clientes:',
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
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              Text(
                '? Analisa padr?es de tr?fego em diferentes hor?rios',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                '? Aumenta pre?os em hor?rios de pico (almo?o, jantar)',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                '? Reduz pre?os em hor?rios de baixo movimento',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                '? Maximiza margem quando demanda ? alta',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                '? Ajustes autom?ticos a cada mudan?a de per?odo',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Entendi',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _salvarConfiguracoes() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    await ref.read(peakHoursProvider.notifier).saveConfigurations();

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
            SizedBox(
              width: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configura??es Salvas!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Hor?rio de Pico ativo e configurado',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: ThemeColors.of(context).orangeDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}







