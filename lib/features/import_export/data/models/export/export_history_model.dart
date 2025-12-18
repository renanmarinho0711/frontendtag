import '../enums/export_format.dart';

/// Histórico de exportação
class ExportHistoryModel {
  final String id;
  final String fileName;
  final ExportFormat format;
  final DateTime dateTime;
  final int recordCount;
  final String fileSize;
  final String? downloadUrl;
  final bool isAvailable;

  const ExportHistoryModel({
    required this.id,
    required this.fileName,
    required this.format,
    required this.dateTime,
    required this.recordCount,
    required this.fileSize,
    this.downloadUrl,
    this.isAvailable = true,
  });

  /// Data formatada para exibição
  String get formattedDate {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
  
  /// Total de registros (alias)
  int get totalRecords => recordCount;
  
  /// Contagem de sucesso (para compatibilidade)
  int get successCount => recordCount;
  
  /// Contagem de erros (para compatibilidade)
  int get errorCount => 0;
  
  /// Duração (estimativa baseada em registros)
  String get duration {
    // Estimativa: ~100 registros/segundo
    final seconds = (recordCount / 100).ceil();
    if (seconds < 60) return '${seconds}s';
    return '${(seconds / 60).ceil()}min';
  }

  factory ExportHistoryModel.fromJson(Map<String, dynamic> json) {
    return ExportHistoryModel(
      id: ((json['id']) as String?) ?? '',
      fileName: (((json['fileName'] ?? json['nome']) as String?) ?? ''),
      format: ExportFormat.values.firstWhere(
        (f) => f.id == json['format'],
        orElse: () => ExportFormat.excel,
      ),
      dateTime: DateTime.tryParse(((json['dateTime']).toString()).toString() ?? json['data'] ?? '') ?? DateTime.now(),
      // ignore: argument_type_not_assignable
      recordCount: json['recordCount'] ?? json['total'] as int,
      fileSize: ((json['fileSize']).toString()).toString() ?? json['tamanho'] ?? '0 KB',
      downloadUrl: (json['downloadUrl']).toString(),
      // ignore: argument_type_not_assignable
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fileName': fileName,
    'format': format.id,
    'dateTime': dateTime.toIso8601String(),
    'recordCount': recordCount,
    'fileSize': fileSize,
    if (downloadUrl != null) 'downloadUrl': downloadUrl,
    'isAvailable': isAvailable,
  };
}
