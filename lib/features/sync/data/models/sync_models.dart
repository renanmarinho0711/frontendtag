import 'package:flutter/material.dart';

/// Modelos para o módulo de Sincronização
/// Gerencia estado e histórico de sincronizações

/// Tipo de sincronização
enum SyncType {
  full,       // Sincronização completa (produtos + tags)
  products,   // Apenas produtos (Produtos Novos na UI)
  tags,       // Apenas tags
  prices,     // Apenas preços
}

extension SyncTypeExtension on SyncType {
  String get label {
    switch (this) {
      case SyncType.full:
        return 'Completa';
      case SyncType.products:
        return 'Produtos Novos';
      case SyncType.tags:
        return 'Tags';
      case SyncType.prices:
        return 'PREÇOs';
    }
  }
  
  IconData get iconData {
    switch (this) {
      case SyncType.full:
        return Icons.sync_rounded;
      case SyncType.products:
        return Icons.inventory_2_rounded;
      case SyncType.tags:
        return Icons.label_rounded;
      case SyncType.prices:
        return Icons.attach_money_rounded;
    }
  }
}

/// Status de uma sincronização
enum SyncStatus {
  pending,    // Aguardando
  running,    // Em execução
  success,    // Sucesso
  partial,    // Parcial (alguns erros)
  failed,     // Falha
  cancelled,  // Cancelada
}

extension SyncStatusExtension on SyncStatus {
  String get label {
    switch (this) {
      case SyncStatus.pending:
        return 'Aguardando';
      case SyncStatus.running:
        return 'Em execução';
      case SyncStatus.success:
        return 'Sucesso';
      case SyncStatus.partial:
        return 'Parcial';
      case SyncStatus.failed:
        return 'Falha';
      case SyncStatus.cancelled:
        return 'Cancelada';
    }
  }
  
  /// Cor associada ao status para uso na UI (hardcoded para models sem context)
  Color get color {
    switch (this) {
      case SyncStatus.pending:
        return const Color(0xFF9E9E9E); // grey500
      case SyncStatus.running:
        return const Color(0xFF00A86B); // primary
      case SyncStatus.success:
        return const Color(0xFF4CAF50); // statusActive
      case SyncStatus.partial:
        return const Color(0xFFFF9800); // statusPending
      case SyncStatus.failed:
        return const Color(0xFFE53935); // statusBlocked
      case SyncStatus.cancelled:
        return const Color(0xFF9E9E9E); // grey500
    }
  }
  
  /// ícone associado ao status para uso na UI
  IconData get iconData {
    switch (this) {
      case SyncStatus.pending:
        return Icons.schedule_rounded;
      case SyncStatus.running:
        return Icons.sync_rounded;
      case SyncStatus.success:
        return Icons.check_circle_rounded;
      case SyncStatus.partial:
        return Icons.warning_rounded;
      case SyncStatus.failed:
        return Icons.error_rounded;
      case SyncStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }
  
  bool get isTerminal => 
    this == SyncStatus.success || 
    this == SyncStatus.failed || 
    this == SyncStatus.partial ||
    this == SyncStatus.cancelled;
}

/// Registro de histórico de sincronização
class SyncHistoryEntry {
  final String id;
  final SyncType type;
  final SyncStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int productsCount;
  final int tagsCount;
  final int successCount;
  final int errorCount;
  final String? errorMessage;
  final Duration? duration;
  final String? executedBy;       // Usuário que executou
  final String? details;          // Detalhes da sincronização
  final List<String> errors;      // Lista de erros

  const SyncHistoryEntry({
    required this.id,
    required this.type,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.productsCount = 0,
    this.tagsCount = 0,
    this.successCount = 0,
    this.errorCount = 0,
    this.errorMessage,
    this.duration,
    this.executedBy,
    this.details,
    this.errors = const [],
  });

  /// Cor baseada no status (getter de conveniãncia)
  Color get color => status.color;
  
  /// ícone baseado no status (getter de conveniãncia)
  IconData get iconData => status.iconData;

