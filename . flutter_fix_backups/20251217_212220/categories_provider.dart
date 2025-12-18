import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/enums/loading_status.dart';
import 'package:tagbean/features/categories/data/models/category_models.dart';
import 'package:tagbean/features/categories/data/repositories/categories_repository.dart';

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

/// Provider do CategoriesRepository
final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepository();
});

// =============================================================================
// CATEGORIES STATE
// =============================================================================

class CategoriesState {
  final LoadingStatus status;
  final List<CategoryModel> categories;
  final List<CategoryModel> filteredCategories;
  final CategoryModel? selectedCategory;
  final String searchQuery;
  final String sortBy; // 'nome', 'quantidade'
  final String? error;

  const CategoriesState({
    this.status = LoadingStatus.initial,
    this.categories = const [],
    this.filteredCategories = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.sortBy = 'nome',
    this.error,
  });

  int get totalProdutos => categories.fold(0, (sum, cat) => sum + cat.quantidadeProdutos);

  /// Conta subcategorias de uma categoria
  int countSubcategories(String categoryId) {
    return categories.where((cat) => cat.parentId == categoryId).length;
  }

  /// Obtém subcategorias de uma categoria
  List<CategoryModel> getSubcategories(String categoryId) {
    return categories.where((cat) => cat.parentId == categoryId).toList();
  }

  CategoriesState copyWith({
    LoadingStatus? status,
    List<CategoryModel>? categories,
    List<CategoryModel>? filteredCategories,
    CategoryModel? selectedCategory,
    String? searchQuery,
    String? sortBy,
    String? error,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      error: error ?? this.error,
    );
  }

  factory CategoriesState.initial() => const CategoriesState();
}

