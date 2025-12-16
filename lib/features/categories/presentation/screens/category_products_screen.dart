import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class CategoriasProdutosScreen extends ConsumerStatefulWidget {
  const CategoriasProdutosScreen({super.key});

  @override
  ConsumerState<CategoriasProdutosScreen> createState() => _CategoriasProdutosScreenState();
}

class _CategoriasProdutosScreenState extends ConsumerState<CategoriasProdutosScreen>
    with SingleTickerProviderStateMixin, ResponsiveCache {
  late TabController _tabController;
  String _categoriaSelecionada = 'Bebidas';
  String _searchQuery = '';
  List<Map<String, dynamic>> _selectedProducts = [];
  bool _isSelectMode = false;
  
  // Cache para produtos filtrados
  List<Map<String, dynamic>>? _cachedProdutosFiltrados;
  String? _lastCategoria;
  String? _lastSearchQuery;

  // ============================================================================
  // DADOS MOCK - BACKEND READY
  // ============================================================================
  // TODO: BACKEND - GET /api/categorias/produtos
  // Response: List<Categoria> com produtos vinculados
  // ============================================================================
  List<Map<String, dynamic>> get _categorias => _categoriasMock;
  static final List<Map<String, dynamic>> _categoriasMock = [
    {
      'nome': 'Bebidas',
      'cor': ThemeColors.of(context).primary,
      'gradiente': [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark],
      'icone': Icons.local_drink_rounded,
      'produtos': 247,
    },
    {
      'nome': 'Mercearia',
      'cor': ThemeColors.of(context).brownMain,
      'gradiente': [ThemeColors.of(context).brownMain, ThemeColors.of(context).brownDark],
      'icone': Icons.shopping_basket_rounded,
      'produtos': 532,
    },
    {
      'nome': 'Perec�veis',
      'cor': ThemeColors.of(context).success,
      'gradiente': [ThemeColors.of(context).success, ThemeColors.of(context).successIcon],
      'icone': Icons.restaurant_rounded,
      'produtos': 189,
    },
    {
      'nome': 'Limpeza',
      'cor': ThemeColors.of(context).blueCyan,
      'gradiente': [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary],
      'icone': Icons.cleaning_services_rounded,
      'produtos': 156,
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _produtosPorCategoria = {
    'Bebidas': [
      {
        'id': '1',
        'nome': 'Coca-Cola 2L',
        'codigo': '7894900011517',
        'preco': 8.90,
        'estoque': 145,
        'imagem': null,
      },
      {
        'id': '2',
        'nome': 'Guaran� Antarctica 2L',
        'codigo': '7894900012517',
        'preco': 7.50,
        'estoque': 89,
        'imagem': null,
      },
      {
        'id': '3',
        'nome': '�gua Mineral Crystal 500ml',
        'codigo': '7891234567890',
        'preco': 1.99,
        'estoque': 234,
        'imagem': null,
      },
      {
        'id': '4',
        'nome': 'Cerveja Heineken 350ml',
        'codigo': '7891991010863',
        'preco': 4.20,
        'estoque': 167,
        'imagem': null,
      },
      {
        'id': '5',
        'nome': 'Suco Del Valle Laranja 1L',
        'codigo': '7894900012345',
        'preco': 5.80,
        'estoque': 98,
        'imagem': null,
      },
    ],
    'Mercearia': [
      {
        'id': '6',
        'nome': 'Arroz Tipo 1 5kg',
        'codigo': '7896064850011',
        'preco': 24.90,
        'estoque': 78,
        'imagem': null,
      },
      {
        'id': '7',
        'nome': 'Feij�o Preto 1kg',
        'codigo': '7896064850028',
        'preco': 8.50,
        'estoque': 156,
        'imagem': null,
      },
    ],
    'Perec�veis': [],
    'Limpeza': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // OTIMIZA��O: Getter com cache - s� recalcula se categoria ou busca mudaram
  List<Map<String, dynamic>> get _produtosFiltrados {
    if (_cachedProdutosFiltrados != null &&
        _lastCategoria == _categoriaSelecionada &&
        _lastSearchQuery == _searchQuery) {
      return _cachedProdutosFiltrados!;
    }
    
    _lastCategoria = _categoriaSelecionada;
    _lastSearchQuery = _searchQuery;
    
    // TODO: BACKEND - GET /api/categorias/{id}/produtos
    final produtos = _produtosPorCategoria[_categoriaSelecionada] ?? [];
    if (_searchQuery.isEmpty) {
      _cachedProdutosFiltrados = produtos;
      return _cachedProdutosFiltrados!;
    }
    
    _cachedProdutosFiltrados = produtos.where((p) {
      final nome = p['nome'].toString().toLowerCase();
      final codigo = p['codigo'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return nome.contains(query) || codigo.contains(query);
    }).toList();
    
    return _cachedProdutosFiltrados!;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

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
          'Gerenciar Produtos',
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
                SliverToBoxAdapter(child: _buildInfoCard()),
                SliverToBoxAdapter(child: SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet))),
                SliverToBoxAdapter(child: _buildStatsCards()),
                SliverToBoxAdapter(child: SizedBox(height: AppSizes.spacingMd.get(isMobile, isTablet))),
                SliverToBoxAdapter(child: _buildSearchBar()),
                SliverToBoxAdapter(child: _buildTabBar()),
                SliverToBoxAdapter(child: _buildCategorySelector()),
                if (_isSelectMode) SliverToBoxAdapter(child: _buildBulkActions()),
              ];
            },
            body: _produtosFiltrados.isEmpty
                ? _buildEmptyState()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGridView(),
                      _buildListView(),
                    ],
                  ),
          ),
      ),
      floatingActionButton: _isSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _showAddProductDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Vincular'),
              backgroundColor: ThemeColors.of(context).success,
            )
    );
  }

  Widget _buildStatsCards() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    final estatisticas = [
      {'label': 'Bebidas', 'valor': '247', 'icon': Icons.local_drink_rounded, 'cor': ThemeColors.of(context).primary, 'mudanca': '+12', 'tipo': 'aumento'},
      {'label': 'Mercearia', 'valor': '532', 'icon': Icons.shopping_basket_rounded, 'cor': ThemeColors.of(context).brownMain, 'mudanca': '+28', 'tipo': 'aumento'},
      {'label': 'Perec�veis', 'valor': '189', 'icon': Icons.restaurant_rounded, 'cor': ThemeColors.of(context).success, 'mudanca': '+7', 'tipo': 'aumento'},
      {'label': 'Limpeza', 'valor': '156', 'icon': Icons.cleaning_services_rounded, 'cor': ThemeColors.of(context).blueCyan, 'mudanca': '+5', 'tipo': 'aumento'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimary.withValues(alpha: 0.06),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isMobile && !ResponsiveHelper.isLandscape(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildEnhancedStatCard(estatisticas[0])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedStatCard(estatisticas[1])),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                    Row(
                      children: [
                        Expanded(child: _buildEnhancedStatCard(estatisticas[2])),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 10)),
                        Expanded(child: _buildEnhancedStatCard(estatisticas[3])),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: estatisticas.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < estatisticas.length - 1 ? 12 : 0),
                        child: _buildEnhancedStatCard(stat),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(Map<String, dynamic> stat) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (stat['cor'] as Color)Light,
              (stat['cor'] as Color)Light,
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: (stat['cor'] as Color)Light,
            width: isMobile ? 1.25 : 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              stat['icon'],
              color: stat['cor'],
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
            Text(
              stat['valor'],
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                color: stat['cor'],
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
            Text(
              stat['label'],
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                overflow: TextOverflow.ellipsis,
                color: ThemeColors.of(context).textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 5, tablet: 5.5, desktop: 6)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsivePadding(context, mobile: 5, tablet: 5.5, desktop: 6),
                vertical: ResponsiveHelper.getResponsivePadding(context, mobile: 2.5, tablet: 2.75, desktop: 3),
              ),
              decoration: BoxDecoration(
                color: (stat['cor'] as Color)Light,
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stat['tipo'] == 'aumento')
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 9, tablet: 9.5, desktop: 10),
                      color: stat['cor'],
                    ),
                  if (stat['tipo'] == 'aumento')
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 2.5, tablet: 2.75, desktop: 3)),
                  Flexible(
                    child: Text(
                      stat['mudanca'],
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: stat['cor'],
                      ),
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

  Widget _buildCategorySelector() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      height: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: 90,
        tablet: 100,
        desktop: 110,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          final isSelected = _categoriaSelecionada == categoria['nome'];
          
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
              width: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: 100,
                tablet: 110,
                desktop: 120,
              ),
              margin: const EdgeInsets.only(right: 12),
              child: Material(
                color: ThemeColors.of(context).transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _categoriaSelecionada = categoria['nome'];
                      _selectedProducts.clear();
                      _isSelectMode = false;
                      _cachedProdutosFiltrados = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppSizes.paddingXl.get(isMobile, isTablet)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(colors: categoria['gradiente'])
                          : null,
                      color: isSelected ?  null : ThemeColors.of(context).surface,
                      borderRadius: BorderRadius.circular(AppSizes.paddingXl.get(isMobile, isTablet)),
                      border: Border.all(
                        color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textSecondary,
                        width: isSelected ? 0 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? (categoria['cor'] as Color)Light
                              : ThemeColors.of(context).textPrimaryOverlay05,
                          blurRadius: isSelected ? 15 : 8,
                          offset: Offset(0, isSelected ? 8 : 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoria['icone'],
                          color: isSelected ? ThemeColors.of(context).surface : categoria['cor'],
                          size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
                        ),
                        SizedBox(height: 8),
                        Text(
                          categoria['nome'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 13,
                              mobileFontSize: 12,
                            ),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ThemeColors.of(context).surfaceOverlay20
                                : categoria['cor']Light,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${categoria['produtos']}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 11,
                                mobileFontSize: 10,
                              ),
                              fontWeight: FontWeight.bold,
                              color: isSelected ? ThemeColors.of(context).surface : categoria['cor'],
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
        },
      ),
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
            ThemeColors.of(context).blueCyanLight,
            ThemeColors.of(context).primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        border: Border.all(
          color: ThemeColors.of(context).blueCyanLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: ThemeColors.of(context).yellowGoldDark,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          SizedBox(
            width: AppSizes.paddingBase.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              'Escolha uma categoria otimizada para supermercados',
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

  Widget _buildSearchBar() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
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
          _cachedProdutosFiltrados = null;
        }),
        decoration: InputDecoration(
          hintText: 'Buscar produtos...',
          hintStyle: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 14,
              mobileFontSize: 13,
            ),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () => setState(() {
                    _searchQuery = '';
                    _cachedProdutosFiltrados = null;
                  }),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingMd.get(isMobile, isTablet)),
            borderSide: BorderSide. none,
          ),
          filled: true,
          fillColor: ThemeColors.of(context).textSecondary,
        ),
      ),
    );
  }

  Widget _buildBulkActions() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final categoria = _categorias.firstWhere((c) => c['nome'] == _categoriaSelecionada);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: categoria['gradiente']),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: (categoria['cor'] as Color)Light,
            blurRadius: 15,
            offset: const Offset(0, 8),
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
              color: ThemeColors.of(context).surfaceOverlay20,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_selectedProducts.length}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 16,
                  mobileFontSize: 14,
                ),
                fontWeight: FontWeight.bold,
                color: ThemeColors.of(context).surface,
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.paddingMd.get(isMobile, isTablet),
          ),
          Expanded(
            child: Text(
              'selecionado${_selectedProducts.length != 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                  mobileFontSize: 12,
                ),
                color: ThemeColors.of(context).surface,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            onPressed: _selectedProducts.isEmpty ?  null : () => _moveProducts(),
          ),
          IconButton(
            icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            onPressed: _selectedProducts.isEmpty ? null : () => _unlinkProducts(),
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
        vertical: AppSizes.paddingSmLg.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.spacingXxsAlt.get(isMobile, isTablet),
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
            isMobile ? 10 : 12,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: ThemeColors.of(context).transparent,
        labelColor: ThemeColors.of(context).surface,
        unselectedLabelColor: ThemeColors.of(context).textSecondary,
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

  Widget _buildGridView() {
    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return GridView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.paddingBaseLg.get(isMobile, isTablet),
        mainAxisSpacing: AppSizes.paddingBaseLg.get(isMobile, isTablet),
        childAspectRatio: 0.68,
      ),
      itemCount: _produtosFiltrados.length,
      itemBuilder: (context, index) {
        return _buildProductGridCard(_produtosFiltrados[index], index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: _produtosFiltrados. length,
      itemBuilder: (context, index) {
        return _buildProductListCard(_produtosFiltrados[index], index);
      },
    );
  }

  Widget _buildProductGridCard(Map<String, dynamic> produto, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _selectedProducts.contains(produto);
    final categoria = _categorias.firstWhere((c) => c['nome'] == _categoriaSelecionada);

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
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: isSelected
              ? Border.all(color: categoria['cor'], width: 2)
              : Border.all(color: ThemeColors.of(context).textSecondary),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (categoria['cor'] as Color)Light
                  : ThemeColors.of(context).textPrimaryOverlay05,
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              if (_isSelectMode) {
                setState(() {
                  if (isSelected) {
                    _selectedProducts.remove(produto);
                  } else {
                    _selectedProducts.add(produto);
                  }
                });
              }
            },
            onLongPress: () {
              if (! _isSelectMode) {
                setState(() {
                  _isSelectMode = true;
                  _selectedProducts.add(produto);
                });
              }
            },
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(
                    AppSizes.paddingMd.get(isMobile, isTablet),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ThemeColors.of(context).textSecondary,
                                ThemeColors.of(context).textSecondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              isMobile ? 12 : 14,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.inventory_2_rounded,
                              size: AppSizes.iconHeroMd.get(isMobile, isTablet),
                              color: ThemeColors.of(context).textSecondary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.spacingSmLg.get(isMobile, isTablet)),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              produto['nome'],
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 14,
                            mobileFontSize: 13,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSizes.spacingXxsAlt.get(isMobile, isTablet)),
                            Text(
                              produto['codigo'],
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                ),
                                color: ThemeColors.of(context).textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSizes.spacingXs.get(isMobile, isTablet)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'R\$ ${produto['preco'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        baseFontSize: 16,
                                        mobileFontSize: 14,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      color: categoria['cor'],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                                    vertical: AppSizes.paddingXxs.get(isMobile, isTablet),
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeColors.of(context).successPastel,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${produto['estoque']}',
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
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isSelectMode)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected ? categoria['cor'] : ThemeColors.of(context).surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? categoria['cor'] : ThemeColors.of(context).textSecondary,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: ThemeColors.of(context).white,
                              size: 18,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductListCard(Map<String, dynamic> produto, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _selectedProducts.contains(produto);
    final categoria = _categorias.firstWhere((c) => c['nome'] == _categoriaSelecionada);

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
          bottom: AppSizes.paddingBaseLg.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: isSelected
              ? Border.all(color: categoria['cor'], width: 2)
              : Border.all(color: ThemeColors.of(context).textSecondary),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (categoria['cor'] as Color)Light
                  : ThemeColors.of(context).textPrimaryOverlay05,
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: ThemeColors.of(context).transparent,
          child: InkWell(
            onTap: () {
              if (_isSelectMode) {
                setState(() {
                  if (isSelected) {
                    _selectedProducts.remove(produto);
                  } else {
                    _selectedProducts.add(produto);
                  }
                });
              }
            },
            onLongPress: () {
              if (!_isSelectMode) {
                setState(() {
                  _isSelectMode = true;
                  _selectedProducts.add(produto);
                });
              }
            },
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                AppSizes.paddingMd.get(isMobile, isTablet),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_isSelectMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? categoria['cor'] : ThemeColors.of(context).surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? categoria['cor'] : ThemeColors.of(context).textSecondary,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: ThemeColors.of(context).surface,
                                size: 16,
                              )
                            : null,
                      ),
                    ),
                  Container(
                    width: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 48,
                      tablet: 56,
                      desktop: 60,
                    ),
                    height: ResponsiveHelper.getResponsiveIconSize(
                      context,
                      mobile: 48,
                      tablet: 56,
                      desktop: 60,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeColors.of(context).textSecondary,
                          ThemeColors.of(context).textSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                    ),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 30,
                      ),
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingMd.get(isMobile, isTablet)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produto['nome'],
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 15,
                              mobileFontSize: 13,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSizes.spacingMicroAlt.get(isMobile, isTablet)),
                        Text(
                          'ID: ${produto['codigo']}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 11,
                              mobileFontSize: 10,
                            ),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSizes.spacingMicroAlt.get(isMobile, isTablet)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingXs.get(isMobile, isTablet),
                            vertical: AppSizes.paddingMicro.get(isMobile, isTablet),
                          ),
                          decoration: BoxDecoration(
                            color: categoria['cor']Light,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _categoriaSelecionada,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 10,
                                mobileFontSize: 9,
                              ),
                              color: categoria['cor'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingMd.get(isMobile, isTablet)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            size: AppSizes.iconSmallMedium.get(isMobile, isTablet),
                            color: categoria['cor'],
                          ),
                          Text(
                            produto['preco'].toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 16,
                                mobileFontSize: 14,
                              ),
                              fontWeight: FontWeight.bold,
                              color: categoria['cor'],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.spacingXsAlt.get(isMobile, isTablet)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_rounded,
                            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 14, tablet: 16, desktop: 18),
                            color: ThemeColors.of(context).textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${produto['estoque']}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 12,
                                mobileFontSize: 11,
                              ),
                              color: ThemeColors.of(context).textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (!_isSelectMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: categoria['cor'],
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        onPressed: () {},
                        tooltip: 'Editar Pre�o',
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.of(context).textSecondary, ThemeColors.of(context).textSecondaryLight],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_rounded,
              size: 64,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isEmpty
                ? 'Nenhum produto vinculado'
                : 'Nenhum produto encontrado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Vincule produtos a esta categoria'
                : 'Tente ajustar sua busca',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchQuery.isEmpty)
            ElevatedButton.icon(
              onPressed: _showAddProductDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Vincular Produto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.of(context).success,
                foregroundColor: ThemeColors.of(context).white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Vincular Produto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar produto',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Funcionalidade em desenvolvimento',
              style: TextStyle(color: ThemeColors.of(context).textSecondary),
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produto vinculado com sucesso'),
                  backgroundColor: ThemeColors.of(context).success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Vincular'),
          ),
        ],
      ),
    );
  }

  void _moveProducts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Mover Produtos'),
        content: Column(
          mainAxisSize: MainAxisSize. min,
          children: [
            Text('Selecione a categoria de destino para ${_selectedProducts.length} produto(s):'),
            const SizedBox(height: 16),
            ..._categorias.map((cat) {
              if (cat['nome'] == _categoriaSelecionada) return const SizedBox.shrink();
              return ListTile(
                leading: Icon(cat['icone'], color: cat['cor']),
                title: Text(cat['nome']),
                onTap: () {
                  setState(() {
                    _selectedProducts.clear();
                    _isSelectMode = false;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produtos movidos para ${cat['nome']}'),
                      backgroundColor: ThemeColors.of(context).success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            }).toList(),
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

  void _unlinkProducts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).warning, size: 48),
        title: const Text('Desvincular Produtos'),
        content: Text(
          'Desvincular ${_selectedProducts. length} produto(s) desta categoria?\n\nOs produtos n�o ser�o exclu�dos, apenas desvinculados.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var produto in _selectedProducts) {
                  _produtosPorCategoria[_categoriaSelecionada]?.remove(produto);
                }
                _selectedProducts.clear();
                _isSelectMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produtos desvinculados'),
                  backgroundColor: ThemeColors.of(context).error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
  }

  void _unlinkSingleProduct(Map<String, dynamic> produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).warning, size: 48),
        title: const Text('Desvincular Produto'),
        content: Text(
          'Desvincular "${produto['nome']}" desta categoria? ',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _produtosPorCategoria[_categoriaSelecionada]?.remove(produto);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produto desvinculado'),
                  backgroundColor: ThemeColors.of(context).error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
  }
}











