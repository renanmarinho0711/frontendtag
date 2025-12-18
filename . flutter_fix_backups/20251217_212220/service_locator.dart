import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// # Service Locator
/// 
/// Facilita acesso às dependências registradas.
/// Fornece getters tipados para serviços comuns.
class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CORE SERVICES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Cliente HTTP
  static Dio get dio => _getIt<Dio>();
  
  /// Storage local
  static SharedPreferences get prefs => _getIt<SharedPreferences>();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // REPOSITORIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // TODO: Adicionar repositories conforme criados
  // static AuthRepository get authRepo => _getIt<AuthRepository>();
  // static ProductRepository get productRepo => _getIt<ProductRepository>();
  // static TagRepository get tagRepo => _getIt<TagRepository>();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // USE CASES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // TODO: Adicionar use cases conforme criados
  // static LoginUseCase get loginUseCase => _getIt<LoginUseCase>();
  // static GetProductsUseCase get getProductsUseCase => _getIt<GetProductsUseCase>();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SERVICES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // TODO: Adicionar services conforme criados
  // static ApiService get apiService => _getIt<ApiService>();
  // static CacheService get cacheService => _getIt<CacheService>();
  // static NavigationService get navigationService => _getIt<NavigationService>();
  
  /// Registra uma instância manualmente
  static void register<T extends Object>(T instance) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingleton<T>(instance);
    }
  }
  
  /// Obtém uma instância registrada
  static T get<T extends Object>() => _getIt<T>();
  
  /// Verifica se um tipo está registrado
  static bool isRegistered<T extends Object>() => _getIt.isRegistered<T>();
  
  /// Limpa todas as instâncias (útil para testes)
  static Future<void> reset() async {
    await _getIt.reset();
  }
}
