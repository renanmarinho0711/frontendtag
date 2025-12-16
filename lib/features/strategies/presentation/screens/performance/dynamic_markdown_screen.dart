import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/performance_provider.dart';

class DynamicMarkdownConfigScreen extends ConsumerStatefulWidget {
  const DynamicMarkdownConfigScreen({super.key});

  @override
  ConsumerState<DynamicMarkdownConfigScreen> createState() => _DynamicMarkdownConfigScreenState();
}

class _DynamicMarkdownConfigScreenState extends ConsumerState<DynamicMarkdownConfigScreen>
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
    final state = ref.watch(dynamicMarkdownProvider);
    final notifier = ref.read(dynamicMarkdownProvider.notifier);

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
                  _buildConfigTab(state, notifier),
                  _buildFaixasTab(state, notifier),
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
              onPressed: () => _salvarConfiguracoes(notifier),
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
              backgroundColor: ThemeColors.of(context).warning,
            ),
          Positioned(
            right: 0,
            bottom: state.fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () => notifier.toggleFabExpanded(),
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

  Widget _buildModernAppBar(DynamicMarkdownState state, DynamicMarkdownNotifier notifier) {
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
              gradient: LinearGradient(colors: [ThemeColors.of(context).warning, ThemeColors.of(context).orangeDark]),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              Icons.schedule_rounded,
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
                  'Dynamic Markdown',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Redu??o por Validade',
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
          gradient: LinearGradient(colors: [ThemeColors.of(context).warning, ThemeColors.of(context).orangeDark]),
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
            text: 'Faixas',
          ),
          Tab(
            icon: Icon(Icons.inventory_2_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Produtos',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab(DynamicMarkdownState state, DynamicMarkdownNotifier notifier) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(state, notifier),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            child: Column(
              children: [
                _buildHeader(state, notifier),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildAlertCard(),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildFiltroCard(state, notifier),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildNotificacoesCard(state, notifier),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildCategoriasCard(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaixasTab(DynamicMarkdownState state, DynamicMarkdownNotifier notifier) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      itemCount: state.rules.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
        child: _buildFaixaCard(state.rules[index], index, notifier),
      ),
    );
  }

  Widget _buildProdutosTab(DynamicMarkdownState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
          padding: EdgeInsets.all(AppSizes.paddingMdAlt2.get(isMobile, isTablet)),
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
                  '${state.products.length} produtos com desconto autom?tico ativo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
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
              child: _buildProdutoCard(state.products[index], index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(DynamicMarkdownState state, DynamicMarkdownNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).warning, ThemeColors.of(context).orangeDark]),
        borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).warning.withValues(alpha: 0.4),
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
              Icons.trending_down_rounded,
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
                  'Redu??o Autom?tica',
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
                  state.isStrategyActive ? 'Sistema ativo' : 'Sistema inativo',
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
              value: state.isStrategyActive,
              onChanged: (value) => notifier.setStrategyActive(value),
              activeColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).warningPastel, ThemeColors.of(context).errorPastel]),
        borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
        border: Border.all(color: ThemeColors.of(context).warning, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_fix_high_rounded,
            color: ThemeColors.of(context).warningDark,
            size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Redu??o Progressiva Inteligente',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                Text(
                  'Pre?os s?o ajustados automaticamente conforme a data de validade se aproxima, maximizando vendas e reduzindo perdas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
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

  Widget _buildFiltroCard(DynamicMarkdownState state, DynamicMarkdownNotifier notifier) {
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoLight,
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              Icons.filter_list_rounded,
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
                  'Aplicar Apenas em Perec?veis',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                Text(
                  'Produtos com data de validade curta',
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
              value: state.apenasPereci,
              onChanged: (value) => notifier.setApenasPereci(value),
              activeColor: ThemeColors.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificacoesCard(DynamicMarkdownState state, DynamicMarkdownNotifier notifier) {
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
              Icons.notifications_active_rounded,
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
                  'Notificar Ajustes de Pre?o',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                Text(
                  'Enviar alerta quando descontos forem aplicados',
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
              value: state.notificarAjustes,
              onChanged: (value) => notifier.setNotificarAjustes(value),
              activeColor: ThemeColors.of(context).blueCyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriasCard(DynamicMarkdownState state) {
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
                  'Categorias Perec?veis',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          ...state.selectedCategories.map((cat) => Padding(
            padding: EdgeInsets.only(bottom: AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
                vertical: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).successPastel,
                borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                border: Border.all(color: ThemeColors.of(context).successLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: ThemeColors.of(context).success,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFaixaCard(MarkdownRuleModel rule, int index, DynamicMarkdownNotifier notifier) {
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
          borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
          border: Border.all(color: rule.corLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: rule.corLight,
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
                    gradient: LinearGradient(colors: [rule.cor, rule.cor.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
                    boxShadow: [
                      BoxShadow(
                        color: rule.corLight,
                        blurRadius: isMobile ? 10 : 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    rule.icone,
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
                      Text(
                        rule.faixa,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        rule.descricao,
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
                    gradient: LinearGradient(colors: [rule.cor, rule.corDark]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    boxShadow: [
                      BoxShadow(
                        color: rule.corLight,
                        blurRadius: isMobile ? 8 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rule.descontoFormatted,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 24, mobileFontSize: 22),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (rule.hasDesconto)
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
            if (rule.hasDesconto) ...[
              SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ajustar percentual de desconto',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                          vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: rule.corLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          rule.descontoFormatted,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: rule.cor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                  Slider(
                    value: rule.desconto,
                    min: 5,
                    max: 80,
                    divisions: 75,
                    label: rule.descontoFormatted,
                    onChanged: (value) => notifier.updateRuleDiscount(rule.id, value),
                    activeColor: rule.cor,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProdutoCard(MarkdownProductModel produto, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final statusColor = produto.statusColor;

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
        padding: EdgeInsets.all(AppSizes.paddingLgAlt3.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 16 : (isTablet ? 17 : 18)),
          border: Border.all(color: statusColorLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: statusColorLight,
              blurRadius: isMobile ? 12 : 15,
              offset: Offset(0, isMobile ? 4 : 5),
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
                    gradient: LinearGradient(colors: [statusColor, statusColor.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    produto.statusIcon,
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
                        produto.nome,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        'Validade: ${produto.validade}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
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
                    color: statusColorLight,
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                    border: Border.all(color: statusColorLight),
                  ),
                  child: Text(
                    produto.diasRestantesFormatted,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingSm.get(isMobile, isTablet)),
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
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        produto.precoOriginal,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
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
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Pre?o com Desconto',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9),
                          overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        produto.precoAtual,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: statusColorLight,
                borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_rounded,
                    color: statusColor,
                    size: AppSizes.iconTiny.get(isMobile, isTablet),
                  ),
                  SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                  Text(
                    '${produto.desconto}% de desconto aplicado automaticamente',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
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

  void _showInfoDialog() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
        icon: Icon(
          Icons.auto_fix_high_rounded,
          color: ThemeColors.of(context).warning,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Dynamic Markdown',
          style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
          overflow: TextOverflow.ellipsis,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sistema inteligente de redu??o de pre?os baseado em validade:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
              Text(
                '? Detecta automaticamente produtos pr?ximos ao vencimento',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Aplica descontos progressivos conforme a data se aproxima',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Reduz perdas e aumenta a rotatividade',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Tags ESL s?o atualizadas em tempo real',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text(
                '? Redu??o de 60-80% em perdas por vencimento',
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12),
                overflow: TextOverflow.ellipsis, height: 1.5),
              ),
              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
              Text(
                'Ideal para supermercados, padarias e restaurantes.',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  fontStyle: FontStyle.italic,
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
              style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _salvarConfiguracoes(DynamicMarkdownNotifier notifier) {
    final isMobile = ResponsiveHelper.isMobile(context);

    notifier.saveConfigurations();

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
                    'Dynamic Markdown ativo e configurado',
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
        backgroundColor: ThemeColors.of(context).warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}








