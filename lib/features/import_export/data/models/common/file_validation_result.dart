/// Resultado de validação de arquivo
class FileValidationResult {
  final bool isValid;
  final String? fileName;
  final int? rowCount;
  final int? columnCount;
  final List<String> detectedColumns;
  final List<String> missingColumns;
  final List<FileValidationError> errors;
  final List<FileValidationWarning> warnings;

  const FileValidationResult({
    required this.isValid,
    this.fileName,
    this.rowCount,
    this.columnCount,
    this.detectedColumns = const [],
    this.missingColumns = const [],
    this.errors = const [],
    this.warnings = const [],
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;

  factory FileValidationResult.fromJson(Map<String, dynamic> json) {
    return FileValidationResult(
      isValid: json['isValid'] ?? false,
      fileName: json['fileName'],
      rowCount: json['rowCount'],
      columnCount: json['columnCount'],
      detectedColumns: (json['detectedColumns'] as List?)
          ?.map((c) => c.toString())
          .toList() ?? [],
      missingColumns: (json['missingColumns'] as List?)
          ?.map((c) => c.toString())
          .toList() ?? [],
      errors: (json['errors'] as List?)
          ?.map((e) => FileValidationError.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      warnings: (json['warnings'] as List?)
          ?.map((w) => FileValidationWarning.fromJson(w as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    if (fileName != null) 'fileName': fileName,
    if (rowCount != null) 'rowCount': rowCount,
    if (columnCount != null) 'columnCount': columnCount,
    'detectedColumns': detectedColumns,
    'missingColumns': missingColumns,
    'errors': errors.map((e) => e.toJson()).toList(),
    'warnings': warnings.map((w) => w.toJson()).toList(),
  };
}

/// Erro de validação de arquivo
class FileValidationError {
  final int? lineNumber;
  final String message;
  final String? field;

  const FileValidationError({
    this.lineNumber,
    required this.message,
    this.field,
  });

  factory FileValidationError.fromJson(Map<String, dynamic> json) {
    return FileValidationError(
      lineNumber: json['lineNumber'],
      message: json['message'] ?? '',
      field: json['field'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (lineNumber != null) 'lineNumber': lineNumber,
    'message': message,
    if (field != null) 'field': field,
  };
}

/// Aviso de validação de arquivo
class FileValidationWarning {
  final int? lineNumber;
  final String message;
  final String? suggestion;

  const FileValidationWarning({
    this.lineNumber,
    required this.message,
    this.suggestion,
  });

  factory FileValidationWarning.fromJson(Map<String, dynamic> json) {
    return FileValidationWarning(
      lineNumber: json['lineNumber'],
      message: json['message'] ?? '',
      suggestion: json['suggestion'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (lineNumber != null) 'lineNumber': lineNumber,
    'message': message,
    if (suggestion != null) 'suggestion': suggestion,
  };
}
