import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/performance_provider.dart';

class LiquidacaoAutomaticaConfigScreen extends ConsumerStatefulWidget {
  const LiquidacaoAutomaticaConfigScreen({super.key});

  @override
  ConsumerState<LiquidacaoAutomaticaConfigScreen> createState() => _LiquidacaoAutomaticaConfigScreenState();
}

class _LiquidacaoAutomaticaConfigScreenState extends ConsumerState<LiquidacaoAutomaticaConfigScreen>
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
    final state = ref.watch(autoClearanceProvider);
    
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
                    _buildConfigTab(state),
                    _buildFasesTab(state),
                    _buildProdutosTab(state),
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
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              backgroundColor: ThemeColors.of(context).error,
            ),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () {
                ref.read(autoClearanceProvider.notifier).toggleFabExpanded();
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

  Widget _buildModernAppBar(AutoClearanceState state) {
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
              gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark]),
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.local_offer_rounded,
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
                  'Liquida??o Autom?tica',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Produtos Parados',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
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
          gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark]),
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
            icon: Icon(Icons.layers_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Fases',
          ),
          Tab(
            icon: Icon(Icons.inventory_2_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Produtos',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab(AutoClearanceState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(state),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            child: Column(
              children: [
                _buildHeader(state),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildInfoCard(),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildMargemCard(state),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildNotificacoesCard(state),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildCategoriasCard(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFasesTab(AutoClearanceState state) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      itemCount: state.phases.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
        child: _buildFaseCard(state.phases[index], index),
      ),
    );
  }

  Widget _buildProdutosTab(AutoClearanceState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
          padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [ThemeColors.of(context).errorPastel, ThemeColors.of(context).warningPastel]),
            borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
            border: Border.all(color: ThemeColors.of(context).errorLight, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                color: ThemeColors.of(context).errorDark,
                size: AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.products.length} Produtos em Liquida??o',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).errorDark,
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                    Text(
                      'Capital empatado: ${state.capitalEmpatado}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
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
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd.get(isMobile, isTablet)),
            itemCount: state.products.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
              child: _buildProdutoCard(state.products[index], index, state),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AutoClearanceState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark]),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).errorLight,
            blurRadius: isMobile ? 12 : 15,
            offset: Offset(0, isMobile ? 4 : 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.trending_down_rounded,
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
                  'Liquida??o Progressiva',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                Text(
                  state.isStrategyActive ? 'Sistema ativo' : 'Sistema inativo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
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
              onChanged: (value) => ref.read(autoClearanceProvider.notifier).setStrategyActive(value),
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
      padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).infoPastel,
        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        border: Border.all(color: ThemeColors.of(context).infoLight, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: ThemeColors.of(context).infoDark,
            size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Text(
              'Produtos sem vendas s?o automaticamente identificados e entram em liquida??o progressiva em 4 fases',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
              overflow: TextOverflow.ellipsis,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMargemCard(AutoClearanceState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMdLg.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : (isTablet ? 13 : 14)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.04),
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
                padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).infoLight,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.percent_rounded,
                  color: ThemeColors.of(context).info,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Margem M?nima Permitida',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                    Text(
                      'Desconto n?o ultrapassa este limite',
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
                  gradient: LinearGradient(colors: [ThemeColors.of(context).info, ThemeColors.of(context).blueDark]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.of(context).infoLight,
                      blurRadius: isMobile ? 8 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  state.margemMinimaFormatted,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 24, mobileFontSize: 22),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
          Slider(
            value: state.margemMinima,
            min: 0,
            max: 20,
            divisions: 40,
            label: state.margemMinimaFormatted,
            onChanged: (value) => ref.read(autoClearanceProvider.notifier).setMargemMinima(value),
            activeColor: ThemeColors.of(context).info,
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
                    'Produtos n?o ter?o desconto que resulte em margem abaixo deste valor',
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
        ],
      ),
    );
  }

  Widget _buildNotificacoesCard(AutoClearanceState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
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
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).blueCyanLight,
              borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
            ),
            child: Icon(
              Icons.email_rounded,
              color: ThemeColors.of(context).blueCyan,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notificar Produtos em Liquida??o',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                Text(
                  'Receber alertas quando produtos entrarem em liquida??o',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                  overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.05,
            child: Switch(
              value: state.notificarLiquidacao,
              onChanged: (value) => ref.read(autoClearanceProvider.notifier).setNotificarLiquidacao(value),
              activeColor: ThemeColors.of(context).blueCyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriasCard(AutoClearanceState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
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
                padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).successLight,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.category_rounded,
                  color: ThemeColors.of(context).success,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Categorias Monitoradas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                  onPressed: () => _editarCategorias(state),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          Wrap(
            spacing: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            runSpacing: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            children: state.selectedCategories.map((cat) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
                  vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark]),
                  borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.of(context).successLight,
                      blurRadius: isMobile ? 6 : 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconTiny.get(isMobile, isTablet),
                    ),
                    SizedBox(width: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                    Text(
                      cat,
                      style: TextStyle(
                        color: ThemeColors.of(context).surface,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                    InkWell(
                      onTap: () => ref.read(autoClearanceProvider.notifier).removeCategory(cat),
                      child: Icon(
                        Icons.close_rounded,
                        color: ThemeColors.of(context).surface,
                        size: AppSizes.iconTiny.get(isMobile, isTablet),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFaseCard(ClearancePhaseModel fase, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 70)),
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
          borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
          border: Border.all(color: fase.corLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: fase.corLight,
              blurRadius: isMobile ? 15 : 20,
              offset: Offset(0, isMobile ? 4 : 6),
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
                    gradient: LinearGradient(colors: [fase.cor, fase.cor.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                    boxShadow: [
                      BoxShadow(
                        color: fase.corLight,
                        blurRadius: isMobile ? 10 : 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    fase.icone,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fase.fase,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                            overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                          SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                              vertical: AppSizes.paddingMicro2.get(isMobile, isTablet),
                            ),
                            decoration: BoxDecoration(
                              color: fase.corLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${fase.dias} dias',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9),
                              overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: fase.cor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        fase.titulo,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 17, mobileFontSize: 16),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        fase.descricao,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
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
                    gradient: LinearGradient(colors: [fase.cor, fase.corDark]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    boxShadow: [
                      BoxShadow(
                        color: fase.corLight,
                        blurRadius: isMobile ? 8 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fase.descontoFormatted,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 24, mobileFontSize: 22),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'OFF',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dias sem venda',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                      Slider(
                        value: fase.dias.toDouble(),
                        min: 15,
                        max: 180,
                        divisions: 33,
                        label: '${fase.dias} dias',
                        onChanged: (value) => ref.read(autoClearanceProvider.notifier).updatePhaseDays(fase.id, value.toInt()),
                        activeColor: fase.cor,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desconto aplicado',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                      Slider(
                        value: fase.desconto,
                        min: 5,
                        max: 80,
                        divisions: 75,
                        label: fase.descontoFormatted,
                        onChanged: (value) => ref.read(autoClearanceProvider.notifier).updatePhaseDiscount(fase.id, value),
                        activeColor: fase.cor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProdutoCard(ClearanceProductModel produto, int index, AutoClearanceState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final faseData = ref.read(autoClearanceProvider.notifier).getPhaseByIndex(produto.fase - 1);
    final corFase = faseData?.cor ?? ThemeColors.of(context).error;

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
        padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 18 : 20)),
          border: Border.all(color: corFaseLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: corFaseLight,
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
                    gradient: LinearGradient(colors: [corFase, corFase.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    faseData?.icone ?? Icons.timer_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produto.nome,
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
                            Icons.access_time_rounded,
                            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                          SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),
                          Text(
                            '${produto.diasParado} dias sem venda',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                            overflow: TextOverflow.ellipsis,
                              color: ThemeColors.of(context).textSecondaryOverlay70,
                            ),
                          ),
                        ],
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
                    gradient: LinearGradient(colors: [corFase, corFaseDark]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                  ),
                  child: Text(
                    'Fase ${produto.fase}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.of(context).surface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pre?o Original',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        produto.precoOriginal,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: ThemeColors.of(context).textSecondary,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Pre?o com Desconto',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondaryOverlay70,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        produto.precoAtual,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: corFase,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingSm.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: corFaseLight,
                      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                      border: Border.all(color: corFaseLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_rounded,
                          color: corFase,
                          size: AppSizes.iconSmall.get(isMobile, isTablet),
                        ),
                        SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                        Text(
                          produto.descontoFormatted,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                          overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: corFase,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                    vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondary,
                    borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        size: AppSizes.iconTiny.get(isMobile, isTablet),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      SizedBox(width: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                      Text(
                        '${produto.estoque} un',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                        overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editarCategorias(AutoClearanceState state) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext2, setDialogState) {
          // Cria uma c?pia local das categorias selecionadas para o di?logo
          final localSelectedCategories = List<String>.from(state.selectedCategories);
          
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
            title: Text(
              'Selecionar Categorias',
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
              overflow: TextOverflow.ellipsis,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: StatefulBuilder(
                builder: (context, setListState) {
                  return ListView(
                    shrinkWrap: true,
                    children: state.allCategories.map((cat) {
                      final isSelected = localSelectedCategories.contains(cat);
                      return CheckboxListTile(
                        title: Text(
                          cat,
                          style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: isSelected,
                        activeColor: ThemeColors.of(context).success,
                        onChanged: (value) {
                          setListState(() {
                            if (value == true) {
                              localSelectedCategories.add(cat);
                            } else {
                              localSelectedCategories.remove(cat);
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancelar',
                  style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Sincroniza com o provider
                  for (final cat in state.allCategories) {
                    final wasSelected = state.selectedCategories.contains(cat);
                    final isNowSelected = localSelectedCategories.contains(cat);
                    if (wasSelected && !isNowSelected) {
                      ref.read(autoClearanceProvider.notifier).removeCategory(cat);
                    } else if (!wasSelected && isNowSelected) {
                      ref.read(autoClearanceProvider.notifier).addCategory(cat);
                    }
                  }
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.of(context).success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
                ),
                child: Text(
                  'Salvar',
                  style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
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
          Icons.local_offer_rounded,
          color: ThemeColors.of(context).error,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Como Funciona',
          style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
          overflow: TextOverflow.ellipsis,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A liquida??o autom?tica identifica produtos parados e aplica descontos progressivos em 4 fases:',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
              Text(
                '? Produtos sem vendas entram automaticamente',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Desconto aumenta conforme o tempo passa',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Respeita a margem m?nima configurada',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Tags ESL s?o atualizadas automaticamente',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Libera capital empatado em produtos parados',
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

  void _salvarConfiguracoes() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    // Salva as configura??es via provider
    ref.read(autoClearanceProvider.notifier).saveConfigurations();

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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configura??es Salvas!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Liquida??o autom?tica ativa e configurada',
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
        backgroundColor: ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}









