import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/repositories/sync_repository.dart';
import 'package:tagbean/features/auth/presentation/providers/work_context_provider.dart';

// ============================================================================
// ESTADOS
// ============================================================================

/// Status do módulo de sincronização
enum SyncModuleStatus {
  initial,
  idle,
  syncing,
  error,
}

/// Estado completo do módulo de sincronização
class SyncState {
  final SyncModuleStatus status;
  final List<SyncHistoryEntry> history;
  final SyncHistoryEntry? currentSync;
  final double progress;
  final String? errorMessage;
  final SyncSettings settings;
  final SyncHistoryEntry? lastSync;

  const SyncState({
    this.status = SyncModuleStatus.initial,
    this.history = const [],
    this.currentSync,
    this.progress = 0.0,
    this.errorMessage,
    this.settings = const SyncSettings(),
    this.lastSync,
  });

  /// Estado inicial
  factory SyncState.initial() => const SyncState(
        status: SyncModuleStatus.initial,
      );

  /// Estado idle (pronto para sincronizar)
  factory SyncState.idle({
    List<SyncHistoryEntry>? history,
    SyncSettings? settings,
    SyncHistoryEntry? lastSync,
    String? error,
  }) =>
      SyncState(
        status: SyncModuleStatus.idle,
        history: history ?? const [],
        settings: settings ?? const SyncSettings(),
        lastSync: lastSync,
        errorMessage: error,
      );

  /// Estado sincronizando
  factory SyncState.syncing({
    required SyncHistoryEntry currentSync,
    double progress = 0.0,
    List<SyncHistoryEntry>? history,
    SyncSettings? settings,
  }) =>
      SyncState(
        status: SyncModuleStatus.syncing,
        currentSync: currentSync,
        progress: progress,
        history: history ?? const [],
        settings: settings ?? const SyncSettings(),
      );

  /// Estado de erro
  factory SyncState.error(
    String message, {
    List<SyncHistoryEntry>? history,
    SyncSettings? settings,
  }) =>
      SyncState(
        status: SyncModuleStatus.error,
        errorMessage: message,
        history: history ?? const [],
        settings: settings ?? const SyncSettings(),
      );

  // Getters de conveniência
  bool get isIdle => status == SyncModuleStatus.idle;
  bool get isSyncing => status == SyncModuleStatus.syncing;
  bool get hasError => status == SyncModuleStatus.error;
  bool get canSync => status == SyncModuleStatus.idle || status == SyncModuleStatus.initial;

  /// Copia com modificações
  SyncState copyWith({
    SyncModuleStatus? status,
    List<SyncHistoryEntry>? history,
    SyncHistoryEntry? currentSync,
    double? progress,
    String? errorMessage,
    SyncSettings? settings,
    SyncHistoryEntry? lastSync,
  }) {
    return SyncState(
      status: status ?? this.status,
      history: history ?? this.history,
      currentSync: currentSync ?? this.currentSync,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      settings: settings ?? this.settings,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  @override
  String toString() {
    return 'SyncState(status: $status, historyCount: ${history.length}, progress: $progress)';
  }
}

// ============================================================================
// NOTIFIER
// ============================================================================

/// Gerenciador de estado do módulo de Sincronização
class SyncNotifier extends StateNotifier<SyncState> {
  final SyncRepository _repository;

  SyncNotifier({SyncRepository? repository})
      : _repository = repository ?? SyncRepository(),
        super(SyncState.initial());

  /// Inicializa o módulo (carrega histórico e configurações)
  Future<void> initialize() async {
    try {
      final historyResponse = await _repository.getHistory();
      final lastSync = await _repository.getLastSync();
      
      if (historyResponse.isSuccess && historyResponse.data != null) {
        state = SyncState.idle(
          history: historyResponse.data!,
          lastSync: lastSync,
        );
      } else {
        // Sem histórico disponível - mostra lista vazia em vez de mock
        state = SyncState.idle(
          history: [],
          lastSync: null,
          error: historyResponse.message,
        );
      }
    } catch (e) {
      // Erro ao carregar - mostra estado vazio com mensagem de erro
      state = SyncState.idle(
        history: [],
        lastSync: null,
        error: 'Falha ao carregar histórico: ${e.toString()}',
      );
    }
  }
  
  /// Executa sincronização de tags
  Future<SyncResult?> syncTags(String storeId) async {
    if (!state.canSync) return null;

    // Criar entrada de sync atual
    final currentSync = SyncHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: SyncType.tags,
      status: SyncStatus.running,
      startedAt: DateTime.now(),
    );

    state = SyncState.syncing(
      currentSync: currentSync,
      history: state.history,
      settings: state.settings,
    );

    try {
      final response = await _repository.syncTags(storeId);

      if (response.isSuccess && response.data != null) {
        final result = response.data!;
        final completedSync = currentSync.copyWith(
          status: result.success ? SyncStatus.success : SyncStatus.failed,
          completedAt: DateTime.now(),
          successCount: result.successCount,
          errorCount: result.errorCount,
          tagsCount: result.totalProcessed,
          duration: result.duration,
          errorMessage: result.errorMessage,
        );

        state = SyncState.idle(
          history: [completedSync, ...state.history],
          settings: state.settings,
          lastSync: completedSync,
        );

        return result;
      } else {
        final failedSync = currentSync.copyWith(
          status: SyncStatus.failed,
          completedAt: DateTime.now(),
          errorMessage: response.errorMessage,
        );

        state = SyncState.idle(
          history: [failedSync, ...state.history],
          settings: state.settings,
          lastSync: failedSync,
        );

        return null;
      }
    } catch (e) {
      final failedSync = currentSync.copyWith(
        status: SyncStatus.failed,
        completedAt: DateTime.now(),
        errorMessage: e.toString(),
      );

      state = SyncState.error(
        e.toString(),
        history: [failedSync, ...state.history],
        settings: state.settings,
      );

      return null;
    }
  }

  /// Atualiza display de todas as tags
  Future<SyncResult?> refreshAllTags(String storeId) async {
    if (!state.canSync) return null;

    final currentSync = SyncHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: SyncType.tags,
      status: SyncStatus.running,
      startedAt: DateTime.now(),
    );

    state = SyncState.syncing(
      currentSync: currentSync,
      history: state.history,
      settings: state.settings,
    );

    try {
      final response = await _repository.refreshAllTags(storeId);

      if (response.isSuccess && response.data != null) {
        final result = response.data!;
        final completedSync = currentSync.copyWith(
          status: result.success ? SyncStatus.success : SyncStatus.failed,
          completedAt: DateTime.now(),
          successCount: result.successCount,
          errorCount: result.errorCount,
          tagsCount: result.totalProcessed,
          duration: result.duration,
        );

        state = SyncState.idle(
          history: [completedSync, ...state.history],
          settings: state.settings,
          lastSync: completedSync,
        );

        return result;
      } else {
        state = SyncState.error(
          response.errorMessage ?? 'Erro ao atualizar displays',
          history: state.history,
          settings: state.settings,
        );
        return null;
      }
    } catch (e) {
      state = SyncState.error(
        e.toString(),
        history: state.history,
        settings: state.settings,
      );
      return null;
    }
  }

