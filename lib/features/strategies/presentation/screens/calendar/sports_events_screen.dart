import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/strategies/data/providers/calendar_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

class EventosEsportivosConfigScreen extends ConsumerStatefulWidget {
  const EventosEsportivosConfigScreen({super.key});

  @override
  ConsumerState<EventosEsportivosConfigScreen> createState() => _EventosEsportivosConfigScreenState();
}

class _EventosEsportivosConfigScreenState extends ConsumerState<EventosEsportivosConfigScreen>
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
    final sportsState = ref.watch(sportsTeamsProvider);

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
                  _buildTimesTab(sportsState),
                  _buildJogosTab(sportsState),
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
              if (_fabExpanded) ...[
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: _adicionarTime,
                  backgroundColor: ThemeColors.of(context).info,
                  child: Icon(
                    Icons.add_rounded,
                    size: AppSizes.iconLarge.get(isMobile, isTablet),
                  ),
                  tooltip: 'Adicionar Time',
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
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  backgroundColor: ThemeColors.of(context).info,
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
              gradient: LinearGradient(colors: [ThemeColors.of(context).info, ThemeColors.of(context).blueDark]),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              Icons.sports_soccer_rounded,
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
                  'Eventos Esportivos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Detec??o de Jogos',
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
          gradient: LinearGradient(colors: [ThemeColors.of(context).info, ThemeColors.of(context).blueDark]),
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
            icon: Icon(Icons.sports_soccer_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Times',
          ),
          Tab(
            icon: Icon(Icons.event_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            text: 'Pr?ximos Jogos',
          ),
        ],
      ),
    );
  }

  Widget _buildTimesTab(SportsTeamsState sportsState) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            child: Column(
              children: [
                _buildHeader(sportsState),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildConfigGeralCard(sportsState),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                ...sportsState.teams.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
                    child: _buildTimeCard(entry.value, entry.key),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJogosTab(SportsTeamsState sportsState) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildModernAppBar(),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sportsState.games.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
                child: _buildJogoCard(sportsState.games[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(SportsTeamsState sportsState) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final timesAtivos = sportsState.activeTeamsCount;

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingLgAlt2.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ThemeColors.of(context).info, ThemeColors.of(context).blueDark]),
        borderRadius: BorderRadius.circular(isMobile ? 20 : (isTablet ? 22 : 24)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).info.withValues(alpha: 0.4),
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
              Icons.stadium_rounded,
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
                  'Detec??o Autom?tica',
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
                  '$timesAtivos times monitorados',
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
              value: sportsState.isStrategyActive,
              onChanged: (value) {
                ref.read(sportsTeamsProvider.notifier).setStrategyActive(value);
              },
              activeColor: ThemeColors.of(context).surface,
              activeTrackColor: ThemeColors.of(context).surfaceOverlay50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigGeralCard(SportsTeamsState sportsState) {
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
                  color: ThemeColors.of(context).blueCyanLight,
                  borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  color: ThemeColors.of(context).blueCyan,
                  size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                ),
              ),
              SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Configura??es Gerais',
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
          SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
          _buildOpcaoSwitch(
            'Notificar Jogos Detectados',
            'Receber alertas quando jogos forem identificados',
            Icons.notifications_active_rounded,
            sportsState.notifyGames,
            (v) => ref.read(sportsTeamsProvider.notifier).setNotifyGames(v),
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                color: ThemeColors.of(context).info,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: Text(
                  'Horas de Anteced?ncia',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
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
                  color: ThemeColors.of(context).infoLight,
                  borderRadius: BorderRadius.circular(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                ),
                child: Text(
                  '${sportsState.hoursInAdvance} horas',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).info,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: sportsState.hoursInAdvance.toDouble(),
            min: 1,
            max: 12,
            divisions: 11,
            label: '${sportsState.hoursInAdvance} horas antes',
            onChanged: (v) => ref.read(sportsTeamsProvider.notifier).setHoursInAdvance(v.toInt()),
            activeColor: ThemeColors.of(context).info,
          ),
        ],
      ),
    );
  }

  Widget _buildOpcaoSwitch(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: value ? ThemeColors.of(context).blueCyanLight : ThemeColors.of(context).textSecondaryOverlay10,
        borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
        border: Border.all(color: value ? ThemeColors.of(context).blueCyanLight : ThemeColors.of(context).textSecondaryOverlay30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: value ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).textSecondaryOverlay70,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                Text(
                  subtitle,
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
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ThemeColors.of(context).blueCyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(SportsTeamModel team, int index) {
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
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
          border: Border.all(color: team.colorLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: team.colorLight,
              blurRadius: isMobile ? 15 : 20,
              offset: Offset(0, isMobile ? 4 : 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSizes.iconHero2Xl.get(isMobile, isTablet),
                    height: AppSizes.iconHero2Xl.get(isMobile, isTablet),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [team.color, team.color.withValues(alpha: 0.7)]),
                      borderRadius: BorderRadius.circular(AppSizes.paddingXl.get(isMobile, isTablet)),
                      boxShadow: [
                        BoxShadow(
                          color: team.colorLight,
                          blurRadius: isMobile ? 10 : 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          team.icon,
                          color: ThemeColors.of(context).surface,
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        Positioned(
                          bottom: 6,
                          child: Text(team.badge, style: TextStyle(fontSize: 12)),
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
                          team.name,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                            vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: team.colorLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Ajuste: ${team.adjustmentFormatted}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: team.color,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_rounded,
                              size: AppSizes.iconMicro.get(isMobile, isTablet),
                              color: ThemeColors.of(context).textSecondary,
                            ),
                            SizedBox(width: AppSizes.paddingXxs.get(isMobile, isTablet)),
                            Expanded(
                              child: Text(
                                team.nextGame,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 11, mobileFontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                  color: ThemeColors.of(context).textSecondary,
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
                      value: team.isActive,
                      onChanged: (value) {
                        ref.read(sportsTeamsProvider.notifier).toggleTeamActive(team.id, value);
                      },
                      activeColor: team.color,
                    ),
                  ),
                ],
              ),
            ),
            if (team.isActive) ...[
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildConfigRow(
                      'Ajuste de Pre?o',
                      team.adjustmentFormatted,
                      Icons.trending_up_rounded,
                      team.color,
                      onTap: () => _editarAjuste(team),
                    ),
                    SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                    _buildConfigRow(
                      'Produtos Afetados',
                      team.products.join(', '),
                      Icons.shopping_cart_rounded,
                      team.color,
                      onTap: () => _editarProdutos(team),
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

  Widget _buildConfigRow(String label, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: colorLight,
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
          border: Border.all(color: colorLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSizes.iconMediumAlt.get(isMobile, isTablet)),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11),
                      overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 14),
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

  Widget _buildJogoCard(SportsGameModel game, int index) {
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
        padding: EdgeInsets.all(AppSizes.cardPadding.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [ThemeColors.of(context).infoPastel, ThemeColors.of(context).cyanMainLight]),
          borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
          border: Border.all(color: ThemeColors.of(context).infoLight, width: 2),
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
                    gradient: LinearGradient(colors: [ThemeColors.of(context).info, ThemeColors.of(context).blueDark]),
                    borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                  ),
                  child: Icon(
                    Icons.sports_soccer_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                  ),
                ),
                SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.matchTitle,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15),
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                      Text(
                        game.championship,
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
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: _buildJogoInfo(Icons.calendar_today_rounded, 'Data', game.date)),
                Expanded(child: _buildJogoInfo(Icons.access_time_rounded, 'Hor?rio', game.time)),
              ],
            ),
            SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
            _buildJogoInfo(Icons.location_on_rounded, 'Local', game.location),
          ],
        ),
      ),
    );
  }

  Widget _buildJogoInfo(IconData icon, String label, String value) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingSmAlt3.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconTiny.get(isMobile, isTablet),
            color: ThemeColors.of(context).infoDark,
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

  void _editarAjuste(SportsTeamModel team) {
    final isMobile = ResponsiveHelper.isMobile(context);
    double tempAdjustment = team.adjustment;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
          title: Text(
            'Ajuste de Pre?o',
            style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
            overflow: TextOverflow.ellipsis,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ajuste aplicado em dias de jogos do ${team.name}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.cardPadding.get(isMobile, isTablet)),
              Slider(
                value: tempAdjustment,
                min: 0,
                max: 50,
                divisions: 50,
                label: '+${tempAdjustment.toStringAsFixed(0)}%',
                onChanged: (value) => setDialogState(() => tempAdjustment = value),
                activeColor: team.color,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(sportsTeamsProvider.notifier).updateTeamAdjustment(team.id, tempAdjustment);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: team.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
              ),
              child: Text('Salvar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
            ),
          ],
        ),
      ),
    );
  }

  void _editarProdutos(SportsTeamModel team) {
    final isMobile = ResponsiveHelper.isMobile(context);
    // Usa categorias do backend
    final categoriesState = ref.read(categoriesProvider);
    final produtos = categoriesState.categories.map((c) => c.nome).toList();
    // Se n?o houver categorias, usa lista padr?o para UX
    final listaProdutos = produtos.isNotEmpty 
        ? produtos 
        : ['Bebidas', 'Snacks', 'Carv?o', 'Carnes', 'Petiscos', 'Cervejas'];
    final selecionados = List<String>.from(team.products);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
          title: Text(
            'Produtos Afetados',
            style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17)),
            overflow: TextOverflow.ellipsis,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: listaProdutos.map((prod) {
              final isSelected = selecionados.contains(prod);
              return CheckboxListTile(
                title: Text(prod, style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
                value: isSelected,
                activeColor: team.color,
                onChanged: (value) {
                  setDialogState(() {
                    if (value == true) {
                      selecionados.add(prod);
                    } else {
                      selecionados.remove(prod);
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(sportsTeamsProvider.notifier).updateTeamProducts(team.id, selecionados);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: team.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
              ),
              child: Text('Salvar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarTime() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
        icon: Icon(Icons.add_rounded, color: ThemeColors.of(context).info, size: AppSizes.iconHeroMd.get(isMobile, isTablet)),
        title: Text('Adicionar Time', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17))),
        content: Text(
          'Em breve voc? poder? adicionar novos times para monitoramento personalizado.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13)),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet))),
        icon: Icon(Icons.sports_soccer_rounded, color: ThemeColors.of(context).info, size: AppSizes.iconHeroMd.get(isMobile, isTablet)),
        title: Text('Eventos Esportivos', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 17))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detecta automaticamente jogos dos times monitorados:',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
              Text('? Integra??o com calend?rios esportivos', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12), height: 1.5)),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text('? Aumenta pre?os automaticamente em dias de jogos', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12), height: 1.5)),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text('? Ideal para bebidas, snacks e produtos de churrasco', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12), height: 1.5)),
              SizedBox(height: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
              Text('? Ajuste aplicado horas antes do jogo', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12), height: 1.5)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendi', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
          ),
        ],
      ),
    );
  }

  void _salvarConfiguracoes() async {
    final isMobile = ResponsiveHelper.isMobile(context);

    final success = await ref.read(sportsTeamsProvider.notifier).saveConfigurations();

    if (success && mounted) {
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
                    Text('Configura??es Salvas!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13))),
                    Text('Eventos esportivos configurados', style: TextStyle(fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11))),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: ThemeColors.of(context).info,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet))),
        ),
      );
    }
  }
}










