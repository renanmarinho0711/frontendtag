/// Models robustos para o m�dulo Import/Export

/// Parte da migra��o para arquitetura Riverpod StateNotifierProvider

/// 

/// Estrutura:

/// - Enums: ExportFormat, ImportStatus, FilterStatus, OperationType

/// - Models: ImportHistory, ExportConfig, BatchOperation, ImportStats

/// - Estados: ImportExportState classes



library import_export_models;



import 'package:flutter/material.dart';

import 'package:tagbean/design_system/theme/theme_colors.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';



// =============================================================================

// ENUMS

// =============================================================================



/// Status de carregamento espec�fico para Import/Export

/// Usa 'loaded' em vez de 'success' pois representa dados carregados, n�o opera��o conclu�da

enum ImportExportLoadingStatus {

  initial,

  loading,

  loaded,

  error,

}



/// Formatos de exporta��o suportados

enum ExportFormat {

  excel('excel', 'Microsoft Excel', '.xlsx', Icons.table_chart_rounded),

  csv('csv', 'CSV', '.csv', Icons.article_rounded),

  json('json', 'JSON', '.json', Icons.code_rounded),

  pdf('pdf', 'PDF', '.pdf', Icons.picture_as_pdf_rounded);



  const ExportFormat(this.id, this.name, this.extension, this.icon);

  

  final String id;

  final String name;

  final String extension;

  final IconData icon;

}



/// Status de importação

enum ImportStatus {

  pending('Pendente', AppThemeColors.orangeMaterial),

  processing('Processando', AppThemeColors.primary),

  completed('Concluído', AppThemeColors.success),

  completedWithErrors('Concluído c/ Erros', AppThemeColors.amberMain),

  failed('Falhou', AppThemeColors.error),

  partial('Parcial', AppThemeColors.amberMain);



  const ImportStatus(this.label, this.color);

  

  final String label;

  final Color color;



  /// Obtém a cor dinâmica do status (requer BuildContext)

  Color dynamicColor(BuildContext context) {

    final colors = ThemeColors.of(context);

    switch (this) {

      case ImportStatus.pending:

        return colors.orangeMaterial;

      case ImportStatus.processing:

        return colors.primary;

      case ImportStatus.completed:

        return colors.success;

      case ImportStatus.completedWithErrors:

        return colors.amberMain;

      case ImportStatus.failed:

        return colors.error;

      case ImportStatus.partial:

        return colors.amberMain;

    }

  }

}



/// Filtro de status para tags

enum FilterStatus {

  all('todas', 'Todas'),

  associated('associadas', 'Associadas'),

  available('disponiveis', 'Dispon�veis'),

  offline('offline', 'Offline');



  const FilterStatus(this.id, this.label);

  

  final String id;

  final String label;

}



/// Tipos de opera��o em lote

enum OperationType {

  updatePrices('update_prices', 'Atualizar Pre�os em Lote', Icons.attach_money_rounded),

  deleteProducts('delete_products', 'Excluir Produtos em Lote', Icons.delete_sweep_rounded),

  associateTags('associate_tags', 'Associar Tags em Lote', Icons.link_rounded),

  updateCategories('update_categories', 'Atualizar Categorias', Icons.category_rounded),

  disassociateTags('disassociate_tags', 'Desassociar Tags em Lote', Icons.link_off_rounded),

  updateStock('update_stock', 'Atualizar Estoque em Lote', Icons.inventory_rounded);



  const OperationType(this.id, this.label, this.icon);

  

  final String id;

  final String label;

  final IconData icon;

}



// =============================================================================

// MODELS

// =============================================================================



/// Modelo para hist�rico de importa��o

class ImportHistoryModel {

  final String id;

  final String fileName;

  final DateTime dateTime;

  final int totalRecords;

  final int successCount;

  final int errorCount;

  final int duplicateCount;

  final String duration;

  final ImportStatus status;

  final String? errorMessage;

  final List<ImportErrorDetail>? errors;



  const ImportHistoryModel({

    required this.id,

    required this.fileName,

    required this.dateTime,

    required this.totalRecords,

    required this.successCount,

    this.errorCount = 0,

    this.duplicateCount = 0,

    required this.duration,

    this.status = ImportStatus.completed,

    this.errorMessage,

    this.errors,

  });



  double get successRate => totalRecords > 0 ? (successCount / totalRecords) * 100 : 0;

  

  bool get hasErrors => errorCount > 0;

  

  bool get hasDuplicates => duplicateCount > 0;

  

  /// Data formatada para exibi��o

