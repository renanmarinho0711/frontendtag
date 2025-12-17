import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class HistoricoAjustesScreen extends ConsumerStatefulWidget {
  const HistoricoAjustesScreen({super.key});

  @override
  ConsumerState<HistoricoAjustesScreen> createState() =>
      _HistoricoAjustesScreenState();
}

class _HistoricoAjustesScreenState extends ConsumerState<HistoricoAjustesScreen>
    with ResponsiveCache {
  final TextEditingController _searchController = TextEditingController();

  // ===========================================================================
  // STATE GETTERS - Conectados ao Provider
  // ===========================================================================

  PricingHistoryState get _state => ref.watch(pricingHistoryProvider);
  List<PricingHistoryModel> get _historicoFiltrado => _state.filteredHistory;
  String get _filtroTipo => _state.filtroTipo;
  String get _filtroPeriodo => _state.filtroPeriodo;
  String get _searchQuery => _state.searchQuery;
  bool get _carregando => _state.status == LoadingStatus.loading;
  int get _totalAjustes => _state.totalAjustes;
  int get _aumentos => _state.aumentos;
  int get _reducoes => _state.reducoes;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pricingHistoryProvider.notifier).loadHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: _carregando
            ? _buildLoadingState()
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildModernAppBar()),
                  SliverToBoxAdapter(
                    child: _buildResumoCard(
                        _totalAjustes, _aumentos, _reducoes),
                  ),
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverToBoxAdapter(child: _buildFiltroChips()),
                  _historicoFiltrado.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState())
                      : SliverPadding(
                          padding: EdgeInsets.all(
                            AppSizes.paddingMdAlt.get(isMobile, isTablet),
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildHistoricoCard(
                                  _historicoFiltrado[index], index),
                              childCount: _historicoFiltrado.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  // ===========================================================================
  // LOADING STATE
  // ===========================================================================

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan),
          ),
          const SizedBox(height: 16),
          Text(
            'Carregando histórico...',
            style: TextStyle(
              fontSize: 16,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // APP BAR
  // ===========================================================================

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLgAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 18 : (isTablet ? 19 : 20)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: ThemeColors.of(context).textSecondary,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
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
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
              ),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            ),
            child: Icon(
              Icons.history_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Histórico de Ajustes',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Todas as alterações de preço',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11.5,
                    ),
                    color: ThemeColors.of(context).textSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: ThemeColors.of(context).textSecondary,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
            ),
            onPressed: _mostrarFiltros,
          ),
          IconButton(
            icon: Icon(
              Icons.file_download_rounded,
              color: ThemeColors.of(context).textSecondary,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
            ),
            onPressed: _exportarHistorico,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RESUMO CARD
  // ===========================================================================

  Widget _buildResumoCard(int total, int aumentos, int reducoes) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 18 : (isTablet ? 19 : 20)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.3),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: ThemeColors.of(context).surface,
                size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
              ),
              SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
              Text(
                'Resumo do Perãodo',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                    tabletFontSize: 17,
                  ),
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).surface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
          Row(
            children: [
              Expanded(
                child: _buildResumoItem(Icons.edit_rounded, '$total', 'Total'),
              ),
              SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
              Expanded(
                child: _buildResumoItem(
                    Icons.arrow_upward_rounded, '$aumentos', 'Aumentos'),
              ),
              SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
              Expanded(
                child: _buildResumoItem(
                    Icons.arrow_downward_rounded, '$reducoes', 'Reduções'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(IconData icon, String valor, String label) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay20,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
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
            valor,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 22,
                mobileFontSize: 19,
                tabletFontSize: 20.5,
              ),
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
                tabletFontSize: 11.5,
              ),
              color: ThemeColors.of(context).surfaceOverlay70,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SEARCH BAR
  // ===========================================================================

  Widget _buildSearchBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      padding:
          EdgeInsets.symmetric(horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(isMobile ? 12 : (isTablet ? 13 : 14)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 14,
            mobileFontSize: 13,
            tabletFontSize: 13.5,
          ),
        ),
        decoration: InputDecoration(
          hintText: 'Buscar produto...',
          hintStyle: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 13,
              mobileFontSize: 12,
              tabletFontSize: 12.5,
            ),
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search_rounded,
            color: ThemeColors.of(context).blueCyan,
            size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(pricingHistoryProvider.notifier).setSearchQuery('');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          ref.read(pricingHistoryProvider.notifier).setSearchQuery(value);
        },
      ),
    );
  }

  // ===========================================================================
  // FILTER CHIPS
  // ===========================================================================

  Widget _buildFiltroChips() {
    return Container(
      height: ResponsiveHelper.getResponsiveHeight(
        context,
        mobile: 55,
        tablet: 57.5,
        desktop: 60,
      ),
      margin: EdgeInsets.only(top: AppSizes.spacingBase.get(isMobile, isTablet)),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
        children: [
          _buildFiltroChip('Todos', 'todos', Icons.all_inclusive_rounded),
          _buildFiltroChip('Automãtico', 'automatico', Icons.auto_mode_rounded),
          _buildFiltroChip('Manual', 'manual', Icons.edit_rounded),
          _buildFiltroChip('IA', 'ia', Icons.psychology_rounded),
          _buildFiltroChip('Lote', 'lote', Icons.inventory_rounded),
        ],
      ),
    );
  }

  Widget _buildFiltroChip(String label, String valor, IconData icon) {
    final selecionado = _filtroTipo == valor;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 7,
          tablet: 7.5,
          desktop: 8,
        ),
      ),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 17,
                tablet: 17.5,
                desktop: 18,
              ),
              color:
                  selecionado ? ThemeColors.of(context).surface : ThemeColors.of(context).blueCyan,
            ),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 5,
                tablet: 5.5,
                desktop: 6,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
        selected: selecionado,
        onSelected: (selected) {
          ref.read(pricingHistoryProvider.notifier).setFiltroTipo(valor);
        },
        selectedColor: ThemeColors.of(context).blueCyan,
        backgroundColor: ThemeColors.of(context).surface,
        labelStyle: TextStyle(
          color:
              selecionado ? ThemeColors.of(context).surface : ThemeColors.of(context).blueCyan,
          fontWeight: FontWeight.w600,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 7,
            tablet: 7.5,
            desktop: 8,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HISTORICO CARD
  // ===========================================================================

  Widget _buildHistoricoCard(PricingHistoryModel item, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final cor = item.tipoColor;

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
        margin:
            EdgeInsets.only(bottom: AppSizes.spacingBase.get(isMobile, isTablet)),
        padding: EdgeInsets.all(AppSizes.paddingMdAlt.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(isMobile ? 14 : (isTablet ? 15 : 16)),
          border: Border.all(
            color: cor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).textPrimaryOverlay05,
              blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
                context,
                mobile: 8,
                tablet: 9,
                desktop: 10,
              ),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(item, cor),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildPriceRow(item),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildMotivoRow(item),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            _buildMetaRow(item),
            SizedBox(height: AppSizes.spacingBase.get(isMobile, isTablet)),
            _buildActionButtons(item, cor),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(PricingHistoryModel item, Color cor) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      children: [
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
            color: cor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
          ),
          child: Icon(
            item.tipoIcon,
            color: cor,
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
          ),
        ),
        SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.produtoNome,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 15,
                    mobileFontSize: 14,
                    tabletFontSize: 14.5,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 3,
                  tablet: 3.5,
                  desktop: 4,
                ),
              ),
              Text(
                item.tipoLabel,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                    tabletFontSize: 10.5,
                  ),
                  color: cor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 9,
              tablet: 9.5,
              desktop: 10,
            ),
            vertical: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: 4,
              tablet: 4.5,
              desktop: 5,
            ),
          ),
          decoration: BoxDecoration(
            color: item.isAumento
                ? ThemeColors.of(context).success.withValues(alpha: 0.1)
                : ThemeColors.of(context).error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.isAumento
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 15,
                  tablet: 15.5,
                  desktop: 16,
                ),
                color: item.isAumento
                    ? ThemeColors.of(context).success
                    : ThemeColors.of(context).error,
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
                '${item.variacao > 0 ? '+' : ''}${item.variacao.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 13,
                    mobileFontSize: 12,
                    tabletFontSize: 12.5,
                  ),
                  fontWeight: FontWeight.bold,
                  color: item.isAumento
                      ? ThemeColors.of(context).success
                      : ThemeColors.of(context).error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(PricingHistoryModel item) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'Antes',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                    tabletFontSize: 10.5,
                  ),
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 3,
                  tablet: 3.5,
                  desktop: 4,
                ),
              ),
              Text(
                'R\$ ${item.precoAntigo.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 15,
                    mobileFontSize: 14,
                    tabletFontSize: 14.5,
                  ),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: ThemeColors.of(context).textSecondary,
            size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
          ),
          Column(
            children: [
              Text(
                'Depois',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 11,
                    mobileFontSize: 10,
                    tabletFontSize: 10.5,
                  ),
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 3,
                  tablet: 3.5,
                  desktop: 4,
                ),
              ),
              Text(
                'R\$ ${item.precoNovo.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 15,
                    mobileFontSize: 14,
                    tabletFontSize: 14.5,
                  ),
                  fontWeight: FontWeight.bold,
                  color: item.isAumento
                      ? ThemeColors.of(context).success
                      : ThemeColors.of(context).error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMotivoRow(PricingHistoryModel item) {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 15,
            tablet: 15.5,
            desktop: 16,
          ),
          color: ThemeColors.of(context).textSecondaryOverlay70,
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 5,
            tablet: 5.5,
            desktop: 6,
          ),
        ),
        Expanded(
          child: Text(
            item.motivacao,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 12,
                mobileFontSize: 11,
                tabletFontSize: 11.5,
              ),
              color: ThemeColors.of(context).textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow(PricingHistoryModel item) {
    return Row(
      children: [
        Icon(
          Icons.person_outline_rounded,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 15,
            tablet: 15.5,
            desktop: 16,
          ),
          color: ThemeColors.of(context).textSecondaryOverlay70,
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 5,
            tablet: 5.5,
            desktop: 6,
          ),
        ),
        Text(
          item.usuario,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 12,
              mobileFontSize: 11,
              tabletFontSize: 11.5,
            ),
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.access_time_rounded,
          size: ResponsiveHelper.getResponsiveIconSize(
            context,
            mobile: 15,
            tablet: 15.5,
            desktop: 16,
          ),
          color: ThemeColors.of(context).textSecondary,
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 5,
            tablet: 5.5,
            desktop: 6,
          ),
        ),
        Text(
          _formatarTempo(item.dataAjuste),
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 12,
              mobileFontSize: 11,
              tabletFontSize: 11.5,
            ),
            color: ThemeColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(PricingHistoryModel item, Color cor) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _verDetalhes(item),
            icon: Icon(
              Icons.visibility_rounded,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 17,
                tablet: 17.5,
                desktop: 18,
              ),
            ),
            label: Text(
              'Detalhes',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: cor,
              side: BorderSide(color: cor.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
              ),
            ),
          ),
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 9,
            tablet: 9.5,
            desktop: 10,
          ),
        ),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: item.revertido ? null : () => _reverterAjuste(item),
            icon: Icon(
              item.revertido ? Icons.check_rounded : Icons.undo_rounded,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 17,
                tablet: 17.5,
                desktop: 18,
              ),
            ),
            label: Text(
              item.revertido ? 'Revertido' : 'Reverter',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  item.revertido ? ThemeColors.of(context).textSecondary : ThemeColors.of(context).error,
              side: BorderSide(
                  color: item.revertido
                      ? ThemeColors.of(context).textSecondary
                      : ThemeColors.of(context).error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: AppSizes.iconHeroXl.get(isMobile, isTablet),
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.spacingLg.get(isMobile, isTablet)),
          Text(
            'Nenhum ajuste encontrado',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 18,
                mobileFontSize: 16,
                tabletFontSize: 17,
              ),
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textSecondary,
            ),
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
            'Tente ajustar os filtros',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _formatarTempo(DateTime data) {
    final now = DateTime.now();
    final diff = now.difference(data);

    if (diff.inHours < 1) return '${diff.inMinutes} min atrãs';
    if (diff.inHours < 24) return '${diff.inHours}hã atrãs';
    if (diff.inDays == 1) return '1 dia atrãs';
    if (diff.inDays < 7) return '${diff.inDays} dias atrãs';
    return '${(diff.inDays / 7).floor()} sem atrãs';
  }

  // ===========================================================================
  // ACTIONS
  // ===========================================================================

  void _mostrarFiltros() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: ResponsiveHelper.getResponsiveWidth(
                  context,
                  mobile: 35,
                  tablet: 37.5,
                  desktop: 40,
                ),
                height: isMobile ? 3.5 : 4,
                decoration: BoxDecoration(
                  color: ThemeColors.of(context).textSecondary,
                  borderRadius: AppRadius.xxxs,
                ),
              ),
            ),
            SizedBox(height: AppSizes.spacingLg.get(isMobile, isTablet)),
            Text(
              'Filtrar por Perãodo',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 18,
                  mobileFontSize: 16,
                  tabletFontSize: 17,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.spacingMdAlt.get(isMobile, isTablet)),
            Wrap(
              spacing: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 9,
                tablet: 9.5,
                desktop: 10,
              ),
              children: [
                _buildPeriodoChip('últimas 24h', '24h'),
                _buildPeriodoChip('últimos 7 dias', '7dias'),
                _buildPeriodoChip('últimos 30 dias', '30dias'),
                _buildPeriodoChip('Todos', 'todos'),
              ],
            ),
            SizedBox(height: AppSizes.spacingLg.get(isMobile, isTablet)),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodoChip(String label, String valor) {
    final selecionado = _filtroPeriodo == valor;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            baseFontSize: 13,
            mobileFontSize: 12,
            tabletFontSize: 12.5,
          ),
        ),
      ),
      selected: selecionado,
      onSelected: (selected) {
        ref.read(pricingHistoryProvider.notifier).setFiltroPeriodo(valor);
        Navigator.pop(context);
      },
      selectedColor: ThemeColors.of(context).blueCyan,
      backgroundColor: ThemeColors.of(context).textSecondary,
      labelStyle: TextStyle(
        color: selecionado ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _verDetalhes(PricingHistoryModel item) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: 7,
                  tablet: 7.5,
                  desktop: 8,
                ),
              ),
              decoration: BoxDecoration(
                color: item.tipoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(isMobile ? 7 : 8),
              ),
              child: Icon(
                item.tipoIcon,
                color: item.tipoColor,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
            ),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            const Expanded(
              child: Text('Detalhes do Ajuste'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetalheItem('Produto', item.produtoNome),
            _buildDetalheItem('Tipo', item.tipoLabel),
            _buildDetalheItem(
                'PREÇO Anterior', 'R\$ ${item.precoAntigo.toStringAsFixed(2)}'),
            _buildDetalheItem(
                'PREÇO Novo', 'R\$ ${item.precoNovo.toStringAsFixed(2)}'),
            _buildDetalheItem('VariAção', '${item.variacao.toStringAsFixed(1)}%'),
            _buildDetalheItem('MotivAção', item.motivacao),
            _buildDetalheItem('Usuário', item.usuario),
            _buildDetalheItem('Data/Hora', _formatarTempo(item.dataAjuste)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalheItem(String label, String valor) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 9,
          tablet: 9.5,
          desktop: 10,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 80,
              tablet: 85,
              desktop: 90,
            ),
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
                fontWeight: FontWeight.w600,
                color: ThemeColors.of(context).textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reverterAjuste(PricingHistoryModel item) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: ThemeColors.of(context).error,
              size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            const Text('Reverter Ajuste'),
          ],
        ),
        content: Text(
          'Deseja reverter o ajuste de preço de "${item.produtoNome}"?\n\n'
          'O preço voltarã de R\$ ${item.precoNovo.toStringAsFixed(2)} para R\$ ${item.precoAntigo.toStringAsFixed(2)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(pricingHistoryProvider.notifier).reverterAjuste(item.id);
              Navigator.pop(context);
              _showSnackBar(
                'Ajuste revertido com sucesso',
                Icons.check_circle_rounded,
                ThemeColors.of(context).success,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              foregroundColor: ThemeColors.of(context).surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
            ),
            child: const Text('Reverter'),
          ),
        ],
      ),
    );
  }

  void _exportarHistorico() {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.file_download_rounded,
              color: ThemeColors.of(context).blueCyan,
              size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            const Text('Exportar Histórico'),
          ],
        ),
        content: const Text('Escolha o formato para exportAção:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(
                'Exportando relatãrio em PDF...',
                Icons.picture_as_pdf_rounded,
                ThemeColors.of(context).blueCyan,
              );
            },
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text('PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              foregroundColor: ThemeColors.of(context).surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(
                'Exportando relatãrio em Excel...',
                Icons.table_chart_rounded,
                ThemeColors.of(context).success,
              );
            },
            icon: const Icon(Icons.table_chart_rounded),
            label: const Text('Excel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).success,
              foregroundColor: ThemeColors.of(context).surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, IconData icon, Color backgroundColor) {
    final isMobile = ResponsiveHelper.isMobile(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            SizedBox(width: AppSizes.spacingBase.get(isMobile, isTablet)),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        ),
      ),
    );
  }
}