  /// DurAção formatada
  String get durationFormatted {
    if (duration == null) return '-';
    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
  
  /// Total de itens processados
  int get totalItems => productsCount + tagsCount;
  
  /// Data formatada
  String get formattedDate {
    final day = startedAt.day.toString().padLeft(2, '0');
    final month = startedAt.month.toString().padLeft(2, '0');
    final year = startedAt.year;
    final hour = startedAt.hour.toString().padLeft(2, '0');
    final minute = startedAt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  factory SyncHistoryEntry.fromJson(Map<String, dynamic> json) {
    return SyncHistoryEntry(
      id: json['id'] as String? ?? '',
      type: _parseSyncType(json['type']),
      status: _parseSyncStatus(json['status']),
      startedAt: json['startedAt'] != null 
          ? DateTime.parse(json['startedAt'] as String)
          : DateTime.now(),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      productsCount: json['productsCount'] as int? ?? 0,
      tagsCount: json['tagsCount'] as int? ?? 0,
      successCount: json['successCount'] as int? ?? 0,
      errorCount: json['errorCount'] as int? ?? 0,
      errorMessage: json['errorMessage'] as String?,
      duration: json['durationMs'] != null 
          ? Duration(milliseconds: json['durationMs'] as int)
          : null,
      executedBy: json['executedBy'] as String? ?? json['usuario'] as String?,
      details: json['details'] as String? ?? json['detalhes'] as String?,
      errors: (json['errors'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'status': status.name,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'productsCount': productsCount,
      'tagsCount': tagsCount,
      'successCount': successCount,
      'errorCount': errorCount,
      'errorMessage': errorMessage,
      'durationMs': duration?.inMilliseconds,
      'executedBy': executedBy,
      'details': details,
      'errors': errors,
    };
  }

  SyncHistoryEntry copyWith({
    String? id,
    SyncType? type,
    SyncStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? productsCount,
    int? tagsCount,
    int? successCount,
    int? errorCount,
    String? errorMessage,
    Duration? duration,
    String? executedBy,
    String? details,
    List<String>? errors,
  }) {
    return SyncHistoryEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      productsCount: productsCount ?? this.productsCount,
      tagsCount: tagsCount ?? this.tagsCount,
      successCount: successCount ?? this.successCount,
      errorCount: errorCount ?? this.errorCount,
      errorMessage: errorMessage ?? this.errorMessage,
      duration: duration ?? this.duration,
      executedBy: executedBy ?? this.executedBy,
      details: details ?? this.details,
      errors: errors ?? this.errors,
    );
  }

  static SyncType _parseSyncType(dynamic value) {
    if (value is SyncType) return value;
    if (value is String) {
      return SyncType.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => SyncType.full,
      );
    }
    return SyncType.full;
  }

  static SyncStatus _parseSyncStatus(dynamic value) {
    if (value is SyncStatus) return value;
    if (value is String) {
      // Mapear labels em português para status
      switch (value.toLowerCase()) {
        case 'sucesso':
          return SyncStatus.success;
        case 'parcial':
          return SyncStatus.partial;
        case 'falha':
        case 'erro':
          return SyncStatus.failed;
        case 'cancelada':
          return SyncStatus.cancelled;
        case 'aguardando':
        case 'pendente':
          return SyncStatus.pending;
        case 'em execução':
        case 'executando':
          return SyncStatus.running;
      }
      return SyncStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => SyncStatus.pending,
      );
    }
    return SyncStatus.pending;
  }
}

/// Resultado de uma operação de sincronização
class SyncResult {
  final bool success;
  final int totalProcessed;
  final int successCount;
  final int errorCount;
  final Duration duration;
  final String? errorMessage;
  final List<String> errors;

  const SyncResult({
    required this.success,
    required this.totalProcessed,
    required this.successCount,
    required this.errorCount,
    required this.duration,
    this.errorMessage,
    this.errors = const [],
  });

  factory SyncResult.fromJson(Map<String, dynamic> json) {
    return SyncResult(
      success: json['success'] as bool? ?? false,
      totalProcessed: json['totalProcessed'] as int? ?? 
                      json['total'] as int? ?? 0,
      successCount: json['successCount'] as int? ?? 0,
      errorCount: json['errorCount'] as int? ?? 
                  json['failureCount'] as int? ?? 0,
      duration: Duration(
        milliseconds: json['durationMs'] as int? ?? 0,
      ),
      errorMessage: json['errorMessage'] as String? ?? 
                    json['message'] as String?,
      errors: (json['errors'] as List?)?.cast<String>() ?? [],
    );
  }

  factory SyncResult.success({
    required int totalProcessed,
    required int successCount,
    required Duration duration,
  }) {
    return SyncResult(
      success: true,
      totalProcessed: totalProcessed,
      successCount: successCount,
      errorCount: 0,
      duration: duration,
    );
  }

