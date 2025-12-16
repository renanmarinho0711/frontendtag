import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Modelos para o m?dulo de Sincroniza??o
/// Gerencia estado e hist?rico de sincroniza??es

/// Tipo de sincroniza??o
enum SyncType {
  full,       // Sincroniza??o completa (produtos + tags)
  products,   // Apenas produtos (Produtos Novos na UI)
  tags,       // Apenas tags
  prices,     // Apenas pre?os
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
        return 'Pre?os';
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

/// Status de uma sincroniza??o
enum SyncStatus {
  pending,    // Aguardando
  running,    // Em execu??o
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
        return 'Em execu??o';
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
  
  /// Cor associada ao status para uso na UI
  Color get color {
    switch (this) {
      case SyncStatus.pending:
        return ThemeColors.of(context).textTertiary;
      case SyncStatus.running:
        return ThemeColors.of(context).primary;
      case SyncStatus.success:
        return ThemeColors.of(context).statusActive; // Verde Material
      case SyncStatus.partial:
        return ThemeColors.of(context).statusPending; // Laranja Material
      case SyncStatus.failed:
        return ThemeColors.of(context).statusBlocked; // Vermelho
      case SyncStatus.cancelled:
        return ThemeColors.of(context).textTertiary;
    }
  }
  
  /// ?cone associado ao status para uso na UI
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

/// Registro de hist?rico de sincroniza??o
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
  final String? executedBy;       // Usu?rio que executou
  final String? details;          // Detalhes da sincroniza??o
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

  /// Cor baseada no status (getter de conveni?ncia)
  Color get color => status.color;
  
  /// ?cone baseado no status (getter de conveni?ncia)
  IconData get iconData => status.iconData;

  /// Dura??o formatada
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
    final newStartedAt = startedAt ?? this.startedAt;
    final newCompletedAt = completedAt ?? this.completedAt;
    
    // Validar que completedAt não seja antes de startedAt
    if (newCompletedAt != null && newCompletedAt.isBefore(newStartedAt)) {
      throw ArgumentError('completedAt cannot be before startedAt');
    }
    
    return SyncHistoryEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      startedAt: newStartedAt,
      completedAt: newCompletedAt,
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
      // Mapear labels em portugu?s para status
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
        case 'em execu??o':
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

/// Resultado de uma opera??o de sincroniza??o
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

/// Configura??es de sincroniza??o
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
// MODELOS DE SINCRONIZA??O MINEW
// Mapeados para os endpoints do SyncController no backend
// =============================================================================

/// Resultado de sincroniza??o com Minew Cloud
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

  /// Sincroniza??o bem sucedida (sem erros)
  bool get isFullySuccessful => success && errorCount == 0;

  /// Sincroniza??o parcial (com alguns erros)
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

/// Resultado de vincula??o tag-produto
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

/// Status detalhado de sincroniza??o
/// Para exibi??o de status em tempo real na UI
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

  /// Verifica se est? em processo de sincroniza??o
  bool get isSyncing => status == 'syncing';

  /// Verifica se est? sincronizado
  bool get isSynced => status == 'synced';

  /// Verifica se tem erro
  bool get hasError => status == 'error';

  /// Verifica se est? pendente
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

/// Request para sincroniza??o em lote de tags
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

/// Request para sincroniza??o em lote de produtos
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

/// Resultado de importa??o de tags
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

// =============================================================================
// NOVOS MODELOS PARA INTEGRAÇÃO MINEW CLOUD
// Compatíveis com MinewStatsController e MinewStatsSyncService
// =============================================================================

/// Estatísticas da Minew Cloud para uma loja
class MinewStoreStats {
  final int totalTags;
  final int onlineTags;
  final int offlineTags;
  final int boundTags;
  final int availableTags;
  final int lowBatteryTags;
  final int totalGateways;
  final int onlineGateways;
  final int offlineGateways;
  final int totalProducts;
  final DateTime collectedAt;

  const MinewStoreStats({
    this.totalTags = 0,
    this.onlineTags = 0,
    this.offlineTags = 0,
    this.boundTags = 0,
    this.availableTags = 0,
    this.lowBatteryTags = 0,
    this.totalGateways = 0,
    this.onlineGateways = 0,
    this.offlineGateways = 0,
    this.totalProducts = 0,
    required this.collectedAt,
  });