// =============================================================================
// CATEGORIES NOTIFIER
// =============================================================================

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final CategoriesRepository _repository;
  
  CategoriesNotifier(this._repository) : super(CategoriesState.initial());

  /// Inicializa carregando as categorias
  Future<void> initialize() async {
    if (state.categories.isNotEmpty) return;
    
    state = state.copyWith(status: LoadingStatus.loading, error: null);
    
    try {
      // API: GET /api/categories
      final response = await _repository.getCategories();
      
      if (response.isSuccess && response.data != null) {
        final apiCategories = response.data!;
        
        state = state.copyWith(
          status: LoadingStatus.success,
          categories: apiCategories,
          filteredCategories: _applyFilters(apiCategories, '', 'nome'),
          error: null,
        );
      } else {
        // ERRO: API retornou falha - NÀO usar mock silenciosamente
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar categorias da API',
          categories: [],
          filteredCategories: [],
        );
      }
    } catch (e) {
      // ERRO: Exceção na chamada - mostrar erro ao usuário
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
        categories: [],
        filteredCategories: [],
      );
    }
  }
  
  // NOTA: _parseColor removido - nunca era usado

  /// Busca categorias por nome
  void search(String query) {
    state = state.copyWith(
      searchQuery: query,
      filteredCategories: _applyFilters(state.categories, query, state.sortBy),
    );
  }

  /// Ordena as categorias
  void setSortBy(String sortBy) {
    state = state.copyWith(
      sortBy: sortBy,
      filteredCategories: _applyFilters(state.categories, state.searchQuery, sortBy),
    );
  }

  /// Seleciona uma categoria
  void selectCategory(CategoryModel? category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Adiciona uma nova categoria
  Future<void> addCategory(CategoryModel category) async {
    // API: POST /api/categories
    try {
      final response = await _repository.createCategory(
        nome: category.nome,
        descricao: category.descricao,
        icone: category.icone,
        cor: '#${category.cor.value.toRadixString(16).substring(2)}',
      );
      
      if (response.isSuccess) {
        await initialize(); // Recarrega lista
        return;
      } else {
        throw Exception(response.message ?? 'Erro ao adicionar categoria');
      }
    } catch (e) {
      // Propaga o erro para a UI tratar
      throw Exception('Falha ao adicionar categoria: ${e.toString()}');
    }
  }

  /// Atualiza uma categoria existente
  Future<void> updateCategory(CategoryModel category) async {
    // API: PUT /api/categories/:id
    try {
      final response = await _repository.updateCategory(
        id: category.id,
        nome: category.nome,
        descricao: category.descricao,
        icone: category.icone,
        cor: '#${category.cor.value.toRadixString(16).substring(2)}',
        ativo: category.status == CategoryStatus.active,
      );
      
      if (response.isSuccess) {
        await initialize(); // Recarrega lista
        return;
      } else {
        throw Exception(response.message ?? 'Erro ao atualizar categoria');
      }
    } catch (e) {
      // Propaga o erro para a UI tratar
      throw Exception('Falha ao atualizar categoria: ${e.toString()}');
    }
  }

  /// Remove uma categoria
  Future<bool> deleteCategory(String categoryId) async {
    // API: DELETE /api/categories/:id
    try {
      final response = await _repository.deleteCategory(categoryId);
      
      if (response.isSuccess) {
        final updatedCategories = state.categories.where((c) => c.id != categoryId).toList();
        state = state.copyWith(
          categories: updatedCategories,
          filteredCategories: _applyFilters(updatedCategories, state.searchQuery, state.sortBy),
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Aplica filtros e ordenação
  List<CategoryModel> _applyFilters(List<CategoryModel> categories, String query, String sortBy) {
    var filtered = categories.where((cat) {
      return cat.nome.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (sortBy == 'nome') {
      filtered.sort((a, b) => a.nome.compareTo(b.nome));
    } else if (sortBy == 'quantidade') {
      filtered.sort((a, b) => b.quantidadeProdutos.compareTo(a.quantidadeProdutos));
    }

    return filtered;
  }
}

// =============================================================================
// CATEGORY STATS STATE
// =============================================================================

class CategoryStatsState {
  final LoadingStatus status;
  final List<CategoryStatsModel> stats;
  final String? error;

  const CategoryStatsState({
    this.status = LoadingStatus.initial,
    this.stats = const [],
    this.error,
  });

  double get totalValorEstoque => stats.fold(0, (sum, s) => sum + s.valorTotalEstoque);
  int get totalProdutos => stats.fold(0, (sum, s) => sum + s.totalProdutos);
  double get margemMediaGeral => 
      stats.isNotEmpty ? stats.fold(0.0, (sum, s) => sum + s.margemMedia) / stats.length : 0;
  
  // Getters adicionais para estatísticas gerais
  int get totalVendas => stats.fold(0, (sum, s) => sum + s.totalVendas);
  double get totalFaturamento => stats.fold(0.0, (sum, s) => sum + s.faturamento);
  double get ticketMedio => totalVendas > 0 ? totalFaturamento / totalVendas : 0.0;
  double get crescimento => 
      stats.isNotEmpty ? stats.fold(0.0, (sum, s) => sum + s.crescimento) / stats.length : 0.0;

  CategoryStatsState copyWith({
    LoadingStatus? status,
    List<CategoryStatsModel>? stats,
    String? error,
  }) {
    return CategoryStatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      error: error ?? this.error,
    );
  }

  factory CategoryStatsState.initial() => const CategoryStatsState();
}

class CategoryStatsNotifier extends StateNotifier<CategoryStatsState> {
  final CategoriesRepository _repository;
  
  CategoryStatsNotifier(this._repository) : super(CategoryStatsState.initial());

  Future<void> loadStats({String periodo = '30dias'}) async {
    state = state.copyWith(status: LoadingStatus.loading, error: null);
    
    try {
      // Nota: Quando endpoint GET /api/categorias/estatisticas?periodo={periodo} estiver disponível,
      // retornará stats completas com vendas, faturamento, crescimento, etc.
      // Por ora, busca categorias básicas e monta stats iniciais
      
      final response = await _repository.getCategories();
      
      if (response.isSuccess && response.data != null) {
        final categories = response.data!;
        // Total de categorias disponível em categories.length
        
        // Calcula participação percentual baseado em quantidade de produtos
        final totalProdutosGeral = categories.fold<int>(0, (sum, c) => sum + c.quantidadeProdutos);
        
        // Transforma categorias em stats
        final stats = categories.map((category) {
          final percentual = totalProdutosGeral > 0 
              ? (category.quantidadeProdutos / totalProdutosGeral) * 100 
              : 0.0;
          
          return CategoryStatsModel(
            categoryId: category.id,
            categoryName: category.nome,
            totalProdutos: category.quantidadeProdutos,
            produtosAtivos: category.quantidadeProdutos,
            produtosInativos: 0,
            valorTotalEstoque: 0.0,
            margemMedia: 0.0,
            vendasUltimos30Dias: 0,
            receita30Dias: 0.0,
            // Campos calculados - serão populados quando endpoint de stats estiver disponível
            totalVendas: 0,
            faturamento: 0.0,
            percentualParticipacao: percentual,
            crescimento: 0.0,
            ticketMedio: 0.0,
            margemLucro: 0.0,
          );
        }).toList();
        
        state = state.copyWith(
          status: LoadingStatus.success,
          stats: stats,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar estatísticas de categorias',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
      );
    }
  }
}

// =============================================================================
// CATEGORY PRODUCTS STATE
// =============================================================================

class CategoryProductsState {
  final LoadingStatus status;
  final String? categoryId;
  final String? categoryName;
  final List<CategoryProductModel> products;
  final String searchQuery;
  final String? error;

  const CategoryProductsState({
    this.status = LoadingStatus.initial,
    this.categoryId,
    this.categoryName,
    this.products = const [],
    this.searchQuery = '',
    this.error,
  });

  List<CategoryProductModel> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    return products.where((p) {
      return p.nome.toLowerCase().contains(searchQuery.toLowerCase()) ||
             (p.sku?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  CategoryProductsState copyWith({
    LoadingStatus? status,
    String? categoryId,
    String? categoryName,
    List<CategoryProductModel>? products,
    String? searchQuery,
    String? error,
  }) {
    return CategoryProductsState(
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error ?? this.error,
    );
  }

  factory CategoryProductsState.initial() => const CategoryProductsState();
}

class CategoryProductsNotifier extends StateNotifier<CategoryProductsState> {
  final CategoriesRepository _repository;
  
  CategoryProductsNotifier(this._repository) : super(CategoryProductsState.initial());

  Future<void> loadProducts(String categoryId, String categoryName) async {
    state = state.copyWith(
      status: LoadingStatus.loading,
      categoryId: categoryId,
      categoryName: categoryName,
      error: null,
    );
    
    try {
      // API: GET /api/categories/{id}/products
      final response = await _repository.getCategoryProducts(categoryId);
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          status: LoadingStatus.success,
          products: response.data!,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar produtos da categoria',
          products: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
        products: [],
      );
    }
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clear() {
    state = CategoryProductsState.initial();
  }

  /// Vincula um produto à categoria atual
  Future<bool> addProductToCategory(String productId) async {
    if (state.categoryId == null) return false;
    
    try {
      final response = await _repository.addProductToCategory(
        productId: productId,
        categoryId: state.categoryId!,
      );
      
      if (response.isSuccess) {
        // Recarrega a lista de produtos
        await loadProducts(state.categoryId!, state.categoryName ?? '');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Remove um produto da categoria atual
  Future<bool> removeProductFromCategory(String productId) async {
    try {
      final response = await _repository.removeProductFromCategory(
        productId: productId,
      );
      
      if (response.isSuccess) {
        // Atualiza lista local removendo o produto
        final updatedProducts = state.products
            .where((p) => p.id != productId)
            .toList();
        state = state.copyWith(products: updatedProducts);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Busca produtos disponíveis para vincular
  Future<List<CategoryProductModel>> getAvailableProducts({String? search}) async {
    try {
      final response = await _repository.getAvailableProducts(
        search: search,
        pageSize: 100,
      );
      
      if (response.isSuccess && response.data != null) {
        // Filtra produtos que já estão na categoria atual
        final currentProductIds = state.products.map((p) => p.id).toSet();
        return response.data!
            .where((p) => !currentProductIds.contains(p.id))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

// =============================================================================
// SUGGESTED CATEGORIES STATE
// =============================================================================

class SuggestedCategoriesState {
  final LoadingStatus status;
  final List<SuggestedCategoryModel> suggestions;
  final String? error;

  const SuggestedCategoriesState({
    this.status = LoadingStatus.initial,
    this.suggestions = const [],
    this.error,
  });

  SuggestedCategoriesState copyWith({
    LoadingStatus? status,
    List<SuggestedCategoryModel>? suggestions,
    String? error,
  }) {
    return SuggestedCategoriesState(
      status: status ?? this.status,
      suggestions: suggestions ?? this.suggestions,
      error: error ?? this.error,
    );
  }

  factory SuggestedCategoriesState.initial() => const SuggestedCategoriesState();
}

class SuggestedCategoriesNotifier extends StateNotifier<SuggestedCategoriesState> {
  final CategoriesRepository _repository;
  
  SuggestedCategoriesNotifier(this._repository) : super(SuggestedCategoriesState.initial());

  Future<void> loadSuggestions() async {
    state = state.copyWith(status: LoadingStatus.loading, error: null);
    
    try {
      // API: GET /api/categories/suggested
      final response = await _repository.getSuggestedCategories();
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          status: LoadingStatus.success,
          suggestions: response.data!,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: LoadingStatus.error,
          error: response.message ?? 'Erro ao carregar categorias sugeridas',
          suggestions: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: LoadingStatus.error,
        error: 'Falha ao conectar com o servidor: ${e.toString()}',
        suggestions: [],
      );
    }
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Provider principal de categorias
final categoriesProvider = StateNotifierProvider<CategoriesNotifier, CategoriesState>(
  (ref) {
    final repository = ref.watch(categoriesRepositoryProvider);
    return CategoriesNotifier(repository);
  },
);

/// Provider de estatísticas de categorias
final categoryStatsProvider = StateNotifierProvider<CategoryStatsNotifier, CategoryStatsState>(
  (ref) {
    final repository = ref.watch(categoriesRepositoryProvider);
    return CategoryStatsNotifier(repository);
  },
);

/// Provider de produtos por categoria
final categoryProductsProvider = StateNotifierProvider<CategoryProductsNotifier, CategoryProductsState>(
  (ref) {
    final repository = ref.watch(categoriesRepositoryProvider);
    return CategoryProductsNotifier(repository);
  },
);

/// Provider de sugestões de categorias
final suggestedCategoriesProvider = StateNotifierProvider<SuggestedCategoriesNotifier, SuggestedCategoriesState>(
  (ref) {
    final repository = ref.watch(categoriesRepositoryProvider);
    return SuggestedCategoriesNotifier(repository);
  },
);

/// Provider para categorias com produtos (GET /api/categories/with-products)
final categoriesWithProductsProvider = FutureProvider<List<CategoryWithProductsModel>>((ref) async {
  final repository = ref.watch(categoriesRepositoryProvider);
  final response = await repository.getCategoriesWithProducts();
  
  if (response.isSuccess && response.data != null) {
    return response.data!;
  }
  
  throw Exception(response.message ?? 'Erro ao carregar categorias com produtos');
});

/// Provider para categorias ativas (GET /api/categories/active)
final activeCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.watch(categoriesRepositoryProvider);
  final response = await repository.getActiveCategories();
  
  if (response.isSuccess && response.data != null) {
    return response.data!;
  }
  
  throw Exception(response.message ?? 'Erro ao carregar categorias ativas');
});



