import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/categories/presentation/screens/category_add_screen.dart';
import 'package:tagbean/features/categories/presentation/screens/category_edit_screen.dart';
import 'package:tagbean/features/categories/presentation/providers/categories_provider.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/core/utils/responsive_cache.dart';
import 'package:tagbean/design_system/design_system.dart';

class CategoriasListaScreen extends ConsumerStatefulWidget {
  const CategoriasListaScreen({super.key});

  @override
  ConsumerState<CategoriasListaScreen> createState() => _CategoriasListaScreenState();
}

class _CategoriasListaScreenState extends ConsumerState<CategoriasListaScreen>
    with TickerProviderStateMixin, ResponsiveCache {
  late AnimationController _fabController;
  // NOTA: _sortBy removido (morto)

  @override
  void initState() {
    super.initState();
    initResponsiveCache();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    // Inicializa o provider de categorias
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // NOTA: Métodos removidos: _getIconData, _buildSearchBar, _buildSortButton (código morto)

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);
    final categories = categoriesState.filteredCategories;
    final totalProdutos = categoriesState.totalProdutos;

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
          'Visualizar Categorias',
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
        backgroundColor: AppThemeColors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppThemeColors.greenMaterial, AppThemeColors.greenDark],
            ),
          ),
        ),
      ),
      backgroundColor: AppThemeColors.surface,
      body: PopScope(
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
                  backgroundColor: AppThemeColors.surface,
                  body: categoriesState.status == LoadingStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeader(totalProdutos, categoriesState.categories.length),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: categories.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    return RepaintBoundary(
                                      child: _buildModernCategoriaCard(
                                        categories[index],
                                        index,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      floatingActionButton: ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _navigatorKey.currentState?.push(
                    MaterialPageRoute(
                      builder: (context) => const CategoriasAdicionarScreen(),
                    ),
                  ).then((_) => _fabController.forward(from: 0.0));
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Nova Categoria'),
                backgroundColor: AppThemeColors.greenMaterial,
              ),
            ),
    );
  }

  Widget _buildHeader(int totalProdutos, int totalCategorias) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Container(
      margin: EdgeInsets.all(
        AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding.get(isMobile, isTablet),
        vertical: AppSizes.paddingMd.get(isMobile, isTablet),
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.darkBackground,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveBorderRadius(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimary.withValues(alpha: 0.4),
            blurRadius: ResponsiveHelper.getResponsiveBlurRadius(
              context,
              mobile: 15,
              tablet: 18,
              desktop: 20,
            ),
            offset: Offset(0, isMobile ? 6 : (isTablet ? 7 : 8)),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppSizes.paddingBase.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: AppThemeColors.surfaceOverlay20,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
            ),
            child: Icon(
              Icons.category_rounded,
              color: AppThemeColors.surface,
              size: AppSizes.iconLarge.get(isMobile, isTablet),
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
                  'Categorias',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 20,
                      mobileFontSize: 18,
                      tabletFontSize: 19,
                    ),
                  overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.surface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: AppSizes.paddingMicro.get(isMobile, isTablet),
                ),
                Text(
                  '$totalCategorias categorias • $totalProdutos produtos',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 13,
                      mobileFontSize: 11,
                      tabletFontSize: 12,
                    ),
                  overflow: TextOverflow.ellipsis,
                    color: AppThemeColors.surfaceOverlay70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              vertical: AppSizes.extraSmallPadding.get(isMobile, isTablet),
            ),
            decoration: BoxDecoration(
              color: AppThemeColors.blueCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveBorderRadius(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              border: Border.all(color: AppThemeColors.blueCyan.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_rounded,
                  color: AppThemeColors.blueCyan,
                  size: AppSizes.iconTiny.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingXsAlt.get(isMobile, isTablet),
                ),
                Text(
                  '$totalCategorias',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      baseFontSize: 11,
                      mobileFontSize: 10,
                      tabletFontSize: 10.5,
                    ),
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildModernCategoriaCard(CategoryModel categoria, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppThemeColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: categoria.cor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: AppThemeColors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(20),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            leading: Hero(
              tag: 'categoria_${categoria.nome}',
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [categoria.cor, categoria.cor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: categoria.cor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  categoria.iconData,
                  color: AppThemeColors.surface,
                  size: 28,
                ),
              ),
            ),
            title: Text(
              categoria.nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  categoria.descricao ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppThemeColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: _buildInfoChip(
                        Icons.inventory_2_rounded,
                        '${categoria.quantidadeProdutos} produtos',
                        categoria.cor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Builder(
                        builder: (context) {
                          final categoriesState = ref.watch(categoriesProvider);
                          final subsCount = categoriesState.countSubcategories(categoria.id);
                          return _buildInfoChip(
                            Icons.folder_rounded,
                            '$subsCount subs',
                            categoria.cor,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppThemeColors.textSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_rounded, color: AppThemeColors.textSecondary, size: 20),
                    onPressed: () {
                      _navigatorKey.currentState?.push(
                        MaterialPageRoute(
                          builder: (context) => CategoriasEditarScreen(categoria: categoria),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppThemeColors.errorPastel,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_rounded, color: AppThemeColors.redMain, size: 20),
                    onPressed: () => _confirmarExclusao(categoria),
                  ),
                ),
              ],
            ),
            children: [
              _buildExpandedContent(categoria),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(CategoryModel categoria) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemeColors.textSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.folder_special_rounded,
                size: 18,
                color: AppThemeColors.textSecondary,
              ),
              SizedBox(width: 8),
              Text(
                'Subcategorias',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final categoriesState = ref.watch(categoriesProvider);
              final subcategorias = categoriesState.getSubcategories(categoria.id);
              
              if (subcategorias.isEmpty) {
                return const Text(
                  'Nenhuma subcategoria',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppThemeColors.textSecondary,
                  ),
                );
              }
              
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: subcategorias.map((sub) => Chip(
                  avatar: Icon(sub.iconData, size: 16, color: sub.cor),
                  label: Text(sub.nome),
                  backgroundColor: sub.cor.withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: sub.cor, fontSize: 12),
                )).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Visualizando produtos de ${categoria.nome}'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.list_rounded, size: 18, color: categoria.cor),
                  label: Text(
                    'Ver Produtos',
                    style: TextStyle(color: categoria.cor),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: categoria.cor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => CategoriasEditarScreen(categoria: categoria),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: categoria.cor,
                    foregroundColor: AppThemeColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final searchQuery = ref.watch(categoriesProvider).searchQuery;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: AppThemeColors.textSecondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.category_outlined,
              size: 80,
              color: AppThemeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhuma categoria encontrada',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? 'Comece criando sua primeira categoria'
                : 'Tente uma busca diferente',
            style: const TextStyle(
              fontSize: 14,
              color: AppThemeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(CategoryModel categoria) {
    if (categoria.quantidadeProdutos > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: const Icon(Icons.block_rounded, color: AppThemeColors.yellowGold, size: 48),
          title: const Text(
            'Não é possível excluir',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'A categoria "${categoria.nome}" possui ${categoria.quantidadeProdutos} produtos associados.\n\n'
            'Mova ou exclua os produtos antes de excluir a categoria.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendi'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: const Icon(Icons.warning_rounded, color: AppThemeColors.redMain, size: 48),
          title: const Text(
            'Confirmar Exclusão',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Deseja realmente excluir a categoria "${categoria.nome}"?\n\n'
            'Esta ação não pode ser desfeita.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(categoriesProvider.notifier).deleteCategory(categoria.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Categoria "${categoria.nome}" excluída'),
                    backgroundColor: AppThemeColors.redMain,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColors.redMain,
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
  }
}

