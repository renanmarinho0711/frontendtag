import '../enums/import_status.dart';
import 'import_error.dart';

/// Modelo para histórico de importação
class ImportHistoryModel {
  final String id;
  final String fileName;
  final DateTime dateTime;
  final int totalRecords;
  final int successCount;
  final int errorCount;
  final int duplicateCount;
  final String duration;
  final ImportStatus status;
  final String? errorMessage;
  final List<ImportErrorDetail>? errors;

  const ImportHistoryModel({
    required this.id,
    required this.fileName,
    required this.dateTime,
    required this.totalRecords,
    required this.successCount,
    this.errorCount = 0,
    this.duplicateCount = 0,
    required this.duration,
    this.status = ImportStatus.completed,
    this.errorMessage,
    this.errors,
  });

  double get successRate => totalRecords > 0 ? (successCount / totalRecords) * 100 : 0;
  
  bool get hasErrors => errorCount > 0;
  
  bool get hasDuplicates => duplicateCount > 0;
  
  /// Data formatada para exibição
  String get formattedDate {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  ImportHistoryModel copyWith({
    String? id,
    String? fileName,
    DateTime? dateTime,
    int? totalRecords,
    int? successCount,
    int? errorCount,
    int? duplicateCount,
    String? duration,
    ImportStatus? status,
    String? errorMessage,
    List<ImportErrorDetail>? errors,
  }) {
    return ImportHistoryModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      dateTime: dateTime ?? this.dateTime,
      totalRecords: totalRecords ?? this.totalRecords,
      successCount: successCount ?? this.successCount,
      errorCount: errorCount ?? this.errorCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      errors: errors ?? this.errors,
    );
  }

  factory ImportHistoryModel.fromJson(Map<String, dynamic> json) {
    return ImportHistoryModel(
      id: ((json['id']) as String?) ?? '',
      fileName: (((json['fileName'] ?? json['nome']) as String?) ?? ''),
      dateTime: DateTime.tryParse(json['dateTime'] as String ?? json['data'] as String ?? '') ?? DateTime.now(),
      totalRecords: (((json['totalRecords'] ?? json['total']) as int?) ?? 0),
      successCount: (((json['successCount'] ?? json['sucesso']) as int?) ?? 0),
      errorCount: json['errorCount'] as int ?? json['erros'] as int ?? 0,
      duplicateCount: json['duplicateCount'] as int ?? json['duplicados'] as int ?? 0,
      duration: (((json['duration'] ?? json['duracao']) as String?) ?? ''),
      status: ImportStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ImportStatus.completed,
      ),
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'dateTime': dateTime.toIso8601String(),
      'totalRecords': totalRecords,
      'successCount': successCount,
      'errorCount': errorCount,
      'duplicateCount': duplicateCount,
      'duration': duration,
      'status': status.name,
      'errorMessage': errorMessage,
    };
  }
}

/// Histórico de importação da API (detalhado)
class ImportHistoryApiModel {
  final String id;
  final String operationType;
  final String dataType;
  final String format;
  final String status;
  final int totalRecords;
  final int successfulRecords;
  final int failedRecords;
  final String? fileName;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final String? userId;

  const ImportHistoryApiModel({
    required this.id,
    required this.operationType,
    required this.dataType,
    required this.format,
    required this.status,
    required this.totalRecords,
    this.successfulRecords = 0,
    this.failedRecords = 0,
    this.fileName,
    required this.startedAt,
    this.completedAt,
    this.errorMessage,
    this.userId,
  });

  factory ImportHistoryApiModel.fromJson(Map<String, dynamic> json) {
    return ImportHistoryApiModel(
      id: json['id'] as String ?? '',
      operationType: json['operationType'] as String ?? '',
      dataType: json['dataType'] as String ?? '',
      format: json['format'] as String ?? '',
      status: json['status'] as String ?? '',
      totalRecords: json['totalRecords'] as int ?? 0,
      successfulRecords: json['successfulRecords'] as int ?? 0,
      failedRecords: json['failedRecords'] as int ?? 0,
      fileName: json['fileName'],
      startedAt: DateTime.tryParse(json['startedAt'] as String ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null 
          ? DateTime.tryParse(json['completedAt'] as String) 
          : null,
      errorMessage: json['errorMessage'],
      userId: json['userId'],
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
    'startedAt': startedAt.toIso8601String(),
    if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    if (errorMessage != null) 'errorMessage': errorMessage,
    if (userId != null) 'userId': userId,
  };
}