  factory SyncResult.failure({
    required String errorMessage,
    int totalProcessed = 0,
    int successCount = 0,
    int errorCount = 0,
    Duration duration = Duration.zero,
    List<String> errors = const [],
  }) {
    return SyncResult(
      success: false,
      totalProcessed: totalProcessed,
      successCount: successCount,
      errorCount: errorCount,
      duration: duration,
      errorMessage: errorMessage,
      errors: errors,
    );
  }
}

/// Configurações de sincronização
class SyncSettings {
  final bool autoSync;
  final int autoSyncIntervalMinutes;
  final bool syncOnStartup;
  final bool notifyOnComplete;
  final bool notifyOnError;
  final SyncType defaultSyncType;

  const SyncSettings({
    this.autoSync = false,
    this.autoSyncIntervalMinutes = 15,
    this.syncOnStartup = true,
    this.notifyOnComplete = true,
    this.notifyOnError = true,
    this.defaultSyncType = SyncType.full,
  });

  factory SyncSettings.fromJson(Map<String, dynamic> json) {
    return SyncSettings(
      autoSync: json['autoSync'] as bool? ?? false,
      autoSyncIntervalMinutes: json['autoSyncIntervalMinutes'] as int? ?? 15,
      syncOnStartup: json['syncOnStartup'] as bool? ?? true,
      notifyOnComplete: json['notifyOnComplete'] as bool? ?? true,
      notifyOnError: json['notifyOnError'] as bool? ?? true,
      defaultSyncType: SyncHistoryEntry._parseSyncType(json['defaultSyncType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoSync': autoSync,
      'autoSyncIntervalMinutes': autoSyncIntervalMinutes,
      'syncOnStartup': syncOnStartup,
      'notifyOnComplete': notifyOnComplete,
      'notifyOnError': notifyOnError,
      'defaultSyncType': defaultSyncType.name,
    };
  }

  SyncSettings copyWith({
    bool? autoSync,
    int? autoSyncIntervalMinutes,
    bool? syncOnStartup,
    bool? notifyOnComplete,
    bool? notifyOnError,
    SyncType? defaultSyncType,
  }) {
    return SyncSettings(
      autoSync: autoSync ?? this.autoSync,
      autoSyncIntervalMinutes: autoSyncIntervalMinutes ?? this.autoSyncIntervalMinutes,
      syncOnStartup: syncOnStartup ?? this.syncOnStartup,
      notifyOnComplete: notifyOnComplete ?? this.notifyOnComplete,
      notifyOnError: notifyOnError ?? this.notifyOnError,
      defaultSyncType: defaultSyncType ?? this.defaultSyncType,
    );
  }

  static const SyncSettings defaultSettings = SyncSettings();
}

// =============================================================================
// MODELOS DE SINCRONIZAããO MINEW
// Mapeados para os endpoints do SyncController no backend
// =============================================================================

/// Resultado de sincronização com Minew Cloud
/// Mapeado para: SyncResultDto do backend
class MinewSyncResult {
  final bool success;
  final String message;
  final int syncedCount;
  final int errorCount;
  final List<String> errors;
  final DateTime? lastSync;
  final String syncStatus; // synced, partial, error

  const MinewSyncResult({
    required this.success,
    required this.message,
    this.syncedCount = 0,
    this.errorCount = 0,
    this.errors = const [],
    this.lastSync,
    this.syncStatus = 'pending',
  });

  /// Sincronização bem sucedida (sem erros)
  bool get isFullySuccessful => success && errorCount == 0;

  /// Sincronização parcial (com alguns erros)
  bool get isPartiallySuccessful => success && errorCount > 0;

  factory MinewSyncResult.fromJson(Map<String, dynamic> json) {
    return MinewSyncResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      syncedCount: json['syncedCount'] as int? ?? json['successCount'] as int? ?? 0,
      errorCount: json['errorCount'] as int? ?? json['failureCount'] as int? ?? 0,
      errors: (json['errors'] as List?)?.cast<String>() ?? [],
      lastSync: json['lastSync'] != null 
          ? DateTime.parse(json['lastSync'] as String)
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'pending',
    );
  }

  factory MinewSyncResult.success({
    required String message,
    int syncedCount = 1,
    DateTime? lastSync,
  }) {
    return MinewSyncResult(
      success: true,
      message: message,
      syncedCount: syncedCount,
      lastSync: lastSync ?? DateTime.now(),
      syncStatus: 'synced',
    );
  }

  factory MinewSyncResult.partial({
    required String message,
    required int syncedCount,
    required int errorCount,
    required List<String> errors,
  }) {
    return MinewSyncResult(
      success: true,
      message: message,
      syncedCount: syncedCount,
      errorCount: errorCount,
      errors: errors,
      lastSync: DateTime.now(),
      syncStatus: 'partial',
    );
  }

  factory MinewSyncResult.error({
    required String message,
    List<String> errors = const [],
  }) {
    return MinewSyncResult(
      success: false,
      message: message,
      errors: errors,
      syncStatus: 'error',
    );
  }
}

/// Resultado de vinculAção tag-produto
/// Mapeado para: BindResultDto do backend
class BindResultDto {
  final bool success;
  final String message;
  final String? tagMacAddress;
  final String? productId;
  final String? productName;
  final DateTime? boundAt;

