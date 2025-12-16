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
        // ERRO: API retornou falha - NÃO usar mock silenciosamente
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

/// Provider de sugestões de categorias
final suggestedCategoriesProvider = StateNotifierProvider<SuggestedCategoriesNotifier, SuggestedCategoriesState>(
  (ref) {
    final repository = ref.watch(categoriesRepositoryProvider);
    return SuggestedCategoriesNotifier(repository);
  },
);

