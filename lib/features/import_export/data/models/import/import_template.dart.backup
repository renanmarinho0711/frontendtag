import '../common/column_definition.dart';

/// Template de importação da API
class ImportTemplateModel {
  final String id;
  final String name;
  final String dataType;
  final List<ColumnDefinitionModel> columns;
  final String? sampleData;

  const ImportTemplateModel({
    required this.id,
    required this.name,
    required this.dataType,
    required this.columns,
    this.sampleData,
  });

  factory ImportTemplateModel.fromJson(Map<String, dynamic> json) {
    return ImportTemplateModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dataType: json['dataType'] ?? '',
      columns: (json['columns'] as List?)
          ?.map((c) => ColumnDefinitionModel.fromJson(c as Map<String, dynamic>))
          .toList() ?? [],
      sampleData: json['sampleData'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dataType': dataType,
    'columns': columns.map((c) => c.toJson()).toList(),
    if (sampleData != null) 'sampleData': sampleData,
  };
}

/// Template de importação/exportação
class ImportExportTemplate {
  final String id;
  final String name;
  final String type;
  final String dataType;
  final String format;
  final Map<String, String>? columnMappings;
  final List<String>? columns;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const ImportExportTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.dataType,
    required this.format,
    this.columnMappings,
    this.columns,
    required this.isDefault,
    required this.createdAt,
    this.lastUsedAt,
  });

  factory ImportExportTemplate.fromJson(Map<String, dynamic> json) {
    return ImportExportTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      dataType: json['dataType'] ?? '',
      format: json['format'] ?? '',
      columnMappings: (json['columnMappings'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())),
      columns: (json['columns'] as List?)
          ?.map((c) => c.toString())
          .toList(),
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      lastUsedAt: json['lastUsedAt'] != null 
          ? DateTime.tryParse(json['lastUsedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'dataType': dataType,
    'format': format,
    if (columnMappings != null) 'columnMappings': columnMappings,
    if (columns != null) 'columns': columns,
    'isDefault': isDefault,
    'createdAt': createdAt.toIso8601String(),
    if (lastUsedAt != null) 'lastUsedAt': lastUsedAt!.toIso8601String(),
  };
}
