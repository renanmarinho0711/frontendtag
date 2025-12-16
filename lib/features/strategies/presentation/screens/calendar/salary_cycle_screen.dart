import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/providers/calendar_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

class CicloSalarioConfigScreen extends ConsumerStatefulWidget {
  const CicloSalarioConfigScreen({super.key});

  @override
  ConsumerState<CicloSalarioConfigScreen> createState() => _CicloSalarioConfigScreenState();
}

class _CicloSalarioConfigScreenState extends ConsumerState<CicloSalarioConfigScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TabController _tabController;
  bool _fabExpanded = true;

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
    final salaryCycleState = ref.watch(salaryCycleProvider);

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
                    _buildConfigTab(salaryCycleState),
                    _buildHistoricoTab(salaryCycleState),
                  ],
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: Stack(
        children: [
          if (_fabExpanded)
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
              backgroundColor: ThemeColors.of(context).greenMain,
            ),
          Positioned(
            right: 0,
            bottom: _fabExpanded ? 66 : 0,
            child: FloatingActionButton.small(
              heroTag: 'toggle',
              onPressed: () {
                setState(() {
                  _fabExpanded = !_fabExpanded;
                });
              },
              backgroundColor: ThemeColors.of(context).textSecondary,
              child: Icon(
                _fabExpanded ? Icons.close_rounded : Icons.add_rounded,
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
                colors: [ThemeColors.of(context).greenMain, ThemeColors.of(context).greenDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.attach_money_rounded,
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
                  'Ciclo de Sal�rio',
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
                  'Monitoramento de Pagamento',
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
            color: ThemeColors.of(context).textSecondaryOverlay70,
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
            colors: [ThemeColors.of(context).greenMain, ThemeColors.of(context).greenDark],
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
            text: 'Configura��o',
          ),
          Tab(
            icon: Icon(
              Icons.history_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Hist�rico',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab(SalaryCycleState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            child: Column(
              children: [
                _buildHeader(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildInfoCard(),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildQuinzenaCard(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildAjusteCard(
            'In�cio do M�s (P�s-Pagamento)',
            'Dias 1-${state.diasPagamento}',
            state.ajusteInicio,
            Icons.trending_up_rounded,
            ThemeColors.of(context).greenMain,
            (v) => ref.read(salaryCycleProvider.notifier).setAjusteInicio(v),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildAjusteCard(
            'Fim do M�s (Pr�-Pagamento)',
            'Dias ${30 - state.diasPagamento}-30',
            state.ajusteFim,
            Icons.trending_down_rounded,
            ThemeColors.of(context).orangeDark,
            (v) => ref.read(salaryCycleProvider.notifier).setAjusteFim(v),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildDiasCard(state),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          _buildVisualizacaoCard(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricoTab(SalaryCycleState state) {
    final history = state.history;
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            itemCount: history.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                bottom: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              child: _buildHistoricoCard(history[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(SalaryCycleState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).greenMain, ThemeColors.of(context).greenDark],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).greenMain.withValues(alpha: 0.4),
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
              Icons.calendar_today_rounded,
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
                  'Monitoramento Ativo',
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
                  state.isStrategyActive ? 'Ajustes autom�ticos ativos' : 'Ajustes desativados',
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
              onChanged: (value) => ref.read(salaryCycleProvider.notifier).setStrategyActive(value),
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

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).infoPastel,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : 16,
        ),
        border: Border.all(color: ThemeColors.of(context).infoLight, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: ThemeColors.of(context).infoDark,
            size: AppSizes.iconLarge.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              'Sistema ajusta pre�os automaticamente baseado no ciclo de pagamento mensal dos consumidores',
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
          ),
        ],
      ),
    );
  }

  Widget _buildQuinzenaCard(SalaryCycleState state) {
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
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.calendar_view_week_rounded,
                  color: ThemeColors.of(context).blueMain,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
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
                      'Monitorar Quinzena',
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
                    Text(
                      'Aplicar ajuste tamb�m no dia 15',
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
                scale: 1.05,
                child: Switch(
                  value: state.monitorarQuinzena,
                  onChanged: (value) => ref.read(salaryCycleProvider.notifier).setMonitorarQuinzena(value),
                  activeColor: ThemeColors.of(context).blueMain,
                ),
              ),
            ],
          ),
          if (state.monitorarQuinzena) ...[
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
                  isMobile ? 10 : 12,
                ),
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
                      'Ajuste aplicado tamb�m no dia ${state.diaQuinzena} de cada m�s',
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
        ],
      ),
    );
  }

  Widget _buildAjusteCard(
    String titulo,
    String periodo,
    double valor,
    IconData icon,
    Color cor,
    Function(double) onChanged,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        border: Border.all(color: cor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: cor.withValues(alpha: 0.15),
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
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cor, cor.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cor.withValues(alpha: 0.3),
                      blurRadius: isMobile ? 10 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconLarge.get(isMobile, isTablet),
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
                      titulo,
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
                    Text(
                      periodo,
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
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cor, cor.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                child: Text(
                  '${valor > 0 ? "+" : ""}${valor.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
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
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Slider(
            value: valor,
            min: -20,
            max: 30,
            divisions: 50,
            label: '${valor > 0 ? "+" : ""}${valor.toStringAsFixed(0)}%',
            onChanged: onChanged,
            activeColor: cor,
          ),
        ],
      ),
    );
  }

  Widget _buildDiasCard(SalaryCycleState state) {
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
                  color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: ThemeColors.of(context).blueCyan,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Dura��o dos Ajustes',
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                  vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 7 : 8,
                  ),
                ),
                child: Text(
                  '${state.diasPagamento} dias',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'In�cio do M�s: Dias 1-${state.diasPagamento}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              Text(
                'Fim do M�s: Dias ${30 - state.diasPagamento}-30',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Slider(
            value: state.diasPagamento.toDouble(),
            min: 3,
            max: 10,
            divisions: 7,
            label: '${state.diasPagamento} dias',
            onChanged: (v) => ref.read(salaryCycleProvider.notifier).setDiasPagamento(v.toInt()),
            activeColor: ThemeColors.of(context).blueCyan,
          ),
        ],
      ),
    );
  }