  String get formattedDate {

    final day = dateTime.day.toString().padLeft(2, '0');

    final month = dateTime.month.toString().padLeft(2, '0');

    final year = dateTime.year;

    final hour = dateTime.hour.toString().padLeft(2, '0');

    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';

  }



  ImportHistoryModel copyWith({

    String? id,

    String? fileName,

    DateTime? dateTime,

    int? totalRecords,

    int? successCount,

    int? errorCount,

    int? duplicateCount,

    String? duration,

    ImportStatus? status,

    String? errorMessage,

    List<ImportErrorDetail>? errors,

  }) {

    return ImportHistoryModel(

      id: id ?? this.id,

      fileName: fileName ?? this.fileName,

      dateTime: dateTime ?? this.dateTime,

      totalRecords: totalRecords ?? this.totalRecords,

      successCount: successCount ?? this.successCount,

      errorCount: errorCount ?? this.errorCount,

      duplicateCount: duplicateCount ?? this.duplicateCount,

      duration: duration ?? this.duration,

      status: status ?? this.status,

      errorMessage: errorMessage ?? this.errorMessage,

      errors: errors ?? this.errors,

    );

  }



  factory ImportHistoryModel.fromJson(Map<String, dynamic> json) {

    return ImportHistoryModel(

      id: ((json['id']) as String?) ?? '',

      fileName: (((json['fileName'] ?? json['nome']) as String?) ?? ''),

      dateTime: DateTime.tryParse(json['dateTime'] ?? json['data'] ?? '') ?? DateTime.now(),

      totalRecords: (((json['totalRecords'] ?? json['total']) as int?) ?? 0),

      successCount: (((json['successCount'] ?? json['sucesso']) as int?) ?? 0),

      errorCount: json['errorCount'] ?? json['erros'] ?? 0,

      duplicateCount: json['duplicateCount'] ?? json['duplicados'] ?? 0,

      duration: (((json['duration'] ?? json['duracao']) as String?) ?? ''),

      status: ImportStatus.values.firstWhere(

        (s) => s.name == json['status'],

        orElse: () => ImportStatus.completed,

      ),

      errorMessage: json['errorMessage'],

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'fileName': fileName,

      'dateTime': dateTime.toIso8601String(),

      'totalRecords': totalRecords,

      'successCount': successCount,

      'errorCount': errorCount,

      'duplicateCount': duplicateCount,

      'duration': duration,

      'status': status.name,

      'errorMessage': errorMessage,

    };

  }

}



/// Detalhes de erro de importa��o

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

}



/// Configura��o de exporta��o

class ExportConfigModel {

  final ExportFormat format;

  final FilterStatus filterStatus;

  final bool includeLocation;

  final bool includeProducts;

  final bool includeMetrics;

  final bool includeHistory;

  final List<String> selectedColumns;

  final DateTimeRange? dateRange;

  final String? categoryId;

  final bool onlyActive;



  const ExportConfigModel({

    this.format = ExportFormat.excel,

    this.filterStatus = FilterStatus.all,

    this.includeLocation = true,

    this.includeProducts = true,

    this.includeMetrics = false,

    this.includeHistory = false,

    this.selectedColumns = const [],

    this.dateRange,

    this.categoryId,

    this.onlyActive = false,

  });



  int get totalColumns {

    int columns = 4; // Base columns

    if (includeLocation) columns += 2;

    if (includeProducts) columns += 3;

    if (includeMetrics) columns += 4;

    if (includeHistory) columns += 2;

    return columns;

  }



  ExportConfigModel copyWith({

    ExportFormat? format,

    FilterStatus? filterStatus,

    bool? includeLocation,

    bool? includeProducts,

    bool? includeMetrics,

    bool? includeHistory,

    List<String>? selectedColumns,

    DateTimeRange? dateRange,

    String? categoryId,

    bool? onlyActive,

  }) {

    return ExportConfigModel(

      format: format ?? this.format,

      filterStatus: filterStatus ?? this.filterStatus,

      includeLocation: includeLocation ?? this.includeLocation,

      includeProducts: includeProducts ?? this.includeProducts,

      includeMetrics: includeMetrics ?? this.includeMetrics,

      includeHistory: includeHistory ?? this.includeHistory,

      selectedColumns: selectedColumns ?? this.selectedColumns,

      dateRange: dateRange ?? this.dateRange,

      categoryId: categoryId ?? this.categoryId,

      onlyActive: onlyActive ?? this.onlyActive,

    );

  }

}



