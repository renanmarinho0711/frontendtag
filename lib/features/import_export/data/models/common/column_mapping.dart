/// Mapeamento de coluna da API
class ColumnMappingModel {
  final String sourceColumn;
  final String targetField;
  final double confidence;

  const ColumnMappingModel({
    required this.sourceColumn,
    required this.targetField,
    this.confidence = 1.0,
  });

  factory ColumnMappingModel.fromJson(Map<String, dynamic> json) {
    return ColumnMappingModel(
      sourceColumn: (((json['sourceColumn'] ?? '') as String?) ?? ''),
      targetField: (((json['targetField'] ?? '') as String?) ?? ''),
      confidence: ((json['confidence'] ?? 1.0) as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'sourceColumn': sourceColumn,
    'targetField': targetField,
    'confidence': confidence,
  };
}

/// Sugestão de mapeamento de colunas
class ColumnMappingSuggestion {
  final String sourceColumn;
  final String? suggestedField;
  final double confidence;
  final List<String> alternativeFields;

  const ColumnMappingSuggestion({
    required this.sourceColumn,
    this.suggestedField,
    required this.confidence,
    required this.alternativeFields,
  });

  factory ColumnMappingSuggestion.fromJson(Map<String, dynamic> json) {
    return ColumnMappingSuggestion(
      sourceColumn: (((json['sourceColumn'] ?? '') as String?) ?? ''),
      suggestedField: (json['suggestedField'] as String?),
      confidence: ((json['confidence'] ?? 0) as num?)?.toDouble() ?? 0.0,
      alternativeFields: (json['alternativeFields'] as List?)
          ?.map((f) => f.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'sourceColumn': sourceColumn,
    if (suggestedField != null) 'suggestedField': suggestedField,
    'confidence': confidence,
    'alternativeFields': alternativeFields,
  };
}
