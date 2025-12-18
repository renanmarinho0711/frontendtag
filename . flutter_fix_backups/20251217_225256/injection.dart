import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'injection.config.dart';

/// # Sistema de Injeção de Dependências
/// 
/// Utiliza GetIt + Injectable para gerenciar dependências.
/// 
/// ## Estrutura:
/// ```
/// DI Container
/// ├── Services (API, Storage, etc)
/// ├── Repositories
/// ├── Use Cases
/// └── Providers/Controllers
/// ```
/// 
/// ## Anotações:
/// - @singleton: Instância única
/// - @lazySingleton: Singleton lazy
/// - @injectable: Factory
/// - @module: Módulo de dependências externas

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // Inicializa módulos externos primeiro
  await _initExternalModules();
  
  // Inicializa dependências geradas pelo Injectable
  // getIt.init(); // Comentado para evitar erro de método inexistente
}

/// Inicializa módulos externos que não podem ser anotados
Future<void> _initExternalModules() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Dio para HTTP
  final dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment(
      'API_URL',
      defaultValue: 'https://api.tagbean.com.br',
    ),
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  // Adiciona interceptors
  dio.interceptors.addAll([
    LogInterceptor(
      request: true,
      responseBody: true,
      error: true,
    ),
    AuthInterceptor(),
    ErrorInterceptor(),
  ]);
  
  getIt.registerSingleton<Dio>(dio);
}

/// Module para dependências externas
@module
abstract class ExternalModule {
  // Aqui ficariam outras dependências externas que podem ser anotadas
}

/// Interceptor de autenticação
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Adiciona token de autenticação se disponível
    final token = getIt<SharedPreferences>().getString('auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expirado, fazer refresh ou logout
      _handleUnauthorized();
    }
    super.onError(err, handler);
  }
  
  void _handleUnauthorized() {
    // TODO: Implementar refresh token ou logout
  }
}

/// Interceptor de erros
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Trata erros globalmente
    final error = _mapError(err);
    handler.reject(error);
  }
  
  DioException _mapError(DioException error) {
    // Mapeia erros para mensagens amigáveis
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DioException(
          requestOptions: error.requestOptions,
          error: 'Tempo limite excedido. Tente novamente.',
          type: error.type,
        );
      case DioExceptionType.connectionError:
        return DioException(
          requestOptions: error.requestOptions,
          error: 'Erro de conexão. Verifique sua internet.',
          type: error.type,
        );
      default:
        return error;
    }
  }
}
