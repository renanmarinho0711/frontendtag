import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/features/strategies/presentation/screens/ai_suggestions_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/calendar/holidays_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/calendar/sports_events_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/calendar/long_holidays_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/calendar/salary_cycle_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/environmental/temperature_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/environmental/peak_hours_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/performance/auto_clearance_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/performance/dynamic_markdown_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/performance/ai_forecast_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/performance/auto_audit_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/visual/heatmap_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/visual/realtime_ranking_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/visual/flash_promos_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/visual/smart_route_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/cross_selling/nearby_products_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/cross_selling/offers_trail_screen.dart';

import 'package:tagbean/features/strategies/presentation/screens/cross_selling/smart_combo_screen.dart';

import 'package:tagbean/features/strategies/data/models/strategy_models.dart';

import 'package:tagbean/features/strategies/presentation/providers/strategies_provider.dart';

import 'package:tagbean/core/utils/responsive_helper.dart';
 // ignore: unused_field

import 'package:tagbean/core/utils/responsive_cache.dart';

import 'package:tagbean/design_system/design_system.dart';




class EstrategiasMenuScreen extends ConsumerStatefulWidget {

  const EstrategiasMenuScreen({super.key});



  @override

  ConsumerState<EstrategiasMenuScreen> createState() => _EstrategiasMenuScreenState();

}



