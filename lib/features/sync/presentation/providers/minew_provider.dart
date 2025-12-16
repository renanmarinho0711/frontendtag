import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/repositories/minew_sync_repository.dart';
import 'package:tagbean/features/sync/data/repositories/sync_history_repository.dart';
import 'package:tagbean/features/sync/domain/usecases/sync_minew_usecase.dart';

// =============================================================================
// REPOSITORIES
// =============================================================================

/// Provider do repositório Minew
final minewSyncRepositoryProvider = Provider<MinewSyncRepository>((ref) {
  return MinewSyncRepository();
});

/// Provider do repositório de histórico
final syncHistoryRepositoryProvider = Provider<SyncHistoryRepository>((ref) {
  final repository = SyncHistoryRepository();
  // Inicializa automaticamente
  repository.initialize();
  
  ref.onDispose(() => repository.dispose());
  
  return repository;
});

// =============================================================================
// USE CASES
// =============================================================================

/// Provider do use case de sync completo Minew
final syncMinewStoreUseCaseProvider = Provider<SyncMinewStoreUseCase>((ref) {
  return SyncMinewStoreUseCase(
    minewRepository: ref.watch(minewSyncRepositoryProvider),
    historyRepository: ref.watch(syncHistoryRepositoryProvider),
  );
});

/// Provider do use case de sync tags Minew
final syncMinewTagsUseCaseProvider = Provider<SyncMinewTagsUseCase>((ref) {
  return SyncMinewTagsUseCase(
    minewRepository: ref.watch(minewSyncRepositoryProvider),
    historyRepository: ref.watch(syncHistoryRepositoryProvider),
  );
});

/// Provider do use case de import tags
final importMinewTagsUseCaseProvider = Provider<ImportMinewTagsUseCase>((ref) {
  return ImportMinewTagsUseCase(
    minewRepository: ref.watch(minewSyncRepositoryProvider),
    historyRepository: ref.watch(syncHistoryRepositoryProvider),
  );
});

/// Provider do use case de stats Minew
final getMinewStatsUseCaseProvider = Provider<GetMinewStatsUseCase>((ref) {
  return GetMinewStatsUseCase(
    minewRepository: ref.watch(minewSyncRepositoryProvider),
  );
});

// =============================================================================
// ESTADO
// =============================================================================

/// Estado das operações Minew
class MinewSyncState {
  final bool isSyncing;
  final MinewStoreStats? lastStats;
  final String? error;
  final DateTime? lastSyncAt;

  const MinewSyncState({
    this.isSyncing = false,
    this.lastStats,
    this.error,
    this.lastSyncAt,
  });

  MinewSyncState copyWith({
    bool? isSyncing,
    MinewStoreStats? lastStats,
    String? error,
    DateTime? lastSyncAt,
  }) {
    return MinewSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastStats: lastStats ?? this.lastStats,
      error: error,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}

/// Notifier para gerenciar estado das operações Minew
class MinewSyncNotifier extends StateNotifier<MinewSyncState> {
  final SyncMinewStoreUseCase _syncStoreUseCase;
  final SyncMinewTagsUseCase _syncTagsUseCase;
  final ImportMinewTagsUseCase _importTagsUseCase;
  final GetMinewStatsUseCase _getStatsUseCase;

  MinewSyncNotifier({
    required SyncMinewStoreUseCase syncStoreUseCase,
    required SyncMinewTagsUseCase syncTagsUseCase,
    required ImportMinewTagsUseCase importTagsUseCase,
    required GetMinewStatsUseCase getStatsUseCase,
  })  : _syncStoreUseCase = syncStoreUseCase,
        _syncTagsUseCase = syncTagsUseCase,
        _importTagsUseCase = importTagsUseCase,
        _getStatsUseCase = getStatsUseCase,
        super(const MinewSyncState());

  /// Sincronização completa com Minew Cloud
  Future<StoreSyncSummary?> syncComplete(String storeId) async {
    if (state.isSyncing) return null;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      final summary = await _syncStoreUseCase.execute(storeId);
      
      state = state.copyWith(
        isSyncing: false,
        lastStats: summary.minewStats,
        lastSyncAt: DateTime.now(),
      );

      return summary;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Sincroniza apenas tags
  Future<StatsSyncResult?> syncTags(String storeId) async {
    if (state.isSyncing) return null;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      final result = await _syncTagsUseCase.execute(storeId);
      
      state = state.copyWith(
        isSyncing: false,
        lastSyncAt: DateTime.now(),
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Importa novas tags
  Future<StatsSyncResult?> importTags(String storeId) async {
    if (state.isSyncing) return null;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      final result = await _importTagsUseCase.execute(storeId);
      
      state = state.copyWith(isSyncing: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Obtém estatísticas atualizadas
  Future<MinewStoreStats?> getStats(String storeId) async {
    try {
      final stats = await _getStatsUseCase.execute(storeId);
      state = state.copyWith(lastStats: stats);
      return stats;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Limpa erro
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// =============================================================================
// PROVIDERS PRINCIPAIS
// =============================================================================

/// Provider principal do Minew Sync
final minewSyncProvider = StateNotifierProvider<MinewSyncNotifier, MinewSyncState>((ref) {
  return MinewSyncNotifier(
    syncStoreUseCase: ref.watch(syncMinewStoreUseCaseProvider),
    syncTagsUseCase: ref.watch(syncMinewTagsUseCaseProvider),
    importTagsUseCase: ref.watch(importMinewTagsUseCaseProvider),
    getStatsUseCase: ref.watch(getMinewStatsUseCaseProvider),
  );
});

/// Provider para forçar refresh das stats Minew
/// Incrementar este valor força um novo fetch
final minewStatsRefreshTriggerProvider = StateProvider<int>((ref) => 0);

/// Provider de estatísticas Minew com auto-refresh
final minewStoreStatsAutoProvider = FutureProvider.family<MinewStoreStats?, String>((ref, storeId) async {
  // Observa o trigger de refresh
  ref.watch(minewStatsRefreshTriggerProvider);
  
  final useCase = ref.read(getMinewStatsUseCaseProvider);
  
  try {
    return await useCase.execute(storeId);
  } catch (e) {
    return null;
  }
});

/// Helper para verificar se está sincronizando
final isMinewSyncingProvider = Provider<bool>((ref) {
  return ref.watch(minewSyncProvider).isSyncing;
});

/// Helper para obter último erro
final minewSyncErrorProvider = Provider<String?>((ref) {
  return ref.watch(minewSyncProvider).error;
});

/// Helper para obter última sincronização
final lastMinewSyncAtProvider = Provider<DateTime?>((ref) {
  return ref.watch(minewSyncProvider).lastSyncAt;
});

