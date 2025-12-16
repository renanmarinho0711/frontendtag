import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/cross_selling_provider.dart';

class TrilhaOfertasConfigScreen extends ConsumerStatefulWidget {
  const TrilhaOfertasConfigScreen({super.key});

  @override
  ConsumerState<TrilhaOfertasConfigScreen> createState() => _TrilhaOfertasConfigScreenState();
}

class _TrilhaOfertasConfigScreenState extends ConsumerState<TrilhaOfertasConfigScreen>
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
    _tabController = TabController(length: 2, vsync: this);
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
    final state = ref.watch(offersTrailProvider);
    
    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModernAppBar(state),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildConfigTab(state),
                    _buildTrilhasTab(state),
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
              if (state.fabExpanded) ...[
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: _criarTrilha,
                  backgroundColor: ThemeColors.of(context).orangeMain,
                  child: Icon(
                    Icons.add_rounded,
                    size: AppSizes.iconLarge.get(isMobile, isTablet),
                  ),
                  tooltip: 'Nova Trilha',
                ),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                FloatingActionButton.extended(
                  heroTag: 'save',
                  onPressed: _salvarConfiguracoes,
                  icon: Icon(
                    Icons.save_rounded,
                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                  ),
                  label: Text(
                    'Salvar',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13,
                      ),
                    ),
                  ),
                  backgroundColor: ThemeColors.of(context).orangeMain,
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
                ref.read(offersTrailProvider.notifier).toggleFabExpanded();
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

  Widget _buildModernAppBar(OffersTrailState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMdAlt2.get(isMobile, isTablet),
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
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingSmAlt.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
              ),
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.timeline_rounded,
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
                  'Trilha de Ofertas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Caminhos Visuais',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
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
          isMobile ? 14 : (isTablet ?  15 : 16),
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
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 13,
            mobileFontSize: 12,
            tabletFontSize: 12,
          ),
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.settings_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Configura��o',
          ),
          Tab(
            icon: Icon(
              Icons.map_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Trilhas',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab(OffersTrailState state) {
    return SingleChildScrollView(
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
          _buildInfoCard(),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildParametrosCard(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildVisualizacaoCard(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildOpcoesCard(state),
        ],
      ),
    );
  }

  Widget _buildTrilhasTab(OffersTrailState state) {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: state.trilhas.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          bottom: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        child: _buildTrilhaCard(state.trilhas[index], index),
      ),
    );
  }

  Widget _buildHeader(OffersTrailState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final trilhasAtivas = state.trilhasAtivas;

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
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
                isMobile ? 12 : (isTablet ? 14 : 16),
              ),
            ),
            child: Icon(
              Icons.route_rounded,
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
                  'Caminhos Inteligentes',
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
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  '$trilhasAtivas trilha(s) ativa(s)',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
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
              onChanged: (value) => ref.read(offersTrailProvider.notifier).setStrategyActive(value),
              activeColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).orangeMain.withValues(alpha: 0.1), ThemeColors.of(context).amberMain.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        border: Border.all(color: ThemeColors.of(context).warning, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.map_rounded,
            color: ThemeColors.of(context).warningDark,
            size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
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
                  'Trilhas Entre Corredores',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  'ESLs criam caminhos visuais conectando produtos complementares atrav�s dos corredores',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParametrosCard(OffersTrailState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ?  14 : (isTablet ? 15 : 16),
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
                  color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  color: ThemeColors.of(context).orangeMain,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Configura��es das Trilhas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14,
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
            height: AppSizes.paddingXl.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.update_rounded,
                size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                color: ThemeColors.of(context).orangeMain,
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Intervalo de Atualiza��o',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14,
                    ),
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
                  color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Text(
                  '${state.intervaloAtualizacao.round()}s',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
                      tabletFontSize: 15,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).orangeMain,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: state.intervaloAtualizacao,
            min: 10,
            max: 60,
            divisions: 10,
            activeColor: ThemeColors.of(context).orangeMain,
            label: '${state.intervaloAtualizacao.round()}s',
            onChanged: (value) => ref.read(offersTrailProvider.notifier).setIntervaloAtualizacao(value),
          ),
          SizedBox(
            height: AppSizes.paddingXl.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.format_list_numbered_rounded,
                size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                color: ThemeColors.of(context).orangeMain,
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Produtos por Trilha',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14,
                    ),
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
                  color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Text(
                  '${state.produtosPorTrilha}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
                      tabletFontSize: 15,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).orangeMain,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: state.produtosPorTrilha.toDouble(),
            min: 2,
            max: 8,
            divisions: 6,
            activeColor: ThemeColors.of(context).orangeMain,
            label: '${state.produtosPorTrilha}',
            onChanged: (value) => ref.read(offersTrailProvider.notifier).setProdutosPorTrilha(value.round()),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizacaoCard(OffersTrailState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ?  14 : (isTablet ? 15 : 16),
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
                  color: ThemeColors.of(context).blueMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.palette_rounded,
                  color: ThemeColors.of(context).blueMain,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Estilo de Visualiza��o',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 15,
                      mobileFontSize: 14,
                      tabletFontSize: 14,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildEstiloButton(
                  'Setas',
                  'setas',
                  Icons.arrow_forward_rounded,
                  state,
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildEstiloButton(
                  'N�meros',
                  'numeros',
                  Icons.format_list_numbered_rounded,
                  state,
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildEstiloButton(
                  'Cores',
                  'cores',
                  Icons.color_lens_rounded,
                  state,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstiloButton(String label, String estilo, IconData icon, OffersTrailState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = state.estilo == estilo;

    return InkWell(
      onTap: () => ref.read(offersTrailProvider.notifier).setEstilo(estilo),
      borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
                )
              : null,
          color: isSelected ? null : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ThemeColors.of(context).orangeMain.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
            ),
            SizedBox(
              height: AppSizes.paddingXs.get(isMobile, isTablet),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12,
                ),
              overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcoesCard(OffersTrailState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXl.get(isMobile, isTablet),
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
        children: [
          _buildSwitchOption(
            'Destacar In�cio',
            'Produto inicial da trilha com anima��o especial',
            Icons.start_rounded,
            state.destacarInicio,
            (value) => ref.read(offersTrailProvider.notifier).setDestacarInicio(value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildSwitchOption(
            'Destacar Fim',
            'Produto final da trilha com anima��o especial',
            Icons.flag_rounded,
            state.destacarFim,
            (value) => ref.read(offersTrailProvider.notifier).setDestacarFim(value),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildSwitchOption(
            'Notificar Cliente',
            'Avisar cliente sobre trilha dispon�vel',
            Icons.notifications_active_rounded,
            state.notificarCliente,
            (value) => ref.read(offersTrailProvider.notifier).setNotificarCliente(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: value ? ThemeColors.of(context).warningPastel : ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        border: Border.all(
          color: value ? ThemeColors.of(context).orangeMain.withValues(alpha: 0.3) : ThemeColors.of(context).textSecondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: value ? ThemeColors.of(context).orangeMain : ThemeColors.of(context).textSecondary,
            size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
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
                      tabletFontSize: 14,
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
                      tabletFontSize: 11,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.95,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ThemeColors.of(context).orangeMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrilhaCard(OffersTrailModel trilha, int index) {
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
          border: Border.all(
            color: trilha.cor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: trilha.cor.withValues(alpha: 0.15),
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
                      colors: [trilha.cor, trilha.cor.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                    boxShadow: [
                      BoxShadow(
                        color: trilha.cor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    trilha.icone,
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
                        trilha.nome,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 17,
                            mobileFontSize: 15,
                            tabletFontSize: 16,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
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
                              horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                              vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                            ),
                            decoration: BoxDecoration(
                              color: trilha.cor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
                            ),
                            child: Text(
                              '${trilha.totalProdutos} produtos',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                  tabletFontSize: 10,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: trilha.cor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: AppSizes.paddingXs.get(isMobile, isTablet),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                              vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                            ),
                            decoration: BoxDecoration(
                              color: trilha.ativa ? ThemeColors.of(context).successLight : ThemeColors.of(context).textSecondary,
                              borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
                            ),
                            child: Text(
                              trilha.ativa ? 'Ativa' : 'Inativa',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                  tabletFontSize: 10,
                                ),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: trilha.ativa ? ThemeColors.of(context).greenMain.withValues(alpha: 0.8) : ThemeColors.of(context).textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 1.05,
                  child: Switch(
                    value: trilha.ativa,
                    onChanged: (value) {
                      ref.read(offersTrailProvider.notifier).toggleTrilhaAtiva(trilha.id, value);
                    },
                    activeColor: trilha.cor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            const Divider(height: 1),
            SizedBox(
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.route_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                  color: ThemeColors.of(context).textSecondary,
                ),
                SizedBox(
                  width: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                Text(
                  'Sequ�ncia:',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 12,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            Wrap(
              spacing: AppSizes.paddingXs.get(isMobile, isTablet),
              runSpacing: AppSizes.paddingXs.get(isMobile, isTablet),
              children: List.generate(
                trilha.produtos.length,
                (i) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                    vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: trilha.cor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                    border: Border.all(
                      color: trilha.cor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: ResponsiveHelper.getResponsiveWidth(
                          context,
                          mobile: 22,
                          tablet: 23,
                          desktop: 24,
                        ),
                        height: ResponsiveHelper.getResponsiveHeight(
                          context,
                          mobile: 22,
                          tablet: 23,
                          desktop: 24,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [trilha.cor, trilha.cor.withValues(alpha: 0.7)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: ThemeColors.of(context).surface,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 11,
                                mobileFontSize: 10,
                                tabletFontSize: 10,
                              ),
                            overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppSizes.paddingXs.get(isMobile, isTablet),
                      ),
                      Text(
                        trilha.produtos[i],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 13,
                            mobileFontSize: 12,
                            tabletFontSize: 12,
                          ),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                      ),
                      Text(
                        '(Cor.  ${trilha.corredores[i]})',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                            tabletFontSize: 10,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_cart_rounded,
                          size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                          color: trilha.cor,
                        ),
                        SizedBox(
                          height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                        ),
                        Text(
                          '${trilha.vendas}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 16,
                              mobileFontSize: 14,
                              tabletFontSize: 15,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: trilha.cor,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingMicro2.get(isMobile, isTablet),
                        ),
                        Text(
                          'Vendas',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                              tabletFontSize: 10,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: ResponsiveHelper.getResponsiveHeight(
                      context,
                      mobile: 56,
                      tablet: 58,
                      desktop: 60,
                    ),
                    color: ThemeColors.of(context).textSecondary,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                          color: trilha.cor,
                        ),
                        SizedBox(
                          height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                        ),
                        Text(
                          '${trilha.conversao}%',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 16,
                              mobileFontSize: 14,
                              tabletFontSize: 15,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: trilha.cor,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingMicro2.get(isMobile, isTablet),
                        ),
                        Text(
                          'Convers�o',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                              tabletFontSize: 10,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: ResponsiveHelper.getResponsiveHeight(
                      context,
                      mobile: 56,
                      tablet: 58,
                      desktop: 60,
                    ),
                    color: ThemeColors.of(context).textSecondary,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                          color: trilha.cor,
                        ),
                        SizedBox(
                          height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                        ),
                        Text(
                          trilha.ticketMedio,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 16,
                              mobileFontSize: 14,
                              tabletFontSize: 15,
                            ),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: trilha.cor,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.paddingMicro2.get(isMobile, isTablet),
                        ),
                        Text(
                          'Ticket M�dio',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                              tabletFontSize: 10,
                            ),
                          overflow: TextOverflow.ellipsis,
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _editarTrilha(trilha),
                icon: Icon(
                  Icons.edit_rounded,
                  size: AppSizes.iconSmall.get(isMobile, isTablet),
                  color: trilha.cor,
                ),
                label: Text(
                  'Editar Trilha',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                      tabletFontSize: 13,
                    ),
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: trilha.cor,
                  side: BorderSide(
                    color: trilha.cor.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingSm.get(isMobile, isTablet),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _criarTrilha() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
        ),
        icon: Icon(
          Icons.add_circle_rounded,
          color: ThemeColors.of(context).orangeMain,
          size: AppSizes.iconHeroLg.get(isMobile, isTablet),
        ),
        title: Text(
          'Nova Trilha de Ofertas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Text(
          'A IA criar� uma nova trilha de ofertas conectando produtos estrat�gicos com base em dados de vendas e comportamento dos clientes.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Chama o m�todo do provider para criar trilha via IA
              await ref.read(offersTrailProvider.notifier).criarTrilha();
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                        Text('Trilha criada com sucesso!', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
                      ],
                    ),
                    backgroundColor: ThemeColors.of(context).orangeMain,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.of(context).orangeMain),
            child: Text(
              'Criar Trilha',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editarTrilha(OffersTrailModel trilha) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
        ),
        title: Text(
          'Editar Trilha',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Trilha: ${trilha.nome}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Produtos: ${trilha.produtos.length}',
              style: TextStyle(
                color: ThemeColors.of(context).textSecondary,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                'Trilha Ativa',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                    tabletFontSize: 13,
                  ),
                ),
              ),
              value: trilha.ativa,
              onChanged: (value) {
                ref.read(offersTrailProvider.notifier).toggleTrilhaAtiva(trilha.id, value);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Salva as altera��es
              ref.read(offersTrailProvider.notifier).saveConfigurations();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trilha atualizada com sucesso!')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
        ),
        icon: Icon(
          Icons.timeline_rounded,
          color: ThemeColors.of(context).orangeMain,
          size: AppSizes.iconHeroLg.get(isMobile, isTablet),
        ),
        title: Text(
          'Trilha de Ofertas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 20,
              mobileFontSize: 18,
              tabletFontSize: 19,
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
                'Crie caminhos visuais entre corredores:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                    tabletFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              Text(
                '? ESLs formam sequ�ncias visuais conectadas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                '? Cliente navega por produtos relacionados',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                '? Aumenta vendas cruzadas em 20-30%',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                '? Cria experi�ncia gamificada de compra',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
                  ),
                overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXs.get(isMobile, isTablet),
              ),
              Text(
                '? Rota��o autom�tica entre m�ltiplas trilhas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12,
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
                  tabletFontSize: 13,
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

    // Salva as configura��es no backend
    await ref.read(offersTrailProvider.notifier).saveConfigurations();
    
    final state = ref.read(offersTrailProvider);
    
    if (mounted) {
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Expanded(
                  child: Text('Erro ao salvar: ${state.error}', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
                ),
              ],
            ),
            backgroundColor: ThemeColors.of(context).error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Configura��es Salvas!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13))),
                      Text('Trilhas de ofertas configuradas', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11))),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: ThemeColors.of(context).orangeMain,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
          ),
        );
      }
    }
  }
}






