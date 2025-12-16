import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

class CategoriasAdminScreen extends ConsumerStatefulWidget {
  const CategoriasAdminScreen({super.key});

  @override
  ConsumerState<CategoriasAdminScreen> createState() => _CategoriasAdminScreenState();
}

class _CategoriasAdminScreenState extends ConsumerState<CategoriasAdminScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  List<Map<String, dynamic>> _selectedItems = [];
  bool _isSelectMode = false;
  String _sortOrder = 'nome_asc';
  String _searchQuery = '';
  String _filtroStatus = 'todas';
  late TabController _tabController;
  
  // Cache para otimiza��o
  List<Map<String, dynamic>>? _cachedCategoriasFiltradas;
  String? _lastSearchQuery;
  String? _lastSortOrder;
  String? _lastFiltroStatus;
  int? _lastCategoriesLength;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Carregar categorias do backend
    Future.microtask(() {
      final state = ref.read(categoriesProvider);
      if (state.status == LoadingStatus.initial) {
        ref.read(categoriesProvider.notifier).initialize();
      }
    });
  }

  /// Converte CategoryModel para Map<String, dynamic> para compatibilidade
  List<Map<String, dynamic>> _getCategorias() {
    final categoriesState = ref.watch(categoriesProvider);
    final allCategories = categoriesState.categories;
    
    return allCategories.map((cat) {
      // Contar subcategorias: categorias que t�m esta como parentId
      final subcategoriasCount = allCategories.where((c) => c.parentId == cat.id).length;
      
      return {
        'id': cat.id,
        'nome': cat.nome,
        'produtos': cat.quantidadeProdutos,
        'ativa': cat.isActive,
        'icone': _getIconForCategory(cat.nome),
        'cor': _getColorForCategory(cat.nome),
        'gradiente': _getGradientForCategory(cat.nome),
        'subcategorias': subcategoriasCount,
        'ultimaAtualizacao': cat.createdAt.toString().substring(0, 10),
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
    return ThemeColors.of(context).info;
  }

  List<Color> _getGradientForCategory(String nome) {
    final lower = nome.toLowerCase();
    if (lower.contains('bebida')) return [ThemeColors.of(context).primary, ThemeColors.of(context).blueDark];
    if (lower.contains('mercear')) return [ThemeColors.of(context).brownMain, ThemeColors.of(context).brownDark];
    if (lower.contains('perec')) return [ThemeColors.of(context).success, ThemeColors.of(context).successIcon];
    if (lower.contains('limp')) return [ThemeColors.of(context).blueCyan, ThemeColors.of(context).primary];
    if (lower.contains('higien')) return [ThemeColors.of(context).blueLight, ThemeColors.of(context).primary];
    if (lower.contains('padar')) return [ThemeColors.of(context).yellowGold, ThemeColors.of(context).warning];
    return [ThemeColors.of(context).info, ThemeColors.of(context).blueDark];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // OTIMIZA��O: Getter com cache - s� recalcula se filtros mudaram
  List<Map<String, dynamic>> get _categoriasFiltradas {
    final categorias = _getCategorias();
    
    if (_cachedCategoriasFiltradas != null &&
        _lastSearchQuery == _searchQuery &&
        _lastSortOrder == _sortOrder &&
        _lastFiltroStatus == _filtroStatus &&
        _lastCategoriesLength == categorias.length) {
      return _cachedCategoriasFiltradas!;
    }
    
    _lastSearchQuery = _searchQuery;
    _lastSortOrder = _sortOrder;
    _lastFiltroStatus = _filtroStatus;
    _lastCategoriesLength = categorias.length;
    
    var lista = categorias.where((cat) {
      final matchSearch = cat['nome'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatus = _filtroStatus == 'todas' ||
          (_filtroStatus == 'ativas' && cat['ativa'] == true) ||
          (_filtroStatus == 'inativas' && cat['ativa'] == false);
      return matchSearch && matchStatus;
    }).toList();

    lista.sort((a, b) {
      switch (_sortOrder) {
        case 'nome_asc':
          return a['nome'].compareTo(b['nome']);
        case 'nome_desc':
          return b['nome'].compareTo(a['nome']);
        case 'produtos_asc':
          return a['produtos'].compareTo(b['produtos']);
        case 'produtos_desc':
          return b['produtos'].compareTo(a['produtos']);
        default:
          return 0;
      }
    });

    _cachedCategoriasFiltradas = lista;
    return _cachedCategoriasFiltradas!;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

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
          'Administra��o Completa',
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
                      if (_isSelectMode) _buildBulkActions(),
                      _buildTabBar(),
                      _buildSearchAndFilters(),
                    ],
                  ),
                ),
              ];
            },
            body: _categoriasFiltradas.isEmpty
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Adicionar nova categoria'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nova'),
              backgroundColor: ThemeColors.of(context).success,
            )
    );
  }

  Widget _buildBulkActions() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark],
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).successLight,
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
              '${_selectedItems.length}',
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
              'selecionada${_selectedItems.length != 1 ? 's' : ''}',
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
            onPressed: _selectedItems.isEmpty ?  null : () => _bulkEdit(),
          ),
          IconButton(
            icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).surface),
            onPressed: _selectedItems.isEmpty ? null : () => _bulkDelete(),
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
        AppSizes.paddingXxs.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : (isTablet ?  14 : 16),
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
          fontSize:ResponsiveHelper.getResponsiveFontSize(
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

  Widget _buildSearchAndFilters() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).textPrimaryOverlay05,
            blurRadius: isMobile ?  8 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() {
              _searchQuery = value;
              _cachedCategoriasFiltradas = null;
            }),
            decoration: InputDecoration(
              hintText: 'Buscar categorias.. .',
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
                        _cachedCategoriasFiltradas = null;
                      }),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                borderSide: BorderSide(color: ThemeColors.of(context).textSecondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                borderSide: BorderSide(color: ThemeColors.of(context).textSecondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.paddingBase.get(isMobile, isTablet)),
                borderSide: BorderSide(color: ThemeColors.of(context).success, width: 2),
              ),
              filled: true,
              fillColor: ThemeColors.of(context).textSecondary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todas', 'todas'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Ativas', 'ativas'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Inativas', 'inativas'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.sort_rounded,
                  color: ThemeColors.of(context).textSecondary,
                ),
                onSelected: (value) => setState(() {
                  _sortOrder = value;
                  _cachedCategoriasFiltradas = null;
                }),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'nome_asc', child: Text('Nome (A-Z)')),
                  const PopupMenuItem(value: 'nome_desc', child: Text('Nome (Z-A)')),
                  const PopupMenuItem(value: 'produtos_asc', child: Text('Produtos (menor)')),
                  const PopupMenuItem(value: 'produtos_desc', child: Text('Produtos (maior)')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filtroStatus == value;
    final isMobile = ResponsiveHelper.isMobile(context);

    return InkWell(
      onTap: () => setState(() {
        _filtroStatus = value;
        _cachedCategoriasFiltradas = null;
      }),
      borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMdAlt.get(isMobile, isTablet),
          vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [ThemeColors.of(context).success, ThemeColors.of(context).greenDark])
              : null,
          color: isSelected ?  null : ThemeColors.of(context).textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.paddingLgAlt.get(isMobile, isTablet)),
          border: Border.all(
            color: isSelected ? ThemeColors.of(context).transparent : ThemeColors.of(context).textTertiary.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              baseFontSize: 13,
              mobileFontSize: 12,
            ),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).textSecondary,
          ),
        ),
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return GridView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.paddingBaseLg.get(isMobile, isTablet),
        mainAxisSpacing: AppSizes.paddingBaseLg.get(isMobile, isTablet),
        childAspectRatio: isMobile ? 1.0 : 1.1,
      ),
      itemCount: _categoriasFiltradas.length,
      itemBuilder: (context, index) {
        return _buildGridCard(_categoriasFiltradas[index], index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      itemCount: _categoriasFiltradas.length,
      itemBuilder: (context, index) {
        return _buildListCard(_categoriasFiltradas[index], index);
      },
    );
  }

  Widget _buildGridCard(Map<String, dynamic> categoria, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _selectedItems.contains(categoria);

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
          gradient: LinearGradient(colors: categoria['gradiente']),
          borderRadius: BorderRadius.circular(
            isMobile ? 16 : (isTablet ? 18 : 20),
          ),
          border: isSelected ?  Border.all(color: ThemeColors.of(context).surface, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: (categoria['cor'] as Color)Light,
              blurRadius: isMobile ? 15 : 20,
              offset: Offset(0, isMobile ? 8 : 10),
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
                    _selectedItems.remove(categoria);
                  } else {
                    _selectedItems.add(categoria);
                  }
                });
              } else {
                _editCategoria(categoria);
              }
            },
            onLongPress: () {
              if (! _isSelectMode) {
                setState(() {
                  _isSelectMode = true;
                  _selectedItems.add(categoria);
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
                    AppSizes.cardPadding.get(isMobile, isTablet),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          AppSizes.paddingMdLg.get(isMobile, isTablet),
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).surfaceOverlay20,
                          borderRadius: BorderRadius.circular(
                            isMobile ? 12 : 14,
                          ),
                        ),
                        child: Icon(
                          categoria['icone'],
                          color: ThemeColors.of(context).surface,
                          size: ResponsiveHelper.getResponsiveIconSize(
                            context,
                            mobile: 32,
                            tablet: 36,
                            desktop: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        categoria['nome'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                            mobileFontSize: 14,
                          ),
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.of(context).surface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.of(context).surfaceOverlay20,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${categoria['produtos']} produtos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              baseFontSize: 12,
                              mobileFontSize: 11,
                            ),
                            color: ThemeColors.of(context).surface,
                            fontWeight: FontWeight.w600,
                          ),
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
                        color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).surfaceOverlay30,
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: categoria['cor'],
                              size: 18,
                            )
                          : null,
                    ),
                  ),
                if (! categoria['ativa'])
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.extraSmallPadding.get(isMobile, isTablet), vertical: 4),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'INATIVA',
                        style: TextStyle(
                          color: ThemeColors.of(context).surface,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(Map<String, dynamic> categoria, int index) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isSelected = _selectedItems.contains(categoria);

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
            isMobile ?  16 : (isTablet ? 18 : 20),
          ),
          border: isSelected
              ? Border.all(color: ThemeColors.of(context).success, width: 2)
              : Border.all(color: ThemeColors.of(context).textSecondary),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? ThemeColors.of(context).successLight
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
              if (_isSelectMode) {
                setState(() {
                  if (isSelected) {
                    _selectedItems.remove(categoria);
                  } else {
                    _selectedItems.add(categoria);
                  }
                });
              } else {
                _editCategoria(categoria);
              }
            },
            onLongPress: () {
              if (!_isSelectMode) {
                setState(() {
                  _isSelectMode = true;
                  _selectedItems.add(categoria);
                });
              }
            },
            borderRadius: BorderRadius.circular(
              isMobile ? 16 : (isTablet ? 18 : 20),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                AppSizes.cardPadding.get(isMobile, isTablet),
              ),
              child: Row(
                children: [
                  if (_isSelectMode)
                    Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ThemeColors.of(context).success
                            : ThemeColors.of(context).textSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: ThemeColors.of(context).surface,
                              size: 18,
                            )
                          : null,
                    ),
                  Container(
                    width: AppSizes.iconHeroXl.get(isMobile, isTablet),
                    height: AppSizes.iconHeroXl.get(isMobile, isTablet),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: categoria['gradiente']),
                      borderRadius: BorderRadius.circular(
                        isMobile ? 14 : 16,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (categoria['cor'] as Color)Light,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      categoria['icone'],
                      color: ThemeColors.of(context).surface,
                      size: AppSizes.iconExtraLarge.get(isMobile, isTablet),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                categoria['nome'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    baseFontSize: 16,
                                    mobileFontSize: 15,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (! categoria['ativa'])
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeColors.of(context).errorLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: ThemeColors.of(context).error),
                                ),
                                child: Text(
                                  'INATIVA',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColors.of(context).warningDark,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2_rounded,
                              size: 16,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${categoria['produtos']} produtos',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 13,
                                  mobileFontSize: 12,
                                ),
                                color: ThemeColors.of(context).textTertiary.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.folder_rounded,
                              size: 16,
                              color: ThemeColors.of(context).textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${categoria['subcategorias']} subcategorias',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  baseFontSize: 13,
                                  mobileFontSize: 12,
                                ),
                                color: ThemeColors.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Atualizado em ${categoria['ultimaAtualizacao']}',
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
                  if (!_isSelectMode)
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert_rounded, color: ThemeColors.of(context).textSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.edit_rounded, size: 20, color: ThemeColors.of(context).primary),
                              const SizedBox(width: 12),
                              const Text('Editar'),
                            ],
                          ),
                          onTap: () => Future.delayed(
                            Duration.zero,
                            () => _editCategoria(categoria),
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(
                                categoria['ativa']
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 20,
                                color: ThemeColors.of(context).yellowGold,
                              ),
                              const SizedBox(width: 12),
                              Text(categoria['ativa'] ? 'Desativar' : 'Ativar'),
                            ],
                          ),
                          onTap: () => Future.delayed(
                            Duration.zero,
                            () => _toggleStatus(categoria),
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.delete_rounded, size: 20, color: ThemeColors.of(context).error),
                              const SizedBox(width: 12),
                              const Text('Excluir'),
                            ],
                          ),
                          onTap: () => Future.delayed(
                            Duration.zero,
                            () => _deleteCategoria(categoria),
                          ),
                        ),
                      ],
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
                colors: ThemeColors.of(context).categoriasGradient,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhuma categoria encontrada',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente ajustar os filtros de busca',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _editCategoria(Map<String, dynamic> categoria) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar: ${categoria['nome']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleStatus(Map<String, dynamic> categoria) {
    setState(() {
      categoria['ativa'] = !categoria['ativa'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${categoria['nome']} ${categoria['ativa'] ? 'ativada' : 'desativada'}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteCategoria(Map<String, dynamic> categoria) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).error, size: 48),
        title: const Text('Confirmar Exclus�o'),
        content: Text(
          'Deseja realmente excluir "${categoria['nome']}"?\n\nEsta a��o n�o pode ser desfeita.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Chamar backend para excluir
              final success = await ref.read(categoriesProvider.notifier).deleteCategory(categoria['id']);
              Navigator.pop(context);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${categoria['nome']} exclu�da'),
                    backgroundColor: ThemeColors.of(context).error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro ao excluir categoria'),
                    backgroundColor: ThemeColors.of(context).error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.of(context).error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _bulkEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar ${_selectedItems.length} categorias'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _bulkDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_rounded, color: ThemeColors.of(context).error, size: 48),
        title: const Text('Excluir em Lote'),
        content: Text(
          'Deseja realmente excluir ${_selectedItems.length} categorias?\n\nEsta a��o n�o pode ser desfeita.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              int deleted = 0;
              for (var item in _selectedItems) {
                final success = await ref.read(categoriesProvider.notifier).deleteCategory(item['id']);
                if (success) deleted++;
              }
              setState(() {
                _selectedItems.clear();
                _isSelectMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$deleted categorias exclu�das'),
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
            child: const Text('Excluir Tudo'),
          ),
        ],
      ),
    );
  }
}












