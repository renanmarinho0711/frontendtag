import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';

/// Modelo de backup
class BackupModel {
  final String id;
  final String name;
  final int sizeBytes;
  final String sizeFormatted;
  final DateTime createdAt;
  final String type;
  final String status;
  final String storeId;
  final String? description;

  BackupModel({
    required this.id,
    required this.name,
    required this.sizeBytes,
    required this.sizeFormatted,
    required this.createdAt,
    required this.type,
    required this.status,
    required this.storeId,
    this.description,
  });

  factory BackupModel.fromJson(Map<String, dynamic> json) {
    return BackupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sizeBytes: json['sizeBytes'] ?? 0,
      sizeFormatted: json['sizeFormatted'] ?? '0 B',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      type: json['type'] ?? 'manual',
      status: json['status'] ?? 'completed',
      storeId: json['storeId'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sizeBytes': sizeBytes,
      'sizeFormatted': sizeFormatted,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
      'status': status,
      'storeId': storeId,
      'description': description,
    };
  }
}

/// Modelo de configuração de backup
class BackupConfigModel {
  final bool autoBackupEnabled;
  final String backupFrequency;
  final int backupHour;
  final int maxBackupsToKeep;
  final bool includeImages;
  final bool includeLogs;
  final bool notifyOnSuccess;
  final bool notifyOnFailure;
  final DateTime? lastBackupAt;
  final String? lastBackupStatus;

  BackupConfigModel({
    this.autoBackupEnabled = true,
    this.backupFrequency = 'daily',
    this.backupHour = 3,
    this.maxBackupsToKeep = 30,
    this.includeImages = true,
    this.includeLogs = false,
    this.notifyOnSuccess = false,
    this.notifyOnFailure = true,
    this.lastBackupAt,
    this.lastBackupStatus,
  });

  factory BackupConfigModel.fromJson(Map<String, dynamic> json) {
    return BackupConfigModel(
      autoBackupEnabled: json['autoBackupEnabled'] ?? true,
      backupFrequency: json['backupFrequency'] ?? 'daily',
      backupHour: json['backupHour'] ?? 3,
      maxBackupsToKeep: json['maxBackupsToKeep'] ?? 30,
      includeImages: json['includeImages'] ?? true,
      includeLogs: json['includeLogs'] ?? false,
      notifyOnSuccess: json['notifyOnSuccess'] ?? false,
      notifyOnFailure: json['notifyOnFailure'] ?? true,
      lastBackupAt: json['lastBackupAt'] != null 
          ? DateTime.parse(json['lastBackupAt']) 
          : null,
      lastBackupStatus: json['lastBackupStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoBackupEnabled': autoBackupEnabled,
      'backupFrequency': backupFrequency,
      'backupHour': backupHour,
      'maxBackupsToKeep': maxBackupsToKeep,
      'includeImages': includeImages,
      'includeLogs': includeLogs,
      'notifyOnSuccess': notifyOnSuccess,
      'notifyOnFailure': notifyOnFailure,
      if (lastBackupAt != null) 'lastBackupAt': lastBackupAt!.toIso8601String(),
      if (lastBackupStatus != null) 'lastBackupStatus': lastBackupStatus,
    };
  }

  BackupConfigModel copyWith({
    bool? autoBackupEnabled,
    String? backupFrequency,
    int? backupHour,
    int? maxBackupsToKeep,
    bool? includeImages,
    bool? includeLogs,
    bool? notifyOnSuccess,
    bool? notifyOnFailure,
  }) {
    return BackupConfigModel(
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      backupHour: backupHour ?? this.backupHour,
      maxBackupsToKeep: maxBackupsToKeep ?? this.maxBackupsToKeep,
      includeImages: includeImages ?? this.includeImages,
      includeLogs: includeLogs ?? this.includeLogs,
      notifyOnSuccess: notifyOnSuccess ?? this.notifyOnSuccess,
      notifyOnFailure: notifyOnFailure ?? this.notifyOnFailure,
      lastBackupAt: lastBackupAt,
      lastBackupStatus: lastBackupStatus,
    );
  }
}

/// Resposta da lista de backups
class BackupListResponse {
  final List<BackupModel> backups;
  final int total;
  final int totalSizeBytes;
  final String totalSizeFormatted;
  final BackupConfigModel config;

  BackupListResponse({
    required this.backups,
    required this.total,
    required this.totalSizeBytes,
    required this.totalSizeFormatted,
    required this.config,
  });

  factory BackupListResponse.fromJson(Map<String, dynamic> json) {
    return BackupListResponse(
      backups: (json['backups'] as List?)
          ?.map((e) => BackupModel.fromJson(e))
          .toList() ?? [],
      total: json['total'] ?? 0,
      totalSizeBytes: json['totalSizeBytes'] ?? 0,
      totalSizeFormatted: json['totalSizeFormatted'] ?? '0 B',
      config: BackupConfigModel.fromJson(json['config'] ?? {}),
    );
  }
}

/// Resposta de restauração
class RestoreBackupResponse {
  final bool success;
  final String message;
  final int recordsRestored;
  final DateTime restoredAt;

