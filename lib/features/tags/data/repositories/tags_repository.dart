import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/features/tags/data/models/tag_model.dart';

/// Repositório para gerenciar etiquetas eletrônicas (ESL)
/// Comunicação com TagsController do backend
class TagsRepository {
  final ApiService _apiService;

  TagsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Cria uma nova tag
  /// POST /api/tags
  Future<ApiResponse<TagModel>> createTag(CreateTagRequest request) async {
    return await _apiService.post<TagModel>(
      ApiConstants.tags,
      body: request.toJson(),
      parser: (data) => TagModel.fromJson(data),
    );
  }

  /// Adiciona tags em lote
  /// POST /api/tags/batch
  Future<ApiResponse<BatchOperationResult>> batchAddTags(
    BatchAddTagsRequest request,
  ) async {
    return await _apiService.post<BatchOperationResult>(
      ApiConstants.tagsBatch,
      body: request.toJson(),
      parser: (data) => BatchOperationResult.fromJson(data),
    );
  }

  /// Lista todas as tags
  /// GET /api/tags
  Future<ApiResponse<List<TagModel>>> getAllTags() async {
    return await _apiService.get<List<TagModel>>(
      ApiConstants.tags,
      parser: (data) {
        if (data is List) {
          return data.map((item) => TagModel.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  /// Obtém uma tag por MAC address
  /// GET /api/tags/:macAddress
  Future<ApiResponse<TagModel>> getTagByMac(String macAddress) async {
    return await _apiService.get<TagModel>(
      ApiConstants.tagByMac(macAddress),
      parser: (data) => TagModel.fromJson(data),
    );
  }

  /// Lista tags de uma loja
  /// GET /api/tags/store/:storeId
  Future<ApiResponse<List<TagModel>>> getTagsByStore(String storeId) async {
    return await _apiService.get<List<TagModel>>(
      ApiConstants.tagsByStore(storeId),
      parser: (data) {
        if (data is List) {
          return data.map((item) => TagModel.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  /// Lista tags com paginação
  /// GET /api/tags/store/:storeId/paged
  Future<ApiResponse<TagsPagedResponse>> getTagsPaged({
    required String storeId,
    int page = 1,
    int size = 50,
    String? search,
    String? status,
    int? type,
    bool? isBound,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (isBound != null) 'isBound': isBound,
    };

    return await _apiService.get<TagsPagedResponse>(
      ApiConstants.tagsPagedByStore(storeId),
      queryParams: queryParams,
      parser: (data) => TagsPagedResponse.fromJson(data),
    );
  }

  /// Lista tags disponíveis (não vinculadas) de uma loja
  /// GET /api/tags/store/:storeId/available
  Future<ApiResponse<List<TagModel>>> getAvailableTags(String storeId) async {
    return await _apiService.get<List<TagModel>>(
      ApiConstants.tagsAvailable(storeId),
      parser: (data) {
        if (data is List) {
          return data.map((item) => TagModel.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  /// Lista tags vinculadas de uma loja
  /// GET /api/tags/store/:storeId/bound
  Future<ApiResponse<List<TagModel>>> getBoundTags(String storeId) async {
    return await _apiService.get<List<TagModel>>(
      ApiConstants.tagsBound(storeId),
      parser: (data) {
        if (data is List) {
          return data.map((item) => TagModel.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  /// Obtém detalhes de vinculação de uma tag
  /// GET /api/tags/:macAddress/binding
  Future<ApiResponse<TagBindingDetails>> getTagBindingDetails(String macAddress) async {
    return await _apiService.get<TagBindingDetails>(
      ApiConstants.tagBinding(macAddress),
      parser: (data) => TagBindingDetails.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Vincula tag a produto
  /// POST /api/tags/:macAddress/bind
  Future<ApiResponse<TagModel>> bindTag(
    String macAddress,
    BindTagRequest request,
  ) async {
    return await _apiService.post<TagModel>(
      ApiConstants.tagBind(macAddress),
      body: request.toJson(),
      parser: (data) => TagModel.fromJson(data),
    );
  }

  /// Desvincula tag de produto
  /// POST /api/tags/:macAddress/unbind
  Future<ApiResponse<TagModel>> unbindTag(String macAddress) async {
    return await _apiService.post<TagModel>(
      ApiConstants.tagUnbind(macAddress),
      parser: (data) => TagModel.fromJson(data),
    );
  }

  /// Vincula tags em lote
  /// POST /api/tags/batch/bind
  Future<ApiResponse<BatchOperationResult>> batchBindTags(
    BatchBindTagsRequest request,
  ) async {
    return await _apiService.post<BatchOperationResult>(
      ApiConstants.tagsBatchBind,
      body: request.toJson(),
      parser: (data) => BatchOperationResult.fromJson(data),
    );
  }

  /// Desvincula tags em lote
  /// POST /api/tags/batch/unbind
  Future<ApiResponse<BatchOperationResult>> batchUnbindTags({
    required String storeId,
    required List<String> macAddresses,
  }) async {
    return await _apiService.post<BatchOperationResult>(
      ApiConstants.tagsBatchUnbind,
      body: {
        'storeId': storeId,
        'macAddresses': macAddresses,
      },
      parser: (data) => BatchOperationResult.fromJson(data),
    );
  }

  /// Aciona o LED da tag (flash)
  /// POST /api/tags/:macAddress/flash
  Future<ApiResponse<void>> flashTag(
    String macAddress, {
    String color = 'green',
    int durationSeconds = 5,
  }) async {
    return await _apiService.post<void>(
      ApiConstants.tagFlash(macAddress),
      body: {
        'color': color,
        'durationSeconds': durationSeconds,
      },
    );
  }

  /// Atualiza display da tag
  /// POST /api/tags/:macAddress/refresh
  Future<ApiResponse<void>> refreshTag(String macAddress) async {
    return await _apiService.post<void>(
      ApiConstants.tagRefresh(macAddress),
    );
  }

  /// Atualiza displays em lote
  /// POST /api/tags/batch/refresh
  Future<ApiResponse<BatchOperationResult>> batchRefreshTags({
    required String storeId,
    required List<String> macAddresses,
  }) async {
    return await _apiService.post<BatchOperationResult>(
      ApiConstants.tagsBatchRefresh,
      body: {
        'storeId': storeId,
        'macAddresses': macAddresses,
      },
      parser: (data) => BatchOperationResult.fromJson(data),
    );
  }

  /// Sincroniza tags com a API Minew
  /// POST /api/tags/store/:storeId/sync
  Future<ApiResponse<BatchOperationResult>> syncTags(String storeId) async {
    return await _apiService.post<BatchOperationResult>(
      '${ApiConstants.tagsStoreSync(storeId)}',
      parser: (data) => BatchOperationResult.fromJson(data),
    );
  }

  /// Exclui uma tag
  /// DELETE /api/tags/:macAddress
  Future<ApiResponse<void>> deleteTag(String macAddress) async {
    return await _apiService.delete(
      ApiConstants.tagByMac(macAddress),
    );
  }

  /// Atualiza uma tag
  /// PUT /api/tags/:macAddress
  Future<ApiResponse<TagModel>> updateTag(
    String macAddress,
    UpdateTagDto dto,
  ) async {
    return await _apiService.put<TagModel>(
      ApiConstants.tagByMac(macAddress),
      body: dto.toJson(),
      parser: (data) => TagModel.fromJson(data),
    );
  }

  /// Exclui tags em lote
  /// DELETE /api/tags/batch
  Future<ApiResponse<BatchOperationResult>> batchDeleteTags({
    required String storeId,
    required List<String> macAddresses,
  }) async {
    return await _apiService.delete<BatchOperationResult>(
      ApiConstants.tagsBatch,
      body: {
        'storeId': storeId,
        'macAddresses': macAddresses,
      },
      parser: (data) => BatchOperationResult.fromJson(data),
    );
  }

  /// Obtém histórico de importações de tags
  /// GET /api/tags/store/:storeId/imports
  Future<ApiResponse<List<TagImportHistory>>> getImportHistory({
    required String storeId,
    int limit = 10,
  }) async {
    return await _apiService.get<List<TagImportHistory>>(
      '/tags/store/$storeId/imports',
      queryParams: {'limit': limit},
      parser: (data) {
        if (data is List) {
          return data.map((item) => TagImportHistory.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Obtém estatísticas das tags de uma loja
  /// GET /api/tags/store/:storeId/stats
  Future<ApiResponse<TagStats>> getTagStats(String storeId) async {
    return await _apiService.get<TagStats>(
      '/tags/store/$storeId/stats',
      parser: (data) => TagStats.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Importa tags de arquivo
  /// POST /api/tags/store/:storeId/import
  Future<ApiResponse<TagImportResult>> importTags({
    required String storeId,
    required List<TagImportItem> items,
    String format = 'csv',
    bool overwriteExisting = false,
    bool validateBeforeImport = true,
  }) async {
    return await _apiService.post<TagImportResult>(
      '/tags/store/$storeId/import',
      body: {
        'format': format,
        'items': items.map((e) => e.toJson()).toList(),
        'overwriteExisting': overwriteExisting,
        'validateBeforeImport': validateBeforeImport,
      },
      parser: (data) => TagImportResult.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}




