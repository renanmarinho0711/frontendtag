import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class CategoriasEstatisticasScreen extends ConsumerStatefulWidget {
  const CategoriasEstatisticasScreen({super.key});

  @override
  ConsumerState<CategoriasEstatisticasScreen> createState() => _CategoriasEstatisticasScreenState();
}

class _CategoriasEstatisticasScreenState extends ConsumerState<CategoriasEstatisticasScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late TabController _tabController;
  String _periodoSelecionado = '30dias';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Inicializa o provider de estatísticas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryStatsProvider.notifier).loadStats();
      // Tambãm carregar categorias se ainda não carregadas
      final categoriesState = ref.read(categoriesProvider);
      if (categoriesState.status == LoadingStatus.initial) {
        ref.read(categoriesProvider.notifier).initialize();
      }
    });
  }

  /// Converte CategoryModel para Map<String, dynamic> para compatibilidade com estatísticas
  List<Map<String, dynamic>> _getCategorias() {
    final categoriesState = ref.watch(categoriesProvider);
    final statsState = ref.watch(categoryStatsProvider);
    
    return categoriesState.categories.map((cat) {
      // Buscar stats específicas dessa categoria
      final stats = statsState.stats.firstWhere(
        (s) => s.categoryId == cat.id,
        orElse: () => CategoryStatsModel.empty(cat.id),
      );
      
      return {
        'nome': cat.nome,
        'produtos': cat.quantidadeProdutos,
        'vendas': stats.totalVendas,
        'faturamento': stats.faturamento,
        'percentual': stats.percentualParticipacao,
        'cor': _getColorForCategory(cat.nome),
        'gradiente': _getGradientForCategory(cat.nome),
        'icone': _getIconForCategory(cat.nome),
        'crescimento': stats.crescimento,
        'ticketMedio': stats.ticketMedio,
        'margemLucro': stats.margemLucro,
      };
    }).toList();
  }

  IconData _getIconForCategory(String nome) {
    final lower = nome.toLowerCase();
    if (lower.contains('bebida')) return Icons.local_drink_rounded;
    if (lower.contains('mercear')) return Icons.shopping_basket_rounded;
    if (lower.contains('perec')) return Icons.restaurant_rounded;
    if (lower.contains('limp')) return Icons.cleaning_services_rounded;
    if (lower.contains('higien')) return Icons.wash_rounded;
    if (lower.contains('padar')) return Icons.bakery_dining_rounded;
    if (lower.contains('frio') || lower.contains('congel')) return Icons.ac_unit_rounded;
    if (lower.contains('hortifruti') || lower.contains('frut')) return Icons.eco_rounded;
    return Icons.category_rounded;
  }

  Color _getColorForCategory(String nome) {
    final lower = nome.toLowerCase();
    if (lower.contains('bebida')) return ThemeColors.of(context).primary;
    if (lower.contains('mercear')) return ThemeColors.of(context).brownMain;
    if (lower.contains('perec')) return ThemeColors.of(context).success;
    if (lower.contains('limp')) return ThemeColors.of(context).blueCyan;
    if (lower.contains('higien')) return ThemeColors.of(context).blueLight;
    if (lower.contains('padar')) return ThemeColors.of(context).yellowGold;
    return ThemeColors.of(context).blueMain;
  }

  List<Color> _getGradientForCategory(String nome) {
    final lower = nome.toLowerCase();
    if (lower.contains('bebida')) return [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark];
    if (lower.contains('mercear')) return [ThemeColors.of(context).brownMain, ThemeColors.of(context).brownDark];
    if (lower.contains('perec')) return [ThemeColors.of(context).success, ThemeColors.of(context).successIcon];
    if (lower.contains('limp')) return [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary];
    if (lower.contains('higien')) return [ThemeColors.of(context).blueLight, ThemeColors.of(context).primary];
    if (lower.contains('padar')) return [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning];
    return [ThemeColors.of(context).blueMain, ThemeColors.of(context).blueDark];
  }

  /// Getter para lista de categorias formatada para UI
  List<Map<String, dynamic>> get _categorias => _getCategorias();

  Map<String, dynamic> _getDadosPeriodo() {
    final statsState = ref.watch(categoryStatsProvider);
    return {
      'totalVendas': statsState.totalVendas,
      'totalFaturamento': statsState.totalFaturamento,
      'ticketMedio': statsState.ticketMedio,
      'crescimento': statsState.crescimento,
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _dadosAtuais => _getDadosPeriodo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Estatãsticas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: ThemeColors.of(context).success,
      ),
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildInfoCard(),
                      _buildPeriodSelector(),
                      _buildTabBar(),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCategoriesTab(),
                _buildTrendsTab(),
              ],
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportarRelatorio,
        icon: const Icon(Icons.file_download_rounded),
        label: const Text('Exportar'),
        backgroundColor: ThemeColors.of(context).success,
      )
    );
  }

  Widget _buildInfoCard() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingSmLg.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 14,
          tablet: 17,
          desktop: 20,
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.of(context).blueCyan.withValues(alpha: 0.1),
            ThemeColors.of(context).primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        border: Border.all(
          color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: ThemeColors.of(context).yellowGold.withValues(alpha: 0.8),
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              'Visualize estatísticas detalhadas e tendãncias das categorias',
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
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 4,
          tablet: 4,
          desktop: 4,
        ),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildPeriodOption('7 dias', '7dias')),
          Expanded(child: _buildPeriodOption('30 dias', '30dias')),
          Expanded(child: _buildPeriodOption('90 dias', '90dias')),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(String label, String value) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSelected = _periodoSelecionado == value;

    return InkWell(
      onTap: () => setState(() => _periodoSelecionado = value),
      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingBase.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark])
              : null,
          borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
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
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ?  ThemeColors.of(context).surface : ThemeColors.of(context).textSecondaryOverlay80,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingSmLg.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 3,
          tablet: 4,
          desktop: 4,
        ),
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
            colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ?  10 : 12,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: ThemeColors.of(context).transparent,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 12,
            mobileFontSize: 11,
          ),
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.dashboard_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Geral',
          ),
          Tab(
            icon: Icon(
              Icons.category_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Categorias',
          ),
          Tab(
            icon: Icon(
              Icons.trending_up_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet),
            ),
            text: 'Tendãncias',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Column(
        children: [
          _buildSummaryCards(),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          _buildDistributionChart(),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          _buildTopCategoriesCard(),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: _categorias.length,
      itemBuilder: (context, index) {
        return _buildCategoryDetailCard(_categorias[index], index);
      },
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: Column(
        children: [
          _buildGrowthRankingCard(),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          _buildPerformanceChart(),
          SizedBox(
            height: AppSizes.cardPadding.get(isMobile, isTablet),
          ),
          _buildInsightsCard(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final isMobile = ResponsiveHelper.isMobile(context);

    final cards = [
      _buildSummaryCard(
        'Total de Vendas',
        '${_dadosAtuais['totalVendas']}',
        Icons.shopping_cart_rounded,
        [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
        '+${_dadosAtuais['crescimento']}%',
      ),
      _buildSummaryCard(
        'Faturamento',
        'R\$ ${_dadosAtuais['totalFaturamento'].toStringAsFixed(2)}',
        Icons.attach_money_rounded,
        [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
        '+${_dadosAtuais['crescimento']}%',
      ),
      _buildSummaryCard(
        'Ticket Mãdio',
        'R\$ ${_dadosAtuais['ticketMedio'].toStringAsFixed(2)}',
        Icons.receipt_long_rounded,
        [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
        '+3.2%',
      ),
      _buildSummaryCard(
        'Categorias',
        '${_categorias.length}',
        Icons.category_rounded,
        [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
        '100%',
      ),
    ];

    return isMobile && !ResponsiveHelper.isLandscape(context)
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                  Expanded(child: cards[1]),
                ],
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          )
        : Row(
            children: cards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;
              
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < cards.length - 1 ? 12 : 0),
                  child: card,
                ),
              );
            }).toList(),
          );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    List<Color> gradient,
    String variation,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value2, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value2),
          child: Opacity(opacity: value2, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient[0].withValues(alpha: 0.1),
              gradient[0].withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: gradient[0].withValues(alpha: 0.3),
            width: isMobile ? 1.25 : 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: gradient[0],
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: gradient[0],
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionChart() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingBase.get(isMobile, isTablet),
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
                  Icons.pie_chart_rounded,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Distribuição por Categoria',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                    ),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 24,
              tablet: 28,
              desktop: 32,
            ),
          ),
          ..._categorias.map((cat) => _buildDistributionBar(cat)),
        ],
      ),
    );
  }

  Widget _buildDistributionBar(Map<String, dynamic> categoria) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    categoria['icone'] as IconData?,
                    size: 18,
                    color: categoria['cor'] as Color?,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    categoria['nome'] as String,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${categoria['percentual']}%',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                  ),
                  fontWeight: FontWeight.bold,
                  color: categoria['cor'] as Color?,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1000),
              tween: Tween<double>(begin: 0, end: (categoria['percentual'] as num) / 100),
              builder: (context, double value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: ThemeColors.of(context).textSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(categoria['cor'] as Color),
                  minHeight: 12,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategoriesCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final topCategories = (List<Map<String, dynamic>>.from(_categorias)
      ..sort((a, b) => (b['faturamento'] as num).compareTo(a['faturamento'] as num)))
      .take(5)
      .toList();

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Top 5 Categorias',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.paddingXxlAlt.get(isMobile, isTablet),
          ),
          ... topCategories.asMap().entries.map((entry) {
            final index = entry.key;
            final cat = entry.value;
            return _buildRankingItem(cat, index + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildRankingItem(Map<String, dynamic> categoria, int posicao) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: posicao == 1
            ? LinearGradient(
                colors: [
                  ThemeColors.of(context).yellowGold.withValues(alpha: 0.1),
                  ThemeColors.of(context).warning.withValues(alpha: 0.1),
                ],
              )
            : null,
        color: posicao == 1 ? null : ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        border: Border.all(
          color: posicao == 1 ? ThemeColors.of(context).yellowGold : ThemeColors.of(context).textSecondary,
          width: posicao == 1 ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: posicao == 1
                    ? [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning]
                    : posicao == 2
                        ? [ThemeColors.of(context).silver, ThemeColors.of(context).grey900]
                        : posicao == 3
                            ? [ThemeColors.of(context).bronze, ThemeColors.of(context).brownSaddle]
                            : [ThemeColors.of(context).textSecondary, ThemeColors.of(context).grey400],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$posicao',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 16,
                    mobileFontSize: 15,
                  ),
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).surface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            categoria['icone'] as IconData?,
            color: categoria['cor'] as Color?,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoria['nome'] as String,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                      mobileFontSize: 13,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${categoria['produtos']} produtos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                    ),
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${((categoria['faturamento'] as num?) ?? 0).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 15,
                    mobileFontSize: 14,
                  ),
                  fontWeight: FontWeight.bold,
                  color: categoria['cor'] as Color?,
                ),
              ),
              Text(
                '${categoria['vendas']} vendas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                  ),
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDetailCard(Map<String, dynamic> categoria, int index) {
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
        margin: EdgeInsets.only(
          bottom: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: Border.all(color: (categoria['cor'] as Color).withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: (categoria['cor'] as Color).withValues(alpha: 0.1),
              blurRadius: isMobile ? 15 : 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: (categoria['gradiente'] as List<dynamic>).cast<Color>()),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isMobile ? 14 : (isTablet ? 16 : 18)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppSizes.paddingBase.get(isMobile, isTablet),
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    child: Icon(
                      categoria['icone'] as IconData?,
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconLarge.get(isMobile, isTablet),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoria['nome'] as String,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 18,
                              mobileFontSize: 16,
                            ),
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.of(context).surface,
                          ),
                        ),
                        Text(
                          '${categoria['produtos']} produtos cadastrados',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 11,
                            ),
                            color: ThemeColors.of(context).surfaceOverlay90,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${categoria['percentual']}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricBox(
                          'Vendas',
                          '${categoria['vendas']}',
                          Icons.shopping_cart_rounded,
                          ThemeColors.of(context).primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricBox(
                          'Faturamento',
                          'R\$ ${categoria['faturamento'].toStringAsFixed(0)}',
                          Icons.attach_money_rounded,
                          ThemeColors.of(context).success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricBox(
                          'Ticket Mãdio',
                          'R\$ ${categoria['ticketMedio'].toStringAsFixed(2)}',
                          Icons.receipt_rounded,
                          ThemeColors.of(context).yellowGold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricBox(
                          'Margem',
                          '${categoria['margemLucro']}%',
                          Icons.show_chart_rounded,
                          ThemeColors.of(context).blueCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (categoria['crescimento'] as num) > 0
                          ? ThemeColors.of(context).successPastel
                          : ThemeColors.of(context).errorPastel,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (categoria['crescimento'] as num) > 0
                            ? ThemeColors.of(context).success.withValues(alpha: 0.4)
                            : ThemeColors.of(context).error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          (categoria['crescimento'] as num) > 0
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: (categoria['crescimento'] as num) > 0
                              ? ThemeColors.of(context).success.withValues(alpha: 0.8)
                              : ThemeColors.of(context).error.withValues(alpha: 0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(categoria['crescimento'] as num) > 0 ? '+' : ''}${categoria['crescimento']}% de crescimento',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 13,
                            ),
                            fontWeight: FontWeight.bold,
                            color: (categoria['crescimento'] as num) > 0
                                ? ThemeColors.of(context).successIcon
                                : ThemeColors.of(context).errorDark,
                          ),
                        ),
                      ],
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

  Widget _buildMetricBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 15,
              ),
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 11,
                mobileFontSize: 10,
              ),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthRankingCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final sortedByGrowth = List<Map<String, dynamic>>.from(_categorias)
      ..sort((a, b) => (b['crescimento'] as num).compareTo(a['crescimento'] as num));

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).greenGradient, ThemeColors.of(context).greenGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ranking de Crescimento',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
          ... sortedByGrowth.map((cat) => _buildGrowthItem(cat)),
        ],
      ),
    );
  }

  Widget _buildGrowthItem(Map<String, dynamic> categoria) {
    final isPositive = (categoria['crescimento'] as num) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPositive ?  ThemeColors.of(context).successPastel : ThemeColors.of(context).errorPastel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive ? ThemeColors.of(context).successLight : ThemeColors.of(context).errorLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            categoria['icone'] as IconData?,
            color: categoria['cor'] as Color?,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              categoria['nome'] as String,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                ),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPositive ? ThemeColors.of(context).success : ThemeColors.of(context).error,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  color: ThemeColors.of(context).surface,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${(categoria['crescimento'] as num) > 0 ? '+' : ''}${categoria['crescimento']}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ?  15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppSizes.paddingBase.get(isMobile, isTablet),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).blueLight],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: ThemeColors.of(context).surface,
                  size: ResponsiveHelper.getResponsiveIconSize(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Performance Comparativa',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.padding2Xl.get(isMobile, isTablet),
          ),
          SizedBox(
            height: 200,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _categorias.map((cat) {
                    return TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0, end: constraints.maxHeight),
                      builder: (context, double animatedHeight, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${cat['percentual']}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: cat['cor'] as Color?,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 40,
                          height: animatedHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: (cat['gradiente'] as List<dynamic>).cast<Color>(),
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(cat['icone'] as IconData?, size: 18, color: cat['cor'] as Color?),
                      ],
                        );
                      },
                    );
                  },
                ).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Gera insights dinâmicos baseados nos dados das categorias
  List<Map<String, dynamic>> _gerarInsights() {
    final categorias = _getCategorias();
    if (categorias.isEmpty) return [];
    
    final insights = <Map<String, dynamic>>[];
    
    // Ordena por faturamento para encontrar láder
    final sortedByFaturamento = List<Map<String, dynamic>>.from(categorias)
      ..sort((a, b) => (b['faturamento'] as num).compareTo(a['faturamento'] as num));
    
    if (sortedByFaturamento.isNotEmpty) {
      final lider = sortedByFaturamento.first;
      insights.add({
        'icon': Icons.star_rounded,
        'text': '${lider['nome']} lidera com ${(lider['percentual'] as num).toStringAsFixed(1)}% do faturamento total',
        'color': ThemeColors.of(context).primary,
      });
    }
    
    // Ordena por crescimento para encontrar maior crescimento
    final sortedByCrescimento = List<Map<String, dynamic>>.from(categorias)
      ..sort((a, b) => (b['crescimento'] as num).compareTo(a['crescimento'] as num));
    
    if (sortedByCrescimento.isNotEmpty) {
      final maiorCrescimento = sortedByCrescimento.first;
      final crescimento = maiorCrescimento['crescimento'] as num;
      if (crescimento > 0) {
        insights.add({
          'icon': Icons.trending_up_rounded,
          'text': '${maiorCrescimento['nome']} teve o maior crescimento (${crescimento.toStringAsFixed(1)}%)',
          'color': ThemeColors.of(context).success,
        });
      }
    }
    
    // Encontra categorias com queda
    final categoriaComQueda = categorias.where((c) => (c['crescimento'] as num) < 0).toList();
    if (categoriaComQueda.isNotEmpty) {
      categoriaComQueda.sort((a, b) => (a['crescimento'] as num).compareTo(b['crescimento'] as num));
      final piorCategoria = categoriaComQueda.first;
      final queda = (piorCategoria['crescimento'] as num).abs();
      insights.add({
        'icon': Icons.warning_rounded,
        'text': '${piorCategoria['nome']} apresentou queda de ${queda.toStringAsFixed(1)}%',
        'color': ThemeColors.of(context).error,
      });
    }
    
    // Ordena por margem de lucro
    final sortedByMargem = List<Map<String, dynamic>>.from(categorias)
      ..sort((a, b) => (b['margemLucro'] as num).compareTo(a['margemLucro'] as num));
    
    if (sortedByMargem.isNotEmpty) {
      final melhorMargem = sortedByMargem.first;
      final margem = melhorMargem['margemLucro'] as num;
      if (margem > 0) {
        insights.add({
          'icon': Icons.insights_rounded,
          'text': '${melhorMargem['nome']} tem a maior margem de lucro (${margem.toStringAsFixed(1)}%)',
          'color': ThemeColors.of(context).blueCyan,
        });
      }
    }
    
    // Se não hã insights, mostra mensagem padrão
    if (insights.isEmpty) {
      insights.add({
        'icon': Icons.info_rounded,
        'text': 'Cadastre categorias para visualizar insights',
        'color': ThemeColors.of(context).blueMain,
      });
    }
    
    return insights;
  }

  Widget _buildInsightsCard() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final insights = _gerarInsights();

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).primaryPastel, ThemeColors.of(context).infoPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: ThemeColors.of(context).primaryLight, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: ThemeColors.of(context).primaryDark,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Insights Principais',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                  ),
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => _buildInsightItem(
            insight['icon'] as IconData,
            insight['text'] as String,
            insight['color'] as Color,
          )),
        ],
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
                color: ThemeColors.of(context).textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportarRelatorio() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).success, size: 48),
        title: const Text('Exportar Relatãrio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecione o formato do relatãrio:'),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.check_rounded, color: ThemeColors.of(context).error),
              title: const Text('PDF'),
              subtitle: const Text('Relatãrio completo em PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Gerando relatãrio PDF...'),
                    backgroundColor: ThemeColors.of(context).success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.check_rounded, color: ThemeColors.of(context).success),
              title: const Text('Excel'),
              subtitle: const Text('Planilha com dados detalhados'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Gerando planilha Excel...'),
                    backgroundColor: ThemeColors.of(context).success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}