/// Modelo para opera��o em lote

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



  /// Getter para �cone - usa o �cone do tipo de opera��o

  IconData get icon => type.icon;

  

  /// Alias para requiredColumns

  List<String> get columns => requiredColumns;



  /// Construtor simplificado para cria��o r�pida de opera��es

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

      id: json['id'] ?? '',

      type: OperationType.values.firstWhere(

        (t) => t.id == json['type'],

        orElse: () => OperationType.updatePrices,

      ),

      title: json['titulo'] ?? json['title'] as String,

      subtitle: json['subtitulo'] ?? json['subtitle'] as String,

      description: json['descricao'] ?? json['description'] as String,

      detailedDescription: json['descricaoDetalhada'] ?? json['detailedDescription'] as String,

      gradientColors: (json['gradiente'] as List?)?.cast<Color>() ?? [],

      hasTemplate: json['template'] ?? true,

      requiredColumns: (json['colunas'] as List?)?.cast<String>() ?? [],

      example: json['exemplo'] ?? json['example'] as String,

      templateUrl: json['templateUrl'],

    );

  }

}



/// Estat�sticas do menu de importa��o

class ImportStatsModel {

  final String label;

  final String value;

  final IconData icon;

  final Color color;

  final String change;

  final String changeType; // 'aumento', 'reducao', 'status'



  const ImportStatsModel({

    required this.label,

    required this.value,

    required this.icon,

    required this.color,

    required this.change,

    required this.changeType,

  });



  bool get isPositiveChange => changeType == 'aumento';

  bool get isNegativeChange => changeType == 'reducao';

  bool get isStatusChange => changeType == 'status';



  factory ImportStatsModel.fromJson(Map<String, dynamic> json) {

    return ImportStatsModel(

      label: json['label'] as String,

      value: json['valor'] as String,

      icon: json['icon'] as IconData,

      color: json['cor'] as Color,

      change: json['mudanca'] as String,

      changeType: json['tipo'] as String,

    );

  }

}



/// Op��o de menu de importa��o/exporta��o

class ImportExportMenuOption {

  final String id;

  final String title;

  final String subtitle;

  final String description;

  final IconData icon;

  final List<Color> gradientColors;

  final String? badge;

  final String itemCount;

  final String lastAction;

  final Widget? targetScreen;



  const ImportExportMenuOption({

    required this.id,

    required this.title,

    required this.subtitle,

    required this.description,

    required this.icon,

    required this.gradientColors,

    this.badge,

    required this.itemCount,

    required this.lastAction,

    this.targetScreen,

  });

}



/// Progresso de upload/download

class TransferProgressModel {

  final double progress;

  final int bytesTransferred;

  final int totalBytes;

  final String? fileName;

  final TransferStatus status;

  final String? errorMessage;



  const TransferProgressModel({

    this.progress = 0.0,

    this.bytesTransferred = 0,

    this.totalBytes = 0,

    this.fileName,

    this.status = TransferStatus.idle,

    this.errorMessage,

  });



  double get progressPercentage => progress * 100;

  

  String get formattedProgress => '${progressPercentage.toStringAsFixed(1)}%';



  TransferProgressModel copyWith({

    double? progress,

    int? bytesTransferred,

    int? totalBytes,

    String? fileName,

    TransferStatus? status,

    String? errorMessage,

  }) {

    return TransferProgressModel(

      progress: progress ?? this.progress,

      bytesTransferred: bytesTransferred ?? this.bytesTransferred,

      totalBytes: totalBytes ?? this.totalBytes,

      fileName: fileName ?? this.fileName,

      status: status ?? this.status,

      errorMessage: errorMessage ?? this.errorMessage,

    );

  }

}



/// Status de transfer�ncia

enum TransferStatus {

  idle,

  preparing,

  uploading,

  downloading,

  processing,

  completed,

  failed,

  cancelled,

}



/// Resultado de valida��o de arquivo

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

}



/// Erro de valida��o de arquivo

class FileValidationError {

  final int? lineNumber;

  final String message;

  final String? field;



  const FileValidationError({

    this.lineNumber,

    required this.message,

    this.field,

  });

}



/// Aviso de valida��o de arquivo

class FileValidationWarning {

  final int? lineNumber;

  final String message;

  final String? suggestion;



  const FileValidationWarning({

    this.lineNumber,

    required this.message,

    this.suggestion,

  });

}



/// Resultado de exporta��o

class ExportResultModel {

  final bool success;

  final String? downloadUrl;

  final String? fileName;

  final int recordCount;

  final String? errorMessage;

  final DateTime generatedAt;

  final String? jobId;



  const ExportResultModel({

    required this.success,

    this.downloadUrl,

    this.fileName,

    this.recordCount = 0,

    this.errorMessage,

    required this.generatedAt,

    this.jobId,

  });



