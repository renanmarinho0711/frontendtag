import 'package:flutter/material.dart';

/// Estatísticas do menu de importação
class ImportStatsModel {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
  final String changeType; // 'aumento', 'reducao', 'status'

  const ImportStatsModel({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
    required this.changeType,
  });

  bool get isPositiveChange => changeType == 'aumento';
  bool get isNegativeChange => changeType == 'reducao';
  bool get isStatusChange => changeType == 'status';

  factory ImportStatsModel.fromJson(Map<String, dynamic> json) {
    return ImportStatsModel(
      label: (json['label'] as String?) ?? '',
      value: (json['valor'] as String?) ?? '',
      icon: (json['icon'] as IconData?) ?? Icons.info,
      color: (json['cor'] as Color?) ?? const Color(0xFF2196F3),
      change: (json['mudanca'] as String?) ?? '',
      changeType: (json['tipo'] as String?) ?? '',
    );
  }
}

/// Histórico de importação/exportação
class ImportExportHistory {
  final String id;
  final String operationType;
  final String dataType;
  final String format;
  final String status;
  final int totalRecords;
  final int successfulRecords;
  final int failedRecords;
  final String? fileName;
  final int? fileSizeBytes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? durationMs;
  final String? userId;
  final String? userName;
  final String? errorMessage;

  const ImportExportHistory({
    required this.id,
    required this.operationType,
    required this.dataType,
    required this.format,
    required this.status,
    required this.totalRecords,
    required this.successfulRecords,
    required this.failedRecords,
    this.fileName,
    this.fileSizeBytes,
    required this.startedAt,
    this.completedAt,
    this.durationMs,
    this.userId,
    this.userName,
    this.errorMessage,
  });