  const BindResultDto({
    required this.success,
    required this.message,
    this.tagMacAddress,
    this.productId,
    this.productName,
    this.boundAt,
  });

  factory BindResultDto.fromJson(Map<String, dynamic> json) {
    return BindResultDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      tagMacAddress: json['tagMacAddress'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      boundAt: json['boundAt'] != null 
          ? DateTime.parse(json['boundAt'] as String)
          : null,
    );
  }
}

/// Status detalhado de sincronização
/// Para exibição de status em tempo real na UI
class SyncStatusInfo {
  final String entityType; // product, tag, store
  final String entityId;
  final String entityName;
  final String status; // synced, pending, error, syncing
  final DateTime? lastSync;
  final String? errorMessage;
  final double? progressPercent;

  const SyncStatusInfo({
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.status,
    this.lastSync,
    this.errorMessage,
    this.progressPercent,
  });

  /// Verifica se estã em processo de sincronização
  bool get isSyncing => status == 'syncing';

  /// Verifica se estã sincronizado
  bool get isSynced => status == 'synced';

  /// Verifica se tem erro
  bool get hasError => status == 'error';

  /// Verifica se estã pendente
  bool get isPending => status == 'pending';

  factory SyncStatusInfo.fromJson(Map<String, dynamic> json) {
    return SyncStatusInfo(
      entityType: json['entityType'] as String? ?? '',
      entityId: json['entityId'] as String? ?? '',
      entityName: json['entityName'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      lastSync: json['lastSync'] != null 
          ? DateTime.parse(json['lastSync'] as String)
          : null,
      errorMessage: json['errorMessage'] as String?,
      progressPercent: (json['progressPercent'] as num?)?.toDouble(),
    );
  }
}

/// Request para sincronização em lote de tags
class BatchSyncTagsRequest {
  final String storeId;
  final List<String> macAddresses;

  const BatchSyncTagsRequest({
    required this.storeId,
    required this.macAddresses,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'macAddresses': macAddresses,
    };
  }
}

/// Request para sincronização em lote de produtos
class BatchSyncProductsRequest {
  final String storeId;
  final List<String> productIds;

  const BatchSyncProductsRequest({
    required this.storeId,
    required this.productIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'productIds': productIds,
    };
  }
}

/// Request para atualizar display de uma tag
class RefreshTagDisplayRequest {
  final String storeId;
  final String macAddress;
  final String? templateId;

  const RefreshTagDisplayRequest({
    required this.storeId,
    required this.macAddress,
    this.templateId,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'macAddress': macAddress,
      if (templateId != null) 'templateId': templateId,
    };
  }
}

/// Request para importar tags da Minew Cloud
class ImportTagsRequest {
  final String storeId;
  final bool overwriteExisting;

  const ImportTagsRequest({
    required this.storeId,
    this.overwriteExisting = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'overwriteExisting': overwriteExisting,
    };
  }
}

/// Resultado de importação de tags
class ImportTagsResult {
  final bool success;
  final String message;
  final int totalFound;
  final int importedCount;
  final int updatedCount;
  final int skippedCount;
  final int errorCount;
  final List<String> errors;

  const ImportTagsResult({
    required this.success,
    required this.message,
    this.totalFound = 0,
    this.importedCount = 0,
    this.updatedCount = 0,
    this.skippedCount = 0,
    this.errorCount = 0,
    this.errors = const [],
  });

  factory ImportTagsResult.fromJson(Map<String, dynamic> json) {
    return ImportTagsResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      totalFound: json['totalFound'] as int? ?? 0,
      importedCount: json['importedCount'] as int? ?? 0,
      updatedCount: json['updatedCount'] as int? ?? 0,
      skippedCount: json['skippedCount'] as int? ?? 0,
      errorCount: json['errorCount'] as int? ?? 0,
      errors: (json['errors'] as List?)?.cast<String>() ?? [],
    );
  }
}



