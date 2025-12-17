import 'dart:convert';

import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/core/utils/web_utils.dart';
import 'package:tagbean/features/import_export/data/models/import_export_models.dart';

/// Repository para gerenciamento de importação/exportação via nova API
/// 
/// Endpoints disponíveis:
/// - POST /api/import-export/import - Importar dados
/// - POST /api/import-export/upload - Upload de arquivo
/// - GET /api/import-export/templates/{type} - Obter template
/// - POST /api/import-export/preview - Preview de dados
/// - POST /api/import-export/validate - Validar dados
/// - POST /api/import-export/export - Exportar dados
/// - GET /api/import-export/export/download/{jobId} - Download de exportação
/// - GET /api/import-export/history - Histórico de importações
/// - GET /api/import-export/jobs/{jobId} - Status do job
/// - DELETE /api/import-export/jobs/{jobId} - Cancelar job
/// - POST /api/import-export/bulk-operation - Operação em lote
class ImportExportRepository {
  final ApiService _apiService;
  static const String _basePath = '/import-export';

  ImportExportRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // ============================================================================
  // TEMPLATES
  // ============================================================================

  /// Obtém template de importação por tipo
  /// GET /api/import-export/templates/{type}
  Future<ApiResponse<ImportTemplateModel>> getTemplate(String type) async {
    return await _apiService.get<ImportTemplateModel>(
      '$_basePath/templates/$type',
      parser: (data) => ImportTemplateModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ============================================================================
  // PREVIEW E VALIDAÇÀO
  // ============================================================================

  /// Preview de dados para importação
  /// POST /api/import-export/preview
  Future<ApiResponse<ImportPreviewModel>> previewImport({
    required String dataType,
    required String fileContent,
    required String fileFormat,
    String? fileName,
  }) async {
    final body = {
      'dataType': dataType,
      'fileContent': fileContent,
      'fileFormat': fileFormat,
      if (fileName != null) 'fileName': fileName,
    };

    return await _apiService.post<ImportPreviewModel>(
      '$_basePath/preview',
      body: body,
      parser: (data) => ImportPreviewModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Valida dados para importação via JSON
  /// POST /api/import-export/validate/data
  Future<ApiResponse<ValidationResultModel>> validateData({
    required String dataType,
    required List<Map<String, dynamic>> records,
    List<ColumnMappingModel>? columnMappings,
  }) async {
    final body = {
      'dataType': dataType,
      'records': records,
      if (columnMappings != null) 
        'columnMappings': columnMappings.map((m) => m.toJson()).toList(),
    };

    return await _apiService.post<ValidationResultModel>(
      '$_basePath/validate/data',
      body: body,
      parser: (data) => ValidationResultModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ============================================================================
  // IMPORTAÇÀO
  // ============================================================================

  /// Executa importação de dados via JSON
  /// POST /api/import-export/import/data
  Future<ApiResponse<ImportResultModel>> executeImport({
    required String dataType,
    required List<Map<String, dynamic>> records,
    List<ColumnMappingModel>? columnMappings,
    bool updateExisting = true,
    bool skipErrors = false,
  }) async {
    final body = {
      'dataType': dataType,
      'records': records,
      'updateExisting': updateExisting,
      'skipErrors': skipErrors,
      if (columnMappings != null) 
        'columnMappings': columnMappings.map((m) => m.toJson()).toList(),
    };

    return await _apiService.post<ImportResultModel>(
      '$_basePath/import/data',
      body: body,
      parser: (data) => ImportResultModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Upload de arquivo para importação
  /// POST /api/import-export/upload
  Future<ApiResponse<ImportPreviewModel>> uploadFile({
    required String dataType,
    required String fileName,
    required String fileContent,
    required String contentType,
  }) async {
    // Convertemos o conteúdo em base64 para envio
    final body = {
      'dataType': dataType,
      'fileName': fileName,
      'fileContent': base64Encode(utf8.encode(fileContent)),
      'contentType': contentType,
    };

    return await _apiService.post<ImportPreviewModel>(
      '$_basePath/upload',
      body: body,
      parser: (data) => ImportPreviewModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ============================================================================
  // EXPORTAÇÀO
  // ============================================================================

  /// Exporta dados
  /// POST /api/import-export/export
  Future<ApiResponse<ExportResultModel>> exportData({
    required String dataType,
    required String format, // 'csv', 'excel', 'json'
    Map<String, dynamic>? filters,
    List<String>? fields,
    bool includeHeaders = true,
  }) async {
    final body = {
      'dataType': dataType,
      'format': format,
      'includeHeaders': includeHeaders,
      if (filters != null) 'filters': filters,
      if (fields != null) 'fields': fields,
    };

    return await _apiService.post<ExportResultModel>(
      '$_basePath/export',
      body: body,
      parser: (data) => ExportResultModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Download de arquivo exportado
  /// GET /api/import-export/export/download/{jobId}
  Future<void> downloadExport({
    required String jobId,
    required String fileName,
  }) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '$_basePath/export/download/$jobId',
      parser: (data) => data as Map<String, dynamic>,
    );

    if (response.isSuccess && response.data != null) {
      final content = response.data!['content'] as String?;
      final contentType = response.data!['contentType'] as String? ?? 'text/csv';
      
      if (content != null) {
        // Download no navegador
        final bytes = base64Decode(content);
        triggerDownload(bytes, fileName, contentType);
      }
    }
  }

  // ============================================================================
  // JOBS E HISTÓRICO
  // ============================================================================

  /// Obtém status de um job
  /// GET /api/import-export/jobs/{jobId}
  Future<ApiResponse<JobStatusModel>> getJobStatus(String jobId) async {
    return await _apiService.get<JobStatusModel>(
      '$_basePath/jobs/$jobId',
      parser: (data) => JobStatusModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Cancela um job em execução
  /// DELETE /api/import-export/jobs/{jobId}
  Future<ApiResponse<bool>> cancelJob(String jobId) async {
    return await _apiService.delete<bool>(
      '$_basePath/jobs/$jobId',
      parser: (data) => true,
    );
  }

  /// Obtém histórico de importações/exportações
  /// GET /api/import-export/history
  Future<ApiResponse<List<ImportHistoryModel>>> getHistory({
    String? type, // 'products', 'categories', 'tags', 'inventory'
    String? operation, // 'import', 'export'
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _apiService.get<List<ImportHistoryModel>>(
      '$_basePath/history',
      queryParams: {
        if (type != null) 'type': type,
        if (operation != null) 'operation': operation,
        'page': page,
        'pageSize': pageSize,
      },
      parser: (data) {
        if (data is List) {
          return data
              .map((item) => ImportHistoryModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  // ============================================================================
  // OPERAÇÕES EM LOTE
  // ============================================================================

  /// Executa operação em lote
  /// POST /api/import-export/bulk-operation
  Future<ApiResponse<BulkOperationResultModel>> executeBulkOperation({
    required String operation, // 'delete', 'update', 'activate', 'deactivate'
    required String dataType,
    required List<String> ids,
    Map<String, dynamic>? updateData,
  }) async {
    final body = {
      'operation': operation,
      'dataType': dataType,
      'ids': ids,
      if (updateData != null) 'updateData': updateData,
    };

    return await _apiService.post<BulkOperationResultModel>(
      '$_basePath/bulk-operation',
      body: body,
      parser: (data) => BulkOperationResultModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ============================================================================
  // MÉTODOS LEGADOS (Para compatibilidade)
  // ============================================================================

  /// Importa produtos via CSV/Excel (legado - usa nova API)
  Future<ApiResponse<ImportResultModel>> importProducts({
    required List<Map<String, dynamic>> products,
    bool updateExisting = true,
  }) async {
    return await executeImport(
      dataType: 'products',
      records: products,
      updateExisting: updateExisting,
    );
  }

  /// Exporta produtos (legado - usa nova API)
  Future<ApiResponse<ExportResultModel>> exportProducts({
    String format = 'csv',
    String? categoryId,
    bool? activeOnly,
  }) async {
    return await exportData(
      dataType: 'products',
      format: format,
      filters: {
        if (categoryId != null) 'categoryId': categoryId,
        if (activeOnly != null) 'isActive': activeOnly,
      },
    );
  }

  /// Importa tags (legado - usa nova API)
  Future<ApiResponse<ImportResultModel>> importTags({
    required List<Map<String, dynamic>> tags,
    required String storeId,
  }) async {
    return await executeImport(
      dataType: 'tags',
      records: tags.map((t) => {...t, 'storeId': storeId}).toList(),
    );
  }

  /// Exporta tags (legado - usa nova API)
  Future<ApiResponse<ExportResultModel>> exportTags({
    required String storeId,
    String format = 'csv',
    String? status,
  }) async {
    return await exportData(
      dataType: 'tags',
      format: format,
      filters: {
        'storeId': storeId,
        if (status != null) 'status': status,
      },
    );
  }

  /// Obtém histórico de importações (alias para getHistory)
  /// Usado pelo menu de importação para exibir contagem de registros
  Future<ApiResponse<List<ImportHistoryModel>>> getImportHistory({
    int pageSize = 100,
  }) async {
    return await getHistory(pageSize: pageSize);
  }

  // ============================================================================
  // ESTATÍSTICAS
  // ============================================================================

  /// Obtém estatísticas de importação/exportação
  /// GET /api/import-export/statistics
  Future<ApiResponse<ImportExportStatisticsModel>> getStatistics() async {
    return await _apiService.get<ImportExportStatisticsModel>(
      '$_basePath/statistics',
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ImportExportStatisticsModel.fromJson(data);
        }
        return const ImportExportStatisticsModel();
      },
    );
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}



