import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';

/// Repositório dedicado para gerenciamento do histórico de sincronização.
/// 
/// Responsabilidades:
/// - Persistir histórico de sincronizações
/// - Gerenciar cache local
/// - Fornecer estatísticas de histórico
/// 
/// Usa SharedPreferences para persistência local.
class SyncHistoryRepository {
  static const String _historyKey = 'sync_history';
  static const String _lastSyncKey = 'sync_last_sync';
  static const int _maxHistoryItems = 100;

  SharedPreferences? _prefs;
  
  // Completer para evitar race conditions na inicialização
  Completer<void>? _initCompleter;
  
  // Cache em memória para acesso rápido
  List<SyncHistoryEntry>? _historyCache;
  SyncHistoryEntry? _lastSyncCache;

  /// Inicializa o repositório (deve ser chamado antes de usar)
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadFromStorage();
  }

  /// Garante que o repositório está inicializado (thread-safe)
  Future<void> _ensureInitialized() async {
    // Já inicializado
    if (_prefs != null) return;
    
    // Se já está inicializando, aguarda o Completer existente
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }
    
    // Inicia nova inicialização
    _initCompleter = Completer<void>();
    
    try {
      await initialize();
      _initCompleter!.complete();
    } catch (e) {
      _initCompleter!.completeError(e);
      _initCompleter = null;
      rethrow;
    } finally {
      // Limpa o completer após conclusÃ£o bem-sucedida
      if (_prefs != null) {
        _initCompleter = null;
      }
    }
  }

  // ===========================================================================
  // HISTÓRICO
  // ===========================================================================

  /// Obtém lista completa do histórico de sincronizações.
  Future<List<SyncHistoryEntry>> getHistory({int? limit}) async {
    await _ensureInitialized();
    
    if (_historyCache == null) {
      await _loadFromStorage();
    }
    
    final history = _historyCache ?? [];
    
    if (limit != null && limit < history.length) {
      return history.take(limit).toList();
    }
    
    return List.unmodifiable(history);
  }

  /// Obtém a última sincronização realizada.
  Future<SyncHistoryEntry?> getLastSync() async {
    await _ensureInitialized();
    return _lastSyncCache;
  }

  /// Adiciona uma entrada ao histórico.
  Future<void> addEntry(SyncHistoryEntry entry) async {
    await _ensureInitialized();
    
    _historyCache ??= [];
    
    // Adiciona no início (mais recente primeiro)
    _historyCache!.insert(0, entry);
    
    // Limita tamanho do histórico
    if (_historyCache!.length > _maxHistoryItems) {
      _historyCache = _historyCache!.take(_maxHistoryItems).toList();
    }
    
    // Atualiza última sincronização se foi concluída com sucesso
    if (entry.status == SyncStatus.success || entry.status == SyncStatus.partial) {
      _lastSyncCache = entry;
    }
    
    await _saveToStorage();
  }

  /// Atualiza uma entrada existente no histórico.
  Future<void> updateEntry(SyncHistoryEntry updatedEntry) async {
    await _ensureInitialized();
    
    if (_historyCache == null) return;
    
    final index = _historyCache!.indexWhere((e) => e.id == updatedEntry.id);
    if (index >= 0) {
      _historyCache![index] = updatedEntry;
      
      // Atualiza última sincronização se necessário
      if (updatedEntry.status == SyncStatus.success || updatedEntry.status == SyncStatus.partial) {
        _lastSyncCache = updatedEntry;
      }
      
      await _saveToStorage();
    }
  }

  /// Limpa todo o histórico.
  Future<void> clearHistory() async {
    await _ensureInitialized();
    
    _historyCache = [];
    _lastSyncCache = null;
    
    await _prefs?.remove(_historyKey);
    await _prefs?.remove(_lastSyncKey);
  }

  /// Remove entradas mais antigas que a data especificada.
  Future<int> pruneOldEntries(DateTime olderThan) async {
    await _ensureInitialized();
    
    if (_historyCache == null) return 0;
    
    final originalCount = _historyCache!.length;
    _historyCache = _historyCache!
        .where((e) => e.startedAt.isAfter(olderThan))
        .toList();
    
    final removedCount = originalCount - _historyCache!.length;
    
    if (removedCount > 0) {
      await _saveToStorage();
    }
    
    return removedCount;
  }

  // ===========================================================================
  // ESTATÍSTICAS
  // ===========================================================================

  /// Obtém estatísticas do histórico de sincronização.
  Future<SyncHistoryStats> getStats() async {
    await _ensureInitialized();
    
    final history = _historyCache ?? [];
    
    if (history.isEmpty) {
      return const SyncHistoryStats(
        totalSyncs: 0,
        successfulSyncs: 0,
        failedSyncs: 0,
        partialSyncs: 0,
        averageDurationMs: 0,
        totalTagsSynced: 0,
        totalErrors: 0,
      );
    }
    
    int successful = 0;
    int failed = 0;
    int partial = 0;
    int totalDuration = 0;
    int totalTags = 0;
    int totalErrors = 0;
    int durationCount = 0;
    
    for (final entry in history) {
      switch (entry.status) {
        case SyncStatus.success:
          successful++;
          break;
        case SyncStatus.failed:
          failed++;
          break;
        case SyncStatus.partial:
          partial++;
          break;
        default:
          break;
      }
      
      if (entry.duration != null) {
        totalDuration += entry.duration!.inMilliseconds;
        durationCount++;
      }
      
      totalTags += entry.tagsCount ?? 0;
      totalErrors += entry.errorCount ?? 0;
    }
    
    return SyncHistoryStats(
      totalSyncs: history.length,
      successfulSyncs: successful,
      failedSyncs: failed,
      partialSyncs: partial,
      averageDurationMs: durationCount > 0 ? totalDuration ~/ durationCount : 0,
      totalTagsSynced: totalTags,
      totalErrors: totalErrors,
      lastSyncAt: _lastSyncCache?.completedAt,
    );
  }

  /// Obtém histórico filtrado por tipo.
  Future<List<SyncHistoryEntry>> getHistoryByType(SyncType type, {int? limit}) async {
    final history = await getHistory();
    final filtered = history.where((e) => e.type == type).toList();
    
    if (limit != null && limit < filtered.length) {
      return filtered.take(limit).toList();
    }
    
    return filtered;
  }

  /// Obtém histórico filtrado por status.
  Future<List<SyncHistoryEntry>> getHistoryByStatus(SyncStatus status, {int? limit}) async {
    final history = await getHistory();
    final filtered = history.where((e) => e.status == status).toList();
    
    if (limit != null && limit < filtered.length) {
      return filtered.take(limit).toList();
    }
    
    return filtered;
  }

  // ===========================================================================
  // PERSISTÊNCIA
  // ===========================================================================

  Future<void> _loadFromStorage() async {
    try {
      // Carrega histórico
      final historyJson = _prefs?.getString(_historyKey);
      if (historyJson != null) {
        final List<dynamic> list = jsonDecode(historyJson);
        _historyCache = list
            .map((e) => SyncHistoryEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _historyCache = [];
      }
      
      // Carrega última sincronização
      final lastSyncJson = _prefs?.getString(_lastSyncKey);
      if (lastSyncJson != null) {
        _lastSyncCache = SyncHistoryEntry.fromJson(
          jsonDecode(lastSyncJson) as Map<String, dynamic>,
        );
      }
    } catch (e) {
      // Em caso de erro, reinicia com dados vazios
      _historyCache = [];
      _lastSyncCache = null;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      // Salva histórico
      if (_historyCache != null) {
        final historyJson = jsonEncode(
          _historyCache!.map((e) => e.toJson()).toList(),
        );
        await _prefs?.setString(_historyKey, historyJson);
      }
      
      // Salva última sincronização
      if (_lastSyncCache != null) {
        final lastSyncJson = jsonEncode(_lastSyncCache!.toJson());
        await _prefs?.setString(_lastSyncKey, lastSyncJson);
      }
    } catch (e) {
      // Falha silenciosa - log seria útil aqui
    }
  }

  /// Libera recursos
  void dispose() {
    _historyCache = null;
    _lastSyncCache = null;
  }
}

/// Estatísticas do histórico de sincronização
class SyncHistoryStats {
  final int totalSyncs;
  final int successfulSyncs;
  final int failedSyncs;
  final int partialSyncs;
  final int averageDurationMs;
  final int totalTagsSynced;
  final int totalErrors;
  final DateTime? lastSyncAt;

  const SyncHistoryStats({
    required this.totalSyncs,
    required this.successfulSyncs,
    required this.failedSyncs,
    required this.partialSyncs,
    required this.averageDurationMs,
    required this.totalTagsSynced,
    required this.totalErrors,
    this.lastSyncAt,
  });

  /// Taxa de sucesso em porcentagem
  double get successRate => totalSyncs > 0 ? (successfulSyncs / totalSyncs) * 100 : 0;

  /// Duração média formatada
  String get averageDurationFormatted {
    if (averageDurationMs < 1000) return '${averageDurationMs}ms';
    if (averageDurationMs < 60000) return '${(averageDurationMs / 1000).toStringAsFixed(1)}s';
    return '${(averageDurationMs / 60000).toStringAsFixed(1)}min';
  }
}
