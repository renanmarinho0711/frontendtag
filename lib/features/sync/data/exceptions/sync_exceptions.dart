/// Exceções específicas para o módulo de sincronização.
/// Permite tratamento granular de erros e melhor debugging.
library;

/// Exceção base para erros de sincronização
sealed class SyncException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const SyncException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'SyncException: $message${code != null ? ' [$code]' : ''}';
}

/// Erro de rede durante sincronização
class SyncNetworkException extends SyncException {
  final int? statusCode;
  final String? url;

  const SyncNetworkException(
    super.message, {
    this.statusCode,
    this.url,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'SyncNetworkException: $message (status: $statusCode)';

  /// Verifica se é um erro de timeout
  bool get isTimeout => code == 'TIMEOUT' || message.toLowerCase().contains('timeout');

  /// Verifica se é um erro de conexão
  bool get isConnectionError => 
      code == 'CONNECTION_ERROR' || 
      message.toLowerCase().contains('connection') ||
      message.toLowerCase().contains('socket');
}

/// Erro de autenticação durante sincronização
class SyncAuthException extends SyncException {
  final bool tokenExpired;

  const SyncAuthException(
    super.message, {
    this.tokenExpired = false,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'SyncAuthException: $message${tokenExpired ? ' (token expired)' : ''}';
}

/// Erro de dados/validação durante sincronização
class SyncDataException extends SyncException {
  final Map<String, dynamic>? validationErrors;

  const SyncDataException(
    super.message, {
    this.validationErrors,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'SyncDataException: $message';

  /// Lista de campos com erro
  List<String> get errorFields => validationErrors?.keys.toList() ?? [];
}

/// Erro de loja não encontrada ou sem configuração Minew
class SyncStoreException extends SyncException {
  final String? storeId;
  final bool missingMinewConfig;

  const SyncStoreException(
    super.message, {
    this.storeId,
    this.missingMinewConfig = false,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'SyncStoreException: $message (store: $storeId)';
}

/// Erro específico da API Minew
class MinewApiException extends SyncException {
  final String? minewErrorCode;
  final String? minewMessage;

  const MinewApiException(
    super.message, {
    this.minewErrorCode,
    this.minewMessage,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'MinewApiException: $message (minew: $minewErrorCode)';

  /// Verifica se é erro de rate limit
  bool get isRateLimited => minewErrorCode == 'RATE_LIMITED' || code == '429';

  /// Verifica se é erro de credenciais inválidas
  bool get isInvalidCredentials => 
      minewErrorCode == 'INVALID_TOKEN' || 
      minewErrorCode == 'UNAUTHORIZED';
}

/// Erro de operação cancelada pelo usuário
class SyncCancelledException extends SyncException {
  const SyncCancelledException([super.message = 'Operação cancelada']);

  @override
  String toString() => 'SyncCancelledException: $message';
}

/// Erro de conflito de dados (sync já em andamento)
class SyncConflictException extends SyncException {
  final DateTime? conflictingSyncStartedAt;

  const SyncConflictException(
    super.message, {
    this.conflictingSyncStartedAt,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'SyncConflictException: $message';
}

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/// Converte exceções genéricas em SyncException apropriada
SyncException wrapException(dynamic error, [StackTrace? stackTrace]) {
  if (error is SyncException) return error;

  final message = error.toString();
  
  // Detecta tipo de erro pelo conteúdo da mensagem
  if (message.contains('401') || message.contains('Unauthorized') || message.contains('Não Autorizado')) {
    return SyncAuthException(
      'SessÃ£o expirada. Faça login novamente.',
      tokenExpired: true,
      originalError: error,
      stackTrace: stackTrace,
    );
  }
  
  if (message.contains('404') || message.contains('Not Found')) {
    return SyncStoreException(
      'Recurso não encontrado',
      code: '404',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
  
  if (message.contains('timeout') || message.contains('Timeout')) {
    return SyncNetworkException(
      'Tempo limite excedido. Tente novamente.',
      code: 'TIMEOUT',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
  
  if (message.contains('connection') || message.contains('socket') || message.contains('network')) {
    return SyncNetworkException(
      'Erro de conexão. Verifique sua internet.',
      code: 'CONNECTION_ERROR',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  // Erro genérico de rede para status codes HTTP
  final statusCodeMatch = RegExp(r'\((\d{3})\)').firstMatch(message);
  if (statusCodeMatch != null) {
    final statusCode = int.parse(statusCodeMatch.group(1)!);
    return SyncNetworkException(
      'Erro de comunicação com o servidor',
      statusCode: statusCode,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  // Fallback para exceção de dados
  return SyncDataException(
    message,
    originalError: error,
    stackTrace: stackTrace,
  );
}

/// Extension para facilitar tratamento de erros em Futures
extension SyncExceptionFuture<T> on Future<T> {
  /// Captura erros e converte para SyncException
  Future<T> wrapSyncErrors() async {
    try {
      return await this;
    } catch (e, stackTrace) {
      throw wrapException(e, stackTrace);
    }
  }
}
