import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/storage/storage_service.dart';
import 'package:tagbean/features/auth/data/models/work_context_model.dart';
import 'package:tagbean/features/auth/data/datasources/work_context_datasource.dart';
import 'package:tagbean/features/auth/presentation/providers/auth_provider.dart';

// ============================================================================
// ESTADOS
// ============================================================================

/// Estado do contexto de trabalho
enum WorkContextStatus {
  /// Estado inicial, não carregado
  initial,

  /// Carregando contexto
  loading,

  /// Contexto carregado com sucesso
  loaded,

  /// Erro ao carregar/alterar contexto
  error,
}

/// Estado completo do contexto de trabalho
class WorkContextState {
  final WorkContextStatus status;
  final WorkContext context;
  final String? errorMessage;
  final bool isChangingStore;

  const WorkContextState({
    this.status = WorkContextStatus.initial,
    this.context = WorkContext.empty,
    this.errorMessage,
    this.isChangingStore = false,
  });

  /// Estado inicial
  factory WorkContextState.initial() => const WorkContextState(
        status: WorkContextStatus.initial,
        context: WorkContext.empty,
      );

  /// Estado de loading
  factory WorkContextState.loading() => const WorkContextState(
        status: WorkContextStatus.loading,
        context: WorkContext.empty,
      );

  /// Estado carregado com sucesso
  factory WorkContextState.loaded(WorkContext context) => WorkContextState(
        status: WorkContextStatus.loaded,
        context: context,
      );

  /// Estado de erro
  factory WorkContextState.error(String message, {WorkContext? context}) =>
      WorkContextState(
        status: WorkContextStatus.error,
        context: context ?? WorkContext.empty,
        errorMessage: message,
      );

  /// Verifica se está carregado
  bool get isLoaded => status == WorkContextStatus.loaded;

  /// Verifica se tem erro
  bool get hasError => status == WorkContextStatus.error;

  /// Copia com modificações
  WorkContextState copyWith({
    WorkContextStatus? status,
    WorkContext? context,
    String? errorMessage,
    bool? isChangingStore,
  }) {
    return WorkContextState(
      status: status ?? this.status,
      context: context ?? this.context,
      errorMessage: errorMessage,
      isChangingStore: isChangingStore ?? this.isChangingStore,
    );
  }

  @override
  String toString() {
    return 'WorkContextState(status: $status, scope: ${context.scope}, store: ${context.currentStoreName})';
  }
}

// ============================================================================
// NOTIFIER
// ============================================================================

/// Gerenciador de estado do contexto de trabalho
class WorkContextNotifier extends StateNotifier<WorkContextState> {
  final WorkContextService _service;
  // ignore: unused_field - Reservado para funcionalidades futuras de cache
  final StorageService _storage;
  // ignore: unused_field - Reservado para funcionalidades futuras de ref cross-provider
  final Ref _ref;

  WorkContextNotifier({
    required WorkContextService service,
    required StorageService storage,
    required Ref ref,
  })  : _service = service,
        _storage = storage,
        _ref = ref,
        super(WorkContextState.initial());

  /// Inicializa o contexto a partir do login ou storage local
  Future<void> initialize(WorkContext? loginContext) async {
    state = WorkContextState.loading();

    try {
      WorkContext context;

      if (loginContext != null) {
        // Usar contexto do login
        context = loginContext;
      } else {
        // Tentar carregar do storage local
        final localContext = await _service.loadLocalContext();
        if (localContext != null) {
          context = localContext;
        } else {
          // Carregar do backend
          final response = await _service.getWorkContext();
          if (response.success && response.workContext != null) {
            context = response.workContext!;
          } else {
            state = WorkContextState.error(
              response.message,
              context: WorkContext.empty,
            );
            return;
          }
        }
      }

      // Salvar localmente
      await _service.saveLocalContext(context);
      state = WorkContextState.loaded(context);
    } catch (e) {
      state = WorkContextState.error('Erro ao inicializar contexto: $e');
    }
  }

