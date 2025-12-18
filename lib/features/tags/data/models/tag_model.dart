/// Modelo de etiqueta eletrônica (ESL)

/// Mapeado para: TagResponseDto do backend

/// Atualizado com campos de integração Minew

class TagModel {

  final String id; // ID único da tag (geralmente igual ao macAddress)

  final String macAddress;

  final String storeId;

  final String? productId;

  final String? productName;

  final TagType type;

  final TagStatus status;

  final int batteryLevel;

  final int signalStrength;

  final int? temperature;

  final String? firmware;

  final DateTime? lastSync;

  final bool isActive;

  final DateTime createdAt;

  final String? screenSize; // Tamanho da tela (ex: "2.13", "4.2", "7.5")

  final String? location; // Localização física da tag

  final String? notes; // Observações/notas

  // Novos campos de integração Minew

  final String? displayName; // Nome amigável para exibição

  final int displayOrder; // Ordem de exibição na lista

  final String? minewDeviceId; // ID do dispositivo na Minew Cloud

  final String? minewSyncStatus; // synced, pending, error, not_synced

  final String? screenColor; // BW (preto/branco), BWR (preto/branco/vermelho), BWY (preto/branco/amarelo)

  final bool isOnline; // Status de conexão em tempo real

  final DateTime? lastSeen; // Última vez que a tag foi vista online



  const TagModel({

    String? id,

    required this.macAddress,

    required this.storeId,

    this.productId,

    this.productName,

    required this.type,

    required this.status,

    required this.batteryLevel,

    required this.signalStrength,

    this.temperature,

    this.firmware,

    this.lastSync,

    required this.isActive,

    required this.createdAt,

    this.screenSize,

    this.location,

    this.notes,

    // Novos campos Minew

    this.displayName,

    this.displayOrder = 0,

    this.minewDeviceId,

    this.minewSyncStatus,

    this.screenColor,

    this.isOnline = false,

    this.lastSeen,

  }) : id = id ?? macAddress;



  /// Verifica se a tag está vinculada a um produto

  bool get isBound => productId != null;



  /// Verifica se a bateria está baixa

  bool get isLowBattery => batteryLevel < 20;



  /// Verifica se a bateria está crítica

  bool get isCriticalBattery => batteryLevel < 10;



  /// Nome para exibição (usa displayName se disponível, senão macAddress)

  String get displayLabel => displayName?.isNotEmpty == true ? displayName! : macAddress;



  /// Verifica se está sincronizado com Minew

  bool get isSynced => minewSyncStatus == 'synced';



  /// Verifica se tem erro de sincronização

  bool get hasSyncError => minewSyncStatus == 'error';



  /// Verifica se está pendente de sincronização

  bool get isPendingSync => minewSyncStatus == 'pending';

  

  /// Alias para signalStrength (compatibilidade)

  int get rssi => signalStrength;



  /// Retorna cor do status baseado no estado

  String get statusColor {

    if (!isActive) return 'grey';

    if (isOnline) return 'green';

    if (status == TagStatus.lowBattery) return 'orange';

    if (status == TagStatus.offline) return 'red';

    return 'blue';

  }



  /// Retorna ícone baseado no tipo de tela

  String get screenTypeIcon {

    switch (screenColor) {

      case 'BWR':

        return '🔴⚫⚪'; // Preto/Branco/Vermelho

      case 'BWY':

        return '🟡⚫⚪'; // Preto/Branco/Amarelo  

      default:

        return '⚫⚪'; // Preto/Branco

    }

  }



  /// Cria a partir do JSON da API

  factory TagModel.fromJson(Map<String, dynamic> json) {

    final macAddr = json['macAddress'] as String;

    return TagModel(

      id: json['id'] as String? ?? macAddr,

      macAddress: macAddr,

      storeId: json['storeId'] as String,

      productId: json['productId'] as String?,

      productName: json['productName'] as String?,

      type: TagType.fromValue(json['type'] as int? ?? 0),

      status: TagStatus.fromValue(json['status'] as int? ?? 0),

      batteryLevel: json['batteryLevel'] as int? ?? 0,

      signalStrength: json['signalStrength'] as int? ?? 0,

      temperature: json['temperature'] as int?,

      firmware: json['firmware'] as String?,

      lastSync: json['lastSync'] != null

          ? DateTime.parse(json['lastSync'] as String)

          : null,

      isActive: json['isActive'] as bool? ?? true,

      createdAt: json['createdAt'] != null 

          ? DateTime.parse(json['createdAt'] as String)

          : DateTime.now(),

      screenSize: json['screenSize'] as String?,

      location: json['location'] as String?,

      notes: json['notes'] as String?,

      // Novos campos Minew

      displayName: json['displayName'] as String?,

      displayOrder: json['displayOrder'] as int? ?? 0,

      minewDeviceId: json['minewDeviceId'] as String?,

      minewSyncStatus: json['minewSyncStatus'] as String?,

      screenColor: json['screenColor'] as String?,

      isOnline: json['isOnline'] as bool? ?? false,

      lastSeen: json['lastSeen'] != null

          ? DateTime.parse(json['lastSeen'] as String)

          : null,

    );

  }



