import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/navigation_service.dart';
// import '../core/services/feedback_service.dart'; // ❌ DESATIVADO - Arquivo removido da arquitetura
import '../core/storage/storage_service.dart';

// =============================================================================
// PROVIDERS GLOBAIS DA APLICAÇÃO
// =============================================================================

/// Provider do serviço de armazenamento local (SharedPreferences)
/// 
/// Responsável por: Persitência de dados locais (preferências do usuário, cache, etc)
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
// ESTADO GLOBAL DA APLICAÇÃO
// =============================================================================

/// Provider de estado de conexão de rede
/// Rastreia se o app está online ou offline
final isOnlineProvider = StateProvider<bool>((ref) => true);

/// Provider de estado de carregamento global
/// Usado para mostrar/esconder indicador de progresso em toda a app
final globalLoadingProvider = StateProvider<bool>((ref) => false);

/// Provider de mensagem de carregamento global
/// Exibe mensagem customizada durante operações longas
final globalLoadingMessageProvider = StateProvider<String?>((ref) => null);

// =============================================================================
// PROVIDERS DE INICIALIZAÇÃO
// =============================================================================

/// Provider que indica se o app foi inicializado com sucesso
/// Usado para evitar múltiplas inicializações
final appInitializedProvider = StateProvider<bool>((ref) => false);

/// Provider de erro de inicialização
/// Armazena qualquer erro que ocorra durante o boot da aplicação
final appInitErrorProvider = StateProvider<String?>((ref) => null);

// =============================================================================
// HELPERS - EXTENSÕES PARA ACESSO FACILITADO
// =============================================================================

/// ExtensÃ£o para facilitar acesso aos providers globais em Widgets
/// 
/// Exemplo de uso:
/// ```dart
/// ref.navigator.push('/dashboard');
/// ref.storage.getString('key');
/// ref.showGlobalLoading('Carregando...');
/// ```
extension GlobalProvidersRef on WidgetRef {
  /// Obtém o NavigationService para gerenciar navegação
  NavigationService get navigator => read(navigationServiceProvider);

  /// Obtém o StorageService para persistência de dados
  StorageService get storage => read(storageServiceProvider);

  /// Verifica se o app está online
  bool get isOnline => watch(isOnlineProvider);

  /// Exibe loading global com mensagem opcional
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

/// ExtensÃ£o para Ref (usado dentro de providers)
/// 
/// Permite acesso aos serviços globais dentro de providers
/// Exemplo:
/// ```dart
/// final myProvider = StateNotifierProvider((ref) {
///   ref.navigator.push('/home');
///   return MyStateNotifier();
/// });
/// ```
extension GlobalProvidersRefProvider on Ref {
  /// Obtém o NavigationService para gerenciar navegação
  NavigationService get navigator => read(navigationServiceProvider);

  /// Obtém o StorageService para persistência de dados
  StorageService get storage => read(storageServiceProvider);
}



