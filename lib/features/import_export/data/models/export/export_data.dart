/// Dados exportados (inline)
class ExportData {
  final String exportId;
  final String type;
  final String format;
  final int totalRecords;
  final String? fileName;
  final String? contentType;
  final String? base64Data;

  const ExportData({
    required this.exportId,
    required this.type,
    required this.format,
    required this.totalRecords,
    this.fileName,
    this.contentType,
    this.base64Data,
  });

  factory ExportData.fromJson(Map<String, dynamic> json) {
    return ExportData(
      exportId: (json['exportId']).toString() ?? '',
      type: (json['type']).toString() ?? '',
      format: (json['format']).toString() ?? '',
      // ignore: argument_type_not_assignable
      totalRecords: json['totalRecords'] ?? 0,
      fileName: (json['fileName']).toString(),
      contentType: (json['contentType']).toString(),
      base64Data: (json['base64Data']).toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'exportId': exportId,
    'type': type,
    'format': format,
    'totalRecords': totalRecords,
    if (fileName != null) 'fileName': fileName,
    if (contentType != null) 'contentType': contentType,
    if (base64Data != null) 'base64Data': base64Data,
  };
}