  /// Converte para JSON

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'macAddress': macAddress,

      'storeId': storeId,

      'productId': productId,

      'productName': productName,

      'type': type.value,

      'status': status.value,

      'batteryLevel': batteryLevel,

      'signalStrength': signalStrength,

      'temperature': temperature,

      'firmware': firmware,

      'lastSync': lastSync?.toIso8601String(),

      'isActive': isActive,

      'createdAt': createdAt.toIso8601String(),

      'screenSize': screenSize,

      'location': location,

      'notes': notes,

      // Novos campos Minew

      'displayName': displayName,

      'displayOrder': displayOrder,

      'minewDeviceId': minewDeviceId,

      'minewSyncStatus': minewSyncStatus,

      'screenColor': screenColor,

      'isOnline': isOnline,

      'lastSeen': lastSeen?.toIso8601String(),

    };

  }



  /// Cria uma cópia com alterações

  TagModel copyWith({

    String? id,

    String? macAddress,

    String? storeId,

    String? productId,

    String? productName,

    TagType? type,

    TagStatus? status,

    int? batteryLevel,

    int? signalStrength,

    int? temperature,

    String? firmware,

    DateTime? lastSync,

    bool? isActive,

    DateTime? createdAt,

    String? screenSize,

    String? location,

    String? notes,

    // Novos campos Minew

    String? displayName,

    int? displayOrder,

    String? minewDeviceId,

    String? minewSyncStatus,

    String? screenColor,

    bool? isOnline,

    DateTime? lastSeen,

  }) {

    return TagModel(

      // ignore: argument_type_not_assignable
      id: id ?? this.id,

      macAddress: macAddress ?? this.macAddress,

      storeId: storeId ?? this.storeId,

      productId: productId ?? this.productId,

      productName: productName ?? this.productName,

      type: type ?? this.type,

      status: status ?? this.status,

      batteryLevel: batteryLevel ?? this.batteryLevel,

      signalStrength: signalStrength ?? this.signalStrength,

      temperature: temperature ?? this.temperature,

      firmware: firmware ?? this.firmware,

      lastSync: lastSync ?? this.lastSync,

      isActive: isActive ?? this.isActive,

      createdAt: createdAt ?? this.createdAt,

      screenSize: screenSize ?? this.screenSize,

      location: location ?? this.location,

      notes: notes ?? this.notes,

      // Novos campos Minew

      displayName: displayName ?? this.displayName,

      displayOrder: displayOrder ?? this.displayOrder,

      minewDeviceId: minewDeviceId ?? this.minewDeviceId,

      minewSyncStatus: minewSyncStatus ?? this.minewSyncStatus,

      screenColor: screenColor ?? this.screenColor,

      isOnline: isOnline ?? this.isOnline,

      lastSeen: lastSeen ?? this.lastSeen,

    );

  }



  @override

  String toString() {

    return 'TagModel(mac: $macAddress, status: $status, product: $productName, online: $isOnline)';

  }

}



/// Tipo de etiqueta eletrônica

/// Mapeado para: ESLType do backend

enum TagType {

  twoInchBW(0, '2.13" P&B', 'Etiqueta 2.13 polegadas preto e branco'),

  twoInch3Color(1, '2.13" 3 Cores', 'Etiqueta 2.13 polegadas 3 cores'),

  fourInchBW(2, '4.2" P&B', 'Etiqueta 4.2 polegadas preto e branco'),

  sevenInch3Color(3, '7.5" 3 Cores', 'Etiqueta 7.5 polegadas 3 cores');



  final int value;

  final String label;

  final String description;



  const TagType(this.value, this.label, this.description);



  /// Cria a partir do valor numérico

  factory TagType.fromValue(int value) {

    return TagType.values.firstWhere(

      (type) => type.value == value,

      orElse: () => TagType.twoInchBW,

    );

  }

}



/// Status da etiqueta

/// Mapeado para: ESLStatus do backend

enum TagStatus {

  unknown(0, 'Desconhecido'),

  online(1, 'Online'),

  offline(2, 'Offline'),

  lowBattery(5, 'Bateria Baixa'),

  bound(8, 'Vinculada'),

  unbound(9, 'Disponível');



  final int value;

  final String label;



  const TagStatus(this.value, this.label);



  /// Cria a partir do valor numérico

