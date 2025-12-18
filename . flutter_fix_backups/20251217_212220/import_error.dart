/// Detalhes de erro de importação
class ImportErrorDetail {
  final int lineNumber;
  final String field;
  final String value;
  final String errorMessage;
  final String? suggestion;

  const ImportErrorDetail({
    required this.lineNumber,
    required this.field,
    required this.value,
    required this.errorMessage,
    this.suggestion,
  });

  factory ImportErrorDetail.fromJson(Map<String, dynamic> json) {
    return ImportErrorDetail(
      lineNumber: json['lineNumber'] as int,
      field: json['field'] as String,
      value: json['value'] as String,
      errorMessage: json['errorMessage'] as String,
      suggestion: json['suggestion'],
    );
  }

  Map<String, dynamic> toJson() => {
    'lineNumber': lineNumber,
    'field': field,
    'value': value,
    'errorMessage': errorMessage,
    if (suggestion != null) 'suggestion': suggestion,
  };
}

/// Erro de importação
class ImportError {
  final int row;
  final String? column;
  final String field;
  final String value;
  final String errorCode;
  final String message;

  const ImportError({
    required this.row,
    this.column,
    required this.field,
    required this.value,
    required this.errorCode,
    required this.message,
  });

  factory ImportError.fromJson(Map<String, dynamic> json) {
    return ImportError(
      row: json['row'] ?? 0,
      column: json['column'],
      field: json['field'] ?? '',
      value: json['value'] ?? '',
      errorCode: json['errorCode'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'row': row,
    if (column != null) 'column': column,
    'field': field,
    'value': value,
    'errorCode': errorCode,
    'message': message,
  };
}

/// Aviso de importação
class ImportWarning {
  final int row;
  final String field;
  final String warningCode;
  final String message;

  const ImportWarning({
    required this.row,
    required this.field,
    required this.warningCode,
    required this.message,
  });

  factory ImportWarning.fromJson(Map<String, dynamic> json) {
    return ImportWarning(
      row: json['row'] ?? 0,
      field: json['field'] ?? '',
      warningCode: json['warningCode'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'row': row,
    'field': field,
    'warningCode': warningCode,
    'message': message,
  };
}

/// Erro de importação da API
class ImportErrorModel {
  final int rowNumber;
  final String? field;
  final String? value;
  final String message;

  const ImportErrorModel({
    required this.rowNumber,
    this.field,
    this.value,
    required this.message,
  });

  factory ImportErrorModel.fromJson(Map<String, dynamic> json) {
    return ImportErrorModel(
      rowNumber: json['rowNumber'] ?? 0,
      field: json['field'],
      value: json['value'],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'rowNumber': rowNumber,
    if (field != null) 'field': field,
    if (value != null) 'value': value,
    'message': message,
  };
}
