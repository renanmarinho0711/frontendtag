import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/dashboard/data/models/dashboard_models.dart';
import 'package:tagbean/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

// ============================================================================
// ESTADOS
// ============================================================================

/// Status do carregamento do dashboard
enum DashboardStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Estado completo do Dashboard
class DashboardState {
  final DashboardStatus status;
  final DashboardData data;
  final String? errorMessage;
  final String? currentStoreId;
  final DateTime? lastRefresh;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.data = const DashboardData(
      storeStats: StoreStats.empty,
      strategiesStats: StrategiesStats.empty,
      alerts: [],
      lastUpdate: null,
    ),
    this.errorMessage,
    this.currentStoreId,
    this.lastRefresh,
  });

  /// Estado inicial
  factory DashboardState.initial() => const DashboardState(
        status: DashboardStatus.initial,
      );

  /// Estado de loading
  factory DashboardState.loading({DashboardData? previousData}) => DashboardState(
        status: DashboardStatus.loading,
        data: previousData ?? DashboardData.empty,
      );

  /// Estado carregado com sucesso
  factory DashboardState.loaded(DashboardData data, String storeId) =>
      DashboardState(
        status: DashboardStatus.loaded,
        data: data,
        currentStoreId: storeId,
        lastRefresh: DateTime.now(),
      );

  /// Estado de erro
  factory DashboardState.error(String message, {DashboardData? previousData}) =>
      DashboardState(
        status: DashboardStatus.error,
        data: previousData ?? DashboardData.empty,
        errorMessage: message,
      );

  // Getters de conveniência
  StoreStats get storeStats => data.storeStats;
  StrategiesStats get strategiesStats => data.strategiesStats;
  List<DashboardAlert> get alerts => data.alerts;
  bool get isLoading => status == DashboardStatus.loading;
  bool get isLoaded => status == DashboardStatus.loaded;
  bool get hasError => status == DashboardStatus.error;

  /// Verifica se precisa atualizar (cache de 5 minutos)
  bool get needsRefresh {
    if (lastRefresh == null) return true;
    return DateTime.now().difference(lastRefresh!).inMinutes > 5;
  }

  /// Copia com modificações
  DashboardState copyWith({
    DashboardStatus? status,
    DashboardData? data,
    String? errorMessage,
    String? currentStoreId,
    DateTime? lastRefresh,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
      currentStoreId: currentStoreId ?? this.currentStoreId,
      lastRefresh: lastRefresh ?? this.lastRefresh,
    );
  }

  @override
  String toString() {
    return 'DashboardState(status: $status, store: $currentStoreId, products: ${storeStats.productsCount}, tags: ${storeStats.tagsCount})';
  }
}

// ============================================================================
// NOTIFIER
// ============================================================================

