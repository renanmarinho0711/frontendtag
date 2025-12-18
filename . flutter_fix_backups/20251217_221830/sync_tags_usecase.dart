import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/repositories/sync_repository.dart';
// REMOVED: import 'package:tagbean/features/sync/data/repositories/minew_sync_repository.dart';
import 'package:tagbean/features/sync/data/repositories/sync_history_repository.dart';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';

/// Use case para sincronização de tags com a Minew Cloud.
/// 
/// Orquestra:
/// - Chamada ao backend para sincronizar tags
/// - Registro no histórico
/// - Tratamento de erros
class SyncTagsUseCase {
  final SyncRepository _syncRepository;
  final SyncHistoryRepository _historyRepository;

  SyncTagsUseCase({
    required SyncRepository syncRepository,
    required SyncHistoryRepository historyRepository,
  })  : _syncRepository = syncRepository,
        _historyRepository = historyRepository;

  /// Executa sincronização de tags para uma loja.
  /// 
  /// Retorna [SyncResult] com resultado da operação.
  /// Lança [SyncException] em caso de erro não recuperável.
  Future<SyncResult> execute(String storeId) async {
    final startTime = DateTime.now();
    final historyEntry = SyncHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: SyncType.tags,
      status: SyncStatus.running,
      startedAt: startTime,
    );

    try {
      // Adiciona entrada de início no histórico
      await _historyRepository.addEntry(historyEntry);

      // Executa sincronização
      final response = await _syncRepository.syncTags(storeId);
      final duration = DateTime.now().difference(startTime);

      if (response.isSuccess && response.data != null) {
        final result = response.data!;
        
        // Atualiza histórico com resultado
        final completedEntry = historyEntry.copyWith(
          status: result.success ? SyncStatus.success : SyncStatus.partial,
          completedAt: DateTime.now(),
          tagsCount: result.totalProcessed,
          successCount: result.successCount,
          errorCount: result.errorCount,
          duration: duration,
          errorMessage: result.errorMessage,
        );
        
        await _historyRepository.updateEntry(completedEntry);
        return result;
      }

      // Falha na resposta
      final failedEntry = historyEntry.copyWith(
        status: SyncStatus.failed,
        completedAt: DateTime.now(),
        duration: duration,
        errorMessage: response.errorMessage ?? 'Erro desconhecido',
      );
      
      await _historyRepository.updateEntry(failedEntry);
      
      throw SyncDataException(response.errorMessage ?? 'Erro ao sincronizar tags');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      
      // Atualiza histórico com erro
      final errorEntry = historyEntry.copyWith(
        status: SyncStatus.failed,
        completedAt: DateTime.now(),
        duration: DateTime.now().difference(startTime),
        errorMessage: e.toString(),
      );
      
      await _historyRepository.updateEntry(errorEntry);
      throw wrapException(e, stackTrace);
    }
  }
}

/// Use case para atualização de display de tags.
class RefreshTagsUseCase {
  final SyncRepository _syncRepository;
  final SyncHistoryRepository _historyRepository;

  RefreshTagsUseCase({
    required SyncRepository syncRepository,
    required SyncHistoryRepository historyRepository,
  })  : _syncRepository = syncRepository,
        _historyRepository = historyRepository;

  /// Atualiza display de todas as tags de uma loja.
  Future<SyncResult> executeAll(String storeId) async {
    final startTime = DateTime.now();
    final historyEntry = SyncHistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: SyncType.tags,
      status: SyncStatus.running,
      startedAt: startTime,
      details: 'Atualização de displays',
    );

    try {
      await _historyRepository.addEntry(historyEntry);

      final response = await _syncRepository.refreshAllTags(storeId);
      final duration = DateTime.now().difference(startTime);

      if (response.isSuccess && response.data != null) {
        final result = response.data!;
        
        await _historyRepository.updateEntry(historyEntry.copyWith(
          status: result.success ? SyncStatus.success : SyncStatus.partial,
          completedAt: DateTime.now(),
          tagsCount: result.totalProcessed,
          successCount: result.successCount,
          errorCount: result.errorCount,
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

      throw SyncDataException(response.errorMessage ?? 'Erro ao atualizar displays');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      throw wrapException(e, stackTrace);
    }
  }

  /// Atualiza display de tags selecionadas.
  Future<SyncResult> executeSelected(String storeId, List<String> macAddresses) async {
    if (macAddresses.isEmpty) {
      throw const SyncDataException('Nenhuma tag selecionada');
    }

    final startTime = DateTime.now();

    try {
      final response = await _syncRepository.refreshSelectedTags(storeId, macAddresses);
      
      if (response.isSuccess && response.data != null) {
        // Não registra no histórico para seleções pequenas
        return response.data!;
      }

      throw SyncDataException(response.errorMessage ?? 'Erro ao atualizar displays');
    } catch (e, stackTrace) {
      if (e is SyncException) rethrow;
      throw wrapException(e, stackTrace);
    }
  }
}