  factory MinewStoreStats.fromJson(Map<String, dynamic> json) {
    return MinewStoreStats(
      totalTags: json['totalTags'] as int? ?? 0,
      onlineTags: json['onlineTags'] as int? ?? 0,
      offlineTags: json['offlineTags'] as int? ?? 0,
      boundTags: json['boundTags'] as int? ?? 0,
      availableTags: json['availableTags'] as int? ?? 0,
      lowBatteryTags: json['lowBatteryTags'] as int? ?? 0,
      totalGateways: json['totalGateways'] as int? ?? 0,
      onlineGateways: json['onlineGateways'] as int? ?? 0,
      offlineGateways: json['offlineGateways'] as int? ?? 0,
      totalProducts: json['totalProducts'] as int? ?? 0,
      collectedAt: json['collectedAt'] != null 
          ? DateTime.parse(json['collectedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Porcentagem de tags online
  double get onlinePercentage => totalTags > 0 ? (onlineTags / totalTags) * 100 : 0;

  /// Porcentagem de tags vinculadas
  double get boundPercentage => totalTags > 0 ? (boundTags / totalTags) * 100 : 0;

  /// Status geral do sistema
  String get systemStatus {
    if (totalTags == 0) return 'Sem tags';
    if (onlinePercentage >= 90) return 'Excelente';
    if (onlinePercentage >= 70) return 'Bom';
    if (onlinePercentage >= 50) return 'Regular';
    return 'Crítico';
  }
}

/// Resultado de sincronização completa de uma loja
class StoreSyncSummary {
  final String storeId;
  final String storeName;
  final DateTime syncedAt;
  final double durationMs;
  final String summary;
  final SyncOperationResult? tagsSync;
  final SyncOperationResult? gatewaysSync;
  final MinewStoreStats? minewStats;

  const StoreSyncSummary({
    required this.storeId,
    required this.storeName,
    required this.syncedAt,
    required this.durationMs,
    required this.summary,
    this.tagsSync,
    this.gatewaysSync,
    this.minewStats,
  });

  factory StoreSyncSummary.fromJson(Map<String, dynamic> json) {
    return StoreSyncSummary(
      storeId: json['storeId'] as String? ?? '',
      storeName: json['storeName'] as String? ?? '',
      syncedAt: json['syncedAt'] != null 
          ? DateTime.parse(json['syncedAt'] as String)
          : DateTime.now(),
      durationMs: (json['duration'] as num?)?.toDouble() ?? 0,
      summary: json['summary'] as String? ?? '',
      tagsSync: json['tags'] != null 
          ? SyncOperationResult.fromJson(json['tags'] as Map<String, dynamic>)
          : null,
      gatewaysSync: json['gateways'] != null 
          ? SyncOperationResult.fromJson(json['gateways'] as Map<String, dynamic>)
          : null,
      minewStats: json['minewStats'] != null 
          ? MinewStoreStats.fromJson(json['minewStats'] as Map<String, dynamic>)
          : null,
    );
  }

  Duration get duration => Duration(milliseconds: durationMs.toInt());
}

/// Resultado de uma operação de sync (tags ou gateways)
class SyncOperationResult {
  final int processed;
  final int updated;
  final int errors;

  const SyncOperationResult({
    this.processed = 0,
    this.updated = 0,
    this.errors = 0,
  });

  factory SyncOperationResult.fromJson(Map<String, dynamic> json) {
    return SyncOperationResult(
      processed: json['processed'] as int? ?? 0,
      updated: json['updated'] as int? ?? 0,
      errors: json['errors'] as int? ?? 0,
    );
  }
}

/// Resultado de sincronização de stats
class StatsSyncResult {
  final bool success;
  final String? message;
  final int processed;
  final int updated;
  final int errors;
  final double durationMs;
  final List<String>? errorMessages;

  const StatsSyncResult({
    required this.success,
    this.message,
    this.processed = 0,
    this.updated = 0,
    this.errors = 0,
    this.durationMs = 0,
    this.errorMessages,
  });

  factory StatsSyncResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return StatsSyncResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      processed: data?['processed'] as int? ?? 0,
      updated: data?['updated'] as int? ?? 0,
      errors: data?['errors'] as int? ?? 0,
      durationMs: (data?['duration'] as num?)?.toDouble() ?? 0,
      errorMessages: (data?['errorMessages'] as List?)?.cast<String>(),
    );
  }

  Duration get duration => Duration(milliseconds: durationMs.toInt());
}