class _EstrategiasMenuScreenState extends ConsumerState<EstrategiasMenuScreen>

    with TickerProviderStateMixin, ResponsiveCache {

  late AnimationController _animationController;

  late TabController _tabController;

  int _currentTab = 0;

  

  // Navigator key para navegao interna

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  

  // Filtros e cache

  String? _filtroCategoria;

  List<StrategyModel>? _cachedEstrategiasFiltradas;

  String _searchQuery = '';

  

  // Getter para estratgias filtradas

  List<StrategyModel> get strategies {

    final strategiesState = ref.watch(strategiesProvider);

    if (_filtroCategoria == null || _filtroCategoria == 'Todas') {

      return strategiesState.filteredStrategies;

    }

    return strategiesState.filteredStrategies

        .where((s) => s.category.label == _filtroCategoria)

        .toList();

  }



  @override

  void initState() {

    super.initState();

    _animationController = AnimationController(

      duration: const Duration(milliseconds: 300),

      vsync: this,

    );

    _tabController = TabController(length: 2, vsync: this);

    _animationController.forward();

    

    // Inicializa o provider

    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(strategiesProvider.notifier).initialize();

    });

  }



  @override

  void dispose() {

    _animationController.dispose();

    _tabController.dispose();

    super.dispose();

  }



  Widget? _getTelaConfiguracao(String nome) {

    switch (nome) {

      case 'Datas Comemorativas':

        return const DatasComemorativasConfigScreen();

      case 'Eventos Esportivos':

        return const EventosEsportivosConfigScreen();

      case 'Feriados Prolongados':

        return const FeriadosProlongadosConfigScreen();

      case 'Ciclo de Salrio':

        return const CicloSalarioConfigScreen();

      case 'precificação por Temperatura':

        return const TemperaturaConfigScreen();

      case 'Horrio de Pico':

        return const HorarioPicoConfigScreen();

      case 'Liquidao Automtica':

        return const LiquidacaoAutomaticaConfigScreen();

      case 'Dynamic Markdown':

        return const DynamicMarkdownConfigScreen();

      case 'Previso com IA':

        return const PrevisaoIAConfigScreen();

      case 'Auditoria Automtica':

        return const AuditoriaAutomaticaConfigScreen();

      case 'Mapa de Calor de Promoes':

        return const MapaCalorConfigScreen();

      case 'Ranking Tempo Real':

        return const RankingTempoRealConfigScreen();

      case 'Promoes Relmpago':

        return const FlashPromosConfigScreen();

      case 'Rota Inteligente':

        return const SmartRouteConfigScreen();

      case 'Produto Vizinho Sugerido':

        return const ProdutoVizinhoConfigScreen();

      case 'Trilha de Ofertas':

        return const TrilhaOfertasConfigScreen();

      case 'Combo Inteligente':

        return const ComboInteligenteConfigScreen();

      default:

        return null;

    }

  }



  @override

  Widget build(BuildContext context) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final strategiesState = ref.watch(strategiesProvider);

    final strategies = strategiesState.filteredStrategies;

    final estrategiasAtivas = strategiesState.activeStrategies.length;

    final estrategiasPausadas = strategiesState.pausedStrategies.length;

    final estrategiasInativas = strategiesState.inactiveStrategies.length;

    

    final impactoTotal = strategiesState.activeStrategies

        .fold(0.0, (sum, e) => sum + double.parse(e.impactValue.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.')));



    // Loading state

    if (strategiesState.isLoading) {

      return const Scaffold(

        body: Center(

          child: CircularProgressIndicator(),

        ),

      );

    }



    return Navigator(

      key: _navigatorKey,

      onGenerateRoute: (settings) {

        return MaterialPageRoute(

          builder: (context) => Scaffold(

            body: Container(

              decoration: BoxDecoration(

                color: ThemeColors.of(context).backgroundLight,

              ),

              child: SafeArea(

                child: SingleChildScrollView(

                  child: Column(

                    children: [

                      // Header sempre visvel

                      _buildHeader(estrategiasAtivas, estrategiasPausadas, estrategiasInativas, impactoTotal),

                      SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet)),

                      _buildInfoCard(),

                      SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet)),

                      _buildSugestoesCard(),

                      SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet)),

                      _buildControlsCard(),

                      SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet)),

                      // Contedo condicional

                      if (strategies.isEmpty)

                        _buildEmptyState()

                      else

                        _buildStrategiesGrid(),

                    ],

                  ),

                ),

              ),

            ),

          ),

        );

      },

    );

  }



  Widget _buildHeader(int ativas, int pausadas, int inativas, double impacto) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return Container(

      margin: EdgeInsets.all(

        AppSizes.paddingMd.get(isMobile, isTablet),

      ),

      padding: EdgeInsets.symmetric(

        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),

        vertical: AppSizes.paddingMd.get(isMobile, isTablet),

      ),

      decoration: BoxDecoration(

        gradient: AppGradients.darkBackground(context),

        borderRadius: BorderRadius.circular(

          ResponsiveHelper.getResponsiveBorderRadius(

            context,

            mobile: 16,

            tablet: 18,

            desktop: 20,

          ),

        ),

        boxShadow: [

          BoxShadow(

            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.4),

            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(

              context,

              mobile: 12,

              tablet: 14,

              desktop: 15,

            ),

            offset: Offset(0, isMobile ? 6 : (isTablet ? 7 : 8)),

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

              color: ThemeColors.of(context).surfaceOverlay20,

              borderRadius: BorderRadius.circular(

                ResponsiveHelper.getResponsiveBorderRadius(

                  context,

                  mobile: 12,

                  tablet: 13,

                  desktop: 14,

                ),

              ),

            ),

            child: Icon(

              Icons.auto_awesome_rounded,

              color: ThemeColors.of(context).surface,

              size: AppSizes.iconMedium.get(isMobile, isTablet),

            ),

          ),

          SizedBox(

            width: AppSizes.spacingSm.get(isMobile, isTablet),

          ),

          Expanded(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  'Estratgias',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(

                      context,

                      baseFontSize: 18,

                      mobileFontSize: 16,

                      tabletFontSize: 17,

                    ),

                  overflow: TextOverflow.ellipsis,

                    fontWeight: FontWeight.bold,

                    color: ThemeColors.of(context).surface,

                    letterSpacing: -0.5,

                  ),

                ),

                SizedBox(

                  height: AppSizes.spacingMicro.get(isMobile, isTablet),

                ),

                Text(

                  'Inteligncia artificial em precificação',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(

                      context,

                      baseFontSize: 12,

                      mobileFontSize: 10,

                      tabletFontSize: 11,

                    ),

                  overflow: TextOverflow.ellipsis,

                    color: ThemeColors.of(context).surfaceOverlay70,

                  ),

                ),

              ],

            ),

          ),

          _buildCompactStat('R\$ ${impacto.toStringAsFixed(0)}', Icons.trending_up_rounded),

          SizedBox(

            width: AppSizes.paddingSmAlt.get(isMobile, isTablet),

          ),

          _buildCompactStat('$ativas', Icons.play_circle_rounded),

          SizedBox(

            width: AppSizes.paddingSmAlt.get(isMobile, isTablet),

          ),

          _buildCompactStat('$pausadas', Icons.pause_circle_rounded),

        ],

      ),

    );

  }



  Widget _buildCompactStat(String value, IconData icon) {

    final isMobile = ResponsiveHelper.isMobile(context);



    return Container(

      padding: EdgeInsets.symmetric(

        horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),

        vertical: AppSizes.paddingXs.get(isMobile, isTablet),

      ),

      decoration: BoxDecoration(

        color: ThemeColors.of(context).surfaceOverlay20,

        borderRadius: BorderRadius.circular(

          isMobile ? 8 : 10,

        ),

      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(

            icon,

            color: ThemeColors.of(context).surface,

            size: AppSizes.iconSmall.get(isMobile, isTablet),

          ),

          SizedBox(

            width: AppSizes.paddingXsAlt5.get(isMobile, isTablet),

          ),

          Text(

            value,

            style: TextStyle(

              fontSize: ResponsiveHelper.getResponsiveFontSize(

                context,

                baseFontSize: 15,

                mobileFontSize: 13,

                tabletFontSize: 14,

              ),

            overflow: TextOverflow.ellipsis,

              fontWeight: FontWeight.bold,

              color: ThemeColors.of(context).surface,

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildSugestoesCard() {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return Container(

      margin: EdgeInsets.symmetric(

        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),

      ),

      child: TweenAnimationBuilder(

        duration: const Duration(milliseconds: 400),

        tween: Tween<double>(begin: 0, end: 1),

        builder: (context, double value, child) {

          return Transform.scale(

            scale: 0.9 + (0.1 * value),

            child: Opacity(opacity: value, child: child),

          );

        },

        child: Container(

          decoration: BoxDecoration(

            gradient: LinearGradient(

              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: [

                ThemeColors.of(context).strategyCardSugestoesBackground,

                ThemeColors.of(context).orangeDeep,

              ],

            ),

            borderRadius: BorderRadius.circular(

              isMobile ? 20 : (isTablet ? 22 : 24),

            ),

            border: Border.all(

              color: ThemeColors.of(context).strategyCardSugestoesBorder,

              width: 2.5,

            ),

            boxShadow: [

              BoxShadow(

                color: ThemeColors.of(context).strategyCardSugestoesBackground.withValues(alpha: 0.4),

                blurRadius: ResponsiveHelper.getResponsiveBlurRadius(

                  context,

                  mobile: 20,

                  tablet: 22.5,

                  desktop: 25,

                ),

                offset: Offset(

                  0,

                  AppSizes.paddingSmAlt.get(isMobile, isTablet),

                ),

              ),

            ],

          ),

          child: Material(

            color: ThemeColors.of(context).surface.withValues(alpha: 0.0),

            child: InkWell(

              onTap: () {

                _navigatorKey.currentState?.push(

                  MaterialPageRoute(builder: (context) => const SugestoesIaScreen()),

                );

              },

              borderRadius: BorderRadius.circular(

                isMobile ? 20 : (isTablet ? 22 : 24),

              ),

              child: Padding(

                padding: EdgeInsets.all(

                  AppSizes.paddingMdAlt.get(isMobile, isTablet),

                ),

                child: Row(

                  children: [

                    Container(

                      padding: EdgeInsets.all(

                        AppSizes.paddingSm.get(isMobile, isTablet),

                      ),

                      decoration: BoxDecoration(

                        gradient: LinearGradient(

                          colors: [ThemeColors.of(context).warning, ThemeColors.of(context).warningDark],

                        ),

                        borderRadius: BorderRadius.circular(

                          isMobile ? 14 : 16,

                        ),

                        boxShadow: [

                          BoxShadow(

                            color: ThemeColors.of(context).warning.withValues(alpha: 0.5),

                            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(

                              context,

                              mobile: 12,

                              tablet: 13.5,

                              desktop: 15,

                            ),

                            offset: Offset(

                              0,

                              ResponsiveHelper.getResponsivePadding(

                                context,

                                mobile: 5,

                                tablet: 5.5,

                                desktop: 6,

                              ),

                            ),

                          ),

                        ],

                      ),

                      child: Icon(

                        Icons.auto_awesome_rounded,

                        color: ThemeColors.of(context).surface,

                        size: ResponsiveHelper.getResponsiveIconSize(

                          context,

                          mobile: 26,

                          tablet: 28,

                          desktop: 30,

                        ),

                      ),

                    ),

                    SizedBox(

                      width: AppSizes.spacingMdAlt.get(isMobile, isTablet),

                    ),

                    Expanded(

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              Flexible(

                                child: Text(

                                  'Sugestões Inteligentes',

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

                                    letterSpacing: -0.6,

                                  ),

                                ),

                              ),

                              SizedBox(

                                width: ResponsiveHelper.getResponsiveSpacing(

                                  context,

                                  mobile: 7,

                                  tablet: 7.5,

                                  desktop: 8,

                                ),

                              ),

                              Container(

                                padding: EdgeInsets.symmetric(

                                  horizontal: ResponsiveHelper.getResponsivePadding(

                                    context,

                                    mobile: 7,

                                    tablet: 7.5,

                                    desktop: 8,

                                  ),

                                  vertical: ResponsiveHelper.getResponsivePadding(

                                    context,

                                    mobile: 3,

                                    tablet: 3.5,

                                    desktop: 3,

                                  ),

                                ),

                                decoration: BoxDecoration(

                                  color: ThemeColors.of(context).error,

                                  borderRadius: BorderRadius.circular(

                                    isMobile ? 8 : 10,

                                  ),

                                ),

                                child: Text(

                                  'NOVO',

                                  style: TextStyle(

                                    fontSize: ResponsiveHelper.getResponsiveFontSize(

                                      context,

                                      baseFontSize: 10,

                                      mobileFontSize: 9,

                                      tabletFontSize: 9.5,

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

                            height: ResponsiveHelper.getResponsiveSpacing(

                              context,

                              mobile: 7,

                              tablet: 7.5,

                              desktop: 8,

                            ),

                          ),

                          Text(

                            'IA analisou e sugere ajustes em 47 produtos',

                            style: TextStyle(

                              fontSize: ResponsiveHelper.getResponsiveFontSize(

                                context,

                                baseFontSize: 13,

                                mobileFontSize: 12,

                                tabletFontSize: 12.5,

                              ),

                              overflow: TextOverflow.ellipsis,

                              color: ThemeColors.of(context).surfaceOverlay95,

                              height: 1.3,

                            ),

                          ),

                          SizedBox(

                            height: AppSizes.spacingSm.get(isMobile, isTablet),

                          ),

                          Row(

                            children: [

                              Container(

                                padding: EdgeInsets.symmetric(

                                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),

                                  vertical: ResponsiveHelper.getResponsivePadding(

                                    context,

                                    mobile: 5,

                                    tablet: 5.5,

                                    desktop: 6,

                                  ),

                                ),

                                decoration: BoxDecoration(

                                  color: ThemeColors.of(context).successLight,

                                  borderRadius: BorderRadius.circular(

                                    isMobile ? 8 : 10,

                                  ),

                                  border: Border.all(color: ThemeColors.of(context).success),

                                ),

                                child: Row(

                                  mainAxisSize: MainAxisSize.min,

                                  // ignore: unused_element
                                  children: [

                                    Icon(

                                      Icons.arrow_upward_rounded,

                                      size: ResponsiveHelper.getResponsiveIconSize(

                                        context,

                                        mobile: 13,

                                        tablet: 13.5,

                                        desktop: 14,

                                      ),

                                      color: ThemeColors.of(context).successIcon,

                                    ),

                                    SizedBox(

                                      width: ResponsiveHelper.getResponsiveSpacing(

                                        context,

                                        mobile: 3,

                                        tablet: 3.5,

                                        desktop: 4,

                                      ),

                                    ),

                                    Text(

                                      '23 aumentos',

                                      style: TextStyle(

                                        fontSize: ResponsiveHelper.getResponsiveFontSize(

                                          context,

                                          baseFontSize: 11,

                                          mobileFontSize: 10,

                                          tabletFontSize: 10.5,

                                        ),

                                        overflow: TextOverflow.ellipsis,

                                        fontWeight: FontWeight.bold,

                                        color: ThemeColors.of(context).successIcon,

                                      ),

                                    ),

                                  ],

                                ),

                              // ignore: unused_element
                              ),

                              SizedBox(

                                width: ResponsiveHelper.getResponsiveSpacing(

                                  context,

                                  mobile: 9,

                                  tablet: 9.5,

                                  desktop: 10,

                                ),

                              ),

                              Container(

                                padding: EdgeInsets.symmetric(

                                  horizontal: AppSizes.paddingBase.get(isMobile, isTablet),

                                  vertical: ResponsiveHelper.getResponsivePadding(

                                    context,

                                    mobile: 5,
 // ignore: unused_element

                                    tablet: 5.5,

                                    desktop: 6,

                                  ),

                                ),

                                decoration: BoxDecoration(

                                  color: ThemeColors.of(context).warningLight,

                                  borderRadius: BorderRadius.circular(

                                    isMobile ? 8 : 10,

                                  ),

                                  border: Border.all(color: ThemeColors.of(context).warning),

                                ),

                                child: Row(

                                  mainAxisSize: MainAxisSize.min,

                                  children: [

                                    Icon(

                                      Icons.arrow_downward_rounded,

                                      size: ResponsiveHelper.getResponsiveIconSize(

                                        context,

                                        mobile: 13,

                                        tablet: 13.5,

                                        desktop: 14,

                                      ),

                                      color: ThemeColors.of(context).warningDark,

                                    ),

                                    SizedBox(

                                      width: ResponsiveHelper.getResponsiveSpacing(

                                        context,

                                        mobile: 3,

                                        tablet: 3.5,

                                        desktop: 4,

                                      ),

                                    ),

                                    Text(

                                      '24 promoes',

                                      style: TextStyle(

                                        fontSize: ResponsiveHelper.getResponsiveFontSize(

                                          context,

                                          baseFontSize: 11,

                                          mobileFontSize: 10,

                                          tabletFontSize: 10.5,

                                        ),

                                        overflow: TextOverflow.ellipsis,

                                        fontWeight: FontWeight.bold,

                                        color: ThemeColors.of(context).warningDark,

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

                    Container(

                      padding: EdgeInsets.all(

                        ResponsiveHelper.getResponsivePadding(

                          context,

                          mobile: 9,

                          tablet: 9.5,

                          desktop: 10,

                        ),

                      ),

                      decoration: BoxDecoration(

                        color: ThemeColors.of(context).surfaceOverlay20,

                        borderRadius: BorderRadius.circular(

                          isMobile ? 10 : 12,

                        ),

                      ),

                      child: Icon(

                        Icons.arrow_forward_ios_rounded,

                        color: ThemeColors.of(context).surface,

                        size: AppSizes.iconMediumSmall.get(isMobile, isTablet),

                      ),

                    ),

                  ],

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }



  Widget _buildInfoCard() {

    final isMobile = ResponsiveHelper.isMobile(context);



    return Container(

      margin: EdgeInsets.symmetric(

        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),

      ),

      padding: EdgeInsets.all(

        AppSizes.paddingMd.get(isMobile, isTablet),

      ),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            ThemeColors.of(context).infoPastel,

            ThemeColors.of(context).primaryPastel,

          ],

        ),

        borderRadius: BorderRadius.circular(

          isMobile ? 12 : 16,

        ),

        border: Border.all(

          color: ThemeColors.of(context).infoLight,

          width: 2,

        ),

        boxShadow: [

          BoxShadow(

            color: ThemeColors.of(context).primary.withValues(alpha: 0.15),

            blurRadius: 12,

            offset: const Offset(0, 4),

          ),

        ],

      ),

      child: Row(

        children: [

          Container(

            padding: EdgeInsets.all(

              AppSizes.paddingSmAlt.get(isMobile, isTablet),

            ),

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],

              ),

              borderRadius: BorderRadius.circular(

                isMobile ? 8 : 10,

              ),

              boxShadow: [

                BoxShadow(

                  color: ThemeColors.of(context).primary.withValues(alpha: 0.4),

                  blurRadius: 8,

                  offset: const Offset(0, 3),

                ),

              ],

            ),

            child: Icon(

              Icons.info_outline_rounded,

              color: ThemeColors.of(context).surface,

              size: AppSizes.iconMedium.get(isMobile, isTablet),

            ),

          ),

          SizedBox(

            width: AppSizes.paddingMd.get(isMobile, isTablet),

          ),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisSize: MainAxisSize.min,

              children: [

                Text(

                  'Sobre este Módulo',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(

                      context,

                      baseFontSize: 15,

                      mobileFontSize: 14,

                      tabletFontSize: 14.5,

                    ),

                    fontWeight: FontWeight.bold,

                    color: ThemeColors.of(context).blueDark,

                    letterSpacing: -0.3,

                  ),

                ),

                SizedBox(

                  height: AppSizes.extraSmallPadding.get(isMobile, isTablet),

                ),

                Text(

                  'Utilize a inteligncia artificial para criar estratgias automticas de precificação baseadas em eventos, calendrio, temperatura, horrios e muito mais.',

                  style: TextStyle(

                    fontSize: ResponsiveHelper.getResponsiveFontSize(

                      context,

                      baseFontSize: 12,

                      mobileFontSize: 11,

                      tabletFontSize: 11,

                    ),

                    color: ThemeColors.of(context).infoText,

                    height: 1.4,

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildControlsCard() {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return Container(

      margin: EdgeInsets.symmetric(

        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),

        vertical: AppSizes.paddingSmLg.get(isMobile, isTablet),

      ),

      padding: EdgeInsets.all(

        AppSizes.cardPadding.get(isMobile, isTablet),

      ),

      decoration: BoxDecoration(

        color: ThemeColors.of(context).surface,

        borderRadius: BorderRadius.circular(

          isMobile ? 16 : (isTablet ? 18 : 20),

        ),

        boxShadow: [

          BoxShadow(

            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.08),

            blurRadius: isMobile ? 15 : 20,

            offset: const Offset(0, 4),

          ),

        ],

      ),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          _buildTabBar(),

          SizedBox(

            height: AppSizes.cardPadding.get(isMobile, isTablet),

          ),

          _buildSearchAndFilter(),

        ],

      ),

    );

  }



  Widget _buildTabBar() {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);



    return Container(

      padding: EdgeInsets.all(

        ResponsiveHelper.getResponsivePadding(

          context,

          mobile: 3,

          tablet: 3,

          desktop: 3,

        ),

      ),

      decoration: BoxDecoration(

        color: ThemeColors.of(context).grey100,

        borderRadius: BorderRadius.circular(

          isMobile ? 10 : 12,

        ),

        border: Border.all(color: ThemeColors.of(context).borderLight, width: 1.5),

        boxShadow: [

          BoxShadow(

            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.08),

            blurRadius: isMobile ? 5 : 6,

            offset: const Offset(0, 2),

          ),

        ],

      ),

      child: TabBar(

        controller: _tabController,

        onTap: (index) => setState(() => _currentTab = index),

        indicator: BoxDecoration(

          gradient: LinearGradient(

            colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],

          ),

          borderRadius: BorderRadius.circular(

            isMobile ? 8 : 9,

          ),

          boxShadow: [

            BoxShadow(

              color: ThemeColors.of(context).success.withValues(alpha: 0.4),

              blurRadius: isMobile ? 6 : 8,

              offset: const Offset(0, 2),

            ),

          ],

        ),

        indicatorSize: TabBarIndicatorSize.tab,

        dividerColor: ThemeColors.of(context).borderLight,

        labelColor: ThemeColors.of(context).surface,

        unselectedLabelColor: ThemeColors.of(context).grey600,

        labelStyle: TextStyle(

          fontSize: ResponsiveHelper.getResponsiveFontSize(

            context,

            baseFontSize: 12,

            mobileFontSize: 11,

          ),

          fontWeight: FontWeight.bold,

        ),

        unselectedLabelStyle: TextStyle(

          fontSize: ResponsiveHelper.getResponsiveFontSize(

            context,

            baseFontSize: 12,

            mobileFontSize: 11,

          ),

          fontWeight: FontWeight.w600,

        ),

        tabs: [

          Tab(

            icon: Icon(

              Icons.grid_view_rounded,

              size: AppSizes.iconTiny.get(isMobile, isTablet),

            ),

            text: 'Grade',

            height: ResponsiveHelper.getResponsivePadding(

              context,

              mobile: 36,

              tablet: 37,

              desktop: 38,

            ),

          ),

          Tab(

            icon: Icon(

              Icons.view_list_rounded,

              size: AppSizes.iconTiny.get(isMobile, isTablet),

            ),

            text: 'Lista',

            height: ResponsiveHelper.getResponsivePadding(

              context,

              mobile: 36,

              tablet: 37,

              desktop: 38,

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildSearchAndFilter() {

    final isMobile = ResponsiveHelper.isMobile(context);



    return Column(

      mainAxisSize: MainAxisSize.min,

      children: [

        Container(

          decoration: BoxDecoration(

            color: ThemeColors.of(context).surface,

            borderRadius: BorderRadius.circular(

              isMobile ? 14 : 16,

            ),

            border: Border.all(color: ThemeColors.of(context).borderLight),

            boxShadow: [

              BoxShadow(

                color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.03),

                blurRadius: isMobile ? 6 : 8,

                offset: const Offset(0, 2),

              ),

            ],

          ),

          child: TextField(

            onChanged: (value) => setState(() {

              _searchQuery = value;

              _cachedEstrategiasFiltradas = null;

            }),

            style: TextStyle(

              fontSize: ResponsiveHelper.getResponsiveFontSize(

                context,

                baseFontSize: 14,

                mobileFontSize: 13,

              ),

            ),

            decoration: InputDecoration(

              hintText: 'Buscar estratgias...',

              hintStyle: TextStyle(

                color: ThemeColors.of(context).textSecondary,

                fontSize: ResponsiveHelper.getResponsiveFontSize(

                  context,

                  baseFontSize: 14,

                  mobileFontSize: 13,

                ),

              ),

              prefixIcon: Icon(

                Icons.search_rounded,

                color: ThemeColors.of(context).textSecondary,

                size: AppSizes.iconMedium.get(isMobile, isTablet),

              ),

              suffixIcon: _searchQuery.isNotEmpty

                  ? IconButton(

                      icon: Icon(

                        Icons.clear_rounded,

                        color: ThemeColors.of(context).textSecondary,

                        size: AppSizes.iconMedium.get(isMobile, isTablet),

                      ),

                      onPressed: () => setState(() {

                        _searchQuery = '';

                        _cachedEstrategiasFiltradas = null;

                      }),

                    )

                  : null,

              border: InputBorder.none,

              contentPadding: EdgeInsets.symmetric(

                horizontal: AppSizes.cardPadding.get(isMobile, isTablet),

                vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),

              ),

            ),

          ),

        ),

        SizedBox(

          height: AppSizes.paddingBase.get(isMobile, isTablet),

        ),

        SingleChildScrollView(

          scrollDirection: Axis.horizontal,

          child: Row(

            mainAxisSize: MainAxisSize.min,

            children: [

              _buildFilterChip('Todas', 'todas', Icons.apps_rounded),

              SizedBox(

                width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),

              ),

              _buildFilterChip('Ativas', 'ativas', Icons.play_circle_rounded),

              SizedBox(

                width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),

              ),

              _buildFilterChip('Pausadas', 'pausadas', Icons.pause_circle_rounded),

              SizedBox(

                width: AppSizes.paddingXsAlt2.get(isMobile, isTablet),

              ),

              _buildFilterChip('Inativas', 'inativas', Icons.cancel_rounded),

            ],

          ),

        ),

      ],

    );

  }



  Widget _buildFilterChip(String label, String value, IconData icon) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isSelected = _filtroCategoria == value;

    

    return InkWell(

      onTap: () => setState(() {

        _filtroCategoria = value;

        _cachedEstrategiasFiltradas = null;

      }),

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        padding: EdgeInsets.symmetric(

          horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),

          vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),

        ),

        decoration: BoxDecoration(

          gradient: isSelected

              ? LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark])

              : null,

          color: isSelected ? null : ThemeColors.of(context).surface,

          borderRadius: BorderRadius.circular(

            isMobile ? 10 : 12,

          ),

          border: Border.all(

            color: isSelected ? ThemeColors.of(context).success : ThemeColors.of(context).borderLight,

          ),

          boxShadow: isSelected

              ? [

                  BoxShadow(

                    color: ThemeColors.of(context).success.withValues(alpha: 0.3),

                    blurRadius: isMobile ? 6 : 8,

                    offset: const Offset(0, 4),

                  ),

                ]

              : null,

        ),

        child: Row(

          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(

              icon,

              size: AppSizes.iconTiny.get(isMobile, isTablet),

              color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,

            ),

            SizedBox(

              width: AppSizes.paddingXsAlt.get(isMobile, isTablet),

            ),

            Text(

              label,

              style: TextStyle(

                fontSize: ResponsiveHelper.getResponsiveFontSize(

                  context,

                  baseFontSize: 13,

                  mobileFontSize: 12,

                ),

              overflow: TextOverflow.ellipsis,

                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,

                color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,

              ),

            ),

          ],

        ),

      ),

    );

  }



  /// Grid de estratgias para exibio no scroll principal

  Widget _buildStrategiesGrid() {

    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(

      context,

      mobile: 2,

      tablet: 3,

      desktop: 3,

    );



    return Padding(

      padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),

      child: GridView.builder(

        shrinkWrap: true,

        physics: const NeverScrollableScrollPhysics(),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: crossAxisCount,

          crossAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),

          mainAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),

          childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.2 : 1.4,

        ),

        itemCount: strategies.length,

        itemBuilder: (context, index) {

          return _buildGridCard(strategies[index], index);

        },

      ),

    );

  }



  Widget _buildScrollableContentWithSugestoes(int ativas, int pausadas, int inativas, double impacto, {required bool isGrid}) {

    return CustomScrollView(

      slivers: [

        SliverToBoxAdapter(

          child: Column(

            children: [

              _buildHeader(ativas, pausadas, inativas, impacto),

              SizedBox(

                height: AppSizes.spacingMd.get(isMobile, isTablet),

              ),

              _buildInfoCard(),

              SizedBox(

                height: AppSizes.spacingMd.get(isMobile, isTablet),

              ),

              _buildSugestoesCard(),

              SizedBox(

                height: AppSizes.spacingMd.get(isMobile, isTablet),

              ),

              _buildControlsCard(),

            ],

          ),

        ),

        if (isGrid)

          SliverPadding(

            padding: EdgeInsets.all(

              AppSizes.paddingBase.get(isMobile, isTablet),

            ),

            sliver: SliverGrid(

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(

                  context,

                  mobile: 2,

                  tablet: 3,

                  desktop: 3,

                ),

                crossAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),

                mainAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),

                // ALTURA DOS CARDS: Quanto MAIOR o valor, MENOR a altura vertical dos cards

                // Valores atuais: Mobile 1.2, Desktop 1.4

                // Para cards mais baixos: aumentar valores (ex: 2.5, 2.4)

                // Para cards mais altos: diminuir valores (ex: 1.0, 1.1)

                childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.2 : 1.4,

              ),

              delegate: SliverChildBuilderDelegate(

                (context, index) => _buildGridCard(strategies[index], index),

                childCount: strategies.length,

              ),

            ),

          )

        else

          SliverList(

            delegate: SliverChildBuilderDelegate(

              (context, index) => Padding(

                padding: EdgeInsets.only(

                  left: AppSizes.paddingBaseLg.get(isMobile, isTablet),

                  right: AppSizes.paddingBaseLg.get(isMobile, isTablet),

                  bottom: AppSizes.paddingBaseLg.get(isMobile, isTablet),

                  top: index == 0

                      ? AppSizes.paddingBaseLg.get(isMobile, isTablet)

                      : 0,

                ),

                child: _buildListCard(strategies[index], index),

              ),

              childCount: strategies.length,

            ),

          ),

      ],

    );

  }



  Widget _buildGridView() {

    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(

      context,

      mobile: 2,

      tablet: 3,

      desktop: 3,

    );



    return GridView.builder(

      padding: EdgeInsets.all(

        AppSizes.paddingBase.get(isMobile, isTablet),

      ),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: crossAxisCount,

        crossAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),

        mainAxisSpacing: AppSizes.spacingBase.get(isMobile, isTablet),

        // ALTURA DOS CARDS: Quanto MAIOR o valor, MENOR a altura vertical dos cards

        // Valores atuais: Mobile 1.2, Desktop 1.4

        // Para cards mais baixos: aumentar valores (ex: 2.5, 2.4)

        // Para cards mais altos: diminuir valores (ex: 1.0, 1.1)

        childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.2 : 1.4,

      ),

      itemCount: strategies.length,

      itemBuilder: (context, index) {

        return _buildGridCard(strategies[index], index);

      },

    );

  }



  Widget _buildListView() {

    return ListView.builder(

      padding: EdgeInsets.all(

        AppSizes.paddingMd.get(isMobile, isTablet),

      ),

      itemCount: strategies.length,

      itemBuilder: (context, index) {

        return _buildListCard(strategies[index], index);

      },

    );

  }



  Widget _buildGridCard(StrategyModel estrategia, int index) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    final isAtiva = estrategia.status.isActive;

    

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

        decoration: BoxDecoration(

          gradient: LinearGradient(colors: estrategia.gradient),

          borderRadius: BorderRadius.circular(

            isMobile ? 20 : (isTablet ? 22 : 24),

          ),

          border: Border.all(

            color: ThemeColors.of(context).surface.withValues(alpha: isAtiva ? 0.3 : 0.1),

            width: isAtiva ? 2 : 1,

          ),

          boxShadow: [

            BoxShadow(

              color: estrategia.primaryColor.withValues(alpha: isAtiva ? 0.4 : 0.3),

              blurRadius: isMobile ? (isAtiva ? 15 : 12) : (isAtiva ? 18 : 15),

              offset: Offset(0, isMobile ? (isAtiva ? 8 : 6) : (isAtiva ? 10 : 8)),

            ),

          ],

        ),

        child: Material(

          color: ThemeColors.of(context).surface.withValues(alpha: 0.0),

          child: InkWell(

            onTap: () {

              final telaConfig = _getTelaConfiguracao(estrategia.name);

              if (telaConfig != null) {

                _navigatorKey.currentState?.push(

                  MaterialPageRoute(

                    builder: (context) => telaConfig,

                  ),

                );

              } else {

                ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(

                    content: Text('Configuração da estratgia "${estrategia.name}" em desenvolvimento'),

                    backgroundColor: ThemeColors.of(context).orangeMain,

                  ),

                );

              }

            },

            borderRadius: BorderRadius.circular(

              isMobile ? 20 : (isTablet ? 22 : 24),

            ),

            child: Padding(

              padding: EdgeInsets.all(

                ResponsiveHelper.getResponsivePadding(

                  context,

                  mobile: 8,

                  tablet: 13,

                  desktop: 14,

                ),

              ),

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Flexible(

                    child: Container(

                      padding: EdgeInsets.all(

                        ResponsiveHelper.getResponsivePadding(

                          context,

                          mobile: 2,

                          tablet: 6,

                          desktop: 8,

                        ),

                      ),

                      decoration: BoxDecoration(

                        color: ThemeColors.of(context).surfaceOverlay20,

                        borderRadius: BorderRadius.circular(

                          ResponsiveHelper.getResponsivePadding(

                            context,

                            mobile: 4,

                            tablet: 10,

                            desktop: 12,

                          ),

                        ),

                      ),

                      child: Icon(

                        estrategia.icon,

                        color: ThemeColors.of(context).surface,

                        size: ResponsiveHelper.getResponsiveIconSize(

                          context,

                          mobile: 16,

                          tablet: 24,

                          desktop: 28,

                        ),

                      ),

                    ),

                  ),

                  SizedBox(

                    height: ResponsiveHelper.getResponsivePadding(

                      context,

                      mobile: 2,

                      tablet: 6,

                      desktop: 8,

                    ),

                  ),

                  Flexible(

                    child: Text(

                      estrategia.name,

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        fontSize: ResponsiveHelper.getResponsiveFontSize(

                          context,

                          baseFontSize: 12,

                          mobileFontSize: 9,

                        ),

                        fontWeight: FontWeight.bold,

                        color: ThemeColors.of(context).surface,

                        letterSpacing: -0.5,

                      ),

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                    ),

                  ),

                  SizedBox(

                    height: ResponsiveHelper.getResponsivePadding(

                      context,

                      mobile: 1,

                      tablet: 2,

                      desktop: 3,

                    ),

                  ),

                  Flexible(

                    child: Text(

                      estrategia.category.label,

                      textAlign: TextAlign.center,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(

                        fontSize: ResponsiveHelper.getResponsiveFontSize(

                          context,

                          baseFontSize: 9,

                          mobileFontSize: 8,

                        ),

                        color: ThemeColors.of(context).surfaceOverlay90,

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }



  Widget _buildListCard(StrategyModel estrategia, int index) {

    final isMobile = ResponsiveHelper.isMobile(context);

    final isTablet = ResponsiveHelper.isTablet(context);

    final isAtiva = estrategia.status.isActive;

    

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

        margin: EdgeInsets.only(

          bottom: AppSizes.paddingBase.get(isMobile, isTablet),

        ),

        decoration: BoxDecoration(

          color: ThemeColors.of(context).surface,

          borderRadius: BorderRadius.circular(

            isMobile ? 16 : (isTablet ? 18 : 20),

          ),

          border: isAtiva

              ? Border.all(color: estrategia.primaryColor.withValues(alpha: 0.3), width: 2)

              : null,

          boxShadow: [

            BoxShadow(

              color: isAtiva

                  ? estrategia.primaryColor.withValues(alpha: 0.1)

                  : ThemeColors.of(context).textPrimaryOverlay05,

              blurRadius: isMobile ? 12 : 15,

              offset: const Offset(0, 4),

            ),

          ],

        ),

        child: Material(

          color: ThemeColors.of(context).surface.withValues(alpha: 0.0),

          child: InkWell(

            onTap: () {

              final telaConfig = _getTelaConfiguracao(estrategia.name);

              if (telaConfig != null) {

                _navigatorKey.currentState?.push(

                  MaterialPageRoute(

                    builder: (context) => telaConfig,

                  ),

                );

              } else {

                ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(

                    content: Text('Configuração da estratgia "${estrategia.name}" em desenvolvimento'),

                    backgroundColor: ThemeColors.of(context).orangeMain,

                  ),

                );

              }

            },

            borderRadius: BorderRadius.circular(

              isMobile ? 16 : (isTablet ? 18 : 20),

            ),

            child: Padding(

              padding: EdgeInsets.all(

                AppSizes.paddingMdAlt.get(isMobile, isTablet),

              ),

              child: Column(

                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      Container(

                        width: AppSizes.iconHeroLg.get(isMobile, isTablet),

                        height: AppSizes.iconHeroLg.get(isMobile, isTablet),

                        decoration: BoxDecoration(

                          gradient: LinearGradient(colors: estrategia.gradient),

                          borderRadius: BorderRadius.circular(

                            isMobile ? 14 : 16,

                          ),

                          boxShadow: [

                            BoxShadow(

                              color: estrategia.primaryColor.withValues(alpha: 0.3),

                              blurRadius: isMobile ? 12 : 15,

                              offset: Offset(0, isMobile ? 4 : 6),

                            ),

                          ],

                        ),

                        child: Icon(

                          estrategia.icon,

                          color: ThemeColors.of(context).surface,

                          size: AppSizes.iconLarge.get(isMobile, isTablet),

                        ),

                      ),

                      SizedBox(

                        width: AppSizes.paddingMdAlt.get(isMobile, isTablet),

                      ),

                      Expanded(

                        child: Column(

                          mainAxisSize: MainAxisSize.min,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Row(

                              children: [

                                Expanded(

                                  child: Text(

                                    estrategia.name,

                                    style: TextStyle(

                                      fontSize: ResponsiveHelper.getResponsiveFontSize(

                                        context,

                                        baseFontSize: 16,

                                        mobileFontSize: 15,

                                      ),

                                      fontWeight: FontWeight.bold,

                                      letterSpacing: -0.5,

                                    ),

                                    overflow: TextOverflow.ellipsis,

                                  ),

                                ),

                                const SizedBox(width: 8),

                                _buildStatusIndicator(estrategia.status.value),

                              ],

                            ),

                            SizedBox(

                              height: AppSizes.paddingXxs.get(isMobile, isTablet),

                            ),

                            Text(

                              estrategia.category.label,

                              style: TextStyle(

                                fontSize: ResponsiveHelper.getResponsiveFontSize(

                                  context,

                                  baseFontSize: 12,

                                  mobileFontSize: 11,

                                ),

                                overflow: TextOverflow.ellipsis,

                                color: estrategia.primaryColor,

                                fontWeight: FontWeight.w600,

                              ),

                            ),

                          ],

                        ),

                      ),

                      Container(

                        decoration: BoxDecoration(

                          color: ThemeColors.of(context).textSecondaryOverlay20,

                          borderRadius: BorderRadius.circular(8),

                        ),

                        child: IconButton(

                          icon: Icon(

                            Icons.settings_rounded,

                            color: ThemeColors.of(context).textSecondary,

                            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),

                          ),

                          onPressed: () {

                            final tela = _getTelaConfiguracao(estrategia.name);

                            if (tela != null) {

                              _navigatorKey.currentState?.push(

                                MaterialPageRoute(builder: (context) => tela),

                              );

                            }

                          },

                        ),

                      ),

                    ],

                  ),

                  SizedBox(

                    height: AppSizes.paddingBase.get(isMobile, isTablet),

                  ),

                  Text(

                    estrategia.description,

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

                  if (isAtiva) ...[

                    SizedBox(

                      height: AppSizes.paddingMdAlt.get(isMobile, isTablet),

                    ),

                    Container(

                      padding: EdgeInsets.all(

                        AppSizes.paddingMdAlt.get(isMobile, isTablet),

                      ),

                      decoration: BoxDecoration(

                        color: estrategia.primaryColor.withValues(alpha: 0.05),

                        borderRadius: BorderRadius.circular(

                          isMobile ? 10 : 12,

                        ),

                      ),

                      child: Row(

                        mainAxisSize: MainAxisSize.min,

                        children: [

                          Expanded(

                            child: _buildMetric(

                              'Impacto',

                              estrategia.impactPercentage,

                              Icons.trending_up_rounded,

                              ThemeColors.of(context).greenMain,

                            ),

                          ),

                          Container(

                            width: 1,

                            height: ResponsiveHelper.getResponsivePadding(

                              context,

                              mobile: 35,

                              tablet: 38,

                              desktop: 40,

                            ),

                            color: ThemeColors.of(context).textSecondary,

                          ),

                          Expanded(

                            child: _buildMetric(

                              'Produtos',

                              '${estrategia.affectedProducts}',

                              Icons.inventory_2_rounded,

                              estrategia.primaryColor,

                            ),

                          ),

                          Container(

                            width: 1,

                            height: ResponsiveHelper.getResponsivePadding(

                              context,

                              mobile: 35,

                              tablet: 38,

                              desktop: 40,

                            ),

                            color: ThemeColors.of(context).textSecondary,

                          ),

                          Expanded(

                            child: _buildMetric(

                              'ROI',

                              estrategia.roi,

                              Icons.show_chart_rounded,

                              ThemeColors.of(context).blueCyan,

                            ),

                          ),

                        ],

                      ),

                    ),

                    SizedBox(

                      height: AppSizes.paddingBase.get(isMobile, isTablet),

                    ),

                    Row(

                      mainAxisSize: MainAxisSize.min,

                      children: [

                        Icon(

                          Icons.schedule_rounded,

                          size: AppSizes.iconExtraSmall.get(isMobile, isTablet),

                          color: ThemeColors.of(context).textSecondary,

                        ),

                        SizedBox(

                          width: AppSizes.paddingXsAlt.get(isMobile, isTablet),

                        ),

                        Text(

                          'Prxima: ${estrategia.nextExecutionFormatted}',

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

                        const Spacer(),

                        Container(

                          padding: EdgeInsets.symmetric(

                            horizontal: AppSizes.paddingXsAlt2.get(isMobile, isTablet),

                            vertical: AppSizes.paddingXxs.get(isMobile, isTablet),

                          ),

                          decoration: BoxDecoration(

                            color: ThemeColors.of(context).successPastel,

                            borderRadius: BorderRadius.circular(6),

                          ),

                          child: Text(

                            '${estrategia.reliability}% confivel',

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(

                              fontSize: ResponsiveHelper.getResponsiveFontSize(

                                context,

                                baseFontSize: 10,

                                mobileFontSize: 9,

                              ),

                              fontWeight: FontWeight.bold,

                              color: ThemeColors.of(context).successIcon,

                            ),

                          ),

                        ),

                      ],

                    ),

                  ],

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }



  Widget _buildStatusIndicator(String status) {

    Color color;

    

    switch (status) {

      case 'ativa':

        color = ThemeColors.of(context).greenMain;

        break;

      case 'pausada':

        color = ThemeColors.of(context).orangeMain;

        break;

      default:

        color = ThemeColors.of(context).textSecondary;

    }



    return Container(

      width: AppSizes.paddingSmAlt.get(isMobile, isTablet),

      height: AppSizes.paddingSmAlt.get(isMobile, isTablet),

      decoration: BoxDecoration(

        color: _currentTab == 0 ? ThemeColors.of(context).surface : color,

        shape: BoxShape.circle,

        boxShadow: [

          BoxShadow(

            color: (_currentTab == 0 ? ThemeColors.of(context).surface : color).withValues(alpha: 0.5),

            blurRadius: ResponsiveHelper.isMobile(context) ? 5 : 6,

            spreadRadius: ResponsiveHelper.isMobile(context) ? 1 : 1,

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

          size: AppSizes.iconSmallMedium.get(isMobile, isTablet),

          color: color,

        ),

        SizedBox(

          height: AppSizes.paddingXxs.get(isMobile, isTablet),

        ),

        Text(

          value,

          style: TextStyle(

            fontSize: ResponsiveHelper.getResponsiveFontSize(

              context,

              baseFontSize: 14,

              mobileFontSize: 13,

            ),

          overflow: TextOverflow.ellipsis,

            fontWeight: FontWeight.bold,

            color: color,

          ),

        ),

        Text(

          label,

          style: TextStyle(

            fontSize: ResponsiveHelper.getResponsiveFontSize(

              context,

              baseFontSize: 9,

              mobileFontSize: 8,

            ),

          overflow: TextOverflow.ellipsis,

            color: ThemeColors.of(context).textSecondary,

          ),

        ),

      ],

    );

  }



  Widget _buildEmptyState() {

    final isMobile = ResponsiveHelper.isMobile(context);



    return Center(

      child: Column(

        mainAxisSize: MainAxisSize.min,

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(

            padding: EdgeInsets.all(

              ResponsiveHelper.getResponsivePadding(

                context,

                mobile: 32,

                tablet: 36,

                desktop: 40,

              ),

            ),

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textSecondary],

              ),

              shape: BoxShape.circle,

            ),

            child: Icon(

              Icons.search_off_rounded,

              size: AppSizes.iconHero3Xl.get(isMobile, isTablet),

              color: ThemeColors.of(context).textSecondary,

            ),

          ),

          SizedBox(

            height: AppSizes.paddingXl.get(isMobile, isTablet),

          ),

          Text(

            'Nenhuma estratgia encontrada',

            style: TextStyle(

              fontSize: ResponsiveHelper.getResponsiveFontSize(

                context,

                baseFontSize: 20,

                mobileFontSize: 18,

                tabletFontSize: 19,

              ),

            overflow: TextOverflow.ellipsis,

              fontWeight: FontWeight.bold,

              color: ThemeColors.of(context).textSecondary,

            ),

          ),

          SizedBox(

            height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),

          ),

          Text(

            'Tente ajustar os filtros de busca',

            style: TextStyle(

              fontSize: ResponsiveHelper.getResponsiveFontSize(

                context,

                baseFontSize: 14,

                mobileFontSize: 13,

              ),

            overflow: TextOverflow.ellipsis,

              color: ThemeColors.of(context).textSecondary,

            ),

          ),

        ],

      ),

    );

  }

}

















