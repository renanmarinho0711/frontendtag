/// Exceções personalizadas para o TagBean
/// 
/// Este arquivo define todas as exceções customizadas utilizadas
/// na aplicação para tratamento de erros.library;


/// Exceção base para todas as exceções do TagBean
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Exceção de rede (sem conexão, timeout, etc.)
class NetworkException extends AppException {
  final int? statusCode;
  final String? endpoint;

  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.statusCode,
    this.endpoint,
  });

  factory NetworkException.noConnection() => const NetworkException(
        message: 'Sem conexão com a internet',
        code: 'NO_CONNECTION',
      );

  factory NetworkException.timeout([String? endpoint]) => NetworkException(
        message: 'Tempo limite de conexão excedido',
        code: 'TIMEOUT',
        endpoint: endpoint,
      );

  factory NetworkException.serverError({
    int? statusCode,
    String? endpoint,
    String? message,
  }) =>
      NetworkException(
        message: message ?? 'Erro no servidor',
        code: 'SERVER_ERROR',
        statusCode: statusCode,
        endpoint: endpoint,
      );

  @override
  String toString() =>
      'NetworkException: $message (status: $statusCode, endpoint: $endpoint)';
}

/// Exceção de autenticação
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.invalidCredentials() => const AuthException(
        message: 'Credenciais inválidas',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthException.sessionExpired() => const AuthException(
        message: 'Sessão expirada. Faça login novamente.',
        code: 'SESSION_EXPIRED',
      );

  factory AuthException.unauthorized() => const AuthException(
        message: 'Você não tem permissão para acessar este recurso',
        code: 'UNAUTHORIZED',
      );

  factory AuthException.tokenExpired() => const AuthException(
        message: 'Token de acesso expirado',
        code: 'TOKEN_EXPIRED',
      );

  factory AuthException.refreshFailed() => const AuthException(
        message: 'Falha ao renovar sessão',
        code: 'REFRESH_FAILED',
      );
}

/// Exceção de validação
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.fieldErrors,
  });

  factory ValidationException.field(String field, String error) =>
      ValidationException(
        message: error,
        code: 'FIELD_VALIDATION',
        fieldErrors: {
          field: [error]
        },
      );

  factory ValidationException.multiple(Map<String, List<String>> errors) =>
      ValidationException(
        message: 'Erro de validação em múltiplos campos',
        code: 'MULTIPLE_VALIDATION',
        fieldErrors: errors,
      );

  /// Retorna a primeira mensagem de erro do primeiro campo
  String get firstError {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final firstField = fieldErrors!.entries.first;
      if (firstField.value.isNotEmpty) {
        return firstField.value.first;
      }
    }
    return message;
  }
}

/// Exceção de negócio (regras de negócio violadas)
class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory BusinessException.productNotFound(String id) => BusinessException(
        message: 'Produto não encontrado: $id',
        code: 'PRODUCT_NOT_FOUND',
      );

  factory BusinessException.tagAlreadyBound(String tagId) => BusinessException(
        message: 'Tag já vinculada a outro produto: $tagId',
        code: 'TAG_ALREADY_BOUND',
      );

  factory BusinessException.storeNotSelected() => const BusinessException(
        message: 'Nenhuma loja selecionada',
        code: 'STORE_NOT_SELECTED',
      );

  factory BusinessException.insufficientStock(String productName) =>
      BusinessException(
        message: 'Estoque insuficiente para: $productName',
        code: 'INSUFFICIENT_STOCK',
      );
}

/// Exceção de armazenamento local
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory StorageException.readError([String? key]) => StorageException(
        message: 'Erro ao ler dados locais${key != null ? ': $key' : ''}',
        code: 'READ_ERROR',
      );

  factory StorageException.writeError([String? key]) => StorageException(
        message: 'Erro ao salvar dados locais${key != null ? ': $key' : ''}',
        code: 'WRITE_ERROR',
      );

  factory StorageException.deleteError([String? key]) => StorageException(
        message: 'Erro ao deletar dados locais${key != null ? ': $key' : ''}',
        code: 'DELETE_ERROR',
      );
}

/// Exceção de sincronização
class SyncException extends AppException {
  final String? conflictType;
  final List<String>? conflictIds;

  const SyncException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.conflictType,
    this.conflictIds,
  });

  factory SyncException.conflict({
    required String type,
    required List<String> ids,
  }) =>
      SyncException(
        message: 'Conflito de sincronização detectado',
        code: 'SYNC_CONFLICT',
        conflictType: type,
        conflictIds: ids,
      );

  factory SyncException.failed([String? reason]) => SyncException(
        message: reason ?? 'Falha na sincronização',
        code: 'SYNC_FAILED',
      );

  factory SyncException.partialFailed(int successCount, int failCount) =>
      SyncException(
        message: 'Sincronização parcial: $successCount OK, $failCount falhas',
        code: 'PARTIAL_SYNC',
      );
}

/// Exceção de cache
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory CacheException.expired([String? key]) => CacheException(
        message: 'Cache expirado${key != null ? ': $key' : ''}',
        code: 'CACHE_EXPIRED',
      );

  factory CacheException.notFound([String? key]) => CacheException(
        message: 'Cache não encontrado${key != null ? ': $key' : ''}',
        code: 'CACHE_NOT_FOUND',
      );
}

/// Exceção para operações canceladas
class CancelledException extends AppException {
  const CancelledException({
    super.message = 'Operação cancelada',
    super.code = 'CANCELLED',
    super.originalError,
    super.stackTrace,
  });
}

/// Exceção genérica de aplicação
class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = 'Erro inesperado. Tente novamente.',
    super.code = 'UNEXPECTED',
    super.originalError,
    super.stackTrace,
  });
}



