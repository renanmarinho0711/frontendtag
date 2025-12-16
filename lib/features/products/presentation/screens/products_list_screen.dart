import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/features/products/presentation/screens/product_add_screen.dart';
import 'package:tagbean/features/products/presentation/screens/product_edit_screen.dart';
import 'package:tagbean/features/products/presentation/screens/product_qr_screen.dart';
import 'package:tagbean/features/products/presentation/screens/product_details_screen.dart';
import 'package:tagbean/features/products/presentation/screens/products_import_screen.dart';
import 'package:tagbean/features/products/data/models/product_models.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/module_gradients.dart';
import 'package:tagbean/features/products/presentation/providers/products_state_provider.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';
import 'package:tagbean/core/enums/loading_status.dart';

class ProdutosListaScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  final String? initialFilter;
  
  const ProdutosListaScreen({super.key, this.onBack, this.initialFilter});

  @override
  ConsumerState<ProdutosListaScreen> createState() => _ProdutosListaScreenState();
}

class _ProdutosListaScreenState extends ConsumerState<ProdutosListaScreen> 
    with SingleTickerProviderStateMixin {
  // Keys e Controllers
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  Timer? _debounceTimer;
  
  // Estado local (apenas UI)
  // NOTA: _fabExpanded removido (morto)
  bool _showInfoCard = true;
  
  // Estado de seleo mltipla
  bool _isSelectionMode = false;
  Set<String> _selectedProductIds = {};
  
  // Estado de ordenao e loading
  String _sortMode = 'recentes'; // 'a-z', 'z-a', 'preco_crescente', 'preco_decrescente', 'recentes'
  bool _isLoadingMore = false;

  // Acesso rpido ao state do provider
  ProductsListState get _productsState => ref.watch(productsListRiverpodProvider);
  ProductsListNotifier get _productsNotifier => ref.read(productsListRiverpodProvider.notifier);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    
    _scrollController.addListener(_onScroll);
    _loadInfoCardPreference();
    
    // Carrega produtos ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Aplica filtro inicial se fornecido
      if (widget.initialFilter != null) {
        _applyInitialFilter(widget.initialFilter!);
      }
      _productsNotifier.loadProducts(refresh: true);
    });
  }

  void _applyInitialFilter(String filter) {
    switch (filter) {
      case 'com_tag':
        _productsNotifier.setFilterStatus('com_tag');
        break;
      case 'sem_tag':
        _productsNotifier.setFilterStatus('sem_tag');
        break;
      case 'sem_preco':
        _productsNotifier.setFilterStatus('sem_preco');
        break;
      default:
        if (filter.startsWith('categoria:')) {
          final categoria = filter.substring(10);
          _productsNotifier.setFilterCategoria(categoria);
        }
        break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInfoCardPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showInfoCard = !(prefs.getBool('produtos_info_card_dismissed') ?? false);
    });
  }

  Future<void> _dismissInfoCard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('produtos_info_card_dismissed', true);
    setState(() {
      _showInfoCard = false;
    });
  }

  // Mtodos de seleo mltipla
  void _enterSelectionMode(ProductModel product) {
    setState(() {
      _isSelectionMode = true;
      _selectedProductIds = {product.id.toString()};
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedProductIds = {};
    });
  }

  void _toggleProductSelection(ProductModel product) {
    final productId = product.id.toString();
    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
        if (_selectedProductIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedProductIds.add(productId);
      }
    });
  }

  void _selectAll() {
    final products = _productsState.filteredProducts;
    setState(() {
      _selectedProductIds = products.map((p) => p.id.toString()).toSet();
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedProductIds = {};
      _isSelectionMode = false;
    });
  }

  List<ProductModel> get _selectedProducts {
    return _productsState.filteredProducts
        .where((p) => _selectedProductIds.contains(p.id.toString()))
        .toList();
  }

  // Aes em lote
  void _showBatchBindTagsDialog() {
    // Navega para tela de associao QR com contexto de batch
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProdutosAssociarQRScreen()),
    );
    _exitSelectionMode();
  }

  void _showBatchEditPriceDialog() {
    final currentStore = ref.read(currentStoreProvider);
    final storeId = currentStore?.id;
    
    showDialog(
      context: context,
      builder: (context) => _BatchPriceDialog(
        selectedProducts: _selectedProducts,
        onSave: (value, mode) async {
          final productIds = _selectedProductIds.toList();
          bool success = false;
          
          switch (mode) {
            case 'fixed':
              success = await _productsNotifier.updatePricesInBatch(
                productIds: productIds,
                fixedPrice: value,
                storeId: storeId,
              );
              break;
            case 'percentage_increase':
              success = await _productsNotifier.updatePricesInBatch(
                productIds: productIds,
                percentageIncrease: value,
                storeId: storeId,
              );
              break;
            case 'percentage_decrease':
              success = await _productsNotifier.updatePricesInBatch(
                productIds: productIds,
                percentageDecrease: value,
                storeId: storeId,
              );
              break;
          }
          
          _exitSelectionMode();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success 
                    ? 'Preo atualizado para ${productIds.length} produtos'
                    : 'Erro ao atualizar preos',
                ),
                backgroundColor: success ? ThemeColors.of(context).success : ThemeColors.of(context).error,
    final currentStore = ref.read(currentStoreProvider);
    final storeId = currentStore?.id;
    
    // Extrai categorias nicas dos produtos carregados
    final categories = _productsState.products
        .map((p) => p.categoria)
        .toSet()
        .toList()
      ..sort();
    
    showDialog(
      context: context,
      builder: (context) => _BatchCategoryDialog(
        selectedCount: _selectedProducts.length,
        categories: categories,
        onSave: (categoriaId) async {
          final productIds = _selectedProductIds.toList();
          final success = await _productsNotifier.updateCategoryInBatch(
            productIds: productIds,
            categoriaId: categoriaId,
            storeId: storeId,
          );
          
          _exitSelectionMode();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success 
                    ? 'Categoria atualizada para ${productIds.length} produtos'
                    : 'Erro ao atualizar categoria',
                ),
                backgroundColor: success ? ThemeColors.of(context).success : ThemeColors.of(context).error,
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: ThemeColors.of(context).error),
            const SizedBox(width: AppSpacing.sm),
            const Text('Excluir Produtos'),
          ],
        ),
        content: Text(
          'Tem certeza que deseja excluir ${_selectedProducts.length} produtos?\n\nEsta ao no pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final productIds = _selectedProductIds.toList();
              final deletedCount = await _productsNotifier.deleteProductsInBatch(productIds);
              
              _exitSelectionMode();
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      deletedCount > 0 
                        ? '$deletedCount produtos excludos'
                        : 'Erro ao excluir produtos',
                    ),
                    backgroundColor: deletedCount > 0 ? ThemeColors.of(context).success : ThemeColors.of(context).error,
              backgroundColor: ThemeColors.of(context).errorDark,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    // Scroll para carregar mais (paginao infinita)
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _productsNotifier.loadMoreProducts();
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _productsNotifier.setSearchQuery(query);
    });
  }

  Future<void> _loadProdutos() async {
    await _productsNotifier.loadProducts(refresh: true);
  }

  void _applyQuickFilter(String filterType) {
    if (filterType == 'total') {
      _productsNotifier.clearFilters();
    } else if (filterType == 'com_tag') {
      _productsNotifier.setFilterStatus('Com Tag');
    } else if (filterType == 'sem_tag') {
      _productsNotifier.setFilterStatus('Sem Tag');
    }
  }

  /// Ordena a lista de produtos conforme o modo selecionado
  List<ProductModel> _sortProducts(List<ProductModel> products) {
    final sorted = List<ProductModel>.from(products);
    switch (_sortMode) {
      case 'a-z':
        sorted.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
        break;
      case 'z-a':
        sorted.sort((a, b) => b.nome.toLowerCase().compareTo(a.nome.toLowerCase()));
        break;
      case 'preco_crescente':
        sorted.sort((a, b) => a.preco.compareTo(b.preco));
        break;
      case 'preco_decrescente':
        sorted.sort((a, b) => b.preco.compareTo(a.preco));
        break;
      case 'recentes':
        // Mantm ordem original (mais recentes primeiro)
        break;
    }
    return sorted;
  }

  // Estatsticas do provider
  int get _totalProdutos => _productsState.products.length;
  int get _produtosComTag => _productsState.produtosComTag;
  int get _produtosSemTag => _productsState.produtosSemTag;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    final state = _productsState;
    final isLoading = state.status == LoadingStatus.loading;
    final hasError = state.status == LoadingStatus.error;
    final filteredProducts = state.filteredProducts;

    // Se tem callback onBack, significa que est dentro do dashboard
    if (widget.onBack != null) {
      return SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadProdutos,
              color: ThemeColors.of(context).success,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Header com modo seleo
                  SliverToBoxAdapter(
                    child: _isSelectionMode 
                        ? _buildSelectionHeader() 
                        : _buildHeader(),
                  ),
              
                  if (_showInfoCard && !_isSelectionMode)
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                          _buildInfoCard(),
                        ],
                      ),
                    ),
              
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                        _buildFilters(),
                      ],
                    ),
                  ),
              
                  if (state.searchQuery.isNotEmpty || 
                      state.filterCategoria != 'Todas' || 
                      state.filterStatus != 'Todos')
                    SliverToBoxAdapter(child: _buildActiveFilters()),
              
                  if (hasError)
                    SliverToBoxAdapter(child: _buildErrorState(state.error)),
              
                  _buildProductsList(isLoading, filteredProducts),
              
                  SliverToBoxAdapter(child: SizedBox(height: _isSelectionMode ? 120 : 100)),
                ],
              ),
            ),
            // Barra de aes em lote
            if (_isSelectionMode)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBatchActionsBar(),
              ),
          ],
        ),
      );
    }

    // Modo standalone com Navigator prprio
    return PopScope(
      canPop: !(_navigatorKey.currentState?.canPop() ?? false),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.pop();
        }
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: ThemeColors.of(context).surface,
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: _loadProdutos,
                  color: ThemeColors.of(context).success,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeader()),
                      
                      if (_showInfoCard)
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                              _buildInfoCard(),
                            ],
                          ),
                        ),
                      
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: AppSizes.paddingMd.get(isMobile, isTablet)),
                            _buildFilters(),
                          ],
                        ),
                      ),
                      
                      if (state.searchQuery.isNotEmpty || 
                          state.filterCategoria != 'Todas' || 
                          state.filterStatus != 'Todos')
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                              _buildActiveFilters(),
                            ],
                          ),
                        ),
                      
                      if (hasError)
                        SliverToBoxAdapter(child: _buildErrorState(state.error)),
                      
                      _buildProductsList(isLoading, filteredProducts),
                      
                      SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
              ),
              floatingActionButton: _buildFABs(),
            ),
          );
        },
      ),
    );
  }

  // ========== WIDGETS ==========

  Widget _buildHeader() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.cardPadding.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: ModuleGradients.produtos(context),
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.elevatedCard,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppGradients.overlayWhite20(context),
              borderRadius: AppRadius.iconButtonMedium,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: ThemeColors.of(context).surface),
              iconSize: AppSizes.iconMedium.get(isMobile, isTablet),
              onPressed: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              tooltip: 'Voltar',
            ),
          ),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Container(
            padding: EdgeInsets.all(AppSizes.paddingBase.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: AppGradients.overlayWhite20(context),
              borderRadius: AppRadius.button,
            ),
            child: Icon(
              Icons.inventory_2_rounded,
              color: ThemeColors.of(context).surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produtos',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXl.get(isMobile, isTablet),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                Text(
                  'Gesto de catlogo e precificao',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                    color: AppGradients.overlayWhite80(context),
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Stats ficam ocultos em mobile para evitar overflow
          if (!isMobile) ...[
            _buildCompactStat(
              '$_totalProdutos',
              Icons.inventory_2_rounded,
              ThemeColors.of(context).infoLight,
              () => _applyQuickFilter('total'),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildCompactStat(
              '$_produtosComTag',
              Icons.label_rounded,
              ThemeColors.of(context).success,
              () => _applyQuickFilter('com_tag'),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildCompactStat(
              '$_produtosSemTag',
              Icons.label_off_rounded,
              ThemeColors.of(context).warningLight,
              () => _applyQuickFilter('sem_tag'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactStat(String value, IconData icon, Color color, VoidCallback onTap) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.sm,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
          vertical: AppSizes.paddingXs.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: AppGradients.overlayWhite20(context),
          borderRadius: AppRadius.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: ThemeColors.of(context).surface, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTextStyles.fontSizeMdAlt2.get(isMobile, isTablet),
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: AppGradients.strategyDetail(context),
        borderRadius: AppRadius.lg,
        border: Border.all(color: ThemeColors.of(context).infoLight, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSmAlt.get(isMobile, isTablet)),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: AppRadius.iconButtonMedium,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: ThemeColors.of(context).info,
              size: AppSizes.iconMedium.get(isMobile, isTablet),
            ),
          ),
          SizedBox(width: AppSizes.paddingMd.get(isMobile, isTablet)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sobre este Mdulo',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).infoDark,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: AppSizes.extraSmallPadding.get(isMobile, isTablet)),
                Text(
                  'Gerencie seu catlogo completo de produtos com controle de preos, estoque, categorias e associao automtica com etiquetas eletrnicas.',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                    color: ThemeColors.of(context).info,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, color: ThemeColors.of(context).info, size: AppSizes.iconMedium.get(isMobile, isTablet)),
            onPressed: _dismissInfoCard,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
    final state = _productsState;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: ThemeColors.of(context).gradientFilterCard,
        borderRadius: AppRadius.card,
        border: Border.all(color: ThemeColors.of(context).borderSuccess, width: 1),
        boxShadow: AppShadows.successCard,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
              color: ThemeColors.of(context).textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar por nome ou cdigo...',
              hintStyle: TextStyle(
                color: ThemeColors.of(context).textPlaceholder,
                fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
              ),
              prefixIcon: Container(
                margin: EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.xs),
                child: Icon(
                  Icons.search_rounded,
                  color: ThemeColors.of(context).brandPrimaryGreen,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
              ),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(AppSpacing.xxs),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).brandPrimaryGreenLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.clear_rounded,
                          color: ThemeColors.of(context).brandPrimaryGreen,
                          size: AppSizes.iconSmall.get(isMobile, isTablet),
                        ),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: AppRadius.lg,
                borderSide: BorderSide(color: ThemeColors.of(context).brandPrimaryGreenLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.lg,
                borderSide: BorderSide(color: ThemeColors.of(context).brandPrimaryGreenLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.lg,
                borderSide: BorderSide(color: ThemeColors.of(context).brandPrimaryGreen, width: 2),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).surfaceOverlay90,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                vertical: AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              isDense: false,
            ),
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: state.filterCategoria,
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    labelStyle: TextStyle(fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet)),
                    prefixIcon: Icon(Icons.category_rounded, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                    border: OutlineInputBorder(borderRadius: AppRadius.lg),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                    ),
                    isDense: true,
                  ),
                  items: ['Todas', 'Bebidas', 'Mercearia', 'Perecveis', 'Limpeza', 'Higiene']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => _productsNotifier.setFilterCategoria(value!),
                ),
              ),
              SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: state.filterStatus,
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
                    color: ThemeColors.of(context).textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet)),
                    prefixIcon: Icon(Icons.filter_list_rounded, size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
                    border: OutlineInputBorder(borderRadius: AppRadius.lg),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                      vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                    ),
                    isDense: true,
                  ),
                  items: ['Todos', 'Com Tag', 'Sem Tag', 'Ativo', 'Inativo']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => _productsNotifier.setFilterStatus(value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
    final state = _productsState;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd.get(isMobile, isTablet)),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (state.filterCategoria != 'Todas')
            _buildFilterChip(
              'Categoria: ${state.filterCategoria}',
              () => _productsNotifier.setFilterCategoria('Todas'),
            ),
          if (state.filterStatus != 'Todos')
            _buildFilterChip(
              'Status: ${state.filterStatus}',
              () => _productsNotifier.setFilterStatus('Todos'),
            ),
          TextButton.icon(
            onPressed: () => _productsNotifier.clearFilters(),
            icon: Icon(Icons.clear_all_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
            label: Text(
              'Limpar tudo',
              style: TextStyle(fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet)),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Chip(
      label: Text(label, style: TextStyle(fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet))),
      deleteIcon: Icon(Icons.close_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet)),
      onDeleted: onRemove,
      backgroundColor: ThemeColors.of(context).successLight,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.sm,
        side: BorderSide(color: ThemeColors.of(context).success),
      ),
    );
  }

  Widget _buildProductsList(bool isLoading, List<ProductModel> products) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    if (isLoading && products.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildSkeletonCard(),
            childCount: 5,
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(),
      );
    }

    final sortedProducts = _sortProducts(products);

    return SliverPadding(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index < sortedProducts.length) {
              return RepaintBoundary(
                child: _buildProductCard(sortedProducts[index], index),
              );
            } else if (_isLoadingMore) {
              // Indicador de loading na paginao
              return Container(
                padding: EdgeInsets.symmetric(vertical: AppSizes.paddingXl.get(isMobile, isTablet)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.of(context).brandPrimaryGreen),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Carregando mais...',
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                        color: ThemeColors.of(context).textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
          childCount: sortedProducts.length + (_isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel produto, int index) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
    final hasTag = produto.hasTag;
    final isSelected = _selectedProductIds.contains(produto.id.toString());
    
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
        margin: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          color: isSelected 
              ? ThemeColors.of(context).successLight
              : ThemeColors.of(context).surface,
          borderRadius: AppRadius.card,
          boxShadow: AppShadows.mediumCard,
          border: isSelected 
              ? Border.all(color: ThemeColors.of(context).success, width: 2)
              : null,
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              if (_isSelectionMode) {
                _toggleProductSelection(produto);
              } else {
                _navigateToDetails(produto);
              }
            },
            onLongPress: () {
              if (!_isSelectionMode) {
                _enterSelectionMode(produto);
              }
            },
            borderRadius: AppRadius.card,
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
              child: Row(
                children: [
                  // Checkbox 24x24 quando em modo de seleo
                  if (_isSelectionMode) ...[
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) => _toggleProductSelection(produto),
                        activeColor: ThemeColors.of(context).brandPrimaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  // Imagem 32x32 com preview ao clicar
                  GestureDetector(
                    onTap: () {
                      if (produto.imagem != null && produto.imagem!.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: ThemeColors.of(context).transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    produto.imagem!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        gradient: AppGradients.fromBaseColor(context, produto.cor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(produto.icone, color: ThemeColors.of(context).surface, size: 80),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.md),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Fechar', style: TextStyle(color: ThemeColors.of(context).surface)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: AppGradients.fromBaseColor(context, produto.cor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: produto.imagem != null && produto.imagem!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                produto.imagem!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  produto.icone,
                                  color: ThemeColors.of(context).surface,
                                  size: 18,
                                ),
                              ),
                            )
                          : Icon(
                              produto.icone,
                              color: ThemeColors.of(context).surface,
                              size: 18,
                            ),
                    ),
                  ),
                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome - max 2 linhas
                        Text(
                          produto.nome,
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                            height: 1.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                        // Categoria ? Cdigo
                        Row(
                          children: [
                            Icon(
                              Icons.category_rounded,
                              size: 12,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                produto.categoria,
                                style: TextStyle(
                                  fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                                  color: ThemeColors.of(context).textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text('?', style: TextStyle(color: ThemeColors.of(context).textSecondary, fontSize: 12)),
                            ),
                            Text(
                              produto.codigo,
                              style: TextStyle(
                                fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                        // Tag vinculada (quando tem tag)
                        if (hasTag && produto.tag != null) ...[
                          SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                          Row(
                            children: [
                              Icon(
                                Icons.label_rounded,
                                size: 11,
                                color: ThemeColors.of(context).successIcon,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Tag vinculada: ${produto.tag}',
                                  style: TextStyle(
                                    fontSize: AppTextStyles.fontSizeXxsAlt.get(isMobile, isTablet),
                                    color: ThemeColors.of(context).successIcon,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Preo ou Alert
                      if (produto.preco <= 0) ...[
                        // Alerta visual para produto sem preo
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingXsAlt3.get(isMobile, isTablet),
                            vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).warningLight,
                            borderRadius: AppRadius.xs,
                            border: Border.all(color: ThemeColors.of(context).warning),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                size: AppSizes.iconMicroAlt.get(isMobile, isTablet),
                                color: ThemeColors.of(context).warningDark,
                              ),
                              SizedBox(width: AppSpacing.xxs),
                              Text(
                                'Sem preo',
                                style: TextStyle(
                                  fontSize: AppTextStyles.fontSizeMicroAlt2.get(isMobile, isTablet),
                                  fontWeight: FontWeight.w600,
                                  color: ThemeColors.of(context).warningDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Text(
                          'R\$ ${produto.preco.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSizeLgAlt.get(isMobile, isTablet),
                            fontWeight: FontWeight.bold,
                            color: produto.cor,
                          ),
                        ),
                      ],
                      // Status Tag Badge
                      SizedBox(height: AppSizes.paddingXsAlt3.get(isMobile, isTablet)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingXsAlt3.get(isMobile, isTablet),
                          vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: hasTag ? ThemeColors.of(context).successLight : ThemeColors.of(context).warningPastel,
                          borderRadius: AppRadius.xs,
                          border: Border.all(
                            color: hasTag ? ThemeColors.of(context).success : ThemeColors.of(context).warningLight,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              hasTag ? Icons.check_circle_rounded : Icons.warning_rounded,
                              size: 10,
                              color: hasTag ? ThemeColors.of(context).successIcon : ThemeColors.of(context).warningDark,
                            ),
                            SizedBox(width: 4),
                            Text(
                              hasTag ? 'Online' : 'Sem Tag',
                              style: TextStyle(
                                fontSize: AppTextStyles.fontSizeMicroAlt2.get(isMobile, isTablet),
                                fontWeight: FontWeight.w600,
                                color: hasTag ? ThemeColors.of(context).successIcon : ThemeColors.of(context).warningDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status de sincronizao Minew
                      if (produto.syncWithMinew) ...[
                        SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                        _buildMinewSyncBadge(produto, isMobile, isTablet),
                      ],
                      if (produto.precoKg != null && produto.preco > 0) ...[
                        SizedBox(height: AppSizes.paddingXxs.get(isMobile, isTablet)),
                        Text(
                          'R\$ ${produto.precoKg!.toStringAsFixed(2)}/kg',
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSizeXxsAlt.get(isMobile, isTablet),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(width: AppSizes.paddingSmAlt.get(isMobile, isTablet)),
                  _buildProductMenu(produto),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildProductMenu(ProductModel produto) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: ThemeColors.of(context).textSecondary,
        size: AppSizes.iconMedium.get(isMobile, isTablet),
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.visibility_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text('Ver Detalhes', style: TextStyle(fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet))),
            ],
          ),
          onTap: () => Future.delayed(Duration.zero, () => _navigateToDetails(produto)),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text('Editar', style: TextStyle(fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet))),
            ],
          ),
          onTap: () => Future.delayed(Duration.zero, () => _navigateToEdit(produto)),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                produto.hasTag ? Icons.link_off_rounded : Icons.link_rounded, 
                size: AppSizes.iconSmall.get(isMobile, isTablet), 
                color: produto.hasTag ? ThemeColors.of(context).warning : ThemeColors.of(context).brandPrimaryGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                produto.hasTag ? 'Desvincular Tag' : 'Vincular Tag', 
                style: TextStyle(
                  fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                  color: produto.hasTag ? ThemeColors.of(context).warning : ThemeColors.of(context).brandPrimaryGreen,
                ),
              ),
            ],
          ),
          onTap: () => Future.delayed(Duration.zero, () {
            if (produto.hasTag) {
              _showUnbindTagDialog(produto);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProdutosAssociarQRScreen()),
              );
            }
          }),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.copy_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).blueCyan),
              const SizedBox(width: AppSpacing.sm),
              Text('Duplicar', style: TextStyle(fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet), color: ThemeColors.of(context).blueCyan)),
            ],
          ),
          onTap: () => Future.delayed(Duration.zero, () => _duplicateProduct(produto)),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.delete_rounded, size: AppSizes.iconSmall.get(isMobile, isTablet), color: ThemeColors.of(context).errorDark),
              const SizedBox(width: AppSpacing.sm),
              Text('Excluir', style: TextStyle(color: ThemeColors.of(context).errorDark, fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet))),
            ],
          ),
          onTap: () => Future.delayed(Duration.zero, () => _showDeleteDialog(produto)),
        ),
      ],
    );
  }

  /// Constri badge de status de sincronizao Minew
  Widget _buildMinewSyncBadge(ProductModel produto, bool isMobile, bool isTablet) {
    final Color bgColor;
    final Color borderColor;
    final Color iconColor;
    final IconData icon;
    final String label;
    
    switch (produto.minewSyncStatus) {
      case 'synced':
        bgColor = ThemeColors.of(context).syncedBg;
        borderColor = ThemeColors.of(context).syncedBorder;
        iconColor = ThemeColors.of(context).syncedIcon;
        icon = Icons.cloud_done_rounded;
        label = 'Minew';
        break;
      case 'pending':
        bgColor = ThemeColors.of(context).syncPendingBg;
        borderColor = ThemeColors.of(context).syncPendingBorder;
        iconColor = ThemeColors.of(context).syncPendingIcon;
        icon = Icons.cloud_upload_rounded;
        label = 'Pendente';
        break;
      case 'error':
        bgColor = ThemeColors.of(context).syncErrorBg;
        borderColor = ThemeColors.of(context).syncErrorBorder;
        iconColor = ThemeColors.of(context).syncErrorIcon;
        icon = Icons.cloud_off_rounded;
        label = 'Erro';
        break;
      default:
        bgColor = ThemeColors.of(context).notSyncedBg;
        borderColor = ThemeColors.of(context).notSyncedBorder;
        iconColor = ThemeColors.of(context).notSyncedIcon;
        icon = Icons.cloud_outlined;
        label = 'N/Sync';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingXsAlt3.get(isMobile, isTablet),
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.xs,
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: iconColor),
          SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showUnbindTagDialog(ProductModel produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desvincular Tag'),
        content: Text('Deseja remover a vinculao da tag "${produto.tag}" do produto "${produto.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Implementao da desvinculao via provider
              if (produto.tag != null) {
                final bindingNotifier = ref.read(tagBindingProvider.notifier);
                final success = await bindingNotifier.unbindTag(produto.tag!);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                        ? 'Tag desvinculada de ${produto.nome}'
                        : 'Erro ao desvincular tag'),
                      backgroundColor: success ? ThemeColors.of(context).brandPrimaryGreen : ThemeColors.of(context).error,
                    ),
                  );
                  
                  if (success) {
                    await _productsNotifier.loadProducts(refresh: true);
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).warning,
            ),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
  }

  void _duplicateProduct(ProductModel produto) async {
    // Cria cpia do produto com novo ID
    final duplicatedProduct = ProductModel(
      id: '', // Ser gerado pelo backend
      codigo: '${produto.codigo}_copy',
      nome: 'Cpia de ${produto.nome}',
      preco: produto.preco,
      categoria: produto.categoria,
      status: produto.status,
      imagem: produto.imagem,
      descricao: produto.descricao,
      precoKg: produto.precoKg,
      estoque: produto.estoque,
    );
    
    // Navega para edio para o usurio ajustar antes de salvar
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProdutosAdicionarScreen(
          onBack: () => Navigator.of(context).pop(),
          initialProduct: duplicatedProduct,
        ),
      ),
    );
  }

  void _navigateToDetails(ProductModel produto) {
    if (widget.onBack != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProdutosDetalhesScreen(product: produto)),
      );
    } else {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => ProdutosDetalhesScreen(product: produto)),
      );
    }
  }

  void _navigateToEdit(ProductModel produto) {
    if (widget.onBack != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProdutosEditarScreen(product: produto)),
      );
    } else {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => ProdutosEditarScreen(product: produto)),
      );
    }
  }

  Widget _buildSkeletonCard() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.iconHeroMd.get(isMobile, isTablet),
            height: AppSizes.iconHeroMd.get(isMobile, isTablet),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay20,
              borderRadius: AppRadius.lg,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondaryOverlay20,
                    borderRadius: AppRadius.xxxs,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 150,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondaryOverlay20,
                    borderRadius: AppRadius.xxxs,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondaryOverlay20,
                    borderRadius: AppRadius.xxxs,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 20,
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay20,
              borderRadius: AppRadius.xxxs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
    final state = _productsState;
    
    // Verifica se  estado vazio inicial (sem filtros) ou resultado de busca
    final isInitialEmpty = state.searchQuery.isEmpty && 
                           state.filterCategoria == 'Todas' && 
                           state.filterStatus == 'Todos';

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingXl.get(isMobile, isTablet)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // cone grande
            Container(
              padding: EdgeInsets.all(AppSizes.paddingXxl.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                gradient: isInitialEmpty 
                    ? LinearGradient(
                        colors: [
                          ThemeColors.of(context).successLight,
                          ThemeColors.of(context).successLight,
                        ],
                      )
                    : null,
                color: isInitialEmpty ? null : ThemeColors.of(context).textSecondaryOverlay10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isInitialEmpty ? Icons.inventory_2_rounded : Icons.search_off_rounded,
                size: AppSizes.iconHero3Xl.get(isMobile, isTablet),
                color: isInitialEmpty ? ThemeColors.of(context).success : ThemeColors.of(context).textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.paddingXl.get(isMobile, isTablet)),
            
            // Ttulo
            Text(
              isInitialEmpty ? 'Comece a cadastrar seus produtos!' : 'Nenhum produto encontrado',
              style: TextStyle(
                fontSize: AppTextStyles.fontSizeXlAlt.get(isMobile, isTablet),
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.paddingXsAlt3.get(isMobile, isTablet)),
            
            // Descrio
            Text(
              isInitialEmpty
                  ? 'Importe uma planilha ou adicione produtos manualmente\npara comear a usar o sistema ESL.'
                  : 'No encontramos produtos com "${state.searchQuery}".\nDeseja criar um novo produto?',
              style: TextStyle(
                fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
                color: ThemeColors.of(context).textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.paddingXxl.get(isMobile, isTablet)),
            
            // Botes de ao
            if (isInitialEmpty) ...[
              // Boto principal - Importar
              SizedBox(
                width: isMobile ? double.infinity : 280,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navegar para importao
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProdutosImportarScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.of(context).success,
                    foregroundColor: ThemeColors.of(context).surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingXl.get(isMobile, isTablet),
                      vertical: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text(
                    'Importar Produtos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
              
              // Boto secundrio - Adicionar manualmente
              SizedBox(
                width: isMobile ? double.infinity : 280,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProdutosAdicionarScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeColors.of(context).success,
                    side: BorderSide(color: ThemeColors.of(context).success),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingXl.get(isMobile, isTablet),
                      vertical: AppSizes.paddingMd.get(isMobile, isTablet),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Adicionar Manualmente',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ] else ...[
              // Botes para resultado de busca vazio
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      _productsNotifier.clearFilters();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ThemeColors.of(context).info,
                      side: BorderSide(color: ThemeColors.of(context).info),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                    ),
                    icon: const Icon(Icons.clear_all_rounded, size: 18),
                    label: const Text('Limpar Filtros'),
                  ),
                  SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProdutosAdicionarScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.of(context).success,
                      foregroundColor: ThemeColors.of(context).surface,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
                        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Criar Produto'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String? error) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).errorLight,
        borderRadius: AppRadius.card,
        border: Border.all(color: ThemeColors.of(context).error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: ThemeColors.of(context).errorDark),
          SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
          Expanded(
            child: Text(
              error ?? 'Erro ao carregar produtos',
              style: TextStyle(color: ThemeColors.of(context).errorDark),
            ),
          ),
          TextButton(
            onPressed: () => _productsNotifier.loadProducts(refresh: true),
            child: Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildFABs() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    return FloatingActionButton(
      heroTag: 'add_product',
      onPressed: () {
        if (widget.onBack != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProdutosAdicionarScreen()),
          );
        } else {
          _navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => const ProdutosAdicionarScreen()),
          );
        }
      },
      backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
      child: Icon(
        Icons.add_rounded,
        size: AppSizes.iconLarge.get(isMobile, isTablet),
        color: ThemeColors.of(context).surface,
      ),
      tooltip: 'Adicionar Produto',
    );
  }

  void _showDeleteDialog(ProductModel produto) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        icon: Icon(Icons.warning_rounded, color: ThemeColors.of(context).error, size: AppSizes.iconHeroSm.get(isMobile, isTablet)),
        title: Text('Confirmar Excluso', style: TextStyle(fontSize: AppTextStyles.fontSizeXlAlt.get(isMobile, isTablet))),
        content: Text(
          'Deseja realmente excluir "${produto.nome}"?\n\nEsta ao no pode ser desfeita.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _productsNotifier.deleteProduct(produto.id);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSizes.paddingXs.get(isMobile, isTablet)),
                          decoration: BoxDecoration(
                            color: ThemeColors.of(context).surfaceOverlay20,
                            borderRadius: AppRadius.xs,
                          ),
                          child: Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).surface, size: AppSizes.iconMedium.get(isMobile, isTablet)),
                        ),
                        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Produto Excludo!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet))),
                              Text('${produto.nome} foi removido', style: TextStyle(fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet)), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: ThemeColors.of(context).error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
                    padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXlAlt2.get(isMobile, isTablet),
                vertical: AppSizes.paddingBaseAlt.get(isMobile, isTablet),
              ),
            ),
            child: Text('Excluir', style: TextStyle(fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet))),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionHeader() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
    final totalProducts = _productsState.filteredProducts.length;
    final selectedCount = _selectedProductIds.length;

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.greenProduct(context),
        borderRadius: AppRadius.lg,
        boxShadow: AppShadows.elevatedCard,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            onPressed: _exitSelectionMode,
            tooltip: 'Cancelar seleo',
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount selecionado${selectedCount > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXlAlt2.get(isMobile, isTablet),
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.of(context).surface,
                  ),
                ),
                Text(
                  'de $totalProducts produtos',
                  style: TextStyle(
                    fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                    color: ThemeColors.of(context).surfaceOverlay80,
                  ),
                ),
              ],
            ),
          ),
          // Boto selecionar todos
          if (selectedCount < totalProducts)
            TextButton.icon(
              onPressed: _selectAll,
              icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 18),
              label: Text(
                'Todos',
                style: TextStyle(
                  color: ThemeColors.of(context).surface,
                  fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: _deselectAll,
              icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface, size: 18),
              label: Text(
                'Limpar',
                style: TextStyle(
                  color: ThemeColors.of(context).surface,
                  fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBatchActionsBar() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && 
                     MediaQuery.of(context).size.width < 900;
    final selectedCount = _selectedProductIds.length;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
        vertical: AppSizes.paddingBase.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlackLight,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Vincular Tags
            _buildBatchActionButton(
              icon: Icons.link_rounded,
              label: 'Vincular',
              color: ThemeColors.of(context).brandPrimaryGreen,
              onTap: _showBatchBindTagsDialog,
              isMobile: isMobile,
            ),
            const SizedBox(width: AppSpacing.sm),
            // Editar Preos
            _buildBatchActionButton(
              icon: Icons.attach_money_rounded,
              label: 'Preos',
              color: ThemeColors.of(context).primary,
              onTap: _showBatchEditPriceDialog,
              isMobile: isMobile,
            ),
            const SizedBox(width: AppSpacing.sm),
            // Alterar Categoria
            _buildBatchActionButton(
              icon: Icons.category_rounded,
              label: 'Categoria',
              color: ThemeColors.of(context).blueCyan,
              onTap: _showBatchChangeCategoryDialog,
              isMobile: isMobile,
            ),
            const Spacer(),
            // Excluir
            _buildBatchActionButton(
              icon: Icons.delete_rounded,
              label: 'Excluir',
              color: ThemeColors.of(context).error,
              onTap: _showBatchDeleteDialog,
              isMobile: isMobile,
              isDanger: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isMobile,
    bool isDanger = false,
  }) {
    return Material(
      color: ThemeColors.of(context).transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: colorLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorLight),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: isMobile ? 20 : 24),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dialog para edio de preo em lote
class _BatchPriceDialog extends StatefulWidget {
  final List<ProductModel> selectedProducts;
  final Function(double, String) onSave;

  const _BatchPriceDialog({
    required this.selectedProducts,
    required this.onSave,
  });

  @override
  State<_BatchPriceDialog> createState() => _BatchPriceDialogState();
}

class _BatchPriceDialogState extends State<_BatchPriceDialog> {
  final _priceController = TextEditingController();
  String _priceMode = 'fixed'; // 'fixed', 'percentage_increase', 'percentage_decrease'

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Preos em Lote'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.selectedProducts.length} produtos selecionados',
            style: TextStyle(color: ThemeColors.of(context).textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'fixed', label: Text('Fixo')),
              ButtonSegment(value: 'percentage_increase', label: Text('+ %')),
              ButtonSegment(value: 'percentage_decrease', label: Text('- %')),
            ],
            selected: {_priceMode},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() => _priceMode = newSelection.first);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: _priceMode == 'fixed' ? 'Novo Preo (R\$)' : 'Porcentagem (%)',
              prefixText: _priceMode == 'fixed' ? 'R\$ ' : null,
              suffixText: _priceMode != 'fixed' ? '%' : null,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final value = double.tryParse(_priceController.text);
            if (value != null && value > 0) {
              Navigator.pop(context);
              widget.onSave(value, _priceMode);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          ),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}

