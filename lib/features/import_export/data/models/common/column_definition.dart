/// Definição de coluna
class ColumnDefinition {
  final String field;
  final String displayName;
  final String dataType;
  final bool isRequired;
  final String? defaultValue;
  final String? description;
  final String? validationPattern;
  final List<String>? allowedValues;

  const ColumnDefinition({
    required this.field,
    required this.displayName,
    required this.dataType,
    required this.isRequired,
    this.defaultValue,
    this.description,
    this.validationPattern,
    this.allowedValues,
  });

  factory ColumnDefinition.fromJson(Map<String, dynamic> json) {
    return ColumnDefinition(
      field: json['field'] ?? '',
      displayName: json['displayName'] ?? '',
      dataType: json['dataType'] ?? 'string',
      isRequired: json['isRequired'] ?? false,
      defaultValue: json['defaultValue'],
      description: json['description'],
      validationPattern: json['validationPattern'],
      allowedValues: (json['allowedValues'] as List?)
          ?.map((v) => v.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'field': field,
    'displayName': displayName,
    'dataType': dataType,
    'isRequired': isRequired,
    if (defaultValue != null) 'defaultValue': defaultValue,
    if (description != null) 'description': description,
    if (validationPattern != null) 'validationPattern': validationPattern,
    if (allowedValues != null) 'allowedValues': allowedValues,
  };
}

/// Definição de coluna da API
class ColumnDefinitionModel {
  final String field;
  final String displayName;
  final String dataType;
  final bool isRequired;
  final String? defaultValue;
  final String? validationPattern;

  const ColumnDefinitionModel({
    required this.field,
    required this.displayName,
    required this.dataType,
    required this.isRequired,
    this.defaultValue,
    this.validationPattern,
  });

  factory ColumnDefinitionModel.fromJson(Map<String, dynamic> json) {
    return ColumnDefinitionModel(
      field: json['field'] ?? '',
      displayName: json['displayName'] ?? '',
      dataType: json['dataType'] ?? 'string',
      isRequired: json['isRequired'] ?? false,
      defaultValue: json['defaultValue'],
      validationPattern: json['validationPattern'],
    );
  }

  Map<String, dynamic> toJson() => {
    'field': field,
    'displayName': displayName,
    'dataType': dataType,
    'isRequired': isRequired,
    if (defaultValue != null) 'defaultValue': defaultValue,
    if (validationPattern != null) 'validationPattern': validationPattern,
  };
}