  factory TagStatus.fromValue(int value) {

    return TagStatus.values.firstWhere(

      (status) => status.value == value,

      orElse: () => TagStatus.unknown,

    );

  }

}



/// DTO para criação de tag

/// Mapeado para: CreateTagDto do backend

class CreateTagRequest {

  final String macAddress;

  final String storeId;

  final int type;



  const CreateTagRequest({

    required this.macAddress,

    required this.storeId,

    this.type = 0,

  });



  Map<String, dynamic> toJson() {

    return {

      'macAddress': macAddress,

      'storeId': storeId,

      'type': type,

    };

  }

}



/// DTO para adicionar tags em lote

/// Mapeado para: BatchAddTagsDto do backend

class BatchAddTagsRequest {

  final String storeId;

  final List<String> macAddresses;

  final int type;



  const BatchAddTagsRequest({

    required this.storeId,

    required this.macAddresses,

    this.type = 0,

  });



  Map<String, dynamic> toJson() {

    return {

      'storeId': storeId,

      'macAddresses': macAddresses,

      'type': type,

    };

  }

}



/// DTO para vincular tag a produto

/// Mapeado para: BindTagDto do backend

class BindTagRequest {

  final String productId;



  const BindTagRequest({

    required this.productId,

  });



  Map<String, dynamic> toJson() {

    return {

      'productId': productId,

    };

  }

}



/// DTO para vincular tags em lote

/// Mapeado para: BatchBindTagsDto do backend

class BatchBindTagsRequest {

  final String storeId;

  final List<TagProductBinding> bindings;



  const BatchBindTagsRequest({

    required this.storeId,

    required this.bindings,

  });



  Map<String, dynamic> toJson() {

    return {

      'storeId': storeId,

      'bindings': bindings.map((b) => b.toJson()).toList(),

    };

  }

}



/// Binding individual para lote

class TagProductBinding {

  final String macAddress;

  final String productId;



  const TagProductBinding({

    required this.macAddress,

    required this.productId,

  });



  Map<String, dynamic> toJson() {

    return {

      'macAddress': macAddress,

      'productId': productId,

    };

  }

}



/// Resposta paginada de tags

class TagsPagedResponse {

  final int currentPage;

  final int pageSize;

  final int totalCount;

  final int totalPages;

  final List<TagModel> items;



  const TagsPagedResponse({

    required this.currentPage,

    required this.pageSize,

    required this.totalCount,

    required this.totalPages,

    required this.items,

  });



  factory TagsPagedResponse.fromJson(Map<String, dynamic> json) {

    return TagsPagedResponse(

      currentPage: json['currentPage'] as int? ?? 1,

      pageSize: json['pageSize'] as int? ?? 50,

      totalCount: json['totalCount'] as int? ?? 0,

      totalPages: json['totalPages'] as int? ?? 0,

      items: (json['items'] as List? ?? [])

          // ignore: argument_type_not_assignable
          .map((item) => TagModel.fromJson(item))

          .toList(),

    );

  }

}



/// Resultado de operação em lote

class BatchOperationResult {

  final int successCount;

  final int failureCount;

  final List<String> errors;



  const BatchOperationResult({

    required this.successCount,

    required this.failureCount,

    required this.errors,

  });



  /// Total de operações (sucesso + falha)

  int get total => successCount + failureCount;



  factory BatchOperationResult.fromJson(Map<String, dynamic> json) {

    return BatchOperationResult(

      successCount: json['successCount'] as int? ?? 0,

      failureCount: json['failureCount'] as int? ?? 0,

      errors: (json['errors'] as List? ?? []).cast<String>(),

    );

  }

}



/// DTO para atualização de tag

/// Mapeado para: UpdateTagDto do backend

class UpdateTagDto {

  final String? displayName;

  final int? displayOrder;

  final String? location;

  final String? notes;

  final bool? isActive;

  final TagStatus? status;



  const UpdateTagDto({

    this.displayName,

    this.displayOrder,

    this.location,

    this.notes,

    this.isActive,

    this.status,

  });



  Map<String, dynamic> toJson() {

    return {

      if (displayName != null) 'displayName': displayName,

      if (displayOrder != null) 'displayOrder': displayOrder,

      if (location != null) 'location': location,

      if (notes != null) 'notes': notes,

      if (isActive != null) 'isActive': isActive,

      if (status != null) 'status': status!.value,

    };

  }

}



/// Histórico de importação de tags

class TagImportHistory {

  final String id;

  final String fileName;

  final DateTime importedAt;

  final int totalCount;

  final int successCount;

  final int failedCount;

  final String duration;

  final String importedBy;

  final String fileSize;



  const TagImportHistory({

    required this.id,

    required this.fileName,

    required this.importedAt,

    required this.totalCount,

    required this.successCount,

    required this.failedCount,

    required this.duration,

    required this.importedBy,

    required this.fileSize,

  });



