/// Resultado de exportação
class ExportResultModel {
  final bool success;
  final String? downloadUrl;
  final String? fileName;
  final int recordCount;
  final String? errorMessage;
  final DateTime generatedAt;
  final String? jobId;

  const ExportResultModel({
    required this.success,
    this.downloadUrl,
    this.fileName,
    this.recordCount = 0,
    this.errorMessage,
    required this.generatedAt,
    this.jobId,
  });

  factory ExportResultModel.fromJson(Map<String, dynamic> json) {
    return ExportResultModel(
      success: json['success'] as bool? ?? false,
      downloadUrl: json['downloadUrl'] as String?,
      fileName: json['fileName'] as String?,
      recordCount: json['recordCount'] as int? ?? 0,
      errorMessage: json['errorMessage'] as String?,
      generatedAt: DateTime.tryParse(json['generatedAt'] ?? '') ?? DateTime.now(),
      jobId: json['jobId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'downloadUrl': downloadUrl,
      'fileName': fileName,
      'recordCount': recordCount,
      'errorMessage': errorMessage,
      'generatedAt': generatedAt.toIso8601String(),
      'jobId': jobId,
    };
  }
}

/// Resultado de exportação
class ExportResult {
  final String exportId;
  final String type;
  final String format;
  final String status;
  final int totalRecords;
  final int processedRecords;
  final double progressPercent;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? durationMs;
  final String? downloadUrl;
  final String? fileName;
  final int? fileSizeBytes;
  final DateTime? expiresAt;

  const ExportResult({
    required this.exportId,
    required this.type,
    required this.format,
    required this.status,
    required this.totalRecords,
    required this.processedRecords,
    required this.progressPercent,
    required this.startedAt,
    this.completedAt,
    this.durationMs,
    this.downloadUrl,
    this.fileName,
    this.fileSizeBytes,
    this.expiresAt,
  });

  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isProcessing => status == 'processing';

  factory ExportResult.fromJson(Map<String, dynamic> json) {
    return ExportResult(
      exportId: json['exportId'] ?? '',
      type: json['type'] ?? '',
      format: json['format'] ?? '',
      status: json['status'] ?? '',
      totalRecords: json['totalRecords'] ?? 0,
      processedRecords: json['processedRecords'] ?? 0,
      progressPercent: (json['progressPercent'] ?? 0).toDouble(),
      startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null 
          ? DateTime.tryParse(json['completedAt']) 
          : null,
      durationMs: json['durationMs'],
      downloadUrl: json['downloadUrl'],
      fileName: json['fileName'],
      fileSizeBytes: json['fileSizeBytes'],
      expiresAt: json['expiresAt'] != null 
          ? DateTime.tryParse(json['expiresAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'exportId': exportId,
    'type': type,
    'format': format,
    'status': status,
    'totalRecords': totalRecords,
    'processedRecords': processedRecords,
    'progressPercent': progressPercent,
    'startedAt': startedAt.toIso8601String(),
    if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    if (durationMs != null) 'durationMs': durationMs,
    if (downloadUrl != null) 'downloadUrl': downloadUrl,
    if (fileName != null) 'fileName': fileName,
    if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
    if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
  };
}

/// Resultado de exportação da API (detalhado)
class ExportApiResultModel {
  final bool success;
  final String? jobId;
  final String? format;
  final int recordCount;
  final String? downloadUrl;
  final String? content;
  final String? contentType;

  const ExportApiResultModel({
    required this.success,
    this.jobId,
    this.format,
    this.recordCount = 0,
    this.downloadUrl,
    this.content,
    this.contentType,
  });

  factory ExportApiResultModel.fromJson(Map<String, dynamic> json) {
    return ExportApiResultModel(
      success: json['success'] ?? false,
      jobId: json['jobId'],
      format: json['format'],
      recordCount: json['recordCount'] ?? 0,
      downloadUrl: json['downloadUrl'],
      content: json['content'],
      contentType: json['contentType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    if (jobId != null) 'jobId': jobId,
    if (format != null) 'format': format,
    'recordCount': recordCount,
    if (downloadUrl != null) 'downloadUrl': downloadUrl,
    if (content != null) 'content': content,
    if (contentType != null) 'contentType': contentType,
  };
}
