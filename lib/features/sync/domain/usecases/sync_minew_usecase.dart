import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/repositories/minew_sync_repository.dart';
import 'package:tagbean/features/sync/data/repositories/sync_history_repository.dart';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';

/// Use case para sincronização completa de uma loja com Minew Cloud.
/// 
/// Orquestra:
/// - Sincronização de tags
/// - Sincronização de gateways
/// - Obtenção de estatísticas
/// - Registro no histórico
class SyncMinewStoreUseCase {
  final MinewSyncRepository _minewRepository;
  final SyncHistoryRepository _historyRepository;

  SyncMinewStoreUseCase({
    required MinewSyncRepository minewRepository,
    required SyncHistoryRepository historyRepository,
  })  : _minewRepository = minewRepository,
        _historyRepository = historyRepository;

  /// Executa sincronização completa (tags + gateways + stats).
  Future<StoreSyncSummary> execute(String storeId) async {
    final startTime = DateTime.now();
    final historyEntry = SyncHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: SyncType.full,
      status: SyncStatus.running,
      startedAt: startTime,
      details: 'Sincronização completa com Minew Cloud',
    );

    try {
      await _historyRepository.addEntry(historyEntry);

      final response = await _minewRepository.syncStoreComplete(storeId);
      final duration = DateTime.now().difference(startTime);

      if (response.isSuccess && response.data != null) {
        final summary = response.data!;
        
        // Calcula totais
        final tagsUpdated = summary.tagsSync?.updated ?? 0;
        final gatewaysUpdated = summary.gatewaysSync?.updated ?? 0;
        final tagsErrors = summary.tagsSync?.errors ?? 0;
        final gatewaysErrors = summary.gatewaysSync?.errors ?? 0;
        
        await _historyRepository.updateEntry(historyEntry.copyWith(
          status: (tagsErrors + gatewaysErrors) == 0 
              ? SyncStatus.success 
              : SyncStatus.partial,
          completedAt: DateTime.now(),
          tagsCount: summary.tagsSync?.processed ?? 0,
          successCount: tagsUpdated + gatewaysUpdated,
          errorCount: tagsErrors + gatewaysErrors,
          duration: duration,
          details: summary.summary,
        ));
        
        return summary;
      }

      await _historyRepository.updateEntry(historyEntry.copyWith(
        status: SyncStatus.failed,
        completedAt: DateTime.now(),
        duration: duration,
        errorMessage: response.errorMessage,
      ));

      throw SyncDataException(response.errorMessage ?? 'Erro na sincronização');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      
      await _historyRepository.updateEntry(historyEntry.copyWith(
        status: SyncStatus.failed,
        completedAt: DateTime.now(),
        duration: DateTime.now().difference(startTime),
        errorMessage: e.toString(),
      ));
      
      throw wrapException(e, stackTrace);
    }
  }
}

/// Use case para sincronização apenas de tags com Minew.
class SyncMinewTagsUseCase {
  final MinewSyncRepository _minewRepository;
  final SyncHistoryRepository _historyRepository;

  SyncMinewTagsUseCase({
    required MinewSyncRepository minewRepository,
    required SyncHistoryRepository historyRepository,
  })  : _minewRepository = minewRepository,
        _historyRepository = historyRepository;

  /// Sincroniza status das tags com Minew Cloud.
  Future<StatsSyncResult> execute(String storeId) async {
    final startTime = DateTime.now();
    final historyEntry = SyncHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: SyncType.tags,
      status: SyncStatus.running,
      startedAt: startTime,
      details: 'Sync tags Minew',
    );

    try {
      await _historyRepository.addEntry(historyEntry);

      final response = await _minewRepository.syncTags(storeId);
      final duration = DateTime.now().difference(startTime);

      if (response.isSuccess && response.data != null) {
        final result = response.data!;
        
        await _historyRepository.updateEntry(historyEntry.copyWith(
          status: result.success ? SyncStatus.success : SyncStatus.partial,
          completedAt: DateTime.now(),
          tagsCount: result.processed,
          successCount: result.updated,
          errorCount: result.errors,
          duration: duration,
        ));
        
        return result;
      }

      await _historyRepository.updateEntry(historyEntry.copyWith(
        status: SyncStatus.failed,
        completedAt: DateTime.now(),
        duration: duration,
        errorMessage: response.errorMessage,
      ));

      throw SyncDataException(response.errorMessage ?? 'Erro ao sincronizar tags');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      throw wrapException(e, stackTrace);
    }
  }
}

/// Use case para importação de tags da Minew Cloud.
class ImportMinewTagsUseCase {
  final MinewSyncRepository _minewRepository;
  final SyncHistoryRepository _historyRepository;

  ImportMinewTagsUseCase({
    required MinewSyncRepository minewRepository,
    required SyncHistoryRepository historyRepository,
  })  : _minewRepository = minewRepository,
        _historyRepository = historyRepository;

  /// Importa novas tags da Minew Cloud para o banco local.
  Future<StatsSyncResult> execute(String storeId) async {
    final startTime = DateTime.now();
    final historyEntry = SyncHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: SyncType.tags,
      status: SyncStatus.running,
      startedAt: startTime,
      details: 'Importação de tags Minew',
    );

    try {
      await _historyRepository.addEntry(historyEntry);

      final response = await _minewRepository.importTags(storeId);
      final duration = DateTime.now().difference(startTime);

      if (response.isSuccess && response.data != null) {
        final result = response.data!;
        
        await _historyRepository.updateEntry(historyEntry.copyWith(
          status: result.success ? SyncStatus.success : SyncStatus.partial,
          completedAt: DateTime.now(),
          tagsCount: result.processed,
          successCount: result.updated,
          errorCount: result.errors,
          duration: duration,
          details: 'Importadas ${result.updated} novas tags',
        ));
        
        return result;
      }

      await _historyRepository.updateEntry(historyEntry.copyWith(
        status: SyncStatus.failed,
        completedAt: DateTime.now(),
        duration: duration,
        errorMessage: response.errorMessage,
      ));

      throw SyncDataException(response.errorMessage ?? 'Erro ao importar tags');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      throw wrapException(e, stackTrace);
    }
  }
}

/// Use case para obter estatísticas Minew.
class GetMinewStatsUseCase {
  final MinewSyncRepository _minewRepository;

  GetMinewStatsUseCase({required MinewSyncRepository minewRepository})
      : _minewRepository = minewRepository;

  /// Obtém estatísticas da loja diretamente da Minew Cloud.
  Future<MinewStoreStats> execute(String storeId) async {
    try {
      final response = await _minewRepository.getStoreStats(storeId);

      if (response.isSuccess && response.data != null) {
        return response.data!;
      }

      throw SyncDataException(response.errorMessage ?? 'Erro ao obter estatísticas');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      throw wrapException(e, stackTrace);
    }
  }
}

/// Use case para importação de gateways da Minew Cloud.
class ImportMinewGatewaysUseCase {
  final MinewSyncRepository _minewRepository;

  ImportMinewGatewaysUseCase({required MinewSyncRepository minewRepository})
      : _minewRepository = minewRepository;

  /// Importa novos gateways da Minew Cloud para o banco local.
  Future<StatsSyncResult> execute(String storeId) async {
    try {
      final response = await _minewRepository.importGateways(storeId);

      if (response.isSuccess && response.data != null) {
        return response.data!;
      }

      throw SyncDataException(response.errorMessage ?? 'Erro ao importar gateways');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      throw wrapException(e, stackTrace);
    }
  }
}

