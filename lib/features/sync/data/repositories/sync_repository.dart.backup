import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/tags/data/repositories/tags_repository.dart';

/// Repositório para operações de Sincronização
/// Orquestra sincronização de tags e produtos com Minew Cloud
class SyncRepository {
  final TagsRepository _tagsRepository;
  final ApiService _apiService;
  
  // Cache local do histórico (até ter endpoint no backend)
  final List<SyncHistoryEntry> _historyCache = [];

  SyncRepository({
    TagsRepository? tagsRepository,
    ApiService? apiService,
  }) : _tagsRepository = tagsRepository ?? TagsRepository(),
       _apiService = apiService ?? ApiService();

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
        
        // Adiciona ao histórico local
        _addToHistory(SyncHistoryEntry(
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
        
        _addToHistory(SyncHistoryEntry(
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
  /// Usa cache local (histórico é mantido em memória durante a sessão)
  Future<ApiResponse<List<SyncHistoryEntry>>> getHistory({
    int limit = 20,
  }) async {
    try {
      // Retorna do cache local ordenado por data
      final sortedHistory = List<SyncHistoryEntry>.from(_historyCache)
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
      
      final limited = sortedHistory.take(limit).toList();
      return ApiResponse.success(limited);
    } catch (e) {
      return ApiResponse.failure('Erro ao obter histórico: $e');
    }
  }

  /// Obtém a última sincronização
  Future<SyncHistoryEntry?> getLastSync() async {
    if (_historyCache.isEmpty) return null;
    
    final sorted = List<SyncHistoryEntry>.from(_historyCache)
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    
    return sorted.first;
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

  /// Adiciona entrada ao histórico
  void _addToHistory(SyncHistoryEntry entry) {
    _historyCache.insert(0, entry);
    
    // Limitar tamanho do cache
    if (_historyCache.length > 100) {
      _historyCache.removeRange(100, _historyCache.length);
    }
  }

  /// Limpa o histórico
  void clearHistory() {
    _historyCache.clear();
  }

  // ==========================================================================
  // NOVOS MÉTODOS - SINCRONIZAÇÀO MINEW CLOUD
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
      _addToHistory(SyncHistoryEntry(
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



