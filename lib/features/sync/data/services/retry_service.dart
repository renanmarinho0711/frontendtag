import 'dart:async';
import 'dart:math';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';
import 'package:tagbean/features/sync/data/services/sync_logger.dart';

/// Configuração para política de retry
class RetryConfig {
  /// Número máximo de tentativas (incluindo a primeira)
  final int maxAttempts;
  
  /// Delay inicial entre tentativas
  final Duration initialDelay;
  
  /// Fator de multiplicação para backoff exponencial
  final double backoffMultiplier;
  
  /// Delay máximo entre tentativas
  final Duration maxDelay;
  
  /// Se deve adicionar jitter (variação aleatória) ao delay
  final bool useJitter;
  
  /// Função para determinar se uma exceção é retryable
  final bool Function(Object error)? isRetryable;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.useJitter = true,
    this.isRetryable,
  });

  /// Configuração padrão para operações de sync
  static const sync = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 2),
    backoffMultiplier: 2.0,
    maxDelay: Duration(seconds: 30),
  );
  
  /// Configuração para chamadas Minew API
  static const minewApi = RetryConfig(
    maxAttempts: 4,
    initialDelay: Duration(seconds: 1),
    backoffMultiplier: 1.5,
    maxDelay: Duration(seconds: 15),
  );
  
  /// Configuração para operações de rede
  static const network = RetryConfig(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 500),
    backoffMultiplier: 2.0,
    maxDelay: Duration(seconds: 60),
  );
  
  /// Sem retry (para testes ou operações que não devem ter retry)
  static const noRetry = RetryConfig(maxAttempts: 1);
}

/// Resultado de uma operação com retry
class RetryResult<T> {
  final T? value;
  final bool success;
  final int attempts;
  final Duration totalDuration;
  final List<Object> errors;

  RetryResult._({
    this.value,
    required this.success,
    required this.attempts,
    required this.totalDuration,
    required this.errors,
  });

  factory RetryResult.success(T value, int attempts, Duration duration) {
    return RetryResult._(
      value: value,
      success: true,
      attempts: attempts,
      totalDuration: duration,
      errors: [],
    );
  }

  factory RetryResult.failure(List<Object> errors, int attempts, Duration duration) {
    return RetryResult._(
      value: null,
      success: false,
      attempts: attempts,
      totalDuration: duration,
      errors: errors,
    );
  }
}

/// Serviço de retry com backoff exponencial
class RetryService {
  final Random _random = Random();

