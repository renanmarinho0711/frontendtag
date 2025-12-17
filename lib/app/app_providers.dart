import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/navigation_service.dart';
import '../core/services/feedback_service.dart';
import '../core/storage/storage_service.dart';

// =============================================================================
// PROVIDERS GLOBAIS DA APLICAÇÀO
// =============================================================================

/// Provider do serviço de armazenamento local
/// 
/// Uso:
/// ```dart
/// final storage = ref.read(storageServiceProvider);
/// await storage.setString('key', 'value');
/// ```
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// =============================================================================
// ESTADO GLOBAL DA APLICAÇÀO
// =============================================================================

/// Provider de estado de conexão de rede
final isOnlineProvider = StateProvider<bool>((ref) => true);

/// Provider de estado de carregamento global
final globalLoadingProvider = StateProvider<bool>((ref) => false);

/// Provider de mensagem de carregamento global
final globalLoadingMessageProvider = StateProvider<String?>((ref) => null);

// =============================================================================
// PROVIDERS DE INICIALIZAÇÀO
// =============================================================================

/// Provider que indica se o app foi inicializado
final appInitializedProvider = StateProvider<bool>((ref) => false);

/// Provider de erro de inicialização
final appInitErrorProvider = StateProvider<String?>((ref) => null);

// =============================================================================
// HELPERS
// =============================================================================

/// Extensão para facilitar acesso aos providers globais
extension GlobalProvidersRef on WidgetRef {
  /// Obtém o NavigationService
  NavigationService get navigator => read(navigationServiceProvider);

  /// Obtém o FeedbackService
  FeedbackService get feedback => read(feedbackServiceProvider);

  /// Obtém o StorageService
  StorageService get storage => read(storageServiceProvider);

  /// Verifica se está online
  bool get isOnline => watch(isOnlineProvider);

  /// Exibe loading global
  void showGlobalLoading([String? message]) {
    read(globalLoadingProvider.notifier).state = true;
    read(globalLoadingMessageProvider.notifier).state = message;
  }

  /// Esconde loading global
  void hideGlobalLoading() {
    read(globalLoadingProvider.notifier).state = false;
    read(globalLoadingMessageProvider.notifier).state = null;
  }
}

/// Extensão para Ref (usado em providers)
extension GlobalProvidersRefProvider on Ref {
  /// Obtém o NavigationService
  NavigationService get navigator => read(navigationServiceProvider);

  /// Obtém o FeedbackService
  FeedbackService get feedback => read(feedbackServiceProvider);

  /// Obtém o StorageService
  StorageService get storage => read(storageServiceProvider);
}