// Dialog para alterao de categoria em lote
class _BatchCategoryDialog extends StatefulWidget {
  final int selectedCount;
  final List<String> categories;
  final Function(String) onSave;

  const _BatchCategoryDialog({
    required this.selectedCount,
    required this.categories,
    required this.onSave,
  });

  @override
  State<_BatchCategoryDialog> createState() => _BatchCategoryDialogState();
}

class _BatchCategoryDialogState extends State<_BatchCategoryDialog> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories.where((c) => c != 'Todas').toList();
    
    return AlertDialog(
      title: const Text('Alterar Categoria'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.selectedCount} produtos selecionados',
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Selecione a nova categoria:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategory == category;
                  
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? ThemeColors.of(context).brandPrimaryGreenLight
                          : ThemeColors.of(context).surfaceSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.category_rounded,
                        color: isSelected 
                          ? ThemeColors.of(context).brandPrimaryGreen
                          : ThemeColors.of(context).textSecondary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      category,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected 
                          ? ThemeColors.of(context).brandPrimaryGreen
                          : ThemeColors.of(context).textPrimary,
                      ),
                    ),
                    trailing: isSelected 
                      ? Icon(Icons.check_circle_rounded, color: ThemeColors.of(context).brandPrimaryGreen)
                      : null,
                    onTap: () => setState(() => _selectedCategory = category),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    selectedTileColor: ThemeColors.of(context).brandPrimaryGreenLight,
                    selected: isSelected,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _selectedCategory != null 
            ? () {
                Navigator.pop(context);
                widget.onSave(_selectedCategory!);
              }
            : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.of(context).brandPrimaryGreen,
          ),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}











