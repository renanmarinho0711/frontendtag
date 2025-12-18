import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interceptor para adicionar o token de autenticação em todas as requisições
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Ler o token do armazenamento seguro
    final token = await _secureStorage.read(key: 'auth_token');

    if (token != null) {
      // Adicionar o token no header Authorization
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}

/// Interceptor para logging de requisições e respostas
/// Nota: Só funciona em modo debug (kDebugMode)
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
    }
    handler.next(err);
  }
}

/// Interceptor para tratamento de erros
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Tempo de conexão esgotado. Verifique sua internet.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Requisição cancelada.';
        break;
      default:
        errorMessage = 'Erro de conexão. Verifique sua internet.';
    }

    // Criar um erro customizado com a mensagem tratada
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
    );

    handler.next(customError);
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida.';
      case 401:
        return 'Não autorizado. Faça login novamente.';
      case 403:
        return 'Acesso negado.';
      case 404:
        return 'Recurso não encontrado.';
      case 500:
        return 'Erro interno do servidor.';
      default:
        return 'Erro desconhecido. Código: $statusCode';
    }
  }
}