  /// Atualiza display de tags selecionadas
  Future<SyncResult?> refreshSelectedTags(
    String storeId,
    List<String> macAddresses,
  ) async {
    if (!state.canSync || macAddresses.isEmpty) return null;

    state = state.copyWith(status: SyncModuleStatus.syncing);

    try {
      final response = await _repository.refreshSelectedTags(
        storeId,
        macAddresses,
      );

      if (response.isSuccess && response.data != null) {
        state = SyncState.idle(
          history: state.history,
          settings: state.settings,
          lastSync: state.lastSync,
        );
        return response.data;
      } else {
        state = SyncState.error(
          response.errorMessage ?? 'Erro ao atualizar displays',
          history: state.history,
          settings: state.settings,
        );
        return null;
      }
    } catch (e) {
      state = SyncState.error(
        e.toString(),
        history: state.history,
        settings: state.settings,
      );
      return null;
    }
  }

  /// Atualiza configurações
  void updateSettings(SyncSettings newSettings) {
    state = state.copyWith(settings: newSettings);
  }

  /// Testa a conexão com a API de sincronização
  Future<SyncConnectionTestResult?> testConnection(String storeId) async {
    try {
      final response = await _repository.testConnection(storeId);
      if (response.isSuccess && response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      return SyncConnectionTestResult(
        success: false,
        pingMs: 0,
        authStatus: 'ERRO',
        permissionsStatus: 'ERRO',
        message: 'Erro: $e',
      );
    }
  }

  /// Limpa erro
  void clearError() {
    if (state.hasError) {
      state = SyncState.idle(
        history: state.history,
        settings: state.settings,
        lastSync: state.lastSync,
      );
    }
  }

  /// Limpa histórico
  void clearHistory() {
    _repository.clearHistory();
    state = state.copyWith(history: []);
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

/// Provider do repositório de sync
final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository();
});

/// Provider principal de Sincronização
final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final repository = ref.watch(syncRepositoryProvider);
  final notifier = SyncNotifier(repository: repository);
  
  // Inicializa automaticamente
  notifier.initialize();
  
  return notifier;
});

/// Provider do histórico de sync
final syncHistoryProvider = Provider<List<SyncHistoryEntry>>((ref) {
  return ref.watch(syncProvider).history;
});

/// Provider se está sincronizando
final isSyncingProvider = Provider<bool>((ref) {
  return ref.watch(syncProvider).isSyncing;
});

/// Provider da última sincronização
final lastSyncProvider = Provider<SyncHistoryEntry?>((ref) {
  return ref.watch(syncProvider).lastSync;
});

/// Provider de erro de sync
final syncErrorProvider = Provider<String?>((ref) {
  return ref.watch(syncProvider).errorMessage;
});

/// Provider das configurações de sync
final syncSettingsProvider = Provider<SyncSettings>((ref) {
  return ref.watch(syncProvider).settings;
});

/// Provider que auto-inicializa sync baseado no work context
final autoSyncInitProvider = FutureProvider<void>((ref) async {
  final workContext = ref.watch(workContextProvider);
  final syncNotifier = ref.watch(syncProvider.notifier);
  
  if (workContext.isLoaded) {
    await syncNotifier.initialize();
  }
});