  factory ImportExportHistory.fromJson(Map<String, dynamic> json) {
    return ImportExportHistory(
      id: (json['id']).toString() ?? '',
      operationType: (json['operationType']).toString() ?? '',
      dataType: (json['dataType']).toString() ?? '',
      format: (json['format']).toString() ?? '',
      status: (json['status']).toString() ?? '',
      // ignore: argument_type_not_assignable
      totalRecords: json['totalRecords'] ?? 0,
      // ignore: argument_type_not_assignable
      successfulRecords: json['successfulRecords'] ?? 0,
      // ignore: argument_type_not_assignable
      failedRecords: json['failedRecords'] ?? 0,
      fileName: (json['fileName']).toString(),
      // ignore: argument_type_not_assignable
      fileSizeBytes: json['fileSizeBytes'],
      startedAt: DateTime.tryParse((json['startedAt']).toString() ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null 
          ? DateTime.tryParse((json['completedAt']).toString()) 
          : null,
      // ignore: argument_type_not_assignable
      durationMs: json['durationMs'],
      userId: (json['userId']).toString(),
      userName: (json['userName']).toString(),
      errorMessage: (json['errorMessage']).toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'operationType': operationType,
    'dataType': dataType,
    'format': format,
    'status': status,
    'totalRecords': totalRecords,
    'successfulRecords': successfulRecords,
    'failedRecords': failedRecords,
    if (fileName != null) 'fileName': fileName,
    if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
    'startedAt': startedAt.toIso8601String(),
    if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    if (durationMs != null) 'durationMs': durationMs,
    if (userId != null) 'userId': userId,
    if (userName != null) 'userName': userName,
    if (errorMessage != null) 'errorMessage': errorMessage,
  };
}

/// Estatísticas de importação/exportação
class ImportExportStats {
  final int totalImports;
  final int totalExports;
  final int successfulOperations;
  final int failedOperations;
  final int totalRecordsImported;
  final int totalRecordsExported;
  final Map<String, int> byDataType;
  final Map<String, int> byFormat;
  final List<ImportExportHistory> recentOperations;

  const ImportExportStats({
    required this.totalImports,
    required this.totalExports,
    required this.successfulOperations,
    required this.failedOperations,
    required this.totalRecordsImported,
    required this.totalRecordsExported,
    required this.byDataType,
    required this.byFormat,
    required this.recentOperations,
  });

  factory ImportExportStats.fromJson(Map<String, dynamic> json) {
    return ImportExportStats(
      totalImports: (((json['totalImports'] ?? 0) as int?) ?? 0),
      totalExports: (((json['totalExports'] ?? 0) as int?) ?? 0),
      successfulOperations: (((json['successfulOperations'] ?? 0) as int?) ?? 0),
      failedOperations: (((json['failedOperations'] ?? 0) as int?) ?? 0),
      totalRecordsImported: (((json['totalRecordsImported'] ?? 0) as int?) ?? 0),
      totalRecordsExported: (((json['totalRecordsExported'] ?? 0) as int?) ?? 0),
      byDataType: (json['byDataType'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, (v as int?) ?? 0)) ?? {},
      byFormat: (json['byFormat'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, (v as int?) ?? 0)) ?? {},
      recentOperations: (json['recentOperations'] as List?)
          ?.map((o) => ImportExportHistory.fromJson(o as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalImports': totalImports,
    'totalExports': totalExports,
    'successfulOperations': successfulOperations,
    'failedOperations': failedOperations,
    'totalRecordsImported': totalRecordsImported,
    'totalRecordsExported': totalRecordsExported,
    'byDataType': byDataType,
    'byFormat': byFormat,
    'recentOperations': recentOperations.map((o) => o.toJson()).toList(),
  };
}

/// Estatísticas de importação/exportação (modelo da API)
class ImportExportStatisticsModel {
  final int totalImports;
  final int totalExports;
  final int successfulImports;
  final int failedImports;
  final int totalRecordsImported;
  final int totalRecordsExported;
  final DateTime? lastImportAt;
  final DateTime? lastExportAt;
  final int pendingJobs;

  const ImportExportStatisticsModel({
    this.totalImports = 0,
    this.totalExports = 0,
    this.successfulImports = 0,
    this.failedImports = 0,
    this.totalRecordsImported = 0,
    this.totalRecordsExported = 0,
    this.lastImportAt,
    this.lastExportAt,
    this.pendingJobs = 0,
  });

  factory ImportExportStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ImportExportStatisticsModel(
      // ignore: argument_type_not_assignable
      totalImports: json['totalImports'] ?? json['total_imports'] ?? 0,
      // ignore: argument_type_not_assignable
      totalExports: json['totalExports'] ?? json['total_exports'] ?? 0,
      // ignore: argument_type_not_assignable
      successfulImports: json['successfulImports'] ?? json['successful_imports'] ?? 0,
      // ignore: argument_type_not_assignable
      failedImports: json['failedImports'] ?? json['failed_imports'] ?? 0,
      // ignore: argument_type_not_assignable
      totalRecordsImported: json['totalRecordsImported'] ?? json['total_records_imported'] ?? 0,
      // ignore: argument_type_not_assignable
      totalRecordsExported: json['totalRecordsExported'] ?? json['total_records_exported'] ?? 0,
      lastImportAt: json['lastImportAt'] != null || json['last_import_at'] != null
          ? DateTime.tryParse((((json['lastImportAt']).toString()).toString()).toString() ?? json['last_import_at'] ?? '')
          : null,
      lastExportAt: json['lastExportAt'] != null || json['last_export_at'] != null
          ? DateTime.tryParse((((json['lastExportAt']).toString()).toString()).toString() ?? json['last_export_at'] ?? '')
          : null,
      // ignore: argument_type_not_assignable
      pendingJobs: json['pendingJobs'] ?? json['pending_jobs'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalImports': totalImports,
    'totalExports': totalExports,
    'successfulImports': successfulImports,
    'failedImports': failedImports,
    'totalRecordsImported': totalRecordsImported,
    'totalRecordsExported': totalRecordsExported,
    'lastImportAt': lastImportAt?.toIso8601String(),
    'lastExportAt': lastExportAt?.toIso8601String(),
    'pendingJobs': pendingJobs,
  };
}
