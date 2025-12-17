import 'package:flutter/foundation.dart';

/// Níveis de log
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Serviço de logging centralizado
class LoggerService {
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;
  static bool _enabled = true;

  /// Configura nível mínimo de log
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Habilita/desabilita logs
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Log de debug
  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log de info
  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log de warning
  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log de erro
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log com nível customizado
  static void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(level, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_enabled) return;
    if (level.index < _minLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);
    final tagStr = tag != null ? '[$tag] ' : '';

    final buffer = StringBuffer();
    buffer.writeln('$timestamp $levelStr $tagStr$message');

    if (error != null) {
      buffer.writeln('  Error: $error');
    }

    if (stackTrace != null) {
      buffer.writeln('  StackTrace:');
      buffer.writeln(stackTrace.toString().split('\n').map((l) => '    $l').join('\n'));
    }

    // Em desenvolvimento, imprime no console
    if (kDebugMode) {
      // Cores ANSI para terminal
      switch (level) {
        case LogLevel.debug:
          debugPrint('\x1B[90m${buffer.toString()}\x1B[0m'); // Cinza
          break;
        case LogLevel.info:
          debugPrint('\x1B[34m${buffer.toString()}\x1B[0m'); // Azul
          break;
        case LogLevel.warning:
          debugPrint('\x1B[33m${buffer.toString()}\x1B[0m'); // Amarelo
          break;
        case LogLevel.error:
          debugPrint('\x1B[31m${buffer.toString()}\x1B[0m'); // Vermelho
          break;
      }
    }

    // Em produção, poderia enviar para serviço externo
    // TODO: Implementar integração com Sentry/Firebase Crashlytics
  }

  /// Log de performance
  static void performance(String operation, Duration duration, {String? tag}) {
    final durationMs = duration.inMilliseconds;
    final level = durationMs > 1000 ? LogLevel.warning : LogLevel.debug;
    _log(
      level,
      'Performance: $operation took ${durationMs}ms',
      tag: tag ?? 'PERF',
    );
  }

  /// Log de requisição HTTP
  static void httpRequest({
    required String method,
    required String url,
    int? statusCode,
    Duration? duration,
    Object? error,
  }) {
    final buffer = StringBuffer();
    buffer.write('$method $url');
    if (statusCode != null) buffer.write(' -> $statusCode');
    if (duration != null) buffer.write(' (${duration.inMilliseconds}ms)');

    final level = _getHttpLogLevel(statusCode);
    _log(level, buffer.toString(), tag: 'HTTP', error: error);
  }

  static LogLevel _getHttpLogLevel(int? statusCode) {
    if (statusCode == null) return LogLevel.error;
    if (statusCode >= 500) return LogLevel.error;
    if (statusCode >= 400) return LogLevel.warning;
    return LogLevel.debug;
  }

  /// Log de evento do usuário
  static void userEvent(String event, {Map<String, dynamic>? params}) {
    final paramsStr = params != null ? ' $params' : '';
    _log(LogLevel.info, 'User Event: $event$paramsStr', tag: 'ANALYTICS');
  }

  /// Log de navegação
  static void navigation(String route, {String? from}) {
    final fromStr = from != null ? ' (from: $from)' : '';
    _log(LogLevel.debug, 'Navigate: $route$fromStr', tag: 'NAV');
  }

  /// Log de estado
  static void state(String component, String state, {Map<String, dynamic>? data}) {
    final dataStr = data != null ? ' $data' : '';
    _log(LogLevel.debug, '$component -> $state$dataStr', tag: 'STATE');
  }
}

/// Extension para adicionar logs a qualquer objeto
extension LoggableExtension on Object {
  void logDebug(String message, {String? tag}) {
    LoggerService.debug(message, tag: tag ?? runtimeType.toString());
  }

  void logInfo(String message, {String? tag}) {
    LoggerService.info(message, tag: tag ?? runtimeType.toString());
  }

  void logWarning(String message, {String? tag}) {
    LoggerService.warning(message, tag: tag ?? runtimeType.toString());
  }

  void logError(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    LoggerService.error(
      message,
      tag: tag ?? runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Classe para medir performance de operações
class PerformanceTimer {
  final String operation;
  final String? tag;
  final Stopwatch _stopwatch;

  PerformanceTimer(this.operation, {this.tag}) : _stopwatch = Stopwatch()..start();

  /// Para o timer e loga a duração
  void stop() {
    _stopwatch.stop();
    LoggerService.performance(operation, _stopwatch.elapsed, tag: tag);
  }

  /// Retorna a duração atual
  Duration get elapsed => _stopwatch.elapsed;
}