/// Gerenciador de estado do Dashboard
class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRepository _repository;

  DashboardNotifier({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepository(),
        super(DashboardState.initial());

  /// Carrega todos os dados do dashboard
  Future<void> loadDashboard(String storeId, {bool forceRefresh = false}) async {
    // Evita recarregar se já está em cache e não força refresh
    if (!forceRefresh &&
        state.currentStoreId == storeId &&
        state.isLoaded &&
        !state.needsRefresh) {
      return;
    }

    state = DashboardState.loading(previousData: state.data);

    try {
      final response = await _repository.loadDashboardData(storeId);

      if (response.isSuccess && response.data != null) {
        state = DashboardState.loaded(response.data!, storeId);
      } else {
        state = DashboardState.error(
          response.errorMessage ?? 'Erro ao carregar dashboard',
          previousData: state.data,
        );
      }
    } catch (e) {
      state = DashboardState.error(
        'Erro ao carregar dashboard: $e',
        previousData: state.data,
      );
    }
  }

  /// Carrega apenas estatísticas da loja
  Future<void> loadStoreStats(String storeId) async {
    state = state.copyWith(status: DashboardStatus.loading);

    try {
      final response = await _repository.getStoreStats(storeId);

      if (response.isSuccess && response.data != null) {
        final newData = DashboardData(
          storeStats: response.data!,
          strategiesStats: state.strategiesStats,
          alerts: state.alerts,
          lastUpdate: DateTime.now(),
        );
        state = DashboardState.loaded(newData, storeId);
      } else {
        state = DashboardState.error(
          response.errorMessage ?? 'Erro ao carregar estatísticas',
          previousData: state.data,
        );
      }
    } catch (e) {
      state = DashboardState.error(
        'Erro ao carregar estatísticas: $e',
        previousData: state.data,
      );
    }
  }

  /// Carrega apenas alertas
  Future<void> loadAlerts(String storeId) async {
    state = state.copyWith(status: DashboardStatus.loading);

    try {
      final response = await _repository.getAlerts(storeId);

      if (response.isSuccess && response.data != null) {
        final newData = DashboardData(
          storeStats: state.storeStats,
          strategiesStats: state.strategiesStats,
          alerts: response.data!,
          lastUpdate: DateTime.now(),
        );
        state = DashboardState.loaded(newData, state.currentStoreId ?? '');
      } else {
        state = DashboardState.error(
          response.errorMessage ?? 'Erro ao carregar alertas',
          previousData: state.data,
        );
      }
    } catch (e) {
      state = DashboardState.error(
        'Erro ao carregar alertas: $e',
        previousData: state.data,
      );
    }
  }

  /// Refresh manual dos dados
  Future<void> refresh() async {
    if (state.currentStoreId != null) {
      await loadDashboard(state.currentStoreId!, forceRefresh: true);
    }
  }

  /// Limpa o erro atual
  void clearError() {
    state = state.copyWith(errorMessage: null, status: DashboardStatus.loaded);
  }

  /// Limpa os dados em cache
  void clearCache() {
    state = DashboardState.initial();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider do repositório de dashboard
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

/// Provider principal do Dashboard
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository: repository);
});

/// Provider das estatísticas da loja
final storeStatsProvider = Provider<StoreStats>((ref) {
  return ref.watch(dashboardProvider).storeStats;
});

/// Provider das estatísticas de estratégias
final strategiesStatsProvider = Provider<StrategiesStats>((ref) {
  return ref.watch(dashboardProvider).strategiesStats;
});

/// Provider dos alertas
final dashboardAlertsProvider = Provider<List<DashboardAlert>>((ref) {
  return ref.watch(dashboardProvider).alerts;
});

/// Provider se está carregando
final dashboardLoadingProvider = Provider<bool>((ref) {
  return ref.watch(dashboardProvider).isLoading;
});

/// Provider da mensagem de erro
final dashboardErrorProvider = Provider<String?>((ref) {
  return ref.watch(dashboardProvider).errorMessage;
});

/// Provider que carrega automaticamente o dashboard baseado no work context
final autoDashboardProvider = FutureProvider<void>((ref) async {
  final workContext = ref.watch(workContextProvider);
  final dashboardNotifier = ref.watch(dashboardProvider.notifier);
  final storeId = workContext.context.currentStoreId;

  if (workContext.isLoaded && storeId != null && storeId.isNotEmpty) {
    await dashboardNotifier.loadDashboard(storeId);
  }
});

/// Provider para controlar visibilidade do card de próxima ação ("Fazer depois")
/// Reseta quando mudar de loja ou após 1 hora
final nextActionDismissedProvider = StateNotifierProvider<NextActionDismissNotifier, bool>((ref) {
  // Quando muda a loja, reseta o estado
  ref.listen(dashboardProvider, (previous, next) {
    if (previous?.currentStoreId != next.currentStoreId) {
      ref.notifier.reset();
    }
  });
  return NextActionDismissNotifier();
});

class NextActionDismissNotifier extends StateNotifier<bool> {
  DateTime? _dismissedAt;
  
  NextActionDismissNotifier() : super(false);
  
  /// Dismiss do card "Fazer depois"
  void dismiss() {
    state = true;
    _dismissedAt = DateTime.now();
  }
  
  /// Reseta o estado (mostra o card novamente)
  void reset() {
    state = false;
    _dismissedAt = null;
  }
  
  /// Verifica se deve mostrar (reseta após 1 hora)
  bool get shouldShow {
    if (!state) return true;
    if (_dismissedAt == null) return true;
    
    final elapsed = DateTime.now().difference(_dismissedAt!);
    if (elapsed.inHours >= 1) {
      reset();
      return true;
    }
    return false;
  }
}
