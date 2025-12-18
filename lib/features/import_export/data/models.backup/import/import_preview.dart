import '../common/column_mapping.dart';

/// Preview de linha de importação
class ImportPreviewRow {
  final int rowNumber;
  final Map<String, String> data;
  final bool isValid;
  final List<String> errors;

  const ImportPreviewRow({
    required this.rowNumber,
    required this.data,
    required this.isValid,
    required this.errors,
  });

  factory ImportPreviewRow.fromJson(Map<String, dynamic> json) {
    return ImportPreviewRow(
      // ignore: argument_type_not_assignable
      rowNumber: json['rowNumber'] ?? 0,
      data: (json['data'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      // ignore: argument_type_not_assignable
      isValid: json['isValid'] ?? true,
      errors: (json['errors'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'rowNumber': rowNumber,
    'data': data,
    'isValid': isValid,
    'errors': errors,
  };
}

/// Linha de preview da API
class PreviewRowModel {
  final Map<String, dynamic> data;
  final bool isValid;
  final List<String> errors;

  const PreviewRowModel({
    required this.data,
    this.isValid = true,
    this.errors = const [],
  });

  factory PreviewRowModel.fromJson(Map<String, dynamic> json) {
    return PreviewRowModel(
      data: json['data'] as Map<String, dynamic>? ?? {},
      // ignore: argument_type_not_assignable
      isValid: json['isValid'] ?? true,
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data,
    'isValid': isValid,
    'errors': errors,
  };
}

/// Preview de importação da API
class ImportPreviewModel {
  final List<String> columns;
  final List<PreviewRowModel> rows;
  final int totalRows;
  final bool hasErrors;
  final List<String> errors;
  final List<ColumnMappingModel> mappings;

  const ImportPreviewModel({
    required this.columns,
    required this.rows,
    required this.totalRows,
    this.hasErrors = false,
    this.errors = const [],
    this.mappings = const [],
  });

  factory ImportPreviewModel.fromJson(Map<String, dynamic> json) {
    return ImportPreviewModel(
      columns: (json['columns'] as List?)?.map((c) => c.toString()).toList() ?? [],
      rows: (json['rows'] as List?)
          ?.map((r) => PreviewRowModel.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
      // ignore: argument_type_not_assignable
      totalRows: json['totalRows'] ?? 0,
      // ignore: argument_type_not_assignable
      hasErrors: json['hasErrors'] ?? false,
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
      mappings: (json['mappings'] as List?)
          ?.map((m) => ColumnMappingModel.fromJson(m as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'columns': columns,
    'rows': rows.map((r) => r.toJson()).toList(),
    'totalRows': totalRows,
    'hasErrors': hasErrors,
    'errors': errors,
    'mappings': mappings.map((m) => m.toJson()).toList(),
  };
}
