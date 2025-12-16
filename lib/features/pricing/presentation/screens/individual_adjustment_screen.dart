import 'package:tagbean/core/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/features/pricing/data/models/pricing_models.dart';
import 'package:tagbean/features/pricing/presentation/providers/pricing_provider.dart';

class AjusteIndividualScreen extends ConsumerStatefulWidget {
  const AjusteIndividualScreen({super.key});

  @override
  ConsumerState<AjusteIndividualScreen> createState() => _AjusteIndividualScreenState();
}

class _AjusteIndividualScreenState extends ConsumerState<AjusteIndividualScreen> with ResponsiveCache {
  final TextEditingController _buscaController = TextEditingController();

  // Getters conectados ao Provider
  IndividualAdjustmentState get _state => ref.watch(individualAdjustmentProvider);
  List<PricingProductModel> get _produtosFiltrados => _state.filteredProdutos;
  String get _filtroCategoria => _state.filterCategoria;
  // NOTA: _ordenacao removido (morto)
  bool get _isLoading => _state.status == LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(individualAdjustmentProvider.notifier).loadProdutos();
    });
    
    _buscaController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(individualAdjustmentProvider.notifier).setSearchQuery(_buscaController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      backgroundColor: ThemeColors.of(context).surface,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildModernAppBar()),
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverToBoxAdapter(child: _buildFilters()),
                  _produtosFiltrados.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState())
                      : SliverPadding(
                          padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                                context,
                                mobile: 1,
                                tablet: 2,
                                desktop: 3,
                              ),
                              crossAxisSpacing: AppSizes.paddingBaseLg.get(isMobile, isTablet),
                              mainAxisSpacing: AppSizes.paddingBaseLg.get(isMobile, isTablet),
                              childAspectRatio: isMobile ? 0.95 : (isTablet ? 1.05 : 1.15),
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _buildProdutoCard(_produtosFiltrados[index], index);
                              },
                              childCount: _produtosFiltrados.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).textSecondary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajuste Individual',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Edi��o produto a produto',
                  style: TextStyle(fontSize: 11, color: ThemeColors.of(context).textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).primary,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay10,
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 8, tablet: 10, desktop: 12),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _buscaController,
        style: TextStyle(
          color: ThemeColors.of(context).surface,
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
        ),
        decoration: InputDecoration(
          hintText: 'Buscar produto por nome ou c�digo...',
          hintStyle: TextStyle(
            color: ThemeColors.of(context).surfaceOverlay70,
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: ThemeColors.of(context).surface,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          suffixIcon: _buscaController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: ThemeColors.of(context).surface,
                    size: AppSizes.iconMedium.get(isMobile, isTablet),
                  ),
                  onPressed: () {
                    _buscaController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: ThemeColors.of(context).surfaceOverlay20,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isMobile ? 10 : (isTablet ? 11 : 12)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
            vertical: AppSizes.paddingSm.get(isMobile, isTablet),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      color: ThemeColors.of(context).surface,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: ResponsiveHelper.getResponsivePadding(context, mobile: 38, tablet: 40, desktop: 42),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) => SizedBox(
                  width: AppSizes.paddingXs.get(isMobile, isTablet),
                ),
                itemBuilder: (context, index) {
                  final filters = [
                    {'label': 'Todas', 'value': 'todas'},
                    {'label': 'Bebidas', 'value': 'Bebidas'},
                    {'label': 'Alimentos', 'value': 'Alimentos'},
                    {'label': 'Limpeza', 'value': 'Limpeza'},
                  ];
                  return _buildFilterChip(filters[index]['label']!, filters[index]['value']!);
                },
              ),
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort_rounded, size: AppSizes.iconMediumLargeFloat.get(isMobile, isTablet)),
            onSelected: (value) {
              ref.read(individualAdjustmentProvider.notifier).setSortBy(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'nome',
                child: Text(
                  'Nome',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'preco',
                child: Text(
                  'Pre�o',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'margem',
                child: Text(
                  'Margem',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filtroCategoria == value;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: () {
        ref.read(individualAdjustmentProvider.notifier).setFilterCategoria(value);
      },
      borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 7, tablet: 7.5, desktop: 8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.of(context).primary : ThemeColors.of(context).textSecondaryOverlay10,
          borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
            overflow: TextOverflow.ellipsis,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildProdutoCard(PricingProductModel produto, int index) {
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
          borderRadius: BorderRadius.circular(isMobile ? 12 : (isTablet ? 14 : 16)),
          border: Border.all(
            color: produto.cor.withValues(alpha: 0.3),
            width: isMobile ? 1.5 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: produto.cor.withValues(alpha: 0.1),
              blurRadius: ResponsiveHelper.getResponsiveBlurRadius(context, mobile: 8, tablet: 10, desktop: 12),
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingSmLg.get(isMobile, isTablet)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppSizes.paddingXsLg.get(isMobile, isTablet)),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [produto.cor, produto.cor.withValues(alpha: 0.7)],
                                ),
                                borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                              ),
                              child: Icon(
                                Icons.shopping_basket_rounded,
                                color: ThemeColors.of(context).surface,
                                size: AppSizes.iconSmallMedium.get(isMobile, isTablet),
                              ),
                            ),
                            SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                            Text(
                              produto.nome,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 13, tabletFontSize: 14),
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 6, desktop: 7),
                                vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                              ),
                              decoration: BoxDecoration(
                                color: produto.cor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppSizes.paddingMicro.get(isMobile, isTablet)),
                              ),
                              child: Text(
                                'ID: ${produto.id}',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                                  fontWeight: FontWeight.bold,
                                  color: produto.cor,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSizes.paddingXs.get(isMobile, isTablet)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 7, desktop: 8),
                                vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                              ),
                              decoration: BoxDecoration(
                                color: ThemeColors.of(context).textSecondaryOverlay10,
                                borderRadius: BorderRadius.circular(AppSizes.paddingMicro.get(isMobile, isTablet)),
                              ),
                              child: Text(
                                produto.categoria,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                                  color: ThemeColors.of(context).textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSizes.paddingSmLg.get(isMobile, isTablet)),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCompactMetric(
                              'Pre�o Atual',
                              'R\$ ${produto.precoAtual.toStringAsFixed(2)}',
                              Icons.attach_money_rounded,
                              produto.cor,
                            ),
                            SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                            _buildCompactMetric(
                              'Margem',
                              '${produto.margemAtual.toStringAsFixed(1)}%',
                              Icons.trending_up_rounded,
                              _getMargemColor(produto.margemAtual),
                            ),
                            SizedBox(height: AppSizes.paddingXsAlt.get(isMobile, isTablet)),
                            _buildCompactMetric(
                              'Custo',
                              'R\$ ${produto.custo.toStringAsFixed(2)}',
                              Icons.inventory_2_rounded,
                              ThemeColors.of(context).textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 6, tablet: 8, desktop: 10),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _editarPreco(produto),
                    icon: Icon(Icons.edit_rounded, size: AppSizes.iconTiny.get(isMobile, isTablet)),
                    label: Text(
                      'Editar Pre�o',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: produto.cor,
                      foregroundColor: ThemeColors.of(context).surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.padding2Xl.get(isMobile, isTablet),
                        vertical: AppSizes.paddingXs.get(isMobile, isTablet),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompactMetric(String label, String value, IconData icon, Color color) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
        SizedBox(
          width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 12, mobileFontSize: 11, tabletFontSize: 11.5),
                  overflow: TextOverflow.ellipsis,
                  color: ThemeColors.of(context).textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 15, mobileFontSize: 13, tabletFontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: AppSizes.iconHeroXl.get(isMobile, isTablet),
            color: ThemeColors.of(context).textSecondary,
          ),
          SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
          Text(
            'Nenhum produto encontrado',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8),
          ),
          Text(
            'Tente ajustar os filtros de busca',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
              overflow: TextOverflow.ellipsis,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMargemColor(double margem) {
    if (margem >= 40) return ThemeColors.of(context).success;
    if (margem >= 25) return ThemeColors.of(context).orangeMaterial;
    return ThemeColors.of(context).error;
  }

  void _editarPreco(PricingProductModel produto) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final precoController = TextEditingController(text: produto.precoAtual.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_rounded, color: produto.cor, size: AppSizes.iconLarge.get(isMobile, isTablet)),
            SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
            Expanded(
              child: Text(
                'Editar Pre�o',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.nome,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 16, mobileFontSize: 15, tabletFontSize: 15.5),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            TextField(
              controller: precoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
              ),
              decoration: InputDecoration(
                labelText: 'Novo Pre�o',
                labelStyle: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                ),
                prefixText: 'R\$ ',
                prefixStyle: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                ),
              ),
            ),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).textSecondaryOverlay10,
                borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Custo:',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'R\$ ${produto.custo.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Margem Atual:',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${produto.margemAtual.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getMargemColor(produto.margemAtual),
                          overflow: TextOverflow.ellipsis,
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.paddingMdAlt.get(isMobile, isTablet)),
            Text(
              'Ajuste R�pido:',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 13, mobileFontSize: 12, tabletFontSize: 12.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildQuickButton(produto.id, '-10%', -10, ThemeColors.of(context).error, dialogContext)),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickButton(produto.id, '-5%', -5, ThemeColors.of(context).orangeMaterial, dialogContext)),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickButton(produto.id, '+5%', 5, ThemeColors.of(context).success, dialogContext)),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickButton(produto.id, '+10%', 10, ThemeColors.of(context).primary, dialogContext)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final novoPreco = double.tryParse(precoController.text.replaceAll(',', '.'));
              if (novoPreco != null && novoPreco > 0) {
                await ref.read(individualAdjustmentProvider.notifier).updateProdutoPreco(produto.id, novoPreco);
                
                if (mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                          const Text('Pre�o atualizado com sucesso'),
                        ],
                      ),
                      backgroundColor: ThemeColors.of(context).success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: produto.cor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 10 : 12)),
            ),
            child: Text(
              'Salvar',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 14, mobileFontSize: 13, tabletFontSize: 13.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String produtoId, String label, double percentual, Color color, BuildContext dialogContext) {
    return InkWell(
      onTap: () async {
        await ref.read(individualAdjustmentProvider.notifier).aplicarAjusteRapido(produtoId, percentual);
        
        if (mounted) {
          Navigator.pop(dialogContext);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 18),
                  const SizedBox(width: 8),
                  Text('Pre�o ajustado $label'),
                ],
              ),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}








