import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';

/// Níveis de log
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// Entrada de log estruturada
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String category;
  final String message;
  final Map<String, dynamic>? context;
  final Object? error;
  final StackTrace? stackTrace;

  LogEntry({
    DateTime? timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.context,
    this.error,
    this.stackTrace,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.name,
    'category': category,
    'message': message,
    if (context != null) 'context': context,
    if (error != null) 'error': error.toString(),
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
  };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[${timestamp.toIso8601String()}]');
    buffer.write(' [${level.name.toUpperCase()}]');
    buffer.write(' [$category]');
    buffer.write(' $message');
    
    if (context != null && context!.isNotEmpty) {
      buffer.write(' | $context');
    }
    
    if (error != null) {
      buffer.write('\n  Error: $error');
    }
    
    return buffer.toString();
  }
}

/// Logger para operações de Sync
class SyncLogger {
  static const String _category = 'Sync';
  static final List<LogEntry> _logBuffer = [];
  static const int _maxBufferSize = 1000;
  
  /// Callback para enviar logs para serviço externo
  static void Function(LogEntry entry)? onLog;
  
  /// Log de debug (apenas em desenvolvimento)
  static void debug(String message, {Map<String, dynamic>? context}) {
    if (kDebugMode) {
      _log(LogLevel.debug, message, context: context);
    }
  }
  
  /// Log informativo
  static void info(String message, {Map<String, dynamic>? context}) {
    _log(LogLevel.info, message, context: context);
  }
  
  /// Log de aviso
  static void warning(String message, {Map<String, dynamic>? context}) {
    _log(LogLevel.warning, message, context: context);
  }
  
  /// Log de erro
  static void error(
    String message, {
    Map<String, dynamic>? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      context: context,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Log fatal (erro crítico)
  static void fatal(
    String message, {
    Map<String, dynamic>? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.fatal,
      message,
      context: context,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Log de início de operação de sync
  static void syncStarted({
    required String syncType,
    required String storeId,
    Map<String, dynamic>? extra,
  }) {
    info('Sync iniciado', context: {
      'syncType': syncType,
      'storeId': storeId,
      ...?extra,
    });
  }
  
  /// Log de conclusÃ£o de sync com sucesso
  static void syncCompleted({
    required String syncType,
    required String storeId,
    required int itemsProcessed,
    required int itemsSuccess,
    required int itemsFailed,
    required Duration duration,
  }) {
    info('Sync concluído', context: {
      'syncType': syncType,
      'storeId': storeId,
      'itemsProcessed': itemsProcessed,
      'itemsSuccess': itemsSuccess,
      'itemsFailed': itemsFailed,
      'durationMs': duration.inMilliseconds,
      'successRate': itemsProcessed > 0 
          ? (itemsSuccess / itemsProcessed * 100).toStringAsFixed(1)
          : '0.0',
    });
  }
  
  /// Log de erro de sync
  static void syncFailed({
    required String syncType,
    required String storeId,
    required Object error,
    StackTrace? stackTrace,
    int? itemsProcessedBeforeError,
  }) {
    final context = {
      'syncType': syncType,
      'storeId': storeId,
      if (itemsProcessedBeforeError != null) 
        'itemsProcessedBeforeError': itemsProcessedBeforeError,
    };
    
    // Adiciona contexto específico baseado no tipo de exceção
    if (error is SyncException) {
      context['errorType'] = error.runtimeType.toString();
      context['errorMessage'] = error.message;
      
      if (error is MinewApiException) {
        context['statusCode'] = error.statusCode;
        context['isRetryable'] = error.isRetryable;
      }
    }
    
    SyncLogger.error(
      'Sync falhou',
      context: context,
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Log de progresso de sync
  static void syncProgress({
    required String syncType,
    required String storeId,
    required double progress,
    int? currentItem,
    int? totalItems,
  }) {
    debug('Sync progresso', context: {
      'syncType': syncType,
      'storeId': storeId,
      'progress': '${(progress * 100).toStringAsFixed(1)}%',
      if (currentItem != null) 'currentItem': currentItem,
      if (totalItems != null) 'totalItems': totalItems,
    });
  }
  
  /// Log de retry
  static void syncRetry({
    required String syncType,
    required String storeId,
    required int attempt,
    required int maxAttempts,
    required Duration delay,
    required Object lastError,
  }) {
    warning('Retry de sync', context: {
      'syncType': syncType,
      'storeId': storeId,
      'attempt': attempt,
      'maxAttempts': maxAttempts,
      'delayMs': delay.inMilliseconds,
      'lastError': lastError.toString(),
    });
  }
  
  /// Log de operação Minew API
  static void minewApiCall({
    required String endpoint,
    required String method,
    String? storeId,
    int? statusCode,
    Duration? duration,
    bool? success,
    String? errorMessage,
  }) {
    final context = {
      'endpoint': endpoint,
      'method': method,
      if (storeId != null) 'storeId': storeId,
      if (statusCode != null) 'statusCode': statusCode,
      if (duration != null) 'durationMs': duration.inMilliseconds,
      if (success != null) 'success': success,
    };
    
    if (success == true) {
      info('Minew API call', context: context);
    } else {
      context['errorMessage'] = errorMessage;
      warning('Minew API call failed', context: context);
    }
  }
  
  /// Obtém logs recentes do buffer
  static List<LogEntry> getRecentLogs({
    int limit = 100,
    LogLevel? minLevel,
  }) {
    var logs = _logBuffer.toList().reversed;
    
    if (minLevel != null) {
      logs = logs.where((e) => e.level.index >= minLevel.index);
    }
    
    return logs.take(limit).toList();
  }
  
  /// Limpa o buffer de logs
  static void clearBuffer() {
    _logBuffer.clear();
  }
  
  /// Exporta logs como JSON
  static List<Map<String, dynamic>> exportLogs({LogLevel? minLevel}) {
    var logs = _logBuffer.toList();
    
    if (minLevel != null) {
      logs = logs.where((e) => e.level.index >= minLevel.index).toList();
    }
    
    return logs.map((e) => e.toJson()).toList();
  }
  
  // Implementação interna de logging
  static void _log(
    LogLevel level,
    String message, {
    Map<String, dynamic>? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final entry = LogEntry(
      level: level,
      category: _category,
      message: message,
      context: context,
      error: error,
      stackTrace: stackTrace,
    );
    
    // Adiciona ao buffer
    _logBuffer.add(entry);
    if (_logBuffer.length > _maxBufferSize) {
      _logBuffer.removeAt(0);
    }
    
    // Console output
    if (kDebugMode) {
      developer.log(
        entry.toString(),
        name: _category,
        level: _levelToInt(level),
        error: error,
        stackTrace: stackTrace,
      );
    }
    
    // Callback para serviço externo
    onLog?.call(entry);
  }
  
  static int _levelToInt(LogLevel level) {
    return switch (level) {
      LogLevel.debug => 500,
      LogLevel.info => 800,
      LogLevel.warning => 900,
      LogLevel.error => 1000,
      LogLevel.fatal => 1200,
    };
  }
}

/// Extension para facilitar logging em exceções
extension SyncExceptionLogging on SyncException {
  void log({String? additionalContext, StackTrace? stackTrace}) {
    SyncLogger.error(
      message,
      context: {
        'exceptionType': runtimeType.toString(),
        if (additionalContext != null) 'additionalContext': additionalContext,
        if (this is MinewApiException) ...{
          'statusCode': (this as MinewApiException).statusCode,
          'isRetryable': (this as MinewApiException).isRetryable,
        },
      },
      error: this,
      stackTrace: stackTrace,
    );
  }
}
