import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';
import 'package:tagbean/features/strategies/data/models/strategy_models.dart';
import 'package:tagbean/features/strategies/data/repositories/strategies_repository.dart';

// ============================================================================
// STRATEGIES PROVIDER - INTEGRADO COM BACKEND
// ============================================================================

/// Provider do repositório de estratégias
final strategiesRepositoryProvider = Provider<StrategiesRepository>((ref) {
  return StrategiesRepository();
});

// ============================================================================
// STRATEGIES STATE
// ============================================================================

enum StrategiesLoadingStatus { initial, loading, loaded, error }

/// Estado das estratégias
class StrategiesState {
  final StrategiesLoadingStatus status;
  final List<StrategyModel> strategies;
  final List<StrategyExecution> recentExecutions;
  final List<TopProductResult> topProducts;
  final String categoryFilter;
  final String searchQuery;
  final String? error;
  final String? currentStoreId;

  const StrategiesState({
    this.status = StrategiesLoadingStatus.initial,
    this.strategies = const [],
    this.recentExecutions = const [],
    this.topProducts = const [],
    this.categoryFilter = 'todas',
    this.searchQuery = '',
    this.error,
    this.currentStoreId,
  });

  StrategiesState copyWith({
    StrategiesLoadingStatus? status,
    List<StrategyModel>? strategies,
    List<StrategyExecution>? recentExecutions,
    List<TopProductResult>? topProducts,
    String? categoryFilter,
    String? searchQuery,
    String? error,
    String? currentStoreId,
  }) {
    return StrategiesState(
      status: status ?? this.status,
      strategies: strategies ?? this.strategies,
      recentExecutions: recentExecutions ?? this.recentExecutions,
      topProducts: topProducts ?? this.topProducts,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
      currentStoreId: currentStoreId ?? this.currentStoreId,
    );
  }

  // ============================================================================
  // COMPUTED PROPERTIES
  // ============================================================================

  bool get isLoading => status == StrategiesLoadingStatus.loading;
  bool get hasError => status == StrategiesLoadingStatus.error;
  bool get isLoaded => status == StrategiesLoadingStatus.loaded;
  bool get isEmpty => strategies.isEmpty && isLoaded;

  /// Estratégias filtradas por categoria e busca
  List<StrategyModel> get filteredStrategies {
    var result = strategies;

    // Filtro por categoria
    if (categoryFilter != 'todas') {
      result = result.where((s) => s.category.label.toLowerCase() == categoryFilter.toLowerCase()).toList();
    }

    // Filtro por busca
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((s) =>
          s.name.toLowerCase().contains(query) ||
          s.description.toLowerCase().contains(query) ||
          s.category.label.toLowerCase().contains(query)).toList();
    }

    return result;
  }

  /// Estratégias ativas
  List<StrategyModel> get activeStrategies =>
      strategies.where((s) => s.status.isActive).toList();

  /// Estratégias pausadas
  List<StrategyModel> get pausedStrategies =>
      strategies.where((s) => s.status.isPaused).toList();

  /// Estratégias inativas
  List<StrategyModel> get inactiveStrategies =>
      strategies.where((s) => s.status.isInactive).toList();

  /// Total de produtos afetados por estratégias ativas
  int get totalAffectedProducts =>
      activeStrategies.fold(0, (sum, s) => sum + s.affectedProducts);

  /// Contagem de estratégias por status
  Map<StrategyStatus, int> get statusCounts => {
        StrategyStatus.active: activeStrategies.length,
        StrategyStatus.paused: pausedStrategies.length,
        StrategyStatus.inactive: inactiveStrategies.length,
      };
}

// ============================================================================
// STRATEGIES NOTIFIER - INTEGRADO COM BACKEND
// ============================================================================

/// Notifier para gerenciamento de estratégias
class StrategiesNotifier extends StateNotifier<StrategiesState> {
  final StrategiesRepository _repository;
  final Ref _ref;

  StrategiesNotifier(this._repository, this._ref) : super(const StrategiesState());

  /// Obtém o storeId do usuário logado
  String _getStoreId() {
    final authState = _ref.read(authProvider);
    return authState.user?.storeId ?? authState.user?.clientId ?? 'default';
  }

  /// Inicializa carregando todos os dados do backend
  Future<void> initialize() async {
    await loadStrategies();
  }
  