  factory ExportResultModel.fromJson(Map<String, dynamic> json) {

    return ExportResultModel(

      success: json['success'] as bool? ?? false,

      downloadUrl: json['downloadUrl'] as String?,

      fileName: json['fileName'] as String?,

      recordCount: json['recordCount'] as int? ?? 0,

      errorMessage: json['errorMessage'] as String?,

      generatedAt: DateTime.tryParse(json['generatedAt'] ?? '') ?? DateTime.now(),

      jobId: json['jobId'] as String?,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'success': success,

      'downloadUrl': downloadUrl,

      'fileName': fileName,

      'recordCount': recordCount,

      'errorMessage': errorMessage,

      'generatedAt': generatedAt.toIso8601String(),

      'jobId': jobId,

    };

  }

}



/// Hist�rico de exporta��o

class ExportHistoryModel {

  final String id;

  final String fileName;

  final ExportFormat format;

  final DateTime dateTime;

  final int recordCount;

  final String fileSize;

  final String? downloadUrl;

  final bool isAvailable;



  const ExportHistoryModel({

    required this.id,

    required this.fileName,

    required this.format,

    required this.dateTime,

    required this.recordCount,

    required this.fileSize,

    this.downloadUrl,

    this.isAvailable = true,

  });



  /// Data formatada para exibi��o

  String get formattedDate {

    final day = dateTime.day.toString().padLeft(2, '0');

    final month = dateTime.month.toString().padLeft(2, '0');

    final year = dateTime.year;

    final hour = dateTime.hour.toString().padLeft(2, '0');

    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';

  }

  

  /// Total de registros (alias)

  int get totalRecords => recordCount;

  

  /// Contagem de sucesso (para compatibilidade)

  int get successCount => recordCount;

  

  /// Contagem de erros (para compatibilidade)

  int get errorCount => 0;

  

  /// Dura��o (estimativa baseada em registros)

  String get duration {

    // Estimativa: ~100 registros/segundo

    final seconds = (recordCount / 100).ceil();

    if (seconds < 60) return '${seconds}s';

    return '${(seconds / 60).ceil()}min';

  }



  factory ExportHistoryModel.fromJson(Map<String, dynamic> json) {

    return ExportHistoryModel(

      id: ((json['id']) as String?) ?? '',

      fileName: (((json['fileName'] ?? json['nome']) as String?) ?? ''),

      format: ExportFormat.values.firstWhere(

        (f) => f.id == json['format'],

        orElse: () => ExportFormat.excel,

      ),

      dateTime: DateTime.tryParse(json['dateTime'] ?? json['data'] ?? '') ?? DateTime.now(),

      recordCount: json['recordCount'] ?? json['total'] as int,

      fileSize: json['fileSize'] ?? json['tamanho'] ?? '0 KB',

      downloadUrl: json['downloadUrl'],

      isAvailable: json['isAvailable'] ?? true,

    );

  }

}



/// Configura��o de importa��o

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

}



// =============================================================================

// API MODELS - Conectados ao ImportExportController

// =============================================================================



/// Resultado de valida��o de importa��o

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

      isValid: json['isValid'] ?? false,

      totalRecords: json['totalRecords'] ?? 0,

      validRecords: json['validRecords'] ?? 0,

      invalidRecords: json['invalidRecords'] ?? 0,

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

}



/// Erro de importa��o

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

}



/// Aviso de importa��o

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

}



/// Preview de linha de importa��o

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

      rowNumber: json['rowNumber'] ?? 0,

      data: (json['data'] as Map<String, dynamic>?)

          ?.map((k, v) => MapEntry(k, v.toString())) ?? {},

      isValid: json['isValid'] ?? true,

      errors: (json['errors'] as List?)

          ?.map((e) => e.toString())

          .toList() ?? [],

    );

  }

}



/// Resultado de importa��o

class ImportResult {

  final String importId;

  final String type;

  final String status;

  final int totalRecords;

  final int processedRecords;

  final int successfulRecords;

  final int failedRecords;

  final int skippedRecords;

  final int newRecords;

  final int updatedRecords;

  final double progressPercent;

  final DateTime startedAt;

  final DateTime? completedAt;

  final int? durationMs;

  final List<ImportError> errors;

  final List<ImportWarning> warnings;



  const ImportResult({

    required this.importId,

    required this.type,

    required this.status,

    required this.totalRecords,

    required this.processedRecords,

    required this.successfulRecords,

    required this.failedRecords,

    required this.skippedRecords,

    required this.newRecords,

    required this.updatedRecords,

    required this.progressPercent,

    required this.startedAt,

    this.completedAt,

    this.durationMs,

    required this.errors,

    required this.warnings,

  });



