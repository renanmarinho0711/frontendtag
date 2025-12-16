import 'dart:async';
import 'dart:io';

import '../exceptions/app_exceptions.dart';

/// Handler centralizado para tratamento de erros de rede e exceções
/// 
/// Converte exceções genéricas em exceções tipadas da aplicação
class ErrorHandler {
  ErrorHandler._();

  /// Processa uma exceção e retorna uma [AppException] tipada
  static AppException handle(dynamic error, [StackTrace? stackTrace]) {
    // Já é uma AppException
    if (error is AppException) {
      return error;
    }

    // Exceções de IO/Rede
    if (error is SocketException) {
      return NetworkException.noConnection();
    }

    if (error is TimeoutException) {
      return NetworkException.timeout();
    }

    if (error is HttpException) {
      return NetworkException.serverError(message: error.message);
    }

    // Exceções de formato
    if (error is FormatException) {
      return ValidationException(
        message: 'Formato de dados inválido: ${error.message}',
        code: 'FORMAT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Exceção genérica
    if (error is Exception) {
      return UnexpectedException(
        message: error.toString(),
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Error ou outro tipo
    return UnexpectedException(
      message: error?.toString() ?? 'Erro desconhecido',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Processa código de status HTTP e retorna exceção apropriada
  static AppException fromStatusCode(
    int statusCode, {
    String? endpoint,
    String? message,
    dynamic body,
  }) {
    switch (statusCode) {
      case 400:
        // Bad Request - geralmente erro de validação
        if (body is Map && body.containsKey('errors')) {
          final errors = body['errors'] as Map<String, dynamic>;
          return ValidationException.multiple(
            errors.map((k, v) => MapEntry(k, (v as List).cast<String>())),
          );
        }
        return ValidationException(
          message: message ?? 'Requisição inválida',
          code: 'BAD_REQUEST',
        );

      case 401:
        return AuthException.sessionExpired();

      case 403:
        return AuthException.unauthorized();

      case 404:
        return BusinessException(
          message: message ?? 'Recurso não encontrado',
          code: 'NOT_FOUND',
        );

      case 409:
        return BusinessException(
          message: message ?? 'Conflito de dados',
          code: 'CONFLICT',
        );

      case 422:
        // Unprocessable Entity - erro de validação de negócio
        return ValidationException(
          message: message ?? 'Dados não processáveis',
          code: 'UNPROCESSABLE_ENTITY',
        );

      case 429:
        return NetworkException(
          message: 'Muitas requisições. Aguarde alguns segundos.',
          code: 'RATE_LIMIT',
          statusCode: statusCode,
          endpoint: endpoint,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return NetworkException.serverError(
          statusCode: statusCode,
          endpoint: endpoint,
          message: message ?? 'Erro no servidor. Tente novamente.',
        );

      default:
        if (statusCode >= 400 && statusCode < 500) {
          return BusinessException(
            message: message ?? 'Erro na requisição',
            code: 'CLIENT_ERROR_$statusCode',
          );
        }
        if (statusCode >= 500) {
          return NetworkException.serverError(
            statusCode: statusCode,
            endpoint: endpoint,
            message: message,
          );
        }
        return UnexpectedException(
          message: message ?? 'Status inesperado: $statusCode',
        );
    }
  }

  /// Extrai mensagem de erro do corpo da resposta
  static String? extractErrorMessage(dynamic body) {
    if (body == null) return null;

    if (body is String) return body;

    if (body is Map) {
      // Formatos comuns de erro de API
      if (body.containsKey('message')) return body['message'] as String?;
      if (body.containsKey('error')) {
        final error = body['error'];
        if (error is String) return error;
        if (error is Map && error.containsKey('message')) {
          return error['message'] as String?;
        }
      }
      if (body.containsKey('title')) return body['title'] as String?;
      if (body.containsKey('detail')) return body['detail'] as String?;
    }

    return null;
  }

  /// Retorna uma mensagem amigável para o usuário
  static String getUserFriendlyMessage(AppException exception) {
    if (exception is NetworkException) {
      switch (exception.code) {
        case 'NO_CONNECTION':
          return 'Sem conexão com a internet. Verifique sua conexão.';
        case 'TIMEOUT':
          return 'Servidor demorou para responder. Tente novamente.';
        case 'SERVER_ERROR':
          return 'Erro no servidor. Tente novamente em alguns minutos.';
        case 'RATE_LIMIT':
          return 'Muitas requisições. Aguarde alguns segundos.';
        default:
          return exception.message;
      }
    }

    if (exception is AuthException) {
      switch (exception.code) {
        case 'INVALID_CREDENTIALS':
          return 'E-mail ou senha incorretos.';
        case 'SESSION_EXPIRED':
        case 'TOKEN_EXPIRED':
          return 'Sua sessÃ£o expirou. Faça login novamente.';
        case 'UNAUTHORIZED':
          return 'Você não tem permissÃ£o para esta ação.';
        default:
          return exception.message;
      }
    }

    if (exception is ValidationException) {
      return exception.firstError;
    }

    if (exception is BusinessException) {
      return exception.message;
    }

    if (exception is SyncException) {
      return exception.message;
    }

    return exception.message;
  }

  /// Alias para getUserFriendlyMessage (compatibilidade)
  static String getMessage(dynamic error) {
    if (error is AppException) {
      return getUserFriendlyMessage(error);
    }
    return handle(error).message;
  }
}



