import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

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
      // Também carregar categorias se ainda não carregadas
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
    if (lower.contains('bebida')) return AppThemeColors.blueMaterial;
    if (lower.contains('mercear')) return AppThemeColors.brownMain;
    if (lower.contains('perec')) return AppThemeColors.greenMaterial;
    if (lower.contains('limp')) return AppThemeColors.blueCyan;
    if (lower.contains('higien')) return AppThemeColors.blueLight;
    if (lower.contains('padar')) return AppThemeColors.yellowGold;
    return AppThemeColors.blueMain;
  }

  List<Color> _getGradientForCategory(String nome) {
    final lower = nome.toLowerCase();
    if (lower.contains('bebida')) return [AppThemeColors.blueMaterial, AppThemeColors.blueDark];
    if (lower.contains('mercear')) return [AppThemeColors.brownMain, AppThemeColors.brownDark];
    if (lower.contains('perec')) return [AppThemeColors.greenMaterial, AppThemeColors.successIcon];
    if (lower.contains('limp')) return [AppThemeColors.blueCyan, AppThemeColors.blueMaterial];
    if (lower.contains('higien')) return [AppThemeColors.blueLight, AppThemeColors.blueMaterial];
    if (lower.contains('padar')) return [AppThemeColors.yellowGold, AppThemeColors.warning];
    return [AppThemeColors.blueMain, AppThemeColors.blueDark];
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
          'Estatísticas',
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
        backgroundColor: AppThemeColors.greenMaterial,
      ),
      backgroundColor: AppThemeColors.surface,
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
        backgroundColor: AppThemeColors.greenMaterial,
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
            AppThemeColors.blueCyan.withValues(alpha: 0.1),
            AppThemeColors.blueMaterial.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        border: Border.all(
          color: AppThemeColors.blueCyan.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: AppThemeColors.yellowGold.withValues(alpha: 0.8),
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              'Visualize estatísticas detalhadas e tendências das categorias',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                color: AppThemeColors.textSecondary,
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
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
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
              ? const LinearGradient(colors: [AppThemeColors.greenMaterial, AppThemeColors.greenDark])
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
            color: isSelected ?  AppThemeColors.surface : AppThemeColors.textSecondaryOverlay80,
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
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ? 14 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
            blurRadius: isMobile ? 8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppThemeColors.greenMaterial, AppThemeColors.greenDark],
          ),
          borderRadius: BorderRadius.circular(
            isMobile ?  10 : 12,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppThemeColors.transparent,
        labelColor: AppThemeColors.surface,
        unselectedLabelColor: AppThemeColors.textSecondary,
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
            text: 'Tendências',
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
        [AppThemeColors.greenGradient, AppThemeColors.greenGradientEnd],
        '+${_dadosAtuais['crescimento']}%',
      ),
      _buildSummaryCard(
        'Faturamento',
        'R\$ ${_dadosAtuais['totalFaturamento'].toStringAsFixed(2)}',
        Icons.attach_money_rounded,
        [AppThemeColors.blueCyan, AppThemeColors.blueMaterial],
        '+${_dadosAtuais['crescimento']}%',
      ),
      _buildSummaryCard(
        'Ticket Médio',
        'R\$ ${_dadosAtuais['ticketMedio'].toStringAsFixed(2)}',
        Icons.receipt_long_rounded,
        [AppThemeColors.blueCyan, AppThemeColors.blueLight],
        '+3.2%',
      ),
      _buildSummaryCard(
        'Categorias',
        '${_categorias.length}',
        Icons.category_rounded,
        [AppThemeColors.blueCyan, AppThemeColors.blueMaterial],
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
                color: AppThemeColors.textSecondary,
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
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
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
                  gradient: const LinearGradient(
                    colors: [AppThemeColors.blueCyan, AppThemeColors.blueMaterial],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: AppThemeColors.surface,
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
                    // ignore: argument_type_not_assignable
                    categoria['icone'],
                    size: 18,
                    // ignore: argument_type_not_assignable
                    color: categoria['cor'],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    (categoria['nome']).toString(),
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
                  // ignore: argument_type_not_assignable
                  color: categoria['cor'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1000),
              // ignore: argument_type_not_assignable
              tween: Tween<double>(begin: 0, end: categoria['percentual'] / 100),
              builder: (context, double value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppThemeColors.textSecondary,
                  // ignore: argument_type_not_assignable
                  valueColor: AlwaysStoppedAnimation<Color>(categoria['cor']),
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
    final topCategories = List<Map<String, dynamic>>.from(_categorias)
      ..sort((a, b) => b['faturamento'].compareTo(a['faturamento']))
      ..take(5);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
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
                  gradient: const LinearGradient(
                    colors: [AppThemeColors.yellowGold, AppThemeColors.warning],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: AppThemeColors.surface,
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
                  AppThemeColors.yellowGold.withValues(alpha: 0.1),
                  AppThemeColors.warning.withValues(alpha: 0.1),
                ],
              )
            : null,
        color: posicao == 1 ? null : AppThemeColors.textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        border: Border.all(
          color: posicao == 1 ? AppThemeColors.yellowGold : AppThemeColors.textSecondary,
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
                    ? [AppThemeColors.yellowGold, AppThemeColors.warning]
                    : posicao == 2
                        ? [AppThemeColors.silver, AppThemeColors.grey900]
                        : posicao == 3
                            ? [AppThemeColors.bronze, AppThemeColors.brownSaddle]
                            : [AppThemeColors.textSecondary, AppThemeColors.grey400],
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
                  color: AppThemeColors.surface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            // ignore: argument_type_not_assignable
            categoria['icone'],
            // ignore: argument_type_not_assignable
            color: categoria['cor'],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (categoria['nome']).toString(),
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
                    color: AppThemeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${categoria['faturamento'].toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 15,
                    mobileFontSize: 14,
                  ),
                  fontWeight: FontWeight.bold,
                  // ignore: argument_type_not_assignable
                  color: categoria['cor'],
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
                  color: AppThemeColors.textSecondary,
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
          color: AppThemeColors.surface,
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
                // ignore: argument_type_not_assignable
                gradient: LinearGradient(colors: categoria['gradiente']),
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
                      color: AppThemeColors.surfaceOverlay20,
                      borderRadius: BorderRadius.circular(
                        isMobile ? 10 : 12,
                      ),
                    ),
                    child: Icon(
                      // ignore: argument_type_not_assignable
                      categoria['icone'],
                      color: AppThemeColors.surface,
                      size: AppSizes.iconLarge.get(isMobile, isTablet),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (categoria['nome']).toString(),
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 18,
                              mobileFontSize: 16,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppThemeColors.surface,
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
                            color: AppThemeColors.surfaceOverlay90,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding.get(isMobile, isTablet), vertical: 6),
                    decoration: BoxDecoration(
                      color: AppThemeColors.surfaceOverlay20,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${categoria['percentual']}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppThemeColors.surface,
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
                          AppThemeColors.blueMaterial,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricBox(
                          'Faturamento',
                          'R\$ ${categoria['faturamento'].toStringAsFixed(0)}',
                          Icons.attach_money_rounded,
                          AppThemeColors.greenMaterial,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricBox(
                          'Ticket Médio',
                          'R\$ ${categoria['ticketMedio'].toStringAsFixed(2)}',
                          Icons.receipt_rounded,
                          AppThemeColors.yellowGold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricBox(
                          'Margem',
                          '${categoria['margemLucro']}%',
                          Icons.show_chart_rounded,
                          AppThemeColors.blueCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: categoria['crescimento'] > 0
                          ? AppThemeColors.successPastel
                          : AppThemeColors.errorPastel,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: categoria['crescimento'] > 0
                            ? AppThemeColors.greenMaterial.withValues(alpha: 0.4)
                            : AppThemeColors.redMain.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoria['crescimento'] > 0
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: categoria['crescimento'] > 0
                              ? AppThemeColors.greenMaterial.withValues(alpha: 0.8)
                              : AppThemeColors.redMain.withValues(alpha: 0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${categoria['crescimento'] > 0 ? '+' : ''}${categoria['crescimento']}% de crescimento',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 14,
                              mobileFontSize: 13,
                            ),
                            fontWeight: FontWeight.bold,
                            color: categoria['crescimento'] > 0
                                ? AppThemeColors.successIcon
                                : AppThemeColors.errorDark,
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
              color: AppThemeColors.textSecondary,
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
      ..sort((a, b) => b['crescimento'].compareTo(a['crescimento']));

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingXxlAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
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
                  gradient: const LinearGradient(
                    colors: [AppThemeColors.greenGradient, AppThemeColors.greenGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: AppThemeColors.surface,
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
    final isPositive = categoria['crescimento'] > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPositive ?  AppThemeColors.successPastel : AppThemeColors.errorPastel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive ? AppThemeColors.successLight : AppThemeColors.errorLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            // ignore: argument_type_not_assignable
            categoria['icone'],
            // ignore: argument_type_not_assignable
            color: categoria['cor'],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              (categoria['nome']).toString(),
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
              color: isPositive ? AppThemeColors.greenMaterial : AppThemeColors.redMain,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  color: AppThemeColors.surface,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${categoria['crescimento'] > 0 ? '+' : ''}${categoria['crescimento']}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.surface,
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
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
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
                  gradient: const LinearGradient(
                    colors: [AppThemeColors.blueCyan, AppThemeColors.blueLight],
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: AppThemeColors.surface,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _categorias.map((cat) {
                final height = (cat['percentual'] / 100) * 180;
                return TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween<double>(begin: 0, end: constraints?.minHeight),
                  builder: (context, double animatedHeight, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${cat['percentual']}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            // ignore: argument_type_not_assignable
                            color: cat['cor'],
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
                              // ignore: argument_type_not_assignable
                              colors: cat['gradiente'],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // ignore: argument_type_not_assignable
                        Icon(cat['icone'], size: 18, color: cat['cor']),
                      ],
                    );
                  },
                );
              }).toList(),
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
    
    // Ordena por faturamento para encontrar líder
    final sortedByFaturamento = List<Map<String, dynamic>>.from(categorias)
      ..sort((a, b) => (b['faturamento'] as num).compareTo(a['faturamento'] as num));
    
    if (sortedByFaturamento.isNotEmpty) {
      final lider = sortedByFaturamento.first;
      insights.add({
        'icon': Icons.star_rounded,
        'text': '${lider['nome']} lidera com ${(lider['percentual'] as num).toStringAsFixed(1)}% do faturamento total',
        'color': AppThemeColors.blueMaterial,
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
          'color': AppThemeColors.greenMaterial,
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
        'color': AppThemeColors.redMain,
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
          'color': AppThemeColors.blueCyan,
        });
      }
    }
    
    // Se não há insights, mostra mensagem padrão
    if (insights.isEmpty) {
      insights.add({
        'icon': Icons.info_rounded,
        'text': 'Cadastre categorias para visualizar insights',
        'color': AppThemeColors.blueMain,
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
        gradient: const LinearGradient(
          colors: [AppThemeColors.primaryPastel, AppThemeColors.infoPastel],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : (isTablet ? 18 : 20),
        ),
        border: Border.all(color: AppThemeColors.primaryLight, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: AppThemeColors.primaryDark,
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
                  color: AppThemeColors.primaryDark,
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
        color: AppThemeColors.surface,
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
                color: AppThemeColors.textPrimary,
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
        icon: const Icon(Icons.file_download_rounded, color: AppThemeColors.greenMaterial, size: 48),
        title: const Text('Exportar Relatório'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecione o formato do relatório:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded, color: AppThemeColors.redMain),
              title: const Text('PDF'),
              subtitle: const Text('Relatório completo em PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gerando relatório PDF...'),
                    backgroundColor: AppThemeColors.greenMaterial,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_rounded, color: AppThemeColors.greenMaterial),
              title: const Text('Excel'),
              subtitle: const Text('Planilha com dados detalhados'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gerando planilha Excel...'),
                    backgroundColor: AppThemeColors.greenMaterial,
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

