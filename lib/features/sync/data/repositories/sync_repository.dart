import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/repositories/sync_history_repository.dart';
import 'package:tagbean/features/tags/data/repositories/tags_repository.dart';

/// Repositório para operações de Sincronização
/// Orquestra sincronização de tags e produtos com Minew Cloud
class SyncRepository {
  final TagsRepository _tagsRepository;
  final ApiService _apiService;
  final SyncHistoryRepository _historyRepository;

  SyncRepository({
    TagsRepository? tagsRepository,
    ApiService? apiService,
    SyncHistoryRepository? historyRepository,
  }) : _tagsRepository = tagsRepository ?? TagsRepository(),
       _apiService = apiService ?? ApiService(),
       _historyRepository = historyRepository ?? SyncHistoryRepository();

  /// Executa sincronização de tags
  /// Usa POST /api/tags/store/:storeId/sync
  Future<ApiResponse<SyncResult>> syncTags(String storeId) async {
    final startTime = DateTime.now();
    
    try {
      final response = await _tagsRepository.syncTags(storeId);
      final duration = DateTime.now().difference(startTime);
      
      if (response.isSuccess && response.data != null) {
        final batchResult = response.data!;
        final result = SyncResult(
          success: batchResult.failureCount == 0,
          totalProcessed: batchResult.total,
          successCount: batchResult.successCount,
          errorCount: batchResult.failureCount,
          duration: duration,
          errors: batchResult.errors,
        );
        
        // Adiciona ao histórico usando repositório
        await _historyRepository.addEntry(SyncHistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: SyncType.tags,
          status: result.success ? SyncStatus.success : SyncStatus.failed,
          startedAt: startTime,
          completedAt: DateTime.now(),
          tagsCount: batchResult.total,
          successCount: batchResult.successCount,
          errorCount: batchResult.failureCount,
          duration: duration,
        ));
        
        return ApiResponse.success(result);
      } else {
        return ApiResponse.failure(
          response.errorMessage ?? 'Erro ao sincronizar tags',
        );
      }
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar tags: $e');
    }
  }

  /// Atualiza display de todas as tags de uma loja
  /// Usa POST /api/tags/batch/refresh
  Future<ApiResponse<SyncResult>> refreshAllTags(String storeId) async {
    final startTime = DateTime.now();
    
    try {
      // Primeiro, obter todas as tags da loja
      final tagsResponse = await _tagsRepository.getTagsByStore(storeId);
      
      if (!tagsResponse.isSuccess || tagsResponse.data == null) {
        return ApiResponse.failure(
          tagsResponse.errorMessage ?? 'Erro ao obter tags',
        );
      }
      
      final tags = tagsResponse.data!;
      if (tags.isEmpty) {
        return ApiResponse.success(SyncResult.success(
          totalProcessed: 0,
          successCount: 0,
          duration: DateTime.now().difference(startTime),
        ));
      }
      
      // Atualizar displays em lote
      final macAddresses = tags.map((t) => t.macAddress).toList();
      final refreshResponse = await _tagsRepository.batchRefreshTags(
        storeId: storeId,
        macAddresses: macAddresses,
      );
      
      final duration = DateTime.now().difference(startTime);
      
      if (refreshResponse.isSuccess && refreshResponse.data != null) {
        final batchResult = refreshResponse.data!;
        final result = SyncResult(
          success: batchResult.failureCount == 0,
          totalProcessed: batchResult.total,
          successCount: batchResult.successCount,
          errorCount: batchResult.failureCount,
          duration: duration,
          errors: batchResult.errors,
        );
        
        await _historyRepository.addEntry(SyncHistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: SyncType.tags,
          status: result.success ? SyncStatus.success : SyncStatus.failed,
          startedAt: startTime,
          completedAt: DateTime.now(),
          tagsCount: batchResult.total,
          successCount: batchResult.successCount,
          errorCount: batchResult.failureCount,
          duration: duration,
        ));
        
        return ApiResponse.success(result);
      } else {
        return ApiResponse.failure(
          refreshResponse.errorMessage ?? 'Erro ao atualizar displays',
        );
      }
    } catch (e) {
      return ApiResponse.failure('Erro ao atualizar displays: $e');
    }
  }

  /// Atualiza display de tags selecionadas
  Future<ApiResponse<SyncResult>> refreshSelectedTags(
    String storeId,
    List<String> macAddresses,
  ) async {
    final startTime = DateTime.now();
    
    try {
      final response = await _tagsRepository.batchRefreshTags(
        storeId: storeId,
        macAddresses: macAddresses,
      );
      
      final duration = DateTime.now().difference(startTime);
      
      if (response.isSuccess && response.data != null) {
        final batchResult = response.data!;
        return ApiResponse.success(SyncResult(
          success: batchResult.failureCount == 0,
          totalProcessed: batchResult.total,
          successCount: batchResult.successCount,
          errorCount: batchResult.failureCount,
          duration: duration,
          errors: batchResult.errors,
        ));
      } else {
        return ApiResponse.failure(
          response.errorMessage ?? 'Erro ao atualizar displays',
        );
      }
    } catch (e) {
      return ApiResponse.failure('Erro ao atualizar displays: $e');
    }
  }

  /// Obtém o histórico de sincronizações
  /// Delega para SyncHistoryRepository (com persistência)
  Future<ApiResponse<List<SyncHistoryEntry>>> getHistory({
    int limit = 20,
  }) async {
    try {
      final history = await _historyRepository.getHistory(limit: limit);
      return ApiResponse.success(history);
    } catch (e) {
      return ApiResponse.failure('Erro ao obter histórico: $e');
    }
  }

  /// Obtém a última sincronização
  Future<SyncHistoryEntry?> getLastSync() async {
    return await _historyRepository.getLastSync();
  }

  /// Testa a conexão com a API de sincronização
  /// Retorna um resultado indicando latência e status
  Future<ApiResponse<SyncConnectionTestResult>> testConnection(String storeId) async {
    final startTime = DateTime.now();
    
    try {
      // Testar obtendo as tags da loja para validar conexão
      final response = await _tagsRepository.getTagsByStore(storeId);
      final pingMs = DateTime.now().difference(startTime).inMilliseconds;
      
      if (response.isSuccess) {
        return ApiResponse.success(SyncConnectionTestResult(
          success: true,
          pingMs: pingMs,
          authStatus: 'OK',
          permissionsStatus: 'OK',
          message: 'Conexão estabelecida com sucesso',
        ));
      } else {
        return ApiResponse.success(SyncConnectionTestResult(
          success: false,
          pingMs: pingMs,
          authStatus: response.errorMessage?.contains('401') == true ? 'FALHA' : 'OK',
          permissionsStatus: response.errorMessage?.contains('403') == true ? 'FALHA' : 'OK',
          message: response.errorMessage ?? 'Falha na conexão',
        ));
      }
    } catch (e) {
      final pingMs = DateTime.now().difference(startTime).inMilliseconds;
      return ApiResponse.success(SyncConnectionTestResult(
        success: false,
        pingMs: pingMs,
        authStatus: 'ERRO',
        permissionsStatus: 'ERRO',
        message: 'Erro de conexão: $e',
      ));
    }
  }

  /// Limpa o histórico (delega para repositório)
  Future<void> clearHistory() async {
    await _historyRepository.clearHistory();
  }

  // ==========================================================================
  // NOVOS MÉTODOS - SINCRONIZAÇÃO MINEW CLOUD
  // Endpoints do SyncController no backend
  // ==========================================================================

  /// Sincroniza uma tag específica com a Minew Cloud
  /// POST /api/sync/tags/{macAddress}
  Future<ApiResponse<MinewSyncResult>> syncTag(String macAddress) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/tags/$macAddress',
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar tag: $e');
    }
  }

  /// Sincroniza tags em lote
  /// POST /api/sync/tags/batch
  Future<ApiResponse<MinewSyncResult>> syncTagsBatch(
    String storeId,
    List<String> macAddresses,
  ) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/tags/batch',
        body: BatchSyncTagsRequest(
          storeId: storeId,
          macAddresses: macAddresses,
        ).toJson(),
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar tags em lote: $e');
    }
  }

  /// Sincroniza um produto específico com a Minew Cloud
  /// POST /api/sync/products/{productId}
  Future<ApiResponse<MinewSyncResult>> syncProduct(String productId) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/products/$productId',
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar produto: $e');
    }
  }

  /// Sincroniza produtos em lote
  /// POST /api/sync/products/batch
  Future<ApiResponse<MinewSyncResult>> syncProductsBatch(
    String storeId,
    List<String> productIds,
  ) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/products/batch',
        body: BatchSyncProductsRequest(
          storeId: storeId,
          productIds: productIds,
        ).toJson(),
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar produtos em lote: $e');
    }
  }

  /// Sincroniza uma loja com a Minew Cloud
  /// POST /api/sync/store/{storeId}
  Future<ApiResponse<MinewSyncResult>> syncStore(String storeId) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/store/$storeId',
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar loja: $e');
    }
  }

  /// Vincula uma tag a um produto
  /// POST /api/sync/tags/{macAddress}/bind/{productId}
  Future<ApiResponse<BindResultDto>> bindTagToProduct(
    String macAddress,
    String productId,
  ) async {
    try {
      return await _apiService.post<BindResultDto>(
        '/sync/tags/$macAddress/bind/$productId',
        parser: (data) => BindResultDto.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao vincular tag: $e');
    }
  }

  /// Desvincula uma tag de um produto
  /// POST /api/sync/tags/{macAddress}/unbind
  Future<ApiResponse<MinewSyncResult>> unbindTag(String macAddress) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/tags/$macAddress/unbind',
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao desvincular tag: $e');
    }
  }

  /// Atualiza o display de uma tag
  /// POST /api/sync/tags/{macAddress}/refresh
  Future<ApiResponse<MinewSyncResult>> refreshTagDisplay(
    String macAddress, {
    String? templateId,
  }) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/tags/$macAddress/refresh',
        body: templateId != null ? {'templateId': templateId} : null,
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao atualizar display: $e');
    }
  }

  /// Atualiza displays de tags em lote
  /// POST /api/sync/tags/refresh/batch
  Future<ApiResponse<MinewSyncResult>> refreshTagDisplaysBatch(
    String storeId,
    List<String> macAddresses,
  ) async {
    try {
      return await _apiService.post<MinewSyncResult>(
        '/sync/tags/refresh/batch',
        body: {
          'storeId': storeId,
          'macAddresses': macAddresses,
        },
        parser: (data) => MinewSyncResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao atualizar displays em lote: $e');
    }
  }

  /// Importa tags da Minew Cloud
  /// POST /api/sync/tags/import/{storeId}
  Future<ApiResponse<ImportTagsResult>> importTagsFromMinew(
    String storeId, {
    bool overwriteExisting = false,
  }) async {
    try {
      return await _apiService.post<ImportTagsResult>(
        '/sync/tags/import/$storeId',
        body: {'overwriteExisting': overwriteExisting},
        parser: (data) => ImportTagsResult.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao importar tags: $e');
    }
  }

  /// Obtém status de sincronização de uma entidade
  /// GET /api/sync/status/{entityType}/{entityId}
  Future<ApiResponse<SyncStatusInfo>> getSyncStatus(
    String entityType,
    String entityId,
  ) async {
    try {
      return await _apiService.get<SyncStatusInfo>(
        '/sync/status/$entityType/$entityId',
        parser: (data) => SyncStatusInfo.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.failure('Erro ao obter status: $e');
    }
  }

  /// Sincronização completa de uma loja (tags + produtos)
  /// Executa sincronização em sequência
  Future<ApiResponse<SyncResult>> syncFullStore(String storeId) async {
    final startTime = DateTime.now();
    int totalSuccess = 0;
    int totalErrors = 0;
    int tagsCount = 0;
    int productsCount = 0;
    final List<String> allErrors = [];

    try {
      // 1. Sincronizar loja primeiro
      final storeResult = await syncStore(storeId);
      if (!storeResult.isSuccess) {
        allErrors.add('Loja: ${storeResult.errorMessage}');
        totalErrors++;
      } else {
        totalSuccess++;
      }

      // 2. Importar tags da Minew Cloud (atualiza lista local)
      final importResult = await importTagsFromMinew(storeId);
      if (importResult.isSuccess && importResult.data != null) {
        tagsCount = importResult.data!.importedCount + importResult.data!.updatedCount;
        if (importResult.data!.errorCount > 0) {
          allErrors.addAll(importResult.data!.errors);
          totalErrors += importResult.data!.errorCount;
        }
        totalSuccess += importResult.data!.importedCount + importResult.data!.updatedCount;
      }

      final duration = DateTime.now().difference(startTime);

      // 3. Criar histórico
      await _historyRepository.addEntry(SyncHistoryEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: SyncType.full,
        status: totalErrors == 0 
            ? SyncStatus.success 
            : (totalSuccess > 0 ? SyncStatus.partial : SyncStatus.failed),
        startedAt: startTime,
        completedAt: DateTime.now(),
        tagsCount: tagsCount,
        productsCount: productsCount,
        successCount: totalSuccess,
        errorCount: totalErrors,
        duration: duration,
        errors: allErrors,
      ));

      return ApiResponse.success(SyncResult(
        success: totalErrors == 0,
        totalProcessed: totalSuccess + totalErrors,
        successCount: totalSuccess,
        errorCount: totalErrors,
        duration: duration,
        errors: allErrors,
      ));
    } catch (e) {
      return ApiResponse.failure('Erro na sincronização completa: $e');
    }
  }

  /// Libera recursos
  void dispose() {
    _tagsRepository.dispose();
  }

  // ==========================================================================
  // NOVOS MÉTODOS - MINEW STATS SYNC
  // Integração com MinewStatsController no backend
  // ==========================================================================

  /// Obtém estatísticas da loja diretamente da Minew Cloud
  /// GET /api/minew/stats/{storeId}
  Future<ApiResponse<MinewStoreStats>> getMinewStoreStats(String storeId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/minew/stats/$storeId',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!['data'] as Map<String, dynamic>?;
        if (data != null) {
          return ApiResponse.success(MinewStoreStats.fromJson(data));
        }
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao obter stats');
    } catch (e) {
      return ApiResponse.failure('Erro ao obter estatísticas Minew: $e');
    }
  }

  /// Sincronização completa da loja (tags + gateways + stats)
  /// POST /api/minew/stats/{storeId}/sync
  Future<ApiResponse<StoreSyncSummary>> syncMinewStoreComplete(String storeId) async {
    final startTime = DateTime.now();
    
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/sync',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!['data'] as Map<String, dynamic>?;
        if (data != null) {
          final summary = StoreSyncSummary.fromJson(data);
          
          // Adiciona ao histórico usando repositório
          await _historyRepository.addEntry(SyncHistoryEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: SyncType.full,
            status: response.data!['success'] == true 
                ? SyncStatus.success 
                : SyncStatus.partial,
            startedAt: startTime,
            completedAt: DateTime.now(),
            tagsCount: summary.tagsSync?.processed ?? 0,
            successCount: (summary.tagsSync?.updated ?? 0) + 
                         (summary.gatewaysSync?.updated ?? 0),
            errorCount: (summary.tagsSync?.errors ?? 0) + 
                       (summary.gatewaysSync?.errors ?? 0),
            duration: summary.duration,
          ));
          
          return ApiResponse.success(summary);
        }
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro na sincronização');
    } catch (e) {
      return ApiResponse.failure('Erro na sincronização completa: $e');
    }
  }

  /// Sincroniza apenas status das tags
  /// POST /api/minew/stats/{storeId}/sync/tags
  Future<ApiResponse<StatsSyncResult>> syncMinewTags(String storeId) async {
    final startTime = DateTime.now();
    
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/sync/tags',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final result = StatsSyncResult.fromJson(response.data!);
        
        await _historyRepository.addEntry(SyncHistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: SyncType.tags,
          status: result.success ? SyncStatus.success : SyncStatus.partial,
          startedAt: startTime,
          completedAt: DateTime.now(),
          tagsCount: result.processed,
          successCount: result.updated,
          errorCount: result.errors,
          duration: result.duration,
        ));
        
        return ApiResponse.success(result);
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao sincronizar tags');
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar tags: $e');
    }
  }

  /// Sincroniza apenas status dos gateways
  /// POST /api/minew/stats/{storeId}/sync/gateways
  Future<ApiResponse<StatsSyncResult>> syncMinewGateways(String storeId) async {
    final startTime = DateTime.now();
    
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/sync/gateways',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final result = StatsSyncResult.fromJson(response.data!);
        return ApiResponse.success(result);
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao sincronizar gateways');
    } catch (e) {
      return ApiResponse.failure('Erro ao sincronizar gateways: $e');
    }
  }

  /// Importa novas tags da Minew Cloud para o banco local
  /// POST /api/minew/stats/{storeId}/import/tags
  Future<ApiResponse<StatsSyncResult>> importMinewTags(String storeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/import/tags',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final result = StatsSyncResult.fromJson(response.data!);
        return ApiResponse.success(result);
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao importar tags');
    } catch (e) {
      return ApiResponse.failure('Erro ao importar tags: $e');
    }
  }

  /// Importa novos gateways da Minew Cloud para o banco local
  /// POST /api/minew/stats/{storeId}/import/gateways
  Future<ApiResponse<StatsSyncResult>> importMinewGateways(String storeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/import/gateways',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final result = StatsSyncResult.fromJson(response.data!);
        return ApiResponse.success(result);
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao importar gateways');
    } catch (e) {
      return ApiResponse.failure('Erro ao importar gateways: $e');
    }
  }
}

/// Resultado do teste de conexão
class SyncConnectionTestResult {
  final bool success;
  final int pingMs;
  final String authStatus;
  final String permissionsStatus;
  final String message;

  const SyncConnectionTestResult({
    required this.success,
    required this.pingMs,
    required this.authStatus,
    required this.permissionsStatus,
    required this.message,
  });
}




