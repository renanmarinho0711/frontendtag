import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

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
  final List<Map<String, dynamic>> _selectedProducts = [];
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
      'cor': AppThemeColors.blueMaterial,
      'gradiente': [AppThemeColors.blueMaterial, AppThemeColors.blueDark],
      'icone': Icons.local_drink_rounded,
      'produtos': 247,
    },
    {
      'nome': 'Mercearia',
      'cor': AppThemeColors.brownMain,
      'gradiente': [AppThemeColors.brownMain, AppThemeColors.brownDark],
      'icone': Icons.shopping_basket_rounded,
      'produtos': 532,
    },
    {
      'nome': 'Perecíveis',
      'cor': AppThemeColors.greenMaterial,
      'gradiente': [AppThemeColors.greenMaterial, AppThemeColors.successIcon],
      'icone': Icons.restaurant_rounded,
      'produtos': 189,
    },
    {
      'nome': 'Limpeza',
      'cor': AppThemeColors.blueCyan,
      'gradiente': [AppThemeColors.blueCyan, AppThemeColors.blueMaterial],
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
        'nome': 'Guaraná Antarctica 2L',
        'codigo': '7894900012517',
        'preco': 7.50,
        'estoque': 89,
        'imagem': null,
      },
      {
        'id': '3',
        'nome': 'Água Mineral Crystal 500ml',
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
        'nome': 'Feijão Preto 1kg',
        'codigo': '7896064850028',
        'preco': 8.50,
        'estoque': 156,
        'imagem': null,
      },
    ],
    'Perecíveis': [],
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

  // OTIMIZAÇÃO: Getter com cache - só recalcula se categoria ou busca mudaram
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
        backgroundColor: AppThemeColors.greenMaterial,
      ),
      backgroundColor: AppThemeColors.surface,
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
              backgroundColor: AppThemeColors.greenMaterial,
            )
    );
  }

  Widget _buildStatsCards() {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    final estatisticas = [
      {'label': 'Bebidas', 'valor': '247', 'icon': Icons.local_drink_rounded, 'cor': AppThemeColors.blueMaterial, 'mudanca': '+12', 'tipo': 'aumento'},
      {'label': 'Mercearia', 'valor': '532', 'icon': Icons.shopping_basket_rounded, 'cor': AppThemeColors.brownMain, 'mudanca': '+28', 'tipo': 'aumento'},
      {'label': 'Perecíveis', 'valor': '189', 'icon': Icons.restaurant_rounded, 'cor': AppThemeColors.greenMaterial, 'mudanca': '+7', 'tipo': 'aumento'},
      {'label': 'Limpeza', 'valor': '156', 'icon': Icons.cleaning_services_rounded, 'cor': AppThemeColors.blueCyan, 'mudanca': '+5', 'tipo': 'aumento'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimary.withValues(alpha: 0.06),
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
              (stat['cor'] as Color).withValues(alpha: 0.1),
              (stat['cor'] as Color).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingLg.get(isMobile, isTablet)),
          border: Border.all(
            color: (stat['cor'] as Color).withValues(alpha: 0.3),
            width: isMobile ? 1.25 : 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              // ignore: argument_type_not_assignable
              stat['icon'],
              // ignore: argument_type_not_assignable
              color: stat['cor'],
              size: AppSizes.iconMediumLarge.get(isMobile, isTablet),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 7, tablet: 7.5, desktop: 8)),
            Text(
              (stat['valor']).toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 18, mobileFontSize: 16, tabletFontSize: 17),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                // ignore: argument_type_not_assignable
                color: stat['cor'],
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 3, tablet: 3.5, desktop: 4)),
            Text(
              (stat['label']).toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 10, mobileFontSize: 9, tabletFontSize: 9.5),
                overflow: TextOverflow.ellipsis,
                color: AppThemeColors.textSecondary,
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
                color: (stat['cor'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stat['tipo'] == 'aumento')
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 9, tablet: 9.5, desktop: 10),
                      // ignore: argument_type_not_assignable
                      color: stat['cor'],
                    ),
                  if (stat['tipo'] == 'aumento')
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, mobile: 2.5, tablet: 2.75, desktop: 3)),
                  Flexible(
                    child: Text(
                      (stat['mudanca']).toString(),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, baseFontSize: 9, mobileFontSize: 8, tabletFontSize: 8.5),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // ignore: argument_type_not_assignable
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
                color: AppThemeColors.transparent,
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
                          // ignore: argument_type_not_assignable
                          ? LinearGradient(colors: categoria['gradiente'])
                          : null,
                      color: isSelected ?  null : AppThemeColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.paddingXl.get(isMobile, isTablet)),
                      border: Border.all(
                        color: isSelected ? AppThemeColors.transparent : AppThemeColors.textSecondary,
                        width: isSelected ? 0 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? (categoria['cor'] as Color).withValues(alpha: 0.3)
                              : AppThemeColors.textPrimaryOverlay05,
                          blurRadius: isSelected ? 15 : 8,
                          offset: Offset(0, isSelected ? 8 : 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          // ignore: argument_type_not_assignable
                          categoria['icone'],
                          // ignore: argument_type_not_assignable
                          color: isSelected ? AppThemeColors.surface : categoria['cor'],
                          size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (categoria['nome']).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 13,
                              mobileFontSize: 12,
                            ),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? AppThemeColors.surface : AppThemeColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            // ignore: argument_type_not_assignable
                            color: isSelected
                                ? AppThemeColors.surfaceOverlay20
                                : categoria['cor'].withValues(alpha: 0.1),
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
                              // ignore: argument_type_not_assignable
                              color: isSelected ? AppThemeColors.surface : categoria['cor'],
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
              'Escolha uma categoria otimizada para supermercados',
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

  Widget _buildSearchBar() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimaryOverlay05,
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
          fillColor: AppThemeColors.textSecondary,
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
        // ignore: argument_type_not_assignable
        gradient: LinearGradient(colors: categoria['gradiente']),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: (categoria['cor'] as Color).withValues(alpha: 0.3),
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
              color: AppThemeColors.surfaceOverlay20,
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
                color: AppThemeColors.surface,
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
                color: AppThemeColors.surface,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.drive_file_move_rounded, color: AppThemeColors.surface),
            onPressed: _selectedProducts.isEmpty ?  null : () => _moveProducts(),
          ),
          IconButton(
            icon: const Icon(Icons.link_off_rounded, color: AppThemeColors.surface),
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
            isMobile ? 10 : 12,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppThemeColors.transparent,
        labelColor: AppThemeColors.surface,
        unselectedLabelColor: AppThemeColors.textSecondary,
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
          color: AppThemeColors.surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: isSelected
              // ignore: argument_type_not_assignable
              ? Border.all(color: categoria['cor'], width: 2)
              : Border.all(color: AppThemeColors.textSecondary),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (categoria['cor'] as Color).withValues(alpha: 0.2)
                  : AppThemeColors.textPrimaryOverlay05,
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: AppThemeColors.transparent,
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
                            gradient: const LinearGradient(
                              colors: [
                                AppThemeColors.textSecondary,
                                AppThemeColors.textSecondary,
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
                              color: AppThemeColors.textSecondary,
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
                              (produto['nome']).toString(),
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
                              (produto['codigo']).toString(),
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 11,
                                  mobileFontSize: 10,
                                ),
                                color: AppThemeColors.textSecondary,
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
                                      // ignore: argument_type_not_assignable
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
                                    color: AppThemeColors.successPastel,
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
                                      color: AppThemeColors.successIcon,
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
                        // ignore: argument_type_not_assignable
                        color: isSelected ? categoria['cor'] : AppThemeColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          // ignore: argument_type_not_assignable
                          color: isSelected ? categoria['cor'] : AppThemeColors.textSecondary,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppThemeColors.white,
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
          color: AppThemeColors.surface,
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: isSelected
              // ignore: argument_type_not_assignable
              ? Border.all(color: categoria['cor'], width: 2)
              : Border.all(color: AppThemeColors.textSecondary),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (categoria['cor'] as Color).withValues(alpha: 0.2)
                  : AppThemeColors.textPrimaryOverlay05,
              blurRadius: isMobile ? 12 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: AppThemeColors.transparent,
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
                          // ignore: argument_type_not_assignable
                          color: isSelected ? categoria['cor'] : AppThemeColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            // ignore: argument_type_not_assignable
                            color: isSelected ? categoria['cor'] : AppThemeColors.textSecondary,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: AppThemeColors.surface,
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
                      gradient: const LinearGradient(
                        colors: [
                          AppThemeColors.textSecondary,
                          AppThemeColors.textSecondary,
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
                      color: AppThemeColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingMd.get(isMobile, isTablet)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (produto['nome']).toString(),
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
                            color: AppThemeColors.textSecondary,
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
                            // ignore: argument_type_not_assignable
                            color: categoria['cor'].withValues(alpha: 0.1),
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
                              // ignore: argument_type_not_assignable
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
                            // ignore: argument_type_not_assignable
                            color: categoria['cor'],
                          ),
                          Text(
                            (produto['preco']).toString().toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 16,
                                mobileFontSize: 14,
                              ),
                              fontWeight: FontWeight.bold,
                              // ignore: argument_type_not_assignable
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
                            color: AppThemeColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${produto['estoque']}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                baseFontSize: 12,
                                mobileFontSize: 11,
                              ),
                              color: AppThemeColors.textSecondary,
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
                          // ignore: argument_type_not_assignable
                          color: categoria['cor'],
                          size: AppSizes.iconMedium.get(isMobile, isTablet),
                        ),
                        onPressed: () {},
                        tooltip: 'Editar Preço',
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
                colors: [AppThemeColors.textSecondary, AppThemeColors.grey600.withValues(alpha: 0.3)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 64,
              color: AppThemeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isEmpty
                ? 'Nenhum produto vinculado'
                : 'Nenhum produto encontrado',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Vincule produtos a esta categoria'
                : 'Tente ajustar sua busca',
            style: const TextStyle(
              fontSize: 14,
              color: AppThemeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchQuery.isEmpty)
            ElevatedButton.icon(
              onPressed: _showAddProductDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Vincular Produto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColors.greenMaterial,
                foregroundColor: AppThemeColors.white,
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
              style: TextStyle(color: AppThemeColors.textSecondary),
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
                  backgroundColor: AppThemeColors.greenMaterial,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColors.greenMaterial,
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
                // ignore: argument_type_not_assignable
                leading: Icon(cat['icone'], color: cat['cor']),
                title: Text((cat['nome']).toString()),
                onTap: () {
                  setState(() {
                    _selectedProducts.clear();
                    _isSelectMode = false;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produtos movidos para ${cat['nome']}'),
                      backgroundColor: AppThemeColors.greenMaterial,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            }),
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
        icon: const Icon(Icons.link_off_rounded, color: AppThemeColors.warning, size: 48),
        title: const Text('Desvincular Produtos'),
        content: Text(
          'Desvincular ${_selectedProducts. length} produto(s) desta categoria?\n\nOs produtos não serão excluídos, apenas desvinculados.',
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
                  backgroundColor: AppThemeColors.redMain,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColors.redMain,
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
        icon: const Icon(Icons.link_off_rounded, color: AppThemeColors.warning, size: 48),
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
                  backgroundColor: AppThemeColors.redMain,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColors.redMain,
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

