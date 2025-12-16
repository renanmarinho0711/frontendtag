import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';

/// Repository para gerenciamento de relatórios
/// Comunicação com endpoints de relatórios do backend
class ReportsRepository {
  final ApiService _apiService;

  ReportsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Obtém relatório de vendas
  /// GET /api/reports/sales
  Future<ApiResponse<Map<String, dynamic>>> getSalesReport({
    String periodo = '30dias',
    String? storeId,
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/reports/sales',
      queryParams: {
        'periodo': periodo,
        if (storeId != null) 'storeId': storeId,
      },
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Obtém relatório de auditoria
  /// GET /api/reports/audit
  Future<ApiResponse<Map<String, dynamic>>> getAuditReport({
    String? storeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/reports/audit',
      queryParams: {
        if (storeId != null) 'storeId': storeId,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      },
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Obtém relatório operacional
  /// GET /api/reports/operational
  Future<ApiResponse<Map<String, dynamic>>> getOperationalReport({
    String? storeId,
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/reports/operational',
      queryParams: {
        if (storeId != null) 'storeId': storeId,
      },
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Obtém relatório de performance
  /// GET /api/reports/performance
  Future<ApiResponse<Map<String, dynamic>>> getPerformanceReport({
    String? storeId,
    String periodo = '30dias',
  }) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/reports/performance',
      queryParams: {
        'periodo': periodo,
        if (storeId != null) 'storeId': storeId,
      },
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Exporta relatório
  /// POST /api/reports/export
  Future<ApiResponse<Map<String, dynamic>>> exportReport({
    required String reportType,
    required String format, // 'pdf', 'excel', 'csv'
    Map<String, dynamic>? filters,
  }) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/reports/export',
      body: {
        'reportType': reportType,
        'format': format,
        if (filters != null) 'filters': filters,
      },
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}



