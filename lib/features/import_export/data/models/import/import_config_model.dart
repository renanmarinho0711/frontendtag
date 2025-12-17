import '../enums/export_format.dart';

/// Configuração de importação
class ImportConfigModel {
  final ExportFormat format;
  final bool skipFirstRow;
  final bool autoDetectColumns;
  final Map<String, String> columnMapping;
  final bool validateBeforeImport;
  final bool stopOnError;
  final int? maxErrors;

  const ImportConfigModel({
    this.format = ExportFormat.excel,
    this.skipFirstRow = true,
    this.autoDetectColumns = true,
    this.columnMapping = const {},
    this.validateBeforeImport = true,
    this.stopOnError = false,
    this.maxErrors = 100,
  });

  ImportConfigModel copyWith({
    ExportFormat? format,
    bool? skipFirstRow,
    bool? autoDetectColumns,
    Map<String, String>? columnMapping,
    bool? validateBeforeImport,
    bool? stopOnError,
    int? maxErrors,
  }) {
    return ImportConfigModel(
      format: format ?? this.format,
      skipFirstRow: skipFirstRow ?? this.skipFirstRow,
      autoDetectColumns: autoDetectColumns ?? this.autoDetectColumns,
      columnMapping: columnMapping ?? this.columnMapping,
      validateBeforeImport: validateBeforeImport ?? this.validateBeforeImport,
      stopOnError: stopOnError ?? this.stopOnError,
      maxErrors: maxErrors ?? this.maxErrors,
    );
  }

  Map<String, dynamic> toJson() => {
    'format': format.id,
    'skipFirstRow': skipFirstRow,
    'autoDetectColumns': autoDetectColumns,
    'columnMapping': columnMapping,
    'validateBeforeImport': validateBeforeImport,
    'stopOnError': stopOnError,
    if (maxErrors != null) 'maxErrors': maxErrors,
  };

  factory ImportConfigModel.fromJson(Map<String, dynamic> json) {
    return ImportConfigModel(
      format: ExportFormat.values.firstWhere(
        (f) => f.id == json['format'],
        orElse: () => ExportFormat.excel,
      ),
      skipFirstRow: json['skipFirstRow'] ?? true,
      autoDetectColumns: json['autoDetectColumns'] ?? true,
      columnMapping: (json['columnMapping'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      validateBeforeImport: json['validateBeforeImport'] ?? true,
      stopOnError: json['stopOnError'] ?? false,
      maxErrors: json['maxErrors'],
    );
  }
}
