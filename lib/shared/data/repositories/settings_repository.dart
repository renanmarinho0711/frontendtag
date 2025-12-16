mport 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';

/// Repository para gerenciamento de configurações
/// Comunicação com endpoints de configuração do backend
class SettingsRepository {
  final ApiService _apiService;

  SettingsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // ============================================================================
  // CONFIGURAÇÕES DA LOJA
  // ============================================================================

  /// Obtém configurações da loja
  /// GET /api/stores/:storeId
  Future<ApiResponse<Map<String, dynamic>>> getStoreSettings(String storeId) async {
    return await _apiService.get<Map<String, dynamic>>(
      '/stores/$storeId',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Atualiza configurações da loja
  /// PUT /api/stores/:storeId
  Future<ApiResponse<Map<String, dynamic>>> updateStoreSettings({
    required String storeId,
    required String nome,
    String? cnpj,
    String? endereco,
    String? cidade,
    String? estado,
    String? cep,
    String? telefone,
    String? email,
  }) async {
    final body = {
      'name': nome,
      if (cnpj != null) 'cnpj': cnpj,
      if (endereco != null) 'address': endereco,
      if (cidade != null) 'city': cidade,
      if (estado != null) 'state': estado,
      if (cep != null) 'zipCode': cep,
      if (telefone != null) 'phone': telefone,
      if (email != null) 'email': email,
    };

    return await _apiService.put<Map<String, dynamic>>(
      '/stores/$storeId',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // ============================================================================
  // CONFIGURAÇÕES ERP
  // ============================================================================

  /// Obtém configurações de integração ERP
  /// GET /api/configurations/erp
  Future<ApiResponse<Map<String, dynamic>>> getERPSettings() async {
    return await _apiService.get<Map<String, dynamic>>(
      '/configurations/erp',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Testa conexão ERP
  /// POST /api/configurations/erp/test
  Future<ApiResponse<Map<String, dynamic>>> testERPConnection({
    required String type,
    required String apiUrl,
    required String apiKey,
  }) async {
    final body = {
      'type': type,
      'apiUrl': apiUrl,
      'apiKey': apiKey,
    };

    return await _apiService.post<Map<String, dynamic>>(
      '/configurations/erp/test',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Salva configurações ERP
  /// PUT /api/configurations/erp
  Future<ApiResponse<Map<String, dynamic>>> saveERPSettings({
    required String type,
    required String apiUrl,
    required String apiKey,
    bool syncProducts = true,
    bool syncPrices = true,
    bool syncStock = true,
    int syncInterval = 30,
  }) async {
    final body = {
      'type': type,
      'apiUrl': apiUrl,
      'apiKey': apiKey,
      'syncProducts': syncProducts,
      'syncPrices': syncPrices,
      'syncStock': syncStock,
      'syncInterval': syncInterval,
    };

    return await _apiService.put<Map<String, dynamic>>(
      '/configurations/erp',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // ============================================================================
  // CONFIGURAÇÕES DE NOTIFICAÇÕES
  // ============================================================================

  /// Obtém configurações de notificações
  /// GET /api/configurations/notifications
  Future<ApiResponse<Map<String, dynamic>>> getNotificationSettings() async {
    return await _apiService.get<Map<String, dynamic>>(
      '/configurations/notifications',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Salva configurações de notificações
  /// PUT /api/configurations/notifications
  Future<ApiResponse<Map<String, dynamic>>> saveNotificationSettings({
    bool emailEnabled = true,
    bool pushEnabled = true,
    bool priceAlerts = true,
    bool stockAlerts = true,
    bool syncAlerts = true,
    bool errorAlerts = true,
  }) async {
    final body = {
      'emailEnabled': emailEnabled,
      'pushEnabled': pushEnabled,
      'priceAlerts': priceAlerts,
      'stockAlerts': stockAlerts,
      'syncAlerts': syncAlerts,
      'errorAlerts': errorAlerts,
    };

    return await _apiService.put<Map<String, dynamic>>(
      '/configurations/notifications',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Envia notificação de teste
  /// POST /api/configurations/notifications/test
  Future<ApiResponse<Map<String, dynamic>>> sendTestNotification() async {
    return await _apiService.post<Map<String, dynamic>>(
      '/configurations/notifications/test',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // ============================================================================
  // CONFIGURAÇÕES DE BACKUP
  // ============================================================================

  /// Lista backups disponíveis
  /// GET /api/configurations/backups
  Future<ApiResponse<List<Map<String, dynamic>>>> getBackups() async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '/configurations/backups',
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  /// Cria novo backup
  /// POST /api/configurations/backups
  Future<ApiResponse<Map<String, dynamic>>> createBackup({
    String description = 'Backup manual',
  }) async {
    final body = {
      'description': description,
      'timestamp': DateTime.now().toIso8601String(),
    };

    return await _apiService.post<Map<String, dynamic>>(
      '/configurations/backups',
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Restaura um backup
  /// POST /api/configurations/backups/:id/restore
  Future<ApiResponse<Map<String, dynamic>>> restoreBackup(String backupId) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/configurations/backups/$backupId/restore',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Exclui um backup
  /// DELETE /api/configurations/backups/:id
  Future<ApiResponse<void>> deleteBackup(String backupId) async {
    return await _apiService.delete('/configurations/backups/$backupId');
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}