  /// Seleciona uma loja específica
  Future<bool> selectStore(String storeId) async {
    state = state.copyWith(isChangingStore: true);

    try {
      final response = await _service.selectStore(storeId);

      if (response.success && response.workContext != null) {
        await _service.saveLocalContext(response.workContext!);
        state = WorkContextState.loaded(response.workContext!);
        return true;
      } else {
        state = state.copyWith(
          isChangingStore: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isChangingStore: false,
        errorMessage: 'Erro ao selecionar loja: $e',
      );
      return false;
    }
  }

  /// Seleciona todas as lojas (modo consolidado)
  Future<bool> selectAllStores() async {
    state = state.copyWith(isChangingStore: true);

    try {
      final response = await _service.selectAllStores();

      if (response.success && response.workContext != null) {
        await _service.saveLocalContext(response.workContext!);
        state = WorkContextState.loaded(response.workContext!);
        return true;
      } else {
        state = state.copyWith(
          isChangingStore: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isChangingStore: false,
        errorMessage: 'Erro ao selecionar todas as lojas: $e',
      );
      return false;
    }
  }

  /// Altera o escopo de trabalho
  Future<bool> setWorkScope(WorkScope scope, {String? storeId}) async {
    state = state.copyWith(isChangingStore: true);

    try {
      final request = SetWorkContextRequest(scope: scope, storeId: storeId);
      final response = await _service.setWorkContext(request);

      if (response.success && response.workContext != null) {
        await _service.saveLocalContext(response.workContext!);
        state = WorkContextState.loaded(response.workContext!);
        return true;
      } else {
        state = state.copyWith(
          isChangingStore: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isChangingStore: false,
        errorMessage: 'Erro ao alterar escopo: $e',
      );
      return false;
    }
  }

  /// Atualiza o contexto do backend
  Future<void> refresh() async {
    try {
      final response = await _service.getWorkContext();
      if (response.success && response.workContext != null) {
        await _service.saveLocalContext(response.workContext!);
        state = WorkContextState.loaded(response.workContext!);
      }
    } catch (e) {
      // Silently fail on refresh
    }
  }

  /// Limpa o contexto (logout)
  Future<void> clear() async {
    await _service.clearLocalContext();
    state = WorkContextState.initial();
  }

  /// Limpa mensagem de erro
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider do serviço de WorkContext
final workContextServiceProvider = Provider<WorkContextService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return WorkContextService(storage: storage);
});

/// Provider principal do contexto de trabalho
final workContextProvider =
    StateNotifierProvider<WorkContextNotifier, WorkContextState>((ref) {
  final service = ref.watch(workContextServiceProvider);
  final storage = ref.watch(storageServiceProvider);
  return WorkContextNotifier(
    service: service,
    storage: storage,
    ref: ref,
  );
});

/// Provider do contexto atual
final currentWorkContextProvider = Provider<WorkContext>((ref) {
  return ref.watch(workContextProvider).context;
});

/// Provider do escopo atual
final currentWorkScopeProvider = Provider<WorkScope>((ref) {
  return ref.watch(currentWorkContextProvider).scope;
});

/// Provider da loja atual selecionada
final currentStoreProvider = Provider<StoreInfo?>((ref) {
  return ref.watch(currentWorkContextProvider).currentStore;
});

/// Provider das lojas disponíveis
final availableStoresProvider = Provider<List<StoreInfo>>((ref) {
  return ref.watch(currentWorkContextProvider).availableStores;
});

/// Provider se pode alternar entre lojas
final canSwitchStoreProvider = Provider<bool>((ref) {
  final context = ref.watch(currentWorkContextProvider);
  return context.canSwitchScope && context.availableStores.length > 1;
});

/// Provider do texto de exibição do contexto
final workContextDisplayTextProvider = Provider<String>((ref) {
  return ref.watch(currentWorkContextProvider).formattedDisplayText;
});

/// Provider se está carregando mudança de contexto
final isChangingStoreProvider = Provider<bool>((ref) {
  return ref.watch(workContextProvider).isChangingStore;
});

/// Provider de erro do contexto
final workContextErrorProvider = Provider<String?>((ref) {
  return ref.watch(workContextProvider).errorMessage;
});