  /// Executa uma operação com retry automático
  /// 
  /// [operation] - A operação async a ser executada
  /// [config] - Configuração de retry
  /// [context] - Contexto para logging (opcional)
  /// [onRetry] - Callback chamado antes de cada retry
  Future<T> retry<T>({
    required Future<T> Function() operation,
    RetryConfig config = RetryConfig.sync,
    String? operationName,
    String? storeId,
    void Function(int attempt, Object error, Duration delay)? onRetry,
  }) async {
    final stopwatch = Stopwatch()..start();
    final errors = <Object>[];
    
    for (int attempt = 1; attempt <= config.maxAttempts; attempt++) {
      try {
        final result = await operation();
        
        if (attempt > 1) {
          SyncLogger.info('Retry bem-sucedido', context: {
            if (operationName != null) 'operation': operationName,
            if (storeId != null) 'storeId': storeId,
            'attempt': attempt,
            'totalAttempts': config.maxAttempts,
            'durationMs': stopwatch.elapsedMilliseconds,
          });
        }
        
        return result;
      } catch (error, stackTrace) {
        errors.add(error);
        
        // Verifica se é o último attempt
        if (attempt >= config.maxAttempts) {
          SyncLogger.error(
            'Todos os retries falharam',
            context: {
              if (operationName != null) 'operation': operationName,
              if (storeId != null) 'storeId': storeId,
              'totalAttempts': attempt,
              'durationMs': stopwatch.elapsedMilliseconds,
            },
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
        
        // Verifica se o erro é retryable
        if (!_isRetryable(error, config)) {
          SyncLogger.warning(
            'Erro não retryable, abortando',
            context: {
              if (operationName != null) 'operation': operationName,
              'errorType': error.runtimeType.toString(),
            },
          );
          rethrow;
        }
        
        // Calcula delay com backoff exponencial
        final delay = _calculateDelay(attempt, config);
        
        // Log do retry
        SyncLogger.syncRetry(
          syncType: operationName ?? 'unknown',
          storeId: storeId ?? 'unknown',
          attempt: attempt,
          maxAttempts: config.maxAttempts,
          delay: delay,
          lastError: error,
        );
        
        // Callback opcional
        onRetry?.call(attempt, error, delay);
        
        // Espera antes do próximo retry
        await Future.delayed(delay);
      }
    }
    
    // Nunca deve chegar aqui, mas por segurança
    throw StateError('Retry loop completed without returning');
  }

  /// versÃ£o que retorna RetryResult em vez de lançar exceção
  Future<RetryResult<T>> retryWithResult<T>({
    required Future<T> Function() operation,
    RetryConfig config = RetryConfig.sync,
    String? operationName,
    String? storeId,
  }) async {
    final stopwatch = Stopwatch()..start();
    final errors = <Object>[];
    
    for (int attempt = 1; attempt <= config.maxAttempts; attempt++) {
      try {
        final result = await operation();
        return RetryResult.success(result, attempt, stopwatch.elapsed);
      } catch (error) {
        errors.add(error);
        
        if (attempt >= config.maxAttempts || !_isRetryable(error, config)) {
          return RetryResult.failure(errors, attempt, stopwatch.elapsed);
        }
        
        final delay = _calculateDelay(attempt, config);
        await Future.delayed(delay);
      }
    }
    
    return RetryResult.failure(errors, config.maxAttempts, stopwatch.elapsed);
  }

  /// Calcula o delay com backoff exponencial e jitter opcional
  Duration _calculateDelay(int attempt, RetryConfig config) {
    // Backoff exponencial: initialDelay * (multiplier ^ (attempt - 1))
    final exponentialDelay = config.initialDelay.inMilliseconds * 
        pow(config.backoffMultiplier, attempt - 1);
    
    // Aplica limite máximo
    var delayMs = min(exponentialDelay.toInt(), config.maxDelay.inMilliseconds);
    
    // Adiciona jitter (variação de ±25%)
    if (config.useJitter) {
      final jitterRange = (delayMs * 0.25).toInt();
      final jitter = _random.nextInt(jitterRange * 2) - jitterRange;
      delayMs = max(0, delayMs + jitter);
    }
    
    return Duration(milliseconds: delayMs);
  }

  /// Determina se um erro é retryable
  bool _isRetryable(Object error, RetryConfig config) {
    // Usa função customizada se fornecida
    if (config.isRetryable != null) {
      return config.isRetryable!(error);
    }
    
    // Lógica padrão baseada em tipos de exceção
    return switch (error) {
      SyncNetworkException() => true,
      MinewApiException(:final isRetryable) => isRetryable,
      SyncCancelledException() => false,
      SyncAuthException() => false,
      SyncConflictException() => false,
      SyncStoreException() => false,
      SyncDataException() => false,
      TimeoutException() => true,
      _ => _isNetworkError(error.toString()),
    };
  }

  /// Verifica se uma mensagem de erro indica problema de rede
  bool _isNetworkError(String errorMessage) {
    final networkIndicators = [
      'socket',
      'timeout',
      'connection',
      'network',
      'host',
      'refused',
      'unreachable',
    ];
    
    final lowerMessage = errorMessage.toLowerCase();
    return networkIndicators.any((indicator) => lowerMessage.contains(indicator));
  }
}

/// Singleton para acesso global
final retryService = RetryService();

/// Extension para facilitar uso de retry
extension RetryExtension<T> on Future<T> Function() {
  /// Executa a função com retry automático
  Future<T> withRetry({
    RetryConfig config = RetryConfig.sync,
    String? operationName,
    String? storeId,
  }) {
    return retryService.retry(
      operation: this,
      config: config,
      operationName: operationName,
      storeId: storeId,
    );
  }
}