  bool get isCompleted => status == 'completed' || status == 'completed_with_errors';

  bool get isFailed => status == 'failed';

  bool get isProcessing => status == 'processing';



  factory ImportResult.fromJson(Map<String, dynamic> json) {

    return ImportResult(

      importId: json['importId'] ?? '',

      type: json['type'] ?? '',

      status: json['status'] ?? '',

      totalRecords: json['totalRecords'] ?? 0,

      processedRecords: json['processedRecords'] ?? 0,

      successfulRecords: json['successfulRecords'] ?? 0,

      failedRecords: json['failedRecords'] ?? 0,

      skippedRecords: json['skippedRecords'] ?? 0,

      newRecords: json['newRecords'] ?? 0,

      updatedRecords: json['updatedRecords'] ?? 0,

      progressPercent: (json['progressPercent'] ?? 0).toDouble(),

      startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),

      completedAt: json['completedAt'] != null 

          ? DateTime.tryParse(json['completedAt']) 

          : null,

      durationMs: json['durationMs'],

      errors: (json['errors'] as List?)

          ?.map((e) => ImportError.fromJson(e as Map<String, dynamic>))

          .toList() ?? [],

      warnings: (json['warnings'] as List?)

          ?.map((w) => ImportWarning.fromJson(w as Map<String, dynamic>))

          .toList() ?? [],

    );

  }

}



/// Resultado de exporta��o

class ExportResult {

  final String exportId;

  final String type;

  final String format;

  final String status;

  final int totalRecords;

  final int processedRecords;

  final double progressPercent;

  final DateTime startedAt;

  final DateTime? completedAt;

  final int? durationMs;

  final String? downloadUrl;

  final String? fileName;

  final int? fileSizeBytes;

  final DateTime? expiresAt;



  const ExportResult({

    required this.exportId,

    required this.type,

    required this.format,

    required this.status,

    required this.totalRecords,

    required this.processedRecords,

    required this.progressPercent,

    required this.startedAt,

    this.completedAt,

    this.durationMs,

    this.downloadUrl,

    this.fileName,

    this.fileSizeBytes,

    this.expiresAt,

  });



  bool get isCompleted => status == 'completed';

  bool get isFailed => status == 'failed';

  bool get isProcessing => status == 'processing';



  factory ExportResult.fromJson(Map<String, dynamic> json) {

    return ExportResult(

      exportId: json['exportId'] ?? '',

      type: json['type'] ?? '',

      format: json['format'] ?? '',

      status: json['status'] ?? '',

      totalRecords: json['totalRecords'] ?? 0,

      processedRecords: json['processedRecords'] ?? 0,

      progressPercent: (json['progressPercent'] ?? 0).toDouble(),

      startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),

      completedAt: json['completedAt'] != null 

          ? DateTime.tryParse(json['completedAt']) 

          : null,

      durationMs: json['durationMs'],

      downloadUrl: json['downloadUrl'],

      fileName: json['fileName'],

      fileSizeBytes: json['fileSizeBytes'],

      expiresAt: json['expiresAt'] != null 

          ? DateTime.tryParse(json['expiresAt']) 

          : null,

    );

  }

}



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

      exportId: json['exportId'] ?? '',

      type: json['type'] ?? '',

      format: json['format'] ?? '',

      totalRecords: json['totalRecords'] ?? 0,

      fileName: json['fileName'],

      contentType: json['contentType'],

      base64Data: json['base64Data'],

    );

  }

}



/// Filtros para exporta��o

class ExportFilters {

  final String? categoryId;

  final List<String>? categoryIds;

  final bool? isActive;

  final double? minPrice;

  final double? maxPrice;

  final int? minStock;

  final int? maxStock;

  final DateTime? createdFrom;

  final DateTime? createdTo;

  final String? searchTerm;



  const ExportFilters({

    this.categoryId,

    this.categoryIds,

    this.isActive,

    this.minPrice,

    this.maxPrice,

    this.minStock,

    this.maxStock,

    this.createdFrom,

    this.createdTo,

    this.searchTerm,

  });



  Map<String, dynamic> toJson() {

    return {

      if (categoryId != null) 'categoryId': categoryId,

      if (categoryIds != null) 'categoryIds': categoryIds,

      if (isActive != null) 'isActive': isActive,

      if (minPrice != null) 'minPrice': minPrice,

      if (maxPrice != null) 'maxPrice': maxPrice,

      if (minStock != null) 'minStock': minStock,

      if (maxStock != null) 'maxStock': maxStock,

      if (createdFrom != null) 'createdFrom': createdFrom!.toIso8601String(),

      if (createdTo != null) 'createdTo': createdTo!.toIso8601String(),

      if (searchTerm != null) 'searchTerm': searchTerm,

    };

  }

}



