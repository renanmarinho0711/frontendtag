import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/providers/calendar_provider.dart';

/// Tela de configura??o de Datas Comemorativas
/// 
/// Esta tela permite ao usu?rio configurar eventos sazonais para ajustes
/// autom?ticos de pre?o durante feriados e datas comemorativas.
/// 
/// Migrada para usar:
/// - ConsumerStatefulWidget + Riverpod
/// - HolidayEventModel (domain model)
/// - HolidayEventsProvider (state management)
class DatasComemorativasConfigScreen extends ConsumerStatefulWidget {
  const DatasComemorativasConfigScreen({super.key});

  @override
  ConsumerState<DatasComemorativasConfigScreen> createState() => _DatasComemorativasConfigScreenState();
}

class _DatasComemorativasConfigScreenState extends ConsumerState<DatasComemorativasConfigScreen>
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
    final holidayState = ref.watch(holidayEventsProvider);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: holidayState.isLoading
            ? _buildLoadingState()
            : holidayState.error != null
                ? _buildErrorState(holidayState.error!)
                : Column(
                    children: [
                      _buildTabBar(),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildEventosTab(holidayState),
                            _buildCalendarioTab(holidayState),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: ThemeColors.of(context).error,
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: AppSizes.iconHeroLg.get(isMobile, isTablet),
            color: ThemeColors.of(context).errorMain,
          ),
          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
          Text(
            'Erro ao carregar eventos',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 15,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
          Text(
            error,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 13,
                mobileFontSize: 12,
              ),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Stack(
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
            backgroundColor: ThemeColors.of(context).error,
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
    );
  }

  Widget _buildModernAppBar() {
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
                colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.event_rounded,
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
                  'Datas Comemorativas',
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
                  'Estrat?gia de Calend?rio',
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
            colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark],
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
              Icons.celebration_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Eventos',
          ),
          Tab(
            icon: Icon(
              Icons.calendar_month_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Calend?rio',
          ),
        ],
      ),
    );
  }

  Widget _buildEventosTab(HolidayEventsState state) {
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
                _buildConfigGeralCard(state),
                SizedBox(
                  height: AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                ...state.events.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    child: _buildEventoCard(entry.value, entry.key),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarioTab(HolidayEventsState state) {
    final eventosOrdenados = state.eventsSortedByNextDate;

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
            itemCount: eventosOrdenados.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                bottom: AppSizes.paddingBase.get(isMobile, isTablet),
              ),
              child: _buildCalendarioCard(eventosOrdenados[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(HolidayEventsState state) {
    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingLgAlt2.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).error, ThemeColors.of(context).errorDark],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 22 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).error.withValues(alpha: 0.4),
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
              Icons.auto_awesome_rounded,
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
                  'Ajustes Sazonais',
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
                  '${state.activeEventsCount} de ${state.events.length} eventos ativos',
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
                ref.read(holidayEventsProvider.notifier).setStrategyActive(value);
              },
              activeColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigGeralCard(HolidayEventsState state) {
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
              Icons.restore_rounded,
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
                  'Reverter Ap?s Evento',
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
                  'Voltar pre?os ao normal ap?s a data',
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
              value: state.revertAfterEvent,
              onChanged: (value) {
                ref.read(holidayEventsProvider.notifier).setRevertAfterEvent(value);
              },
              activeColor: ThemeColors.of(context).info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventoCard(HolidayEventModel evento, int index) {
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
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
          ),
          border: Border.all(
            color: evento.colorLight,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: evento.colorLight,
              blurRadius: isMobile ? 15 : 20,
              offset: Offset(0, isMobile ? 4 : 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildEventoIcon(evento),
                  SizedBox(
                    width: AppSizes.paddingMd.get(isMobile, isTablet),
                  ),
                  Expanded(
                    child: _buildEventoInfo(evento),
                  ),
                  Transform.scale(
                    scale: 1.05,
                    child: Switch(
                      value: evento.isActive,
                      onChanged: (value) {
                        ref.read(holidayEventsProvider.notifier).toggleEventActive(evento.id, value);
                      },
                      activeColor: evento.color,
                    ),
                  ),
                ],
              ),
            ),
            if (evento.isActive) ...[
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.all(
                  AppSizes.cardPadding.get(isMobile, isTablet),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildConfigRow(
                      'Ajuste de Pre?o',
                      evento.adjustmentFormatted,
                      Icons.trending_up_rounded,
                      evento.color,
                      onTap: () => _editarAjuste(evento),
                    ),
                    SizedBox(
                      height: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    _buildConfigRow(
                      'Dias de Anteced?ncia',
                      '${evento.daysInAdvance} dias',
                      Icons.access_time_rounded,
                      evento.color,
                      onTap: () => _editarDiasAntecedencia(evento),
                    ),
                    SizedBox(
                      height: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    _buildConfigRow(
                      'Categorias Afetadas',
                      evento.categories.take(2).join(', ') +
                          (evento.categories.length > 2 ? '...' : ''),
                      Icons.category_rounded,
                      evento.color,
                      onTap: () => _editarCategorias(evento),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventoIcon(HolidayEventModel evento) {
    return Container(
      width: AppSizes.iconHero2Xl.get(isMobile, isTablet),
      height: AppSizes.iconHero2Xl.get(isMobile, isTablet),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            evento.color,
            evento.color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : 18,
        ),
        boxShadow: [
          BoxShadow(
            color: evento.colorLight,
            blurRadius: isMobile ? 10 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            evento.icon,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          Positioned(
            bottom: 8,
            child: Text(
              evento.emoji,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 16,
                  mobileFontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventoInfo(HolidayEventModel evento) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          evento.name,
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
              width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
            ),
            Text(
              evento.dateLabel,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppSizes.paddingXxs.get(isMobile, isTablet),
        ),
        Text(
          evento.description,
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
    );
  }

  Widget _buildConfigRow(
    String label,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        isMobile ? 10 : 12,
      ),
      child: Container(
        padding: EdgeInsets.all(
          AppSizes.paddingSm.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: colorLight,
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
          border: Border.all(color: colorLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
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
                    label,
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
                  SizedBox(
                    height: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Text(
                    value,
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
                ],
              ),
            ),
            Icon(
              Icons.edit_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarioCard(HolidayEventModel evento, int index) {
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
            colors: evento.isActive
                ? [evento.colorLight, evento.colorLight]
                : [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textSecondary],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 14 : (isTablet ? 15 : 16),
          ),
          border: Border.all(
            color: evento.isActive
                ? evento.colorLight
                : ThemeColors.of(context).textSecondary,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingSm.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                gradient: evento.isActive
                    ? LinearGradient(
                        colors: [evento.color, evento.color.withValues(alpha: 0.7)],
                      )
                    : null,
                color: evento.isActive ? null : ThemeColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(
                  isMobile ? 12 : 14,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    evento.emoji,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 24,
                        mobileFontSize: 22,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.paddingXxs.get(isMobile, isTablet),
                  ),
                  Icon(
                    evento.icon,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
                  ),
                ],
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
                    evento.name,
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
                        Icons.event_rounded,
                        size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                        color: ThemeColors.of(context).textSecondary,
                      ),
                      SizedBox(
                        width: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      Text(
                        evento.nextDate,
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
                  if (evento.isActive) ...[
                    SizedBox(
                      height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: evento.colorLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        evento.adjustmentFormatted,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 11,
                            mobileFontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: evento.color,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                color: evento.isActive
                    ? ThemeColors.of(context).successLight
                    : ThemeColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(
                  isMobile ? 9 : 10,
                ),
              ),
              child: Icon(
                evento.isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: evento.isActive
                    ? ThemeColors.of(context).successDark
                    : ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editarAjuste(HolidayEventModel evento) {
    double currentAdjustment = evento.adjustment;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
          ),
          title: Text(
            'Ajuste de Pre?o',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 18,
                mobileFontSize: 17,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Defina o percentual de ajuste para ${evento.name}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Slider(
                value: currentAdjustment,
                min: -50,
                max: 50,
                divisions: 100,
                label: '${currentAdjustment > 0 ? "+" : ""}${currentAdjustment.toStringAsFixed(0)}%',
                onChanged: (value) {
                  setDialogState(() {
                    currentAdjustment = value;
                  });
                },
                activeColor: evento.color,
              ),
            ],
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
                ref.read(holidayEventsProvider.notifier).updateEventAdjustment(evento.id, currentAdjustment);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: evento.color,
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

  void _editarDiasAntecedencia(HolidayEventModel evento) {
    int currentDays = evento.daysInAdvance;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
          ),
          title: Text(
            'Dias de Anteced?ncia',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 18,
                mobileFontSize: 17,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Com quantos dias de anteced?ncia aplicar ajuste?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              Slider(
                value: currentDays.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: '$currentDays dias',
                onChanged: (value) {
                  setDialogState(() {
                    currentDays = value.toInt();
                  });
                },
                activeColor: evento.color,
              ),
            ],
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
                ref.read(holidayEventsProvider.notifier).updateEventDaysInAdvance(evento.id, currentDays);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: evento.color,
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

  void _editarCategorias(HolidayEventModel evento) {
    // Usa categorias do backend
    final categoriesState = ref.read(categoriesProvider);
    final categoriasBackend = categoriesState.categories.map((c) => c.nome).toList();
    // Se n?o houver categorias, usa lista padr?o para UX
    final categorias = categoriasBackend.isNotEmpty 
        ? [...categoriasBackend, 'Todos']
        : ['Bebidas', 'Mercearia', 'Perec?veis', 'Limpeza', 'Chocolates', 'Panetones', 'Presentes', 'Todos'];
    final selecionadas = List<String>.from(evento.categories);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
          ),
          title: Text(
            'Categorias Afetadas',
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
              children: categorias.map((cat) {
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
                  activeColor: evento.color,
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
                ref.read(holidayEventsProvider.notifier).updateEventCategories(evento.id, selecionadas);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: evento.color,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
        ),
        icon: Icon(
          Icons.celebration_rounded,
          color: ThemeColors.of(context).error,
          size: AppSizes.iconHeroMd.get(isMobile, isTablet),
        ),
        title: Text(
          'Datas Comemorativas',
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
                'Configure eventos sazonais para ajustes autom?ticos:',
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
              _buildInfoItem('? Detecta automaticamente datas comemorativas'),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              _buildInfoItem('? Aplica ajustes com anteced?ncia configur?vel'),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              _buildInfoItem('? Reverte pre?os automaticamente ap?s o evento'),
              SizedBox(
                height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
              ),
              _buildInfoItem('? Maximiza vendas em per?odos de alta demanda'),
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

  Widget _buildInfoItem(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ResponsiveHelper.getResponsiveFontSize(
          context,
          baseFontSize: 13,
          mobileFontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
        height: 1.5,
      ),
    );
  }

  void _salvarConfiguracoes() async {
    final success = await ref.read(holidayEventsProvider.notifier).saveConfigurations();

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
                    success ? 'Configura??es Salvas!' : 'Erro ao Salvar',
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
                    success
                        ? 'Datas comemorativas configuradas'
                        : 'Tente novamente mais tarde',
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
        backgroundColor: success ? ThemeColors.of(context).error : ThemeColors.of(context).errorMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        ),
      ),
    );
  }
}