  /// Alias para compatibilidade - carrega estratégias
  Future<void> loadStrategies() async {
    final storeId = _getStoreId();
    state = state.copyWith(
      status: StrategiesLoadingStatus.loading,
      currentStoreId: storeId,
    );

    try {
      // Carrega estratégias do backend
      final strategiesResponse = await _repository.getStrategies(storeId: storeId);
      
      if (strategiesResponse.isSuccess) {
        // Carrega execuções recentes
        final executionsResponse = await _repository.getRecentExecutions(
          storeId: storeId,
          limit: 10,
        );

        // Carrega top produtos
        final topProductsResponse = await _repository.getTopProducts(
          storeId: storeId,
          limit: 5,
        );

        state = state.copyWith(
          status: StrategiesLoadingStatus.loaded,
          strategies: strategiesResponse.data ?? [],
          recentExecutions: executionsResponse.isSuccess ? executionsResponse.data ?? [] : [],
          topProducts: topProductsResponse.isSuccess ? topProductsResponse.data ?? [] : [],
        );
      } else {
        state = state.copyWith(
          status: StrategiesLoadingStatus.error,
          error: strategiesResponse.errorMessage ?? 'Erro ao carregar estratégias',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: StrategiesLoadingStatus.error,
        error: 'Erro de conexão: $e',
      );
    }
  }

  /// Recarrega estratégias do backend
  Future<void> refresh() async {
    final storeId = _getStoreId();
    state = state.copyWith(status: StrategiesLoadingStatus.loading);
    
    try {
      final response = await _repository.getStrategies(storeId: storeId);
      
      if (response.isSuccess) {
        state = state.copyWith(
          status: StrategiesLoadingStatus.loaded,
          strategies: response.data ?? [],
        );
      } else {
        state = state.copyWith(
          status: StrategiesLoadingStatus.error,
          error: response.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: StrategiesLoadingStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Define o filtro de categoria
  void setCategoryFilter(String category) {
    state = state.copyWith(categoryFilter: category);
  }

  /// Define a busca
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Limpa filtros
  void clearFilters() {
    state = state.copyWith(
      categoryFilter: 'todas',
      searchQuery: '',
    );
  }

  /// Ativa uma estratégia via backend
  Future<bool> activateStrategy(String id) async {
    try {
      final response = await _repository.activateStrategy(id);
      
      if (response.isSuccess && response.data != null) {
        final updatedList = state.strategies.map((s) {
          if (s.id == id) return response.data!;
          return s;
        }).toList();

        state = state.copyWith(strategies: updatedList);
        return true;
      } else {
        state = state.copyWith(error: response.errorMessage);
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Desativa uma estratégia via backend
  Future<bool> deactivateStrategy(String id) async {
    try {
      final response = await _repository.deactivateStrategy(id);
      
      if (response.isSuccess && response.data != null) {
        final updatedList = state.strategies.map((s) {
          if (s.id == id) return response.data!;
          return s;
        }).toList();

        state = state.copyWith(strategies: updatedList);
        return true;
      } else {
        state = state.copyWith(error: response.errorMessage);
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Executa uma estratégia manualmente
  Future<StrategyExecution?> executeStrategy(String id) async {
    try {
      final response = await _repository.executeStrategy(id);
      
      if (response.isSuccess && response.data != null) {
        // Adiciona à lista de execuções recentes
        final updatedExecutions = [response.data!, ...state.recentExecutions];
        state = state.copyWith(recentExecutions: updatedExecutions.take(10).toList());
        
        // Recarrega estratégias para atualizar contadores
        await refresh();
        
        return response.data;
      } else {
        state = state.copyWith(error: response.errorMessage);
        return null;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Cria uma nova estratégia
  Future<StrategyModel?> createStrategy({
    required String name,
    required String description,
    required String category,
    String? fullDescription,
    Map<String, dynamic>? configuration,
  }) async {
    final storeId = _getStoreId();
    
    try {
      final response = await _repository.createStrategy(
        storeId: storeId,
        name: name,
        description: description,
        category: category,
        fullDescription: fullDescription,
        configuration: configuration,
      );
      
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          strategies: [response.data!, ...state.strategies],
        );
        return response.data;
      } else {
        state = state.copyWith(error: response.errorMessage);
        return null;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Atualiza uma estratégia
  Future<bool> updateStrategy({
    required String id,
    String? name,
    String? description,
    String? fullDescription,
    Map<String, dynamic>? configuration,
  }) async {
    try {
      final response = await _repository.updateStrategy(
        id: id,
        name: name,
        description: description,
        fullDescription: fullDescription,
        configuration: configuration,
      );
      
      if (response.isSuccess && response.data != null) {
        final updatedList = state.strategies.map((s) {
          if (s.id == id) return response.data!;
          return s;
        }).toList();

        state = state.copyWith(strategies: updatedList);
        return true;
      } else {
        state = state.copyWith(error: response.errorMessage);
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Exclui uma estratégia
  Future<bool> deleteStrategy(String id) async {
    try {
      final response = await _repository.deleteStrategy(id);
      
      if (response.isSuccess) {
        state = state.copyWith(
          strategies: state.strategies.where((s) => s.id != id).toList(),
        );
        return true;
      } else {
        state = state.copyWith(error: response.errorMessage);
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Carrega execuções recentes do backend
  Future<void> loadRecentExecutions({int limit = 10}) async {
    final storeId = _getStoreId();
    
    try {
      final response = await _repository.getRecentExecutions(
        storeId: storeId,
        limit: limit,
      );
      
      if (response.isSuccess) {
        state = state.copyWith(recentExecutions: response.data ?? []);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Carrega top produtos do backend
  Future<void> loadTopProducts({int limit = 5}) async {
    final storeId = _getStoreId();
    
    try {
      final response = await _repository.getTopProducts(
        storeId: storeId,
        limit: limit,
      );
      
      if (response.isSuccess) {
        state = state.copyWith(topProducts: response.data ?? []);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Limpa erro
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ============================================================================
// PROVIDER DEFINITIONS
// ============================================================================

/// Provider principal de estratégias
final strategiesProvider = StateNotifierProvider<StrategiesNotifier, StrategiesState>((ref) {
  final repository = ref.watch(strategiesRepositoryProvider);
  return StrategiesNotifier(repository, ref);
});

/// Provider para estratégias filtradas (conveniente para UI)
final filteredStrategiesProvider = Provider<List<StrategyModel>>((ref) {
  final state = ref.watch(strategiesProvider);
  return state.filteredStrategies;
});

/// Provider para estratégias ativas
final activeStrategiesProvider = Provider<List<StrategyModel>>((ref) {
  final state = ref.watch(strategiesProvider);
  return state.activeStrategies;
});

/// Provider para contagem de status
final strategiesStatusCountsProvider = Provider<Map<StrategyStatus, int>>((ref) {
  final state = ref.watch(strategiesProvider);
  return state.statusCounts;
});

/// Provider para execuções recentes
final recentExecutionsProvider = Provider<List<StrategyExecution>>((ref) {
  final state = ref.watch(strategiesProvider);
  return state.recentExecutions;
});

/// Provider para top produtos
final topProductsProvider = Provider<List<TopProductResult>>((ref) {
  final state = ref.watch(strategiesProvider);
  return state.topProducts;
});

/// Provider para buscar uma estratégia específica por ID
final strategyByIdProvider = Provider.family<StrategyModel?, String>((ref, id) {
  final state = ref.watch(strategiesProvider);
  try {
    return state.strategies.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
});

/// Provider para estatísticas de uma estratégia específica
final strategyStatsProvider = FutureProvider.family<StrategyStats?, String>((ref, strategyId) async {
  final repository = ref.watch(strategiesRepositoryProvider);
  final response = await repository.getStrategyStats(strategyId);
  return response.isSuccess ? response.data : null;
});

/// Provider para top produtos de uma estratégia específica
final strategyTopProductsProvider = FutureProvider.family<List<TopProductResult>, String>((ref, strategyId) async {
  final repository = ref.watch(strategiesRepositoryProvider);
  final response = await repository.getTopProductsByStrategy(strategyId: strategyId, limit: 5);
  return response.isSuccess ? response.data ?? [] : [];
});

/// Provider para estatísticas de período de uma estratégia
/// Parâmetro: "{strategyId}:{period}" (ex: "abc-123:7dias")
final strategyPeriodStatsProvider = FutureProvider.family<StrategyPeriodStats?, String>((ref, params) async {
  final parts = params.split(':');
  if (parts.length != 2) return null;
  
  final strategyId = parts[0];
  final period = parts[1];
  
  final repository = ref.watch(strategiesRepositoryProvider);
  final response = await repository.getStrategyPeriodStats(strategyId: strategyId, period: period);
  return response.isSuccess ? response.data : null;
});

/// Provider para histórico de execuções de uma estratégia
final strategyExecutionHistoryProvider = FutureProvider.family<List<StrategyExecution>, String>((ref, strategyId) async {
  final repository = ref.watch(strategiesRepositoryProvider);
  final response = await repository.getExecutionHistory(strategyId);
  return response.isSuccess ? response.data ?? [] : [];
});

/// Provider para dados de vendas diárias
/// Parâmetro: "{strategyId}:{days}" (ex: "abc-123:7")
final strategyDailySalesProvider = FutureProvider.family<List<DailySalesData>, String>((ref, params) async {
  final parts = params.split(':');
  if (parts.length != 2) return [];
  
  final strategyId = parts[0];
  final days = int.tryParse(parts[1]) ?? 7;
  
  final repository = ref.watch(strategiesRepositoryProvider);
  final response = await repository.getDailySalesData(strategyId: strategyId, days: days);
  return response.isSuccess ? response.data ?? [] : [];
});



