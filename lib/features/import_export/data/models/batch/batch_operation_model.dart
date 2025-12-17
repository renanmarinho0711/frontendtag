import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import '../enums/operation_type.dart';

/// Modelo para operação em lote
class BatchOperationModel {
  final String id;
  final OperationType type;
  final String title;
  final String subtitle;
  final String description;
  final String detailedDescription;
  final List<Color> gradientColors;
  final bool hasTemplate;
  final List<String> requiredColumns;
  final String example;
  final String? templateUrl;

  const BatchOperationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.detailedDescription,
    required this.gradientColors,
    this.hasTemplate = true,
    required this.requiredColumns,
    required this.example,
    this.templateUrl,
  });

  /// Getter para ícone - usa o ícone do tipo de operação
  IconData get icon => type.icon;
  
  /// Alias para requiredColumns
  List<String> get columns => requiredColumns;

  /// Construtor simplificado para criação rápida de operações
  factory BatchOperationModel.simple({
    required String id,
    required String name,
    required String description,
    required String type,
  }) {
    final opType = OperationType.values.firstWhere(
      (t) => t.id == type,
      orElse: () => OperationType.updatePrices,
    );
    return BatchOperationModel(
      id: id,
      type: opType,
      title: name,
      subtitle: description,
      description: description,
      detailedDescription: description,
      gradientColors: const [AppThemeColors.primary, AppThemeColors.blueCyan],
      requiredColumns: const [],
      example: '',
    );
  }

  factory BatchOperationModel.fromJson(Map<String, dynamic> json) {
    return BatchOperationModel(
      id: (((json['id'] ?? '') as String?) ?? ''),
      type: OperationType.values.firstWhere(
        (t) => t.id == (json['type'] as String?),
        orElse: () => OperationType.updatePrices,
      ),
      title: (((json['titulo'] ?? json['title']) as String?) ?? ''),
      subtitle: (((json['subtitulo'] ?? json['subtitle']) as String?) ?? ''),
      description: (((json['descricao'] ?? json['description']) as String?) ?? ''),
      detailedDescription: (((json['descricaoDetalhada'] ?? json['detailedDescription']) as String?) ?? ''),
      gradientColors: (json['gradiente'] as List?)?.cast<Color>() ?? [],
      hasTemplate: (((json['template'] ?? true) as bool?) ?? true),
      requiredColumns: (json['colunas'] as List?)?.cast<String>() ?? [],
      example: (((json['exemplo'] ?? json['example']) as String?) ?? ''),
      templateUrl: (json['templateUrl'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.id,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'detailedDescription': detailedDescription,
    'hasTemplate': hasTemplate,
    'requiredColumns': requiredColumns,
    'example': example,
    if (templateUrl != null) 'templateUrl': templateUrl,
  };
}

/// Resultado de operação em lote da API
class BulkOperationResultModel {
  final bool success;
  final String operation;
  final int totalRequested;
  final int totalProcessed;
  final int succeeded;
  final int failed;
  final List<String> failedIds;
  final List<String> errors;

  const BulkOperationResultModel({
    required this.success,
    required this.operation,
    required this.totalRequested,
    this.totalProcessed = 0,
    this.succeeded = 0,
    this.failed = 0,
    this.failedIds = const [],
    this.errors = const [],
  });

  factory BulkOperationResultModel.fromJson(Map<String, dynamic> json) {
    return BulkOperationResultModel(
      success: (((json['success'] ?? false) as bool?) ?? false),
      operation: (((json['operation'] ?? '') as String?) ?? ''),
      totalRequested: (((json['totalRequested'] ?? 0) as int?) ?? 0),
      totalProcessed: (((json['totalProcessed'] ?? 0) as int?) ?? 0),
      succeeded: (((json['succeeded'] ?? 0) as int?) ?? 0),
      failed: (((json['failed'] ?? 0) as int?) ?? 0),
      failedIds: (json['failedIds'] as List?)?.map((id) => id.toString()).toList() ?? [],
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'operation': operation,
    'totalRequested': totalRequested,
    'totalProcessed': totalProcessed,
    'succeeded': succeeded,
    'failed': failed,
    'failedIds': failedIds,
    'errors': errors,
  };
}
