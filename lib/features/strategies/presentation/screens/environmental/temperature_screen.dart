import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/providers/environmental_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

class TemperaturaConfigScreen extends ConsumerStatefulWidget {
  const TemperaturaConfigScreen({super.key});

  @override
  ConsumerState<TemperaturaConfigScreen> createState() => _TemperaturaConfigScreenState();
}

class _TemperaturaConfigScreenState extends ConsumerState<TemperaturaConfigScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TabController _tabController;
  late TextEditingController _cidadeController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tabController = TabController(length: 3, vsync: this);
    _animationController.forward();
    
    // Inicializa o controller com o valor do provider
    final state = ref.read(temperatureProvider);
    _cidadeController = TextEditingController(text: state.city);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final state = ref.watch(temperatureProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModernAppBar(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildConfigTab(),
                    _buildFaixasTab(),
                    _buildHistoricoTab(),
                  ],
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: Stack(
        children: [
          if (state.fabExpanded)
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
              backgroundColor: ThemeColors.of(context).orangeMain,
            ),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () {
                ref.read(temperatureProvider.notifier).toggleFabExpanded();
              },
              backgroundColor: ThemeColors.of(context).textSecondary,
              child: Icon(
                state.fabExpanded ? Icons.close_rounded : Icons.add_rounded,
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
                colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.thermostat_rounded,
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
                  'Precifica??o por Temperatura',
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
                  'Integra??o com Clima',
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
            colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
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
              Icons.layers_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Faixas',
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

  Widget _buildConfigTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildClimaAtualCard(),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildApiCard(),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildPrevisaoCard(),
        ],
      ),
    );
  }

  Widget _buildFaixasTab() {
    final state = ref.watch(temperatureProvider);
    
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: state.temperatureRanges.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        child: _buildFaixaCard(state.temperatureRanges[index], index),
      ),
    );
  }

  Widget _buildHistoricoTab() {
    final state = ref.watch(temperatureProvider);
    
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: state.history.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        child: _buildHistoricoCard(state.history[index], index),
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final state = ref.watch(temperatureProvider);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.4),
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
              Icons.wb_sunny_rounded,
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
                  'Integra??o com Clima',
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
              onChanged: (value) => ref.read(temperatureProvider.notifier).setStrategyActive(value),
              activeColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClimaAtualCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final state = ref.watch(temperatureProvider);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).info, ThemeColors.of(context).infoDark],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).blueMainLight,
            blurRadius: isMobile ? 15 : 20,
            offset: Offset(0, isMobile ? 8 : 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.city,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 15,
                        mobileFontSize: 14,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).surface,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Text(
                    state.currentCondition,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 13,
                        mobileFontSize: 12,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).surfaceOverlay90,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.isConnected ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                  SizedBox(
                    width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                  ),
                  Text(
                    state.isConnected ? 'Conectado' : 'Desconectado',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).surface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(
                    AppSizes.cardPadding.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).surfaceOverlay20,
                    borderRadius: BorderRadius.circular(
                      isMobile ? 14 : 16,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thermostat_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconExtraLargeAlt.get(isMobile, isTablet),
                      ),
                      SizedBox(
                        height: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                      Text(
                        state.temperatureFormatted,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 24,
                            mobileFontSize: 22,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'Temperatura Atual',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).surfaceOverlay70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApiCard() {
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
                  Icons.cloud_rounded,
                  color: ThemeColors.of(context).blueMain,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Configura??o API',
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
              TextButton.icon(
                onPressed: _testarConexao,
                icon: Icon(
                  Icons.play_arrow_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                ),
                label: Text(
                  'Testar',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          TextField(
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Chave API OpenWeather',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              ),
              hintText: 'Digite sua API key',
              prefixIcon: Icon(
                Icons.key_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).textSecondaryOverlay10,
            ),
            obscureText: true,
            onChanged: (v) => ref.read(temperatureProvider.notifier).setApiKey(v),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          TextField(
            controller: _cidadeController,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Cidade',
              labelStyle: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
              ),
              hintText: 'Ex: S?o Paulo',
              prefixIcon: Icon(
                Icons.location_city_rounded,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).textSecondary,
            ),
            onChanged: (v) => ref.read(temperatureProvider.notifier).setCity(v),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSm.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoPastel,
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
              border: Border.all(color: ThemeColors.of(context).infoLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                  color: ThemeColors.of(context).infoDark,
                ),
                SizedBox(
                  width: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    'Obtenha sua API key gratuita em openweathermap.org',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 12,
                        mobileFontSize: 11,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).infoDark,
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

  Widget _buildPrevisaoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final state = ref.watch(temperatureProvider);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).successLight],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        border: Border.all(color: ThemeColors.of(context).primaryLight, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                color: ThemeColors.of(context).primaryDark,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Frequ?ncia de Atualiza??o',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildFrequenciaChip('30 min', state.selectedFrequency == '30 min'),
              ),
              SizedBox(
                width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildFrequenciaChip('1 hora', state.selectedFrequency == '1 hora'),
              ),
              SizedBox(
                width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildFrequenciaChip('2 horas', state.selectedFrequency == '2 horas'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFrequenciaChip(String label, bool selected) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return GestureDetector(
      onTap: () => ref.read(temperatureProvider.notifier).setSelectedFrequency(label),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark])
              : null,
          color: selected ? null : ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 8 : 10,
          ),
          border: Border.all(
            color: selected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
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
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFaixaCard(TemperatureRangeModel faixa, int index) {
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
          border: Border.all(color: faixa.colorLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: faixa.colorLight,
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
                      colors: [faixa.color, faixa.color.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 12 : 14,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: faixa.colorLight,
                        blurRadius: isMobile ? 10 : 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    faixa.icon,
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
                      Text(
                        faixa.range,
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
                      Text(
                        faixa.title,
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
                        height: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        faixa.description,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 12,
                            mobileFontSize: 11,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondaryOverlay70,
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
                      colors: [faixa.color, faixa.colorDark],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                  child: Text(
                    faixa.adjustmentFormatted,
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
            if (!faixa.isNoAdjustment) ...[
              SizedBox(
                height: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: faixa.products.map((p) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: faixa.colorLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: faixa.colorLight),
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
                        color: faixa.color,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Slider(
                value: faixa.adjustment.abs(),
                min: 0,
                max: 30,
                divisions: 60,
                label: faixa.adjustmentFormatted,
                onChanged: (value) {
                  final newAdjustment = faixa.adjustment >= 0 ? value : -value;
                  ref.read(temperatureProvider.notifier).updateRangeAdjustment(faixa.id, newAdjustment);
                },
                activeColor: faixa.color,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoCard(TemperatureHistoryModel item, int index) {
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
                    item.dateTime,
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
                    'Temperatura: ${item.temperature}',
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
                  '${item.adjustmentsCount}',
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

  void _testarConexao() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueMain),
            ),
            SizedBox(
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            Text(
              'Testando Conex?o',
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
              height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            ),
            Text(
              'Conectando com OpenWeather API...',
              textAlign: TextAlign.center,
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
    );

    ref.read(temperatureProvider.notifier).testConnection().then((_) {
      Navigator.pop(context);
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
                      'Conex?o Bem-Sucedida!',
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
                      'API OpenWeather conectada',
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
          backgroundColor: ThemeColors.of(context).greenMain,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
          ),
        ),
      );
    });
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
          Icons.wb_sunny_rounded,
          color: ThemeColors.of(context).orangeMain,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Precifica??o por Temperatura',
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
                'Sistema inteligente que ajusta pre?os baseado na temperatura:',
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
                '? Integra??o com API OpenWeather em tempo real',
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
                '? Aumenta pre?os de bebidas geladas em dias quentes',
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
                '? Reduz pre?os de sorvetes em dias frios',
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
                '? Aumenta pre?os de bebidas quentes no frio',
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
                '? Atualiza??es autom?ticas a cada 30 minutos',
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

  void _salvarConfiguracoes() {
    final isMobile = ResponsiveHelper.isMobile(context);

    ref.read(temperatureProvider.notifier).saveConfigurations().then((_) {
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
                'Configura??es salvas com sucesso',
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
          backgroundColor: ThemeColors.of(context).orangeMain,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
          ),
        ),
      );
    });
  }
}








