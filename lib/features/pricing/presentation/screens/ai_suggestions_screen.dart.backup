import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class SugestoesIaScreen extends ConsumerStatefulWidget {
  const SugestoesIaScreen({super.key});

  @override
  ConsumerState<SugestoesIaScreen> createState() => _SugestoesIaScreenState();
}

class _SugestoesIaScreenState extends ConsumerState<SugestoesIaScreen>
    with ResponsiveCache {
  // ===========================================================================
  // STATE GETTERS - Conectados ao Provider
  // ===========================================================================

  AiSuggestionsState get _state => ref.watch(aiSuggestionsProvider);
  List<AiSuggestionModel> get _sugestoesFiltradas => _state.filteredSuggestions;
  String get _filtroTipo => _state.filtroTipo;
  bool get _carregando =>
      _state.status == LoadingStatus.loading || _state.regenerando;
  int get _aumentos => _state.aumentos;
  int get _reducoes => _state.reducoes;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiSuggestionsProvider.notifier).loadSuggestions();
    });
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernAppBar(),
            Expanded(
              child: _carregando
                  ? _buildLoadingState()
                  : _sugestoesFiltradas.isEmpty
                      ? _buildEmptyState()
                      : CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: _buildResumoCard(_aumentos, _reducoes),
                            ),
                            SliverToBoxAdapter(
                              child: _buildFilterBar(),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.all(
                                AppSizes.paddingMdAlt.get(isMobile, isTablet),
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: AppSizes.spacingBase
                                            .get(isMobile, isTablet),
                                      ),
                                      child: _buildSugestaoCard(
                                          _sugestoesFiltradas[index], index),
                                    );
                                  },
                                  childCount: _sugestoesFiltradas.length,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: _state.suggestions.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _aplicarTodasSugestoes,
              icon: Icon(
                Icons.done_all_rounded,
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              label: Text(
                'Aplicar Todas',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 14,
                    mobileFontSize: 13,
                    tabletFontSize: 13.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              backgroundColor: ThemeColors.of(context).blueCyan,
            )
          : null,
    );
  }

  // ===========================================================================
  // APP BAR
  // ===========================================================================

  Widget _buildModernAppBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLgAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 18 : (isTablet ? 19 : 20),
        ),
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
                size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingMdAlt.get(isMobile, isTablet),
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
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 10 : 12,
              ),
            ),
            child: Icon(
              Icons.psychology_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sugestões da IA',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 18,
                      mobileFontSize: 16,
                      tabletFontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Inteligãncia artificial',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 12,
                      mobileFontSize: 11,
                      tabletFontSize: 11.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    color: ThemeColors.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: _state.regenerando
                ? SizedBox(
                    width: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                    height: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan),
                    ),
                  )
                : Icon(
                    Icons.refresh_rounded,
                    color: ThemeColors.of(context).textSecondary,
                    size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
                  ),
            onPressed:
                _state.regenerando ? null : _regenerarSugestoes,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RESUMO CARD
  // ===========================================================================

  Widget _buildResumoCard(int aumentos, int reducoes) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.3),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
                  color: ThemeColors.of(context).surfaceOverlay20,
                  borderRadius: BorderRadius.circular(
                    isMobile ? 10 : 12,
                  ),
                ),
                child: Icon(
                  Icons.psychology_rounded,
                  color: ThemeColors.of(context).surface,
                  size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anãlise Inteligente',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 16,
                          mobileFontSize: 15,
                          tabletFontSize: 15.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).surface,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 2,
                        tablet: 2.5,
                        desktop: 2,
                      ),
                    ),
                    Text(
                      'Baseado em IA e Machine Learning',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 11,
                          mobileFontSize: 10,
                          tabletFontSize: 10.5,
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
            height: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildResumoItem(
                  Icons.trending_up_rounded,
                  '$aumentos',
                  'Aumentos',
                ),
              ),
              SizedBox(
                width: AppSizes.spacingBase.get(isMobile, isTablet),
              ),
              Expanded(
                child: _buildResumoItem(
                  Icons.trending_down_rounded,
                  '$reducoes',
                  'Reduções',
                ),
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
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 9,
          tablet: 9.5,
          desktop: 10,
        ),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surfaceOverlay15,
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
            size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
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
            valor,
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
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 10,
                mobileFontSize: 9,
                tabletFontSize: 9.5,
              ),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).surfaceOverlay70,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FILTER BAR
  // ===========================================================================

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      color: ThemeColors.of(context).surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterChip('Todos', 'todos', Icons.list_rounded),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            _buildFilterChip('Aumentos', 'aumento', Icons.trending_up_rounded),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            _buildFilterChip('Reduções', 'reducao', Icons.trending_down_rounded),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            _buildFilterChip('Manter', 'manutencao', Icons.horizontal_rule_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _filtroTipo == value;
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: () => ref.read(aiSuggestionsProvider.notifier).setFiltroTipo(value),
      borderRadius: BorderRadius.circular(
        isMobile ? 18 : 20,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm.get(isMobile, isTablet),
          vertical: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: 7,
            tablet: 7.5,
            desktop: 8,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeColors.of(context).blueCyan.withValues(alpha: 0.15)
              : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(
            isMobile ? 18 : 20,
          ),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).blueCyan : ThemeColors.of(context).transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 15,
                tablet: 15.5,
                desktop: 16,
              ),
              color: isSelected
                  ? ThemeColors.of(context).blueCyan
                  : ThemeColors.of(context).textSecondary,
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
                overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? ThemeColors.of(context).blueCyan
                    : ThemeColors.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SUGESTAO CARD
  // ===========================================================================

  Widget _buildSugestaoCard(AiSuggestionModel sugestao, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final cor = sugestao.tipoColor;

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
            color: cor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: cor.withValues(alpha: 0.1),
              blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
                context,
                mobile: 12,
                tablet: 13.5,
                desktop: 15,
              ),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCardHeader(sugestao, cor),
            Padding(
              padding: EdgeInsets.all(
                AppSizes.paddingMdAlt.get(isMobile, isTablet),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceComparison(sugestao, cor),
                  if (sugestao.variacao != 0) ...[
                    SizedBox(
                      height: AppSizes.spacingBase.get(isMobile, isTablet),
                    ),
                    _buildVariacaoChip(sugestao, cor),
                  ],
                  SizedBox(
                    height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  _buildMotivo(sugestao),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  _buildImpactoRow(sugestao),
                  SizedBox(
                    height: AppSizes.spacingBase.get(isMobile, isTablet),
                  ),
                  _buildActionButtons(sugestao, cor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(AiSuggestionModel sugestao, Color cor) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(
        AppSizes.paddingMdAlt.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            isMobile ? 12 : 14,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
              gradient: LinearGradient(
                colors: [cor, cor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(
                isMobile ? 8 : 10,
              ),
            ),
            child: Icon(
              sugestao.tipoIcon,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumAlt.get(isMobile, isTablet),
            ),
          ),
          SizedBox(
            width: AppSizes.spacingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sugestao.produtoNome,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                      mobileFontSize: 15,
                      tabletFontSize: 15.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 13,
                        tablet: 13.5,
                        desktop: 14,
                      ),
                      color: ThemeColors.of(context).blueCyan.withValues(alpha: 0.7),
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
                      'Confiança: ${sugestao.confianca}%',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          baseFontSize: 12,
                          mobileFontSize: 11,
                          tabletFontSize: 11.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                        color: ThemeColors.of(context).primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceComparison(AiSuggestionModel sugestao, Color cor) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PREÇO Atual',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                    tabletFontSize: 11.5,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                'R\$ ${sugestao.precoAtual.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 18,
                    mobileFontSize: 16,
                    tabletFontSize: 17,
                  ),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).textSecondaryOverlay80,
                  decoration: sugestao.tipo != 'manutencao'
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_rounded,
          color: cor,
          size: AppSizes.iconLargeAlt.get(isMobile, isTablet),
        ),
        SizedBox(
          width: AppSizes.spacingBase.get(isMobile, isTablet),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PREÇO Sugerido',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 12,
                    mobileFontSize: 11,
                    tabletFontSize: 11.5,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                'R\$ ${sugestao.precoSugerido.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    baseFontSize: 20,
                    mobileFontSize: 18,
                    tabletFontSize: 19,
                  ),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: cor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVariacaoChip(AiSuggestionModel sugestao, Color cor) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 9,
          tablet: 9.5,
          desktop: 10,
        ),
        vertical: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 5,
          tablet: 5.5,
          desktop: 6,
        ),
      ),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          isMobile ? 7 : 8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            sugestao.variacao > 0
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: ResponsiveHelper.getResponsiveIconSize(
              context,
              mobile: 15,
              tablet: 15.5,
              desktop: 16,
            ),
            color: cor,
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
            '${sugestao.variacao > 0 ? '+' : ''}${sugestao.variacao.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13.5,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivo(AiSuggestionModel sugestao) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_rounded,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 17,
                tablet: 17.5,
                desktop: 18,
              ),
              color: ThemeColors.of(context).orangeAmber.withValues(alpha: 0.8),
            ),
            SizedBox(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 7,
                tablet: 7.5,
                desktop: 8,
              ),
            ),
            Text(
              'Motivo:',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 5,
            tablet: 5.5,
            desktop: 6,
          ),
        ),
        Text(
          sugestao.motivo,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 13,
              mobileFontSize: 12,
              tabletFontSize: 12.5,
            ),
            color: ThemeColors.of(context).textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactoRow(AiSuggestionModel sugestao) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _buildImpactoItem('Vendas', sugestao.impactoVendas),
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
          child: _buildImpactoItem('Margem', sugestao.impactoMargem),
        ),
      ],
    );
  }

  Widget _buildImpactoItem(String label, String valor) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(
          context,
          mobile: 9,
          tablet: 9.5,
          desktop: 10,
        ),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).textSecondary,
        borderRadius: BorderRadius.circular(
          isMobile ? 7 : 8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 11,
                mobileFontSize: 10,
                tabletFontSize: 10.5,
              ),
              overflow: TextOverflow.ellipsis,
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
            valor,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 14,
                mobileFontSize: 13,
                tabletFontSize: 13.5,
              ),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AiSuggestionModel sugestao, Color cor) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _rejeitarSugestao(sugestao),
            icon: Icon(
              Icons.close_rounded,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 17,
                tablet: 17.5,
                desktop: 18,
              ),
            ),
            label: Text(
              'Rejeitar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: ThemeColors.of(context).textSecondary,
              side: BorderSide(color: ThemeColors.of(context).textSecondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 8 : 10,
                ),
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
          child: ElevatedButton.icon(
            onPressed: () => _aplicarSugestao(sugestao),
            icon: Icon(
              Icons.check_rounded,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 17,
                tablet: 17.5,
                desktop: 18,
              ),
            ),
            label: Text(
              'Aplicar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 13,
                  mobileFontSize: 12,
                  tabletFontSize: 12.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: cor,
              foregroundColor: ThemeColors.of(context).surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 8 : 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STATES
  // ===========================================================================

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(ThemeColors.of(context).blueCyan),
          ),
          SizedBox(
            height: AppSizes.spacingLg.get(isMobile, isTablet),
          ),
          Text(
            'Analisando produtos...',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 15,
                tabletFontSize: 15.5,
              ),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: AppSizes.iconHeroXl.get(isMobile, isTablet),
            color: ThemeColors.of(context).success,
          ),
          SizedBox(
            height: AppSizes.spacingMdAlt.get(isMobile, isTablet),
          ),
          Text(
            'Nenhuma suGestão nesta categoria',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                baseFontSize: 16,
                mobileFontSize: 15,
                tabletFontSize: 15.5,
              ),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACTIONS
  // ===========================================================================

  void _regenerarSugestoes() {
    ref.read(aiSuggestionsProvider.notifier).regenerarSugestoes().then((_) {
      if (mounted) {
        _showSnackBar(
          'Sugestões atualizadas pela IA',
          Icons.auto_awesome_rounded,
          ThemeColors.of(context).blueCyan,
        );
      }
    });
  }

  void _aplicarSugestao(AiSuggestionModel sugestao) {
    final isMobile = ResponsiveHelper.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 18 : 20,
          ),
        ),
        title: Text(
          'Aplicar SuGestão',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Text(
          'Alterar preço de "${sugestao.produtoNome}" para R\$ ${sugestao.precoSugerido.toStringAsFixed(2)}?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13.5,
            ),
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
                  tabletFontSize: 13.5,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(aiSuggestionsProvider.notifier)
                  .aplicarSugestao(sugestao.id);
              Navigator.pop(context);
              _showSnackBar(
                'PREÇO aplicado com sucesso',
                Icons.check_circle_rounded,
                ThemeColors.of(context).success,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: sugestao.tipoColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
            ),
            child: Text(
              'Aplicar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _rejeitarSugestao(AiSuggestionModel sugestao) {
    ref.read(aiSuggestionsProvider.notifier).rejeitarSugestao(sugestao.id);
    _showSnackBar(
      'SuGestão rejeitada',
      Icons.info_rounded,
      ThemeColors.of(context).textSecondary,
    );
  }

  void _aplicarTodasSugestoes() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final total = _state.suggestions.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 18 : 20,
          ),
        ),
        icon: Icon(
          Icons.done_all_rounded,
          color: ThemeColors.of(context).blueCyan,
          size: AppSizes.iconHeroSm.get(isMobile, isTablet),
        ),
        title: Text(
          'Aplicar Todas',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 18,
              mobileFontSize: 16,
              tabletFontSize: 17,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        content: Text(
          'Aplicar $total sugestões da IA automaticamente?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
              tabletFontSize: 13.5,
            ),
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
                  tabletFontSize: 13.5,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(aiSuggestionsProvider.notifier).aplicarTodasSugestoes();
              Navigator.pop(context);
              _showSnackBar(
                '$total sugestões aplicadas',
                Icons.check_circle_rounded,
                ThemeColors.of(context).success,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).blueCyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  isMobile ? 10 : 12,
                ),
              ),
            ),
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 13,
                  tabletFontSize: 13.5,
                ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconMediumSmall.get(isMobile, isTablet),
            ),
            SizedBox(
              width: AppSizes.spacingBase.get(isMobile, isTablet),
            ),
            Expanded(
              child: Text(
                message,
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
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isMobile ? 10 : 12,
          ),
        ),
      ),
    );
  }
}





