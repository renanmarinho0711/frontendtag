import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/strategies/data/providers/calendar_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

class FeriadosProlongadosConfigScreen extends ConsumerStatefulWidget {
  const FeriadosProlongadosConfigScreen({super.key});

  @override
  ConsumerState<FeriadosProlongadosConfigScreen> createState() => _FeriadosProlongadosConfigScreenState();
}

class _FeriadosProlongadosConfigScreenState extends ConsumerState<FeriadosProlongadosConfigScreen>
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
    final holidaysState = ref.watch(longHolidaysProvider);
    
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
                    _buildConfigTab(holidaysState),
                    _buildFeriadosTab(holidaysState),
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
              backgroundColor: ThemeColors.of(context).blueCyan,
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
                colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.beach_access_rounded,
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
                  'Feriados Prolongados',
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
                  'Detec??o de Pontes',
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
            colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
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
            text: 'Configura??o',
          ),
          Tab(
            icon: Icon(
              Icons.event_available_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Feriados',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab(LongHolidaysState holidaysState) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            child: Column(
              children: [
                _buildHeader(holidaysState),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                _buildDeteccaoCard(holidaysState),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                _buildAjusteCard(
                  'Produtos de Lazer',
                  '???',
                  holidaysState.ajusteLazer,
                  Icons.beach_access_rounded,
                  ThemeColors.of(context).blueCyan,
                  (v) => ref.read(longHolidaysProvider.notifier).setAjusteLazer(v),
                ),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                _buildAjusteCard(
                  'Produtos de Viagem',
                  '??',
                  holidaysState.ajusteViagem,
                  Icons.flight_rounded,
                  ThemeColors.of(context).info,
                  (v) => ref.read(longHolidaysProvider.notifier).setAjusteViagem(v),
                ),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                _buildAjusteCard(
                  'Produtos para Casa',
                  '??',
                  holidaysState.ajusteCasa,
                  Icons.home_rounded,
                  ThemeColors.of(context).success,
                  (v) => ref.read(longHolidaysProvider.notifier).setAjusteCasa(v),
                ),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                _buildCategoriasCard(holidaysState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeriadosTab(LongHolidaysState holidaysState) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(
              AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: holidaysState.holidays.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  bottom: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                child: _buildFeriadoCard(holidaysState.holidays[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(LongHolidaysState holidaysState) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
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
              Icons.calendar_month_rounded,
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
                  'Pontes e Feriad?es',
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
                  holidaysState.isStrategyActive ? 'Detec??o ativa' : 'Detec??o inativa',
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
              value: holidaysState.isStrategyActive,
              onChanged: (value) => ref.read(longHolidaysProvider.notifier).setStrategyActive(value),
              activeColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeteccaoCard(LongHolidaysState holidaysState) {
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).infoLight,
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: ThemeColors.of(context).info,
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
                  'Detec??o Autom?tica',
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
                  'Identificar pontes e feriados prolongados',
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
              value: holidaysState.deteccaoAutomatica,
              onChanged: (value) => ref.read(longHolidaysProvider.notifier).setDeteccaoAutomatica(value),
              activeColor: ThemeColors.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAjusteCard(
    String titulo,
    String emoji,
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
        border: Border.all(color: corLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: corLight,
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
                      color: corLight,
                      blurRadius: isMobile ? 10 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      icon,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconMedium.get(isMobile, isTablet),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Text(
                        emoji,
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
                      'Ajuste aplicado automaticamente',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
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
                    colors: [cor, corDark],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 8 : 10,
                  ),
                ),
                child: Text(
                  '+${valor.toStringAsFixed(0)}%',
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
            min: 0,
            max: 50,
            divisions: 50,
            label: '+${valor.toStringAsFixed(0)}%',
            onChanged: onChanged,
            activeColor: cor,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriasCard(LongHolidaysState holidaysState) {
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
                  color: ThemeColors.of(context).warningLight,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.category_rounded,
                  color: ThemeColors.of(context).warning,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              Expanded(
                child: Text(
                  'Categorias Afetadas',
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).warning, ThemeColors.of(context).orangeDark],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 9 : 10,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                  onPressed: () => _editarCategorias(holidaysState),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Wrap(
            spacing: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            runSpacing: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
            children: holidaysState.categoriasSelecionadas.map((cat) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
                  vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 9 : 10,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.of(context).blueCyanLight,
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
                    SizedBox(
                      width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    Text(
                      cat,
                      style: TextStyle(
                        color: ThemeColors.of(context).surface,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                          mobileFontSize: 12,
                        ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildFeriadoCard(LongHolidayModel feriado, int index) {
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
          gradient: LinearGradient(
            colors: [
              feriado.colorLight,
              feriado.colorLight,
            ],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
          ),
          border: Border.all(
            color: feriado.colorLight,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    feriado.color,
                    feriado.color.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  isMobile ? 12 : 14,
                ),
                boxShadow: [
                  BoxShadow(
                    color: feriado.colorLight,
                    blurRadius: isMobile ? 10 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.event_available_rounded,
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
                    feriado.name,
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
                    height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      SizedBox(
                        width: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        feriado.data.isNotEmpty ? feriado.data : feriado.startDate,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 13,
                            mobileFontSize: 12,
                          ),
                        overflow: TextOverflow.ellipsis,
                          color: ThemeColors.of(context).textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                      vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: feriado.colorLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: feriado.colorLight,
                      ),
                    ),
                    child: Text(
                      '${feriado.diasPonte} dias - ${feriado.tipo}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: feriado.color,
                      ),
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

  void _editarCategorias(LongHolidaysState holidaysState) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final selecionadas = List<String>.from(holidaysState.categoriasSelecionadas);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
          ),
          title: Text(
            'Selecionar Categorias',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 18,
                mobileFontSize: 17,
              ),
            overflow: TextOverflow.ellipsis,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: holidaysState.todasCategorias.map((cat) {
                final isSelected = selecionadas.contains(cat);
                return CheckboxListTile(
                  title: Text(
                    cat,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  value: isSelected,
                  activeColor: ThemeColors.of(context).blueCyan,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value == true) {
                        selecionadas.add(cat);
                      } else {
                        selecionadas.remove(cat);
                      }
                    });
                  },
                );
              }).toList(),
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
                  ),
                overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(longHolidaysProvider.notifier).setCategoriasSelecionadas(selecionadas);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).blueCyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
              ),
              child: Text(
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
          borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        ),
        icon: Icon(
          Icons.beach_access_rounded,
          color: ThemeColors.of(context).blueCyan,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Feriados Prolongados',
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
                'Detecta automaticamente feriados prolongados e pontes:',
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
                '? Identifica quando h? ponte ou feriad?o',
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
                '? Aumenta pre?os de produtos de lazer e viagem',
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
                '? Ideal para snacks, bebidas e produtos de praia',
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
                '? Maximiza vendas em per?odos de turismo',
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
    
    // Salva via provider
    final success = await ref.read(longHolidaysProvider.notifier).saveConfigurations();

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
                    success ? 'Configura??es Salvas!' : 'Erro ao salvar',
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
                    success ? 'Feriados prolongados configurados' : 'Tente novamente',
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
        backgroundColor: success ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );
  }
}