Widget _buildVisualizacaoCard(SalaryCycleState state) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).blueIndigo.withValues(alpha: 0.1), ThemeColors.of(context).primaryPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        border: Border.all(color: ThemeColors.of(context).blueIndigo.withValues(alpha: 0.3), width: 2),
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
                color: ThemeColors.of(context).blueIndigo.withValues(alpha: 0.8),
                size: AppSizes.iconLarge.get(isMobile, isTablet),
              ),
              SizedBox(
                width: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              Text(
                'Visualiza��o do Ciclo',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).blueIndigo.withValues(alpha: 0.8),
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
              mobile: 85,
              tablet: 92,
              desktop: 100,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(30, (index) {
                final dia = index + 1;
                final isInicio = dia <= state.diasPagamento;
                final isFim = dia >= (30 - state.diasPagamento);
                final isQuinzena = state.monitorarQuinzena && dia == state.diaQuinzena;
                
                Color cor;
                double altura;
                
                if (isInicio || isQuinzena) {
                  cor = ThemeColors.of(context).greenMain;
                  altura = 80.0;
                } else if (isFim) {
                  cor = ThemeColors.of(context).orangeMain;
                  altura = 40.0;
                } else {
                  cor = ThemeColors.of(context).textSecondaryOverlay40;
                  altura = 60.0;
                }
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    height: altura,
                    decoration: BoxDecoration(
                      color: cor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegenda(ThemeColors.of(context).greenMain, 'In�cio (+${state.ajusteInicio.toStringAsFixed(0)}%)'),
              _buildLegenda(ThemeColors.of(context).textSecondary, 'Normal'),
              _buildLegenda(ThemeColors.of(context).orangeMain, 'Fim (${state.ajusteFim.toStringAsFixed(0)}%)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegenda(Color cor, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.paddingBase.get(isMobile, isTablet),
          height: AppSizes.paddingBase.get(isMobile, isTablet),
          decoration: BoxDecoration(
            color: cor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
        ),
        Text(
          texto,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 11,
              mobileFontSize: 10,
            ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoricoCard(SalaryAdjustmentHistoryModel item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
          AppSizes.cardPadding.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
          ),
          border: Border.all(color: item.color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: item.color.withValues(alpha: 0.15),
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
                    AppSizes.paddingBase.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [item.color, item.color.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 10 : 12,
                    ),
                  ),
                  child: Icon(
                    item.isPositiveAdjustment ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    color: ThemeColors.of(context).surface,
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
                        item.periodo,
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
                      Text(
                        item.dateRange,
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
                    horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                    vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                  ),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      isMobile ? 7 : 8,
                    ),
                  ),
                  child: Text(
                    item.adjustmentFormatted,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 15,
                        mobileFontSize: 14,
                      ),
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: item.color,
                    ),
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
                  child: _buildInfoChip(Icons.inventory_2_rounded, '${item.productsCount} produtos'),
                ),
                SizedBox(
                  width: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                ),
                Expanded(
                  child: _buildInfoChip(Icons.attach_money_rounded, item.revenue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String texto) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
        vertical: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(
          isMobile ? 7 : 8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSizes.iconTiny.get(isMobile, isTablet),
            color: ThemeColors.of(context).textSecondary,
          ),
          SizedBox(
            width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
          ),
          Text(
            texto,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
              ),
            overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
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
          Icons.attach_money_rounded,
          color: ThemeColors.of(context).greenMain,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Ciclo de Sal�rio',
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
                'Ajusta pre�os automaticamente baseado no ciclo de pagamento:',
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
                '? Aumenta pre�os no in�cio do m�s (p�s-pagamento)',
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
                '? Reduz pre�os no fim do m�s (pr�-pagamento)',
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
                '? Monitora tamb�m o dia 15 (quinzena)',
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
                '? Maximiza vendas em per�odos de alto poder de compra',
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

  Future<void> _salvarConfiguracoes() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    // Salva as configura��es via provider
    final success = await ref.read(salaryCycleProvider.notifier).saveConfigurations();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.error_rounded,
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
                    success ? 'Configura��es Salvas!' : 'Erro ao Salvar',
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
                    success ? 'Ciclo de sal�rio configurado' : 'Tente novamente',
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
        backgroundColor: success ? ThemeColors.of(context).greenMain : ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );
  }
}







