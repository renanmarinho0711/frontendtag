import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/strategies/presentation/screens/strategies_results_screen.dart';
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
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class EstrategiasConfigurarScreen extends ConsumerStatefulWidget {
  final StrategyModel estrategia;

  const EstrategiasConfigurarScreen({super.key, required this.estrategia});

  @override
  ConsumerState<EstrategiasConfigurarScreen> createState() => _EstrategiasConfigurarScreenState();
}

class _EstrategiasConfigurarScreenState extends ConsumerState<EstrategiasConfigurarScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _animationController;
  late TabController _tabController;
  int _currentTab = 0;
  
  // Filtros locais (sincronizados com provider)
  String _filtroCategoria = 'todas';
  String _searchQuery = '';
  
  // Cache de estrat�gias filtradas
  List<StrategyModel>? _cachedEstrategiasFiltradas;
  String? _lastFiltroCategoria;
  String? _lastSearchQuery;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tabController = TabController(length: 2, vsync: this);
    _animationController.forward();
    
    // Inicializa o provider se ainda n�o foi inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(strategiesProvider);
      if (state.strategies.isEmpty) {
        ref.read(strategiesProvider.notifier).initialize();
      }
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
      case 'Precifica��o por Temperatura':
        return const TemperaturaConfigScreen();
      case 'Horrio de Pico':
        return const HorarioPicoConfigScreen();
      case 'Liquida��o Automtica':
        return const LiquidacaoAutomaticaConfigScreen();
      case 'Dynamic Markdown':
        return const DynamicMarkdownConfigScreen();
      case 'Previso com IA':
        return const PrevisaoIAConfigScreen();
      case 'auditoria Automtica':
        return const auditoriaAutomaticaConfigScreen();
      case 'Mapa de Calor de Promo��es':
        return const MapaCalorConfigScreen();
      case 'Ranking Tempo Real':
        return const RankingTempoRealConfigScreen();
      case 'Promo��es Relmpago':
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

  // OTIMIZA��O: Getter com cache
  List<StrategyModel> get _estrategiasFiltradas {
    final strategiesState = ref.read(strategiesProvider);
    final estrategias = strategiesState.strategies;
    
    if (_cachedEstrategiasFiltradas != null &&
        _lastFiltroCategoria == _filtroCategoria &&
        _lastSearchQuery == _searchQuery) {
      return _cachedEstrategiasFiltradas!;
    }
    
    _lastFiltroCategoria = _filtroCategoria;
    _lastSearchQuery = _searchQuery;
    
    _cachedEstrategiasFiltradas = estrategias.where((estrategia) {
      final nome = estrategia.name.toLowerCase();
      final descricao = estrategia.description.toLowerCase();
      final query = _searchQuery.toLowerCase();
      final matchSearch = nome.contains(query) || descricao.contains(query);

      final matchCategoria = _filtroCategoria == 'todas' ||
          (_filtroCategoria == 'ativas' && estrategia.status == StrategyStatus.active) ||
          (_filtroCategoria == 'pausadas' && estrategia.status == StrategyStatus.paused) ||
          (_filtroCategoria == 'inativas' && estrategia.status == StrategyStatus.inactive);

      return matchSearch && matchCategoria;
    }).toList();

    return _cachedEstrategiasFiltradas!;
  }

  @override
  Widget build(BuildContext context) {
    final strategiesState = ref.watch(strategiesProvider);
    final estrategias = strategiesState.strategies;
    
    final estrategiasAtivas = estrategias.where((e) => e.status == StrategyStatus.active).length;
    final estrategiasPausadas = estrategias.where((e) => e.status == StrategyStatus.paused).length;
    final estrategiasInativas = estrategias.where((e) => e.status == StrategyStatus.inactive).length;
    
    final impactoTotal = estrategias
        .where((e) => e.status == StrategyStatus.active)
        .fold(0.0, (sum, e) {
          final valorStr = e.impactValue
              .replaceAll('R\$ ', '')
              .replaceAll('.', '')
              .replaceAll(',', '.');
          return sum + (double.tryParse(valorStr) ?? 0.0);
        });

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGlassHeader(estrategiasAtivas, estrategiasPausadas, estrategiasInativas, impactoTotal),
              _buildTabBar(),
              _buildSearchAndFilter(),
              Expanded(
                child: _estrategiasFiltradas.isEmpty
                    ? _buildEmptyState()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildGridView(),
                          _buildListView(),
                        ],
                      ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildGlassHeader(int ativas, int pausadas, int inativas, double impacto) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final strategiesState = ref.read(strategiesProvider);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingXlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 20 : (isTablet ? 24 : 28),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).success.withValues(alpha: 0.4),
            blurRadius: isMobile ? 20 : 30,
            offset: Offset(0, isMobile ? 10 : 15),
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
                  AppSizes.paddingMd.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(
                    AppSizes.paddingMdLg.get(isMobile, isTablet),
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
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
                      'Estrat�gias Autom�ticas',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 24,
                          mobileFontSize: 20,
                          tabletFontSize: 22,
                        ),
                      overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.paddingXxs.get(isMobile, isTablet),
                    ),
                    Text(
                      'Inteligncia Artificial para Precifica��o',
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
            ],
          ),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          Container(
            padding: EdgeInsets.all(
              AppSizes.cardPadding.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(
                AppSizes.paddingMd.get(isMobile, isTablet),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: _buildHeaderStat('R\$ ${impacto.toStringAsFixed(0)}', 'Impacto Total', Icons.trending_up_rounded),
                    ),
                    Container(
                      width: 1,
                      height: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: 45,
                        tablet: 48,
                        desktop: 50,
                      ),
                      color: ThemeColors.of(context).surfaceOverlay30,
                    ),
                    Expanded(
                      child: _buildHeaderStat('$ativas', 'Ativas', Icons.play_circle_rounded),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.paddingMd.get(isMobile, isTablet),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: _buildMiniStat('$pausadas', 'Pausadas', Icons.pause_circle_rounded, ThemeColors.of(context).orangeMain)),
                    SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                    Expanded(child: _buildMiniStat('$inativas', 'Inativas', Icons.cancel_rounded, ThemeColors.of(context).textSecondary)),
                    SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                    Expanded(child: _buildMiniStat('${strategiesState.strategies.length}', 'Total', Icons.layers_rounded, ThemeColors.of(context).blueMain)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: ThemeColors.of(context).surface,
          size: AppSizes.iconLarge.get(isMobile, isTablet),
        ),
        SizedBox(
          height: AppSizes.paddingXsAlt2.get(isMobile, isTablet),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 28,
              mobileFontSize: 24,
              tabletFontSize: 26,
            ),
          overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: ThemeColors.of(context).surface,
            letterSpacing: -1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 11,
              mobileFontSize: 10,
            ),
          overflow: TextOverflow.ellipsis,
            color: ThemeColors.of(context).surfaceOverlay90,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String value, String label, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay10,
        borderRadius: BorderRadius.circular(
          isMobile ? 8 : 10,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconSmall.get(isMobile, isTablet),
          ),
          SizedBox(
            height: AppSizes.paddingXxs.get(isMobile, isTablet),
          ),
          Text(
            value,
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
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 9,
                mobileFontSize: 8,
              ),
            overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).surfaceOverlay80,
            ),
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
        onTap: (index) => setState(() => _currentTab = index),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
        ),
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).grey600,
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 14,
            mobileFontSize: 13,
          ),
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.grid_view_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            text: 'Grade',
          ),
          Tab(
            icon: Icon(
              Icons.view_list_rounded,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            text: 'Lista',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(
                isMobile ? 14 : 16,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).textPrimaryOverlay05,
                  blurRadius: isMobile ? 8 : 10,
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
                hintText: 'Buscar estrat�gias...',
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
                SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                _buildFilterChip('Ativas', 'ativas', Icons.play_circle_rounded),
                SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                _buildFilterChip('Pausadas', 'pausadas', Icons.pause_circle_rounded),
                SizedBox(width: AppSizes.paddingXsAlt2.get(isMobile, isTablet)),
                _buildFilterChip('Inativas', 'inativas', Icons.cancel_rounded),
              ],
            ),
          ),
        ],
      ),
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
            color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondaryOverlay40,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ThemeColors.of(context).successLight,
                    blurRadius: isMobile ? 8 : 10,
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
                color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondaryOverlay80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 2,
      desktop: 2,
    );
    final isMobile = ResponsiveHelper.isMobile(context);

    return GridView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
        mainAxisSpacing: AppSizes.paddingBase.get(isMobile, isTablet),
        childAspectRatio: isMobile ? 1.5 : 0.75,
      ),
      itemCount: _estrategiasFiltradas.length,
      itemBuilder: (context, index) {
        return _buildGridCard(_estrategiasFiltradas[index], index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: _estrategiasFiltradas.length,
      itemBuilder: (context, index) {
        return _buildListCard(_estrategiasFiltradas[index], index);
      },
    );
  }

  Widget _buildGridCard(StrategyModel estrategia, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAtiva = estrategia.status == StrategyStatus.active;
    
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
          boxShadow: [
            BoxShadow(
              color: estrategia.primaryColorLight,
              blurRadius: isMobile ? 15 : 20,
              offset: Offset(0, isMobile ? 8 : 10),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => EstrategiasResultadosScreen(estrategia: estrategia),
                ),
              );
            },
            borderRadius: BorderRadius.circular(
              isMobile ? 20 : (isTablet ? 22 : 24),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          AppSizes.paddingBase.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).surfaceOverlay20,
                          borderRadius: BorderRadius.circular(
                            AppSizes.paddingBase.get(isMobile, isTablet),
                          ),
                        ),
                        child: Icon(
                          estrategia.icon,
                          color: ThemeColors.of(context).surface,
                          size: AppSizes.iconLarge.get(isMobile, isTablet),
                        ),
                      ),
                      _buildStatusIndicator(estrategia.status),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    estrategia.name,
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
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                  ),
                  Text(
                    estrategia.category.label,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                      ),
                    overflow: TextOverflow.ellipsis,
                      color: ThemeColors.of(context).surfaceOverlay90,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isAtiva) ...[
                    SizedBox(
                      height: AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surfaceOverlay20,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            color: ThemeColors.of(context).surface,
                            size: AppSizes.iconExtraSmall.get(isMobile, isTablet),
                          ),
                          SizedBox(
                            width: AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          Text(
                            estrategia.impact,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 14,
                                mobileFontSize: 13,
                              ),
                            overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.of(context).surface,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildListCard(StrategyModel estrategia, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isAtiva = estrategia.status == StrategyStatus.active;
    
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
              ? Border.all(color: estrategia.primaryColorLight, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isAtiva
                  ? estrategia.primaryColorLight
                  : ThemeColors.of(context).textPrimaryOverlay05,
              blurRadius: isMobile ? 15 : 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => EstrategiasResultadosScreen(estrategia: estrategia),
                ),
              );
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
                    mainAxisSize: MainAxisSize.min,
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
                              color: estrategia.primaryColorLight,
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
                              mainAxisSize: MainAxisSize.min,
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
                                    overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                _buildStatusIndicator(estrategia.status),
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
                              Navigator.of(context, rootNavigator: false).push(
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
                        color: estrategia.primaryColorLight,
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
                              estrategia.impact,
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
                              '${estrategia.products}',
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
                          'Prxima: ${estrategia.nextExecution}',
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
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 10,
                                mobileFontSize: 9,
                              ),
                            overflow: TextOverflow.ellipsis,
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

  Widget _buildStatusIndicator(StrategyStatus status) {
    final color = status.color;

    return Container(
      width: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
      height: AppSizes.paddingSmAlt3.get(isMobile, isTablet),
      decoration: BoxDecoration(
        color: _currentTab == 0 ? ThemeColors.of(context).surface : color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (_currentTab == 0 ? ThemeColors.of(context).surface : color)Light,
            blurRadius: ResponsiveHelper.isMobile(context) ? 6 : 8,
            spreadRadius: ResponsiveHelper.isMobile(context) ? 1 : 2,
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
          size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
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
              baseFontSize: 16,
              mobileFontSize: 15,
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
              baseFontSize: 10,
              mobileFontSize: 9,
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








