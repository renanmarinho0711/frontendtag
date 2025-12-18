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

 // ignore: argument_type_not_assignable

 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  BackupModel({
 // ignore: argument_type_not_assignable

    required this.id,
 // ignore: argument_type_not_assignable

    required this.name,
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    required this.sizeBytes,
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    required this.sizeFormatted,

    required this.createdAt,

    required this.type,

    required this.status,

    required this.storeId,

    this.description,

  });



  factory BackupModel.fromJson(Map<String, dynamic> json) {

    return BackupModel(

      id: (json['id']).toString() ?? '',

      name: (json['name']).toString() ?? '',

      // ignore: argument_type_not_assignable
      sizeBytes: json['sizeBytes'] ?? 0,

      sizeFormatted: (json['sizeFormatted']).toString() ?? '0 B',

      createdAt: json['createdAt'] != null 

          ? DateTime.parse((json['createdAt']).toString()) 

          : DateTime.now(),

      type: (json['type']).toString() ?? 'manual',

      status: (json['status']).toString() ?? 'completed',

      storeId: (json['storeId']).toString() ?? '',

      description: (json['description']).toString(),

    );

  }


 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  Map<String, dynamic> toJson() {
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    return {
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      'id': id,
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      'name': name,

      // ignore: argument_type_not_assignable
      'sizeBytes': sizeBytes,

      // ignore: argument_type_not_assignable
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
 // ignore: argument_type_not_assignable

    this.lastBackupAt,
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    this.lastBackupStatus,
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  });



  factory BackupConfigModel.fromJson(Map<String, dynamic> json) {

    return BackupConfigModel(

      // ignore: argument_type_not_assignable
      autoBackupEnabled: json['autoBackupEnabled'] ?? true,

      backupFrequency: (json['backupFrequency']).toString() ?? 'daily',

      // ignore: argument_type_not_assignable
      backupHour: json['backupHour'] ?? 3,

      // ignore: argument_type_not_assignable
      maxBackupsToKeep: json['maxBackupsToKeep'] ?? 30,

      // ignore: argument_type_not_assignable
      includeImages: json['includeImages'] ?? true,

      // ignore: argument_type_not_assignable
      includeLogs: json['includeLogs'] ?? false,

      // ignore: argument_type_not_assignable
      notifyOnSuccess: json['notifyOnSuccess'] ?? false,

      notifyOnFailure: (json['notifyOnFailure'] as bool?) ?? true,

      lastBackupAt: json['lastBackupAt'] != null

          ? DateTime.parse((json['lastBackupAt']).toString()) 

          : null,

      lastBackupStatus: (json['lastBackupStatus']).toString(),

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

          // ignore: argument_type_not_assignable
          ?.map((e) => BackupModel.fromJson(e))

          .toList() ?? [],

      // ignore: argument_type_not_assignable
      total: json['total'] ?? 0,

      // ignore: argument_type_not_assignable
      totalSizeBytes: json['totalSizeBytes'] ?? 0,

      totalSizeFormatted: (json['totalSizeFormatted']).toString() ?? '0 B',

      // ignore: argument_type_not_assignable
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

      // ignore: argument_type_not_assignable
      success: json['success'] ?? false,

      message: (json['message']).toString() ?? '',

      // ignore: argument_type_not_assignable
      recordsRestored: json['recordsRestored'] ?? 0,

      restoredAt: json['restoredAt'] != null 

          ? DateTime.parse((json['restoredAt']).toString()) 

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