/// Template de importa��o/exporta��o

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

}



/// Defini��o de coluna

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

}



/// Sugest�o de mapeamento de colunas

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

      sourceColumn: json['sourceColumn'] ?? '',

      suggestedField: json['suggestedField'],

      confidence: (json['confidence'] ?? 0).toDouble(),

      alternativeFields: (json['alternativeFields'] as List?)

          ?.map((f) => f.toString())

          .toList() ?? [],

    );

  }

}



/// Hist�rico de importa��o/exporta��o

class ImportExportHistory {

  final String id;

  final String operationType;

  final String dataType;

  final String format;

  final String status;

  final int totalRecords;

  final int successfulRecords;

  final int failedRecords;

  final String? fileName;

  final int? fileSizeBytes;

  final DateTime startedAt;

  final DateTime? completedAt;

  final int? durationMs;

  final String? userId;

  final String? userName;

  final String? errorMessage;



  const ImportExportHistory({

    required this.id,

    required this.operationType,

    required this.dataType,

    required this.format,

    required this.status,

    required this.totalRecords,

    required this.successfulRecords,

    required this.failedRecords,

    this.fileName,

    this.fileSizeBytes,

    required this.startedAt,

    this.completedAt,

    this.durationMs,

    this.userId,

    this.userName,

    this.errorMessage,

  });



  factory ImportExportHistory.fromJson(Map<String, dynamic> json) {

    return ImportExportHistory(

      id: json['id'] ?? '',

      operationType: json['operationType'] ?? '',

      dataType: json['dataType'] ?? '',

      format: json['format'] ?? '',

      status: json['status'] ?? '',

      totalRecords: json['totalRecords'] ?? 0,

      successfulRecords: json['successfulRecords'] ?? 0,

      failedRecords: json['failedRecords'] ?? 0,

      fileName: json['fileName'],

      fileSizeBytes: json['fileSizeBytes'],

      startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),

      completedAt: json['completedAt'] != null 

          ? DateTime.tryParse(json['completedAt']) 

          : null,

      durationMs: json['durationMs'],

      userId: json['userId'],

      userName: json['userName'],

      errorMessage: json['errorMessage'],

    );

  }

}



/// Estat�sticas de importa��o/exporta��o

class ImportExportStats {

  final int totalImports;

  final int totalExports;

  final int successfulOperations;

  final int failedOperations;

  final int totalRecordsImported;

  final int totalRecordsExported;

  final Map<String, int> byDataType;

  final Map<String, int> byFormat;

  final List<ImportExportHistory> recentOperations;



  const ImportExportStats({

    required this.totalImports,

    required this.totalExports,

    required this.successfulOperations,

    required this.failedOperations,

    required this.totalRecordsImported,

    required this.totalRecordsExported,

    required this.byDataType,

    required this.byFormat,

    required this.recentOperations,

  });



  factory ImportExportStats.fromJson(Map<String, dynamic> json) {

    return ImportExportStats(

      totalImports: json['totalImports'] ?? 0,

      totalExports: json['totalExports'] ?? 0,

      successfulOperations: json['successfulOperations'] ?? 0,

      failedOperations: json['failedOperations'] ?? 0,

      totalRecordsImported: json['totalRecordsImported'] ?? 0,

      totalRecordsExported: json['totalRecordsExported'] ?? 0,

      byDataType: (json['byDataType'] as Map<String, dynamic>?)

          ?.map((k, v) => MapEntry(k, v as int)) ?? {},

      byFormat: (json['byFormat'] as Map<String, dynamic>?)

          ?.map((k, v) => MapEntry(k, v as int)) ?? {},

      recentOperations: (json['recentOperations'] as List?)

          ?.map((o) => ImportExportHistory.fromJson(o as Map<String, dynamic>))

          .toList() ?? [],

    );

  }

}



/// Opera��o agendada

class ScheduledOperation {

  final String id;

  final String name;

  final String operationType;

  final String dataType;

  final String format;

  final String cronExpression;

  final bool isActive;

  final DateTime? lastRun;

  final DateTime? nextRun;

  final String? templateId;



  const ScheduledOperation({

    required this.id,

    required this.name,

    required this.operationType,

    required this.dataType,

    required this.format,

    required this.cronExpression,

    required this.isActive,

    this.lastRun,

    this.nextRun,

    this.templateId,

  });