  RestoreBackupResponse({
    required this.success,
    required this.message,
    required this.recordsRestored,
    required this.restoredAt,
  });

  factory RestoreBackupResponse.fromJson(Map<String, dynamic> json) {
    return RestoreBackupResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      recordsRestored: json['recordsRestored'] ?? 0,
      restoredAt: json['restoredAt'] != null 
          ? DateTime.parse(json['restoredAt']) 
          : DateTime.now(),
    );
  }
}

/// Repository para gerenciamento de backups
/// Comunicação com BackupController do backend
class BackupRepository {
  final ApiService _apiService;

  BackupRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Lista todos os backups de uma loja
  /// GET /api/backup?storeId=xxx
  Future<ApiResponse<BackupListResponse>> getBackups({
    required String storeId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = {
      'storeId': storeId,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };

    return await _apiService.get<BackupListResponse>(
      '${ApiConstants.backup}?${_buildQueryString(queryParams)}',
      parser: (data) => BackupListResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Obtém um backup específico
  /// GET /api/backup/{id}?storeId=xxx
  Future<ApiResponse<BackupModel>> getBackupById({
    required String backupId,
    required String storeId,
  }) async {
    return await _apiService.get<BackupModel>(
      '${ApiConstants.backupById(backupId)}?storeId=$storeId',
      parser: (data) => BackupModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Cria um novo backup
  /// POST /api/backup?storeId=xxx
  Future<ApiResponse<BackupModel>> createBackup({
    required String storeId,
    String? name,
    String? description,
    String type = 'manual',
    bool includeImages = true,
    bool includeLogs = false,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    body['type'] = type;
    body['includeImages'] = includeImages;
    body['includeLogs'] = includeLogs;

    return await _apiService.post<BackupModel>(
      '${ApiConstants.backup}?storeId=$storeId',
      body: body,
      parser: (data) => BackupModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Restaura um backup
  /// POST /api/backup/{id}/restore?storeId=xxx
  Future<ApiResponse<RestoreBackupResponse>> restoreBackup({
    required String backupId,
    required String storeId,
  }) async {
    return await _apiService.post<RestoreBackupResponse>(
      '${ApiConstants.backupRestore(backupId)}?storeId=$storeId',
      parser: (data) => RestoreBackupResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Exclui um backup
  /// DELETE /api/backup/{id}?storeId=xxx
  Future<ApiResponse<void>> deleteBackup({
    required String backupId,
    required String storeId,
  }) async {
    return await _apiService.delete<void>(
      '${ApiConstants.backupById(backupId)}?storeId=$storeId',
    );
  }

  /// Obtém a URL de download de um backup
  String getBackupDownloadUrl({
    required String backupId,
    required String storeId,
  }) {
    return '${ApiConstants.baseUrl}${ApiConstants.backupDownload(backupId)}?storeId=$storeId';
  }

  /// Obtém a configuração de backup
  /// GET /api/backup/config?storeId=xxx
  Future<ApiResponse<BackupConfigModel>> getBackupConfig({
    required String storeId,
  }) async {
    return await _apiService.get<BackupConfigModel>(
      '${ApiConstants.backupConfig}?storeId=$storeId',
      parser: (data) => BackupConfigModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Atualiza a configuração de backup
  /// PUT /api/backup/config?storeId=xxx
  Future<ApiResponse<BackupConfigModel>> updateBackupConfig({
    required String storeId,
    bool? autoBackupEnabled,
    String? backupFrequency,
    int? backupHour,
    int? maxBackupsToKeep,
    bool? includeImages,
    bool? includeLogs,
    bool? notifyOnSuccess,
    bool? notifyOnFailure,
  }) async {
    final body = <String, dynamic>{};
    if (autoBackupEnabled != null) body['autoBackupEnabled'] = autoBackupEnabled;
    if (backupFrequency != null) body['backupFrequency'] = backupFrequency;
    if (backupHour != null) body['backupHour'] = backupHour;
    if (maxBackupsToKeep != null) body['maxBackupsToKeep'] = maxBackupsToKeep;
    if (includeImages != null) body['includeImages'] = includeImages;
    if (includeLogs != null) body['includeLogs'] = includeLogs;
    if (notifyOnSuccess != null) body['notifyOnSuccess'] = notifyOnSuccess;
    if (notifyOnFailure != null) body['notifyOnFailure'] = notifyOnFailure;

    return await _apiService.put<BackupConfigModel>(
      '${ApiConstants.backupConfig}?storeId=$storeId',
      body: body,
      parser: (data) => BackupConfigModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Executa limpeza de backups antigos
  /// POST /api/backup/cleanup?storeId=xxx
  Future<ApiResponse<Map<String, dynamic>>> cleanupOldBackups({
    required String storeId,
  }) async {
    return await _apiService.post<Map<String, dynamic>>(
      '${ApiConstants.backupCleanup}?storeId=$storeId',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  String _buildQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}