  factory TagImportHistory.fromJson(Map<String, dynamic> json) {

    return TagImportHistory(

      id: json['id'] as String? ?? '',

      fileName: json['fileName'] as String? ?? '',

      importedAt: DateTime.tryParse(json['importedAt'] as String? ?? '') ?? DateTime.now(),

      totalCount: json['totalCount'] as int? ?? 0,

      successCount: json['successCount'] as int? ?? 0,

      failedCount: json['failedCount'] as int? ?? 0,

      duration: json['duration'] as String? ?? '',

      importedBy: json['importedBy'] as String? ?? '',

      fileSize: json['fileSize'] as String? ?? '',

    );

  }

}



/// Estatísticas de tags

class TagStats {

  final int total;

  final int online;

  final int offline;

  final int bound;

  final int available;

  final int lowBattery;

  final double averageBattery;

  final DateTime? lastSync;



  const TagStats({

    required this.total,

    required this.online,

    required this.offline,

    required this.bound,

    required this.available,

    required this.lowBattery,

    required this.averageBattery,

    this.lastSync,

  });



  factory TagStats.fromJson(Map<String, dynamic> json) {

    return TagStats(

      total: json['total'] as int? ?? 0,

      online: json['online'] as int? ?? 0,

      offline: json['offline'] as int? ?? 0,

      bound: json['bound'] as int? ?? 0,

      available: json['available'] as int? ?? 0,

      lowBattery: json['lowBattery'] as int? ?? 0,

      averageBattery: (json['averageBattery'] as num?)?.toDouble() ?? 100.0,

      lastSync: json['lastSync'] != null 

          ? DateTime.tryParse(json['lastSync'] as String)

          : null,

    );

  }

}



/// Item para importação de tag

class TagImportItem {

  final String macAddress;

  final int type;

  final String? productCode;



  const TagImportItem({

    required this.macAddress,

    this.type = 0,

    this.productCode,

  });



  Map<String, dynamic> toJson() {

    return {

      'macAddress': macAddress,

      'type': type,

      if (productCode != null) 'productCode': productCode,

    };

  }

}



/// Resultado de importação de tags

class TagImportResult {

  final String importId;

  final int totalProcessed;

  final int successCount;

  final int failedCount;

  final List<String> failedMacs;

  final List<String> errors;

  final String duration;

  final DateTime importedAt;



  const TagImportResult({

    required this.importId,

    required this.totalProcessed,

    required this.successCount,

    required this.failedCount,

    required this.failedMacs,

    required this.errors,

    required this.duration,

    required this.importedAt,

  });



  factory TagImportResult.fromJson(Map<String, dynamic> json) {

    return TagImportResult(

      importId: json['importId'] as String? ?? '',

      totalProcessed: json['totalProcessed'] as int? ?? 0,

      successCount: json['successCount'] as int? ?? 0,

      failedCount: json['failedCount'] as int? ?? 0,

      failedMacs: (json['failedMacs'] as List? ?? []).cast<String>(),

      errors: (json['errors'] as List? ?? []).cast<String>(),

      duration: json['duration'] as String? ?? '',

      importedAt: DateTime.tryParse(json['importedAt'] as String? ?? '') ?? DateTime.now(),

    );

  }

}



/// Detalhes de vinculação de uma tag

/// Mapeado para: TagBindingDetailsDto do backend

class TagBindingDetails {

  final String macAddress;

  final String? productId;

  final String? productName;

  final String? productCode;

  final String? categoryName;

  final double? price;

  final DateTime? boundAt;

  final String? boundBy;

  final bool isBound;



  const TagBindingDetails({

    required this.macAddress,

    this.productId,

    this.productName,

    this.productCode,

    this.categoryName,

    this.price,

    this.boundAt,

    this.boundBy,

    required this.isBound,

  });



  factory TagBindingDetails.fromJson(Map<String, dynamic> json) {

    return TagBindingDetails(

      macAddress: json['macAddress'] as String? ?? '',

      productId: json['productId'] as String?,

      productName: json['productName'] as String?,

      productCode: json['productCode'] as String?,

      categoryName: json['categoryName'] as String?,

      price: (json['price'] as num?)?.toDouble(),

      boundAt: json['boundAt'] != null

          ? DateTime.tryParse(json['boundAt'] as String)

          : null,

      boundBy: json['boundBy'] as String?,

      isBound: json['isBound'] as bool? ?? false,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'macAddress': macAddress,

      'productId': productId,

      'productName': productName,

      'productCode': productCode,

      'categoryName': categoryName,

      'price': price,

      'boundAt': boundAt?.toIso8601String(),

      'boundBy': boundBy,

      'isBound': isBound,

    };

  }

}