  factory ScheduledOperation.fromJson(Map<String, dynamic> json) {

    return ScheduledOperation(

      id: json['id'] ?? '',

      name: json['name'] ?? '',

      operationType: json['operationType'] ?? '',

      dataType: json['dataType'] ?? '',

      format: json['format'] ?? '',

      cronExpression: json['cronExpression'] ?? '',

      isActive: json['isActive'] ?? false,

      lastRun: json['lastRun'] != null 

          ? DateTime.tryParse(json['lastRun']) 

          : null,

      nextRun: json['nextRun'] != null 

          ? DateTime.tryParse(json['nextRun']) 

          : null,

      templateId: json['templateId'],

    );

  }

}



// =============================================================================

// MODELS DA API - Conectados ao ImportExportController do Backend

// =============================================================================



/// Template de importa��o da API

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

}



/// Defini��o de coluna da API

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

}



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

      sourceColumn: json['sourceColumn'] ?? '',

      targetField: json['targetField'] ?? '',

      confidence: (json['confidence'] ?? 1.0).toDouble(),

    );

  }



  Map<String, dynamic> toJson() => {

    'sourceColumn': sourceColumn,

    'targetField': targetField,

    'confidence': confidence,

  };

}



/// Preview de importa��o da API

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

      totalRows: json['totalRows'] ?? 0,

      hasErrors: json['hasErrors'] ?? false,

      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],

      mappings: (json['mappings'] as List?)

          ?.map((m) => ColumnMappingModel.fromJson(m as Map<String, dynamic>))

          .toList() ?? [],

    );

  }

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

      isValid: json['isValid'] ?? true,

      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],

    );

  }

}



/// Resultado de importa��o da API

class ImportResultModel {

  final bool success;

  final int totalProcessed;

  final int inserted;

  final int updated;

  final int failed;

  final List<ImportErrorModel> errors;

  final String? jobId;



  const ImportResultModel({

    required this.success,

    required this.totalProcessed,

    this.inserted = 0,

    this.updated = 0,

    this.failed = 0,

    this.errors = const [],

    this.jobId,

  });



  factory ImportResultModel.fromJson(Map<String, dynamic> json) {

    return ImportResultModel(

      success: json['success'] ?? false,

      totalProcessed: json['totalProcessed'] ?? 0,

      inserted: json['inserted'] ?? 0,

      updated: json['updated'] ?? 0,

      failed: json['failed'] ?? 0,

      errors: (json['errors'] as List?)

          ?.map((e) => ImportErrorModel.fromJson(e as Map<String, dynamic>))

          .toList() ?? [],

      jobId: json['jobId'],

    );

  }

}



/// Erro de importa��o da API

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

}



/// Resultado de exporta��o da API (detalhado)

class ExportApiResultModel {

  final bool success;

  final String? jobId;

  final String? format;

  final int recordCount;

  final String? downloadUrl;

  final String? content;

  final String? contentType;



  const ExportApiResultModel({

    required this.success,

    this.jobId,

    this.format,

    this.recordCount = 0,

    this.downloadUrl,

    this.content,

    this.contentType,

  });



  factory ExportApiResultModel.fromJson(Map<String, dynamic> json) {

    return ExportApiResultModel(

      success: json['success'] ?? false,

      jobId: json['jobId'],

      format: json['format'],

      recordCount: json['recordCount'] ?? 0,

      downloadUrl: json['downloadUrl'],

      content: json['content'],

      contentType: json['contentType'],

    );

  }

}



/// Status de job da API

class JobStatusModel {

  final String id;

  final String status;

  final double progress;

  final String? currentStep;

  final int? totalSteps;

  final Map<String, dynamic>? result;

  final String? error;



  const JobStatusModel({

    required this.id,

    required this.status,

    this.progress = 0,

    this.currentStep,

    this.totalSteps,

    this.result,

    this.error,

  });



  factory JobStatusModel.fromJson(Map<String, dynamic> json) {

    return JobStatusModel(

      id: json['id'] ?? '',

      status: json['status'] ?? '',

      progress: (json['progress'] ?? 0).toDouble(),

      currentStep: json['currentStep'],

      totalSteps: json['totalSteps'],

      result: json['result'] as Map<String, dynamic>?,

      error: json['error'],

    );

  }



  bool get isCompleted => status == 'completed';

  bool get isFailed => status == 'failed';

  bool get isRunning => status == 'running' || status == 'processing';

}



