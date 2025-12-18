/// Modelo para vinculação Produto-Tag (N:N)

/// Um produto pode ter múltiplas tags vinculadas

class ProductTagModel {

  final int id;

  final String productId;

  final String productName;

  final String tagMacAddress;

  final String storeId;

  final String? location;

  final String? description;

  final bool isPrimary;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? lastPriceSync;

  final TagSyncStatus syncStatus;



  ProductTagModel({

    required this.id,

    required this.productId,

    required this.productName,

    required this.tagMacAddress,

    required this.storeId,

    this.location,

    this.description,

    this.isPrimary = false,

    this.isActive = true,

    required this.createdAt,

    this.lastPriceSync,

    this.syncStatus = TagSyncStatus.pending,

  });



  ProductTagModel copyWith({

    int? id,

    String? productId,

    String? productName,

    String? tagMacAddress,

    String? storeId,

    String? location,

    String? description,

    bool? isPrimary,

    bool? isActive,

    DateTime? createdAt,

    DateTime? lastPriceSync,

    TagSyncStatus? syncStatus,

  }) {

    return ProductTagModel(

      id: id ?? this.id,

      productId: productId ?? this.productId,

      productName: productName ?? this.productName,

      tagMacAddress: tagMacAddress ?? this.tagMacAddress,

      storeId: storeId ?? this.storeId,

      location: location ?? this.location,

      description: description ?? this.description,

      isPrimary: isPrimary ?? this.isPrimary,

      isActive: isActive ?? this.isActive,

      createdAt: createdAt ?? this.createdAt,

      lastPriceSync: lastPriceSync ?? this.lastPriceSync,

      syncStatus: syncStatus ?? this.syncStatus,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'productId': productId,

      'productName': productName,

      'tagMacAddress': tagMacAddress,

      'storeId': storeId,

      'location': location,

      'description': description,

      'isPrimary': isPrimary,

      'isActive': isActive,

      'createdAt': createdAt.toIso8601String(),

      'lastPriceSync': lastPriceSync?.toIso8601String(),

      'syncStatus': syncStatus.name,

    };

  }



  factory ProductTagModel.fromJson(Map<String, dynamic> json) {

    return ProductTagModel(

      id: json['id'] as int ?? 0,

      productId: json['productId'] as String ?? '',

      productName: json['productName'] as String ?? '',

      tagMacAddress: json['tagMacAddress'] as String ?? '',

      storeId: json['storeId'] as String ?? '',

      location: json['location'],

      description: json['description'],

      isPrimary: json['isPrimary'] as bool ?? false,

      isActive: json['isActive'] as bool ?? true,

      createdAt: json['createdAt'] != null 

          ? DateTime.parse(json['createdAt'] as String) 

          : DateTime.now(),

      lastPriceSync: json['lastPriceSync'] != null 

          ? DateTime.parse(json['lastPriceSync'] as String) 

          : null,

      syncStatus: TagSyncStatus.fromString(json['syncStatus'] as String ?? 'pending'),

    );

  }

}



/// DTO para criar vinculação

class CreateProductTagDto {

  final String productId;

  final String tagMacAddress;

  final String? location;

  final String? description;

  final bool isPrimary;



  CreateProductTagDto({

    required this.productId,

    required this.tagMacAddress,

    this.location,

    this.description,

    this.isPrimary = false,

  });



  Map<String, dynamic> toJson() {

    return {

      'productId': productId,

      'tagMacAddress': tagMacAddress,

      'location': location,

      'description': description,

      'isPrimary': isPrimary,

    };

  }

}



/// DTO para atualizar vinculação

class UpdateProductTagDto {

  final String? location;

  final String? description;

  final bool? isPrimary;

  final bool? isActive;



  UpdateProductTagDto({

    this.location,

    this.description,

    this.isPrimary,

    this.isActive,

  });



  Map<String, dynamic> toJson() {

    final map = <String, dynamic>{};

    if (location != null) map['location'] = location;

    if (description != null) map['description'] = description;

    if (isPrimary != null) map['isPrimary'] = isPrimary;

    if (isActive != null) map['isActive'] = isActive;

    return map;

  }

}



/// Resultado de sincronização de preço

class PriceSyncResult {

  final int productTagId;

  final String tagMacAddress;

  final String productId;

  final double price;

  final bool success;

  final String? error;

  final DateTime syncedAt;



  PriceSyncResult({

    required this.productTagId,

    required this.tagMacAddress,

    required this.productId,

    required this.price,

    required this.success,

    this.error,

    required this.syncedAt,

  });



  factory PriceSyncResult.fromJson(Map<String, dynamic> json) {

    return PriceSyncResult(

      productTagId: json['productTagId'] as int ?? 0,

      tagMacAddress: json['tagMacAddress'] as String ?? '',

      productId: json['productId'] as String ?? '',

      price: ((json['price'] ?? 0) as num?)?.toDouble() ?? 0.0,

      success: json['success'] as bool ?? false,

      error: json['error'],

      syncedAt: json['syncedAt'] != null 

          ? DateTime.parse(json['syncedAt'] as String) 

          : DateTime.now(),

    );

  }

}



/// Lista de tags vinculadas a um produto

class ProductTagsList {

  final String productId;

  final String productName;

  final double currentPrice;

  final List<TagBinding> linkedTags;



  ProductTagsList({

    required this.productId,

    required this.productName,

    required this.currentPrice,

    required this.linkedTags,

  });



  factory ProductTagsList.fromJson(Map<String, dynamic> json) {

    return ProductTagsList(

      productId: json['productId'] as String ?? '',

      productName: json['productName'] as String ?? '',

      currentPrice: ((json['currentPrice'] ?? 0) as num?)?.toDouble() ?? 0.0,

      linkedTags: (json['linkedTags'] as List<dynamic>?)

          ?.map((e) => TagBinding.fromJson(e))

          .toList() ?? [],

    );

  }

}



/// Vinculação simplificada de tag

class TagBinding {

  final int productTagId;

  final String tagMacAddress;

  final String? location;

  final bool isPrimary;

  final bool isActive;

  final DateTime? lastPriceSync;

  final TagSyncStatus syncStatus;



  TagBinding({

    required this.productTagId,

    required this.tagMacAddress,

    this.location,

    this.isPrimary = false,

    this.isActive = true,

    this.lastPriceSync,

    this.syncStatus = TagSyncStatus.pending,

  });



  factory TagBinding.fromJson(Map<String, dynamic> json) {

    return TagBinding(

      productTagId: json['productTagId'] as int ?? 0,

      tagMacAddress: json['tagMacAddress'] as String ?? '',

      location: json['location'],

      isPrimary: json['isPrimary'] as bool ?? false,

      isActive: json['isActive'] as bool ?? true,

      lastPriceSync: json['lastPriceSync'] != null 

          ? DateTime.parse(json['lastPriceSync'] as String) 

          : null,

      syncStatus: TagSyncStatus.fromString(json['syncStatus'] as String ?? 'pending'),

    );

  }

}



/// Status de sincronização de tags

enum TagSyncStatus {

  pending,

  synced,

  error,

  syncing;



  static TagSyncStatus fromString(String value) {

    switch (value.toLowerCase()) {

      case 'synced':

        return TagSyncStatus.synced;

      case 'error':

        return TagSyncStatus.error;

      case 'syncing':

        return TagSyncStatus.syncing;

      default:

        return TagSyncStatus.pending;

    }

  }

}





