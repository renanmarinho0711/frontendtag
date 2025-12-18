import 'import_error.dart';
import 'import_preview.dart';

/// Resultado de validação de importação
class ImportValidation {
  final bool isValid;
  final int totalRecords;
  final int validRecords;
  final int invalidRecords;
  final List<ImportError> errors;
  final List<ImportWarning> warnings;
  final List<String> detectedColumns;
  final Map<String, String> suggestedMappings;
  final List<ImportPreviewRow> previewRows;

  const ImportValidation({
    required this.isValid,
    required this.totalRecords,
    required this.validRecords,
    required this.invalidRecords,
    required this.errors,
    required this.warnings,
    required this.detectedColumns,
    required this.suggestedMappings,
    required this.previewRows,
  });

  factory ImportValidation.fromJson(Map<String, dynamic> json) {
    return ImportValidation(
      isValid: json['isValid'] as bool ?? false,
      totalRecords: json['totalRecords'] as int ?? 0,
      validRecords: json['validRecords'] as int ?? 0,
      invalidRecords: json['invalidRecords'] as int ?? 0,
      errors: (json['errors'] as List?)
          ?.map((e) => ImportError.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      warnings: (json['warnings'] as List?)
          ?.map((w) => ImportWarning.fromJson(w as Map<String, dynamic>))
          .toList() ?? [],
      detectedColumns: (json['detectedColumns'] as List?)
          ?.map((c) => c.toString())
          .toList() ?? [],
      suggestedMappings: (json['suggestedMappings'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      previewRows: (json['previewRows'] as List?)
          ?.map((r) => ImportPreviewRow.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    'totalRecords': totalRecords,
    'validRecords': validRecords,
    'invalidRecords': invalidRecords,
    'errors': errors.map((e) => e.toJson()).toList(),
    'warnings': warnings.map((w) => w.toJson()).toList(),
    'detectedColumns': detectedColumns,
    'suggestedMappings': suggestedMappings,
    'previewRows': previewRows.map((r) => r.toJson()).toList(),
  };
}

/// Resultado de validação da API
class ValidationResultModel {
  final bool isValid;
  final int totalRecords;
  final int validRecords;
  final int invalidRecords;
  final List<ImportErrorModel> errors;
  final List<String> warnings;

  const ValidationResultModel({
    required this.isValid,
    required this.totalRecords,
    this.validRecords = 0,
    this.invalidRecords = 0,
    this.errors = const [],
    this.warnings = const [],
  });

  factory ValidationResultModel.fromJson(Map<String, dynamic> json) {
    return ValidationResultModel(
      isValid: json['isValid'] as bool ?? false,
      totalRecords: json['totalRecords'] as int ?? 0,
      validRecords: json['validRecords'] as int ?? 0,
      invalidRecords: json['invalidRecords'] as int ?? 0,
      errors: (json['errors'] as List?)
          ?.map((e) => ImportErrorModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      warnings: (json['warnings'] as List?)?.map((w) => w.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    'totalRecords': totalRecords,
    'validRecords': validRecords,
    'invalidRecords': invalidRecords,
    'errors': errors.map((e) => e.toJson()).toList(),
    'warnings': warnings,
  };
}