/// Resultado de valida��o da API

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

      isValid: json['isValid'] ?? false,

      totalRecords: json['totalRecords'] ?? 0,

      validRecords: json['validRecords'] ?? 0,

      invalidRecords: json['invalidRecords'] ?? 0,

      errors: (json['errors'] as List?)

          ?.map((e) => ImportErrorModel.fromJson(e as Map<String, dynamic>))

          .toList() ?? [],

      warnings: (json['warnings'] as List?)?.map((w) => w.toString()).toList() ?? [],

    );

  }

}



/// Hist�rico de importa��o da API (detalhado)

class ImportHistoryApiModel {

  final String id;

  final String operationType;

  final String dataType;

  final String format;

  final String status;

  final int totalRecords;

  final int successfulRecords;

  final int failedRecords;

  final String? fileName;

  final DateTime startedAt;

  final DateTime? completedAt;

  final String? errorMessage;

  final String? userId;



  const ImportHistoryApiModel({

    required this.id,

    required this.operationType,

    required this.dataType,

    required this.format,

    required this.status,

    required this.totalRecords,

    this.successfulRecords = 0,

    this.failedRecords = 0,

    this.fileName,

    required this.startedAt,

    this.completedAt,

    this.errorMessage,

    this.userId,

  });



  factory ImportHistoryApiModel.fromJson(Map<String, dynamic> json) {

    return ImportHistoryApiModel(

      id: json['id'] ?? '',

      operationType: json['operationType'] ?? '',

      dataType: json['dataType'] ?? '',

      format: json['format'] ?? '',

      status: json['status'] ?? '',

      totalRecords: json['totalRecords'] ?? 0,

      successfulRecords: json['successfulRecords'] ?? 0,

      failedRecords: json['failedRecords'] ?? 0,

      fileName: json['fileName'],

      startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),

      completedAt: json['completedAt'] != null 

          ? DateTime.tryParse(json['completedAt']) 

          : null,

      errorMessage: json['errorMessage'],

      userId: json['userId'],

    );

  }

}



/// Resultado de opera��o em lote da API

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

      success: json['success'] ?? false,

      operation: json['operation'] ?? '',

      totalRequested: json['totalRequested'] ?? 0,

      totalProcessed: json['totalProcessed'] ?? 0,

      succeeded: json['succeeded'] ?? 0,

      failed: json['failed'] ?? 0,

      failedIds: (json['failedIds'] as List?)?.map((id) => id.toString()).toList() ?? [],

      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],

    );

  }

}



/// Estat�sticas de importa��o/exporta��o

class ImportExportStatisticsModel {

  final int totalImports;

  final int totalExports;

  final int successfulImports;

  final int failedImports;

  final int totalRecordsImported;

  final int totalRecordsExported;

  final DateTime? lastImportAt;

  final DateTime? lastExportAt;

  final int pendingJobs;



  const ImportExportStatisticsModel({

    this.totalImports = 0,

    this.totalExports = 0,

    this.successfulImports = 0,

    this.failedImports = 0,

    this.totalRecordsImported = 0,

    this.totalRecordsExported = 0,

    this.lastImportAt,

    this.lastExportAt,

    this.pendingJobs = 0,

  });



  factory ImportExportStatisticsModel.fromJson(Map<String, dynamic> json) {

    return ImportExportStatisticsModel(

      totalImports: json['totalImports'] ?? json['total_imports'] ?? 0,

      totalExports: json['totalExports'] ?? json['total_exports'] ?? 0,

      successfulImports: json['successfulImports'] ?? json['successful_imports'] ?? 0,

      failedImports: json['failedImports'] ?? json['failed_imports'] ?? 0,

      totalRecordsImported: json['totalRecordsImported'] ?? json['total_records_imported'] ?? 0,

      totalRecordsExported: json['totalRecordsExported'] ?? json['total_records_exported'] ?? 0,

      lastImportAt: json['lastImportAt'] != null || json['last_import_at'] != null

          ? DateTime.tryParse(json['lastImportAt'] ?? json['last_import_at'] ?? '')

          : null,

      lastExportAt: json['lastExportAt'] != null || json['last_export_at'] != null

          ? DateTime.tryParse(json['lastExportAt'] ?? json['last_export_at'] ?? '')

          : null,

      pendingJobs: json['pendingJobs'] ?? json['pending_jobs'] ?? 0,

    );

  }



  Map<String, dynamic> toJson() => {

    'totalImports': totalImports,

    'totalExports': totalExports,

    'successfulImports': successfulImports,

    'failedImports': failedImports,

    'totalRecordsImported': totalRecordsImported,

    'totalRecordsExported': totalRecordsExported,

    'lastImportAt': lastImportAt?.toIso8601String(),

    'lastExportAt': lastExportAt?.toIso8601String(),

    'pendingJobs': pendingJobs,

  };

}









