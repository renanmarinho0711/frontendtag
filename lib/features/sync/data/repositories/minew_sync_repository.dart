import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';

/// Repositório dedicado para operações de sincronização com Minew Cloud.
/// 
/// Responsabilidades:
/// - Obter estatísticas da Minew Cloud
/// - Sincronizar status de tags e gateways
/// - Importar novas tags/gateways da Minew
/// 
/// NÃO gerencia:
/// - Histórico de sincronização (ver SyncHistoryRepository)
/// - Sincronização de produtos/preços (ver SyncRepository)
class MinewSyncRepository {
  final ApiService _apiService;

  MinewSyncRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // ===========================================================================
  // ESTATÍSTICAS
  // ===========================================================================

  /// Obtém estatísticas da loja diretamente da Minew Cloud.
  /// GET /api/minew/stats/{storeId}
  Future<ApiResponse<MinewStoreStats>> getStoreStats(String storeId) async {
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
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao obter estatísticas');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  // ===========================================================================
  // SINCRONIZAÇÃO
  // ===========================================================================

  /// Sincronização completa da loja (tags + gateways + stats).
  /// POST /api/minew/stats/{storeId}/sync
  Future<ApiResponse<StoreSyncSummary>> syncStoreComplete(String storeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/sync',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!['data'] as Map<String, dynamic>?;
        if (data != null) {
          return ApiResponse.success(StoreSyncSummary.fromJson(data));
        }
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro na sincronização');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  /// Sincroniza apenas status das tags.
  /// POST /api/minew/stats/{storeId}/sync/tags
  Future<ApiResponse<StatsSyncResult>> syncTags(String storeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/sync/tags',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(StatsSyncResult.fromJson(response.data!));
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao sincronizar tags');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  /// Sincroniza apenas status dos gateways.
  /// POST /api/minew/stats/{storeId}/sync/gateways
  Future<ApiResponse<StatsSyncResult>> syncGateways(String storeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/sync/gateways',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(StatsSyncResult.fromJson(response.data!));
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao sincronizar gateways');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  // ===========================================================================
  // IMPORTAÇÃO
  // ===========================================================================

  /// Importa novas tags da Minew Cloud para o banco local.
  /// POST /api/minew/stats/{storeId}/import/tags
  Future<ApiResponse<StatsSyncResult>> importTags(String storeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/import/tags',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(StatsSyncResult.fromJson(response.data!));
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao importar tags');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  /// Importa novos gateways da Minew Cloud para o banco local.
  /// POST /api/minew/stats/{storeId}/import/gateways
  Future<ApiResponse<StatsSyncResult>> importGateways(String storeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/minew/stats/$storeId/import/gateways',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(StatsSyncResult.fromJson(response.data!));
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao importar gateways');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  // ===========================================================================
  // OPERAÇÕES ESPECÍFICAS DE TAG
  // ===========================================================================

  /// Sincroniza uma tag específica com a Minew Cloud.
  /// Atualiza display da tag com dados do produto vinculado.
  Future<ApiResponse<MinewSyncResult>> syncSingleTag({
    required String storeId,
    required String macAddress,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/tags/store/$storeId/sync/tag/$macAddress',
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(MinewSyncResult.fromJson(response.data!));
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao sincronizar tag');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  /// Sincroniza múltiplas tags selecionadas.
  Future<ApiResponse<MinewSyncResult>> syncSelectedTags({
    required String storeId,
    required List<String> macAddresses,
  }) async {
    if (macAddresses.isEmpty) {
      return ApiResponse.failure('Nenhuma tag selecionada');
    }

    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/tags/store/$storeId/sync/selected',
        body: {'macAddresses': macAddresses},
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(MinewSyncResult.fromJson(response.data!));
      }
      return ApiResponse.failure(response.errorMessage ?? 'Erro ao sincronizar tags selecionadas');
    } catch (e, stackTrace) {
      final syncError = wrapException(e, stackTrace);
      return ApiResponse.failure(syncError.message);
    }
  }

  // ===========================================================================
  // TESTES E DIAGNÓSTICO
  // ===========================================================================

  /// Testa conexão com a API Minew.
  Future<ApiResponse<MinewConnectionTestResult>> testConnection(String storeId) async {
    final startTime = DateTime.now();
    
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/minew/stats/$storeId',
        parser: (data) => data as Map<String, dynamic>,
      );

      final pingMs = DateTime.now().difference(startTime).inMilliseconds;

      if (response.isSuccess) {
        return ApiResponse.success(MinewConnectionTestResult(
          success: true,
          pingMs: pingMs,
          minewStatus: 'ONLINE',
          message: 'Conexão com Minew Cloud estabelecida',
        ));
      }

      return ApiResponse.success(MinewConnectionTestResult(
        success: false,
        pingMs: pingMs,
        minewStatus: 'ERROR',
        message: response.errorMessage ?? 'Erro desconhecido',
      ));
    } catch (e) {
      final pingMs = DateTime.now().difference(startTime).inMilliseconds;
      final syncError = wrapException(e);
      
      return ApiResponse.success(MinewConnectionTestResult(
        success: false,
        pingMs: pingMs,
        minewStatus: _getStatusFromException(syncError),
        message: syncError.message,
      ));
    }
  }

  String _getStatusFromException(SyncException error) {
    if (error is SyncAuthException) return 'AUTH_ERROR';
    if (error is SyncNetworkException) return 'NETWORK_ERROR';
    if (error is MinewApiException) return 'MINEW_ERROR';
    return 'ERROR';
  }
}

/// Resultado do teste de conexão com Minew
class MinewConnectionTestResult {
  final bool success;
  final int pingMs;
  final String minewStatus;
  final String message;

  const MinewConnectionTestResult({
    required this.success,
    required this.pingMs,
    required this.minewStatus,
    required this.message,
  });
}

