import 'import_error.dart';

/// Resultado de importação
class ImportResult {
  final String importId;
  final String type;
  final String status;
  final int totalRecords;
  final int processedRecords;
  final int successfulRecords;
  final int failedRecords;
  final int skippedRecords;
  final int newRecords;
  final int updatedRecords;
  final double progressPercent;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? durationMs;
  final List<ImportError> errors;
  final List<ImportWarning> warnings;

  const ImportResult({
    required this.importId,
    required this.type,
    required this.status,
    required this.totalRecords,
    required this.processedRecords,
    required this.successfulRecords,
    required this.failedRecords,
    required this.skippedRecords,
    required this.newRecords,
    required this.updatedRecords,
    required this.progressPercent,
    required this.startedAt,
    this.completedAt,
    this.durationMs,
    required this.errors,
    required this.warnings,
  });

  bool get isCompleted => status == 'completed' || status == 'completed_with_errors';
  bool get isFailed => status == 'failed';
  bool get isProcessing => status == 'processing';

  factory ImportResult.fromJson(Map<String, dynamic> json) {
    return ImportResult(
      importId: json['importId'] as String ?? '',
      type: json['type'] as String ?? '',
      status: json['status'] as String ?? '',
      totalRecords: json['totalRecords'] as int ?? 0,
      processedRecords: json['processedRecords'] as int ?? 0,
      successfulRecords: json['successfulRecords'] as int ?? 0,
      failedRecords: json['failedRecords'] as int ?? 0,
      skippedRecords: json['skippedRecords'] as int ?? 0,
      newRecords: json['newRecords'] as int ?? 0,
      updatedRecords: json['updatedRecords'] as int ?? 0,
      progressPercent: ((json['progressPercent'] ?? 0) as num?)?.toDouble() ?? 0.0,
      startedAt: DateTime.tryParse(json['startedAt'] as String ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null 
          ? DateTime.tryParse(json['completedAt'] as String) 
          : null,
      durationMs: json['durationMs'],
      errors: (json['errors'] as List?)
          ?.map((e) => ImportError.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      warnings: (json['warnings'] as List?)
          ?.map((w) => ImportWarning.fromJson(w as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'importId': importId,
    'type': type,
    'status': status,
    'totalRecords': totalRecords,
    'processedRecords': processedRecords,
    'successfulRecords': successfulRecords,
    'failedRecords': failedRecords,
    'skippedRecords': skippedRecords,
    'newRecords': newRecords,
    'updatedRecords': updatedRecords,
    'progressPercent': progressPercent,
    'startedAt': startedAt.toIso8601String(),
    if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    if (durationMs != null) 'durationMs': durationMs,
    'errors': errors.map((e) => e.toJson()).toList(),
    'warnings': warnings.map((w) => w.toJson()).toList(),
  };
}

/// Resultado de importação da API
class ImportResultModel {
  final bool success;
  final int totalProcessed;
  final int inserted;
  final int updated;
  final int failed;
  final List<ImportErrorModel> errors;
  final String? jobId;

  const ImportResultModel({
    required this.success,
    required this.totalProcessed,
    this.inserted = 0,
    this.updated = 0,
    this.failed = 0,
    this.errors = const [],
    this.jobId,
  });

  factory ImportResultModel.fromJson(Map<String, dynamic> json) {
    return ImportResultModel(
      success: json['success'] as bool ?? false,
      totalProcessed: json['totalProcessed'] as int ?? 0,
      inserted: json['inserted'] as int ?? 0,
      updated: json['updated'] as int ?? 0,
      failed: json['failed'] as int ?? 0,
      errors: (json['errors'] as List?)
          ?.map((e) => ImportErrorModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      jobId: json['jobId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'totalProcessed': totalProcessed,
    'inserted': inserted,
    'updated': updated,
    'failed': failed,
    'errors': errors.map((e) => e.toJson()).toList(),
    if (jobId != null) 'jobId': jobId,
  };
}
