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

    // ignore: argument_type_not_assignable
    bool? isActive,
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    DateTime? createdAt,
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    DateTime? lastPriceSync,
 // ignore: argument_type_not_assignable

    // ignore: argument_type_not_assignable
    TagSyncStatus? syncStatus,
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  }) {

    // ignore: argument_type_not_assignable
    return ProductTagModel(

      id: id ?? this.id,
 // ignore: argument_type_not_assignable

      productId: productId ?? this.productId,
 // ignore: argument_type_not_assignable

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

      // ignore: argument_type_not_assignable
      id: json['id'] ?? 0,

      productId: (json['productId']).toString() ?? '',

      productName: (json['productName']).toString() ?? '',

      tagMacAddress: (json['tagMacAddress']).toString() ?? '',

      storeId: (json['storeId']).toString() ?? '',

      location: (json['location']).toString(),

      description: (json['description']).toString(),

      isPrimary: (json['isPrimary'] as bool?) ?? false,

      isActive: json['isActive'] ?? true,

      createdAt: (json['createdAt']).toString() != null 

          ? DateTime.parse((json['createdAt']).toString()) 

          : DateTime.now(),

      lastPriceSync: json['lastPriceSync'] != null 

          ? DateTime.parse((json['lastPriceSync']).toString()) 

          : null,

      syncStatus: TagSyncStatus.fromString((json['syncStatus']).toString() ?? 'pending'),

    );

  }

}



/// DTO para criar vinculação

// ignore: argument_type_not_assignable
class CreateProductTagDto {
 // ignore: argument_type_not_assignable

  // ignore: argument_type_not_assignable
  final String productId;

  // ignore: argument_type_not_assignable
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

    // ignore: argument_type_not_assignable
    return {
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      'productId': productId,
 // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
      'tagMacAddress': tagMacAddress,

      // ignore: argument_type_not_assignable
      'location': location,

      // ignore: argument_type_not_assignable
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

      // ignore: argument_type_not_assignable
      productTagId: json['productTagId'] ?? 0,

      tagMacAddress: (json['tagMacAddress']).toString() ?? '',

      productId: (json['productId']).toString() ?? '',

      // ignore: argument_type_not_assignable
      price: (json['price'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      success: json['success'] ?? false,

      error: (json['error']).toString(),

      syncedAt: json['syncedAt'] != null 

          ? DateTime.parse((json['syncedAt']).toString()) 

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

      productId: (json['productId']).toString() ?? '',

      productName: (json['productName']).toString() ?? '',

      // ignore: argument_type_not_assignable
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),

      linkedTags: (json['linkedTags'] as List<dynamic>?)

          // ignore: argument_type_not_assignable
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

      // ignore: argument_type_not_assignable
      productTagId: json['productTagId'] ?? 0,

      tagMacAddress: (json['tagMacAddress']).toString() ?? '',

      location: (json['location']).toString(),

      // ignore: argument_type_not_assignable
      isPrimary: json['isPrimary'] ?? false,

      // ignore: argument_type_not_assignable
      isActive: json['isActive'] ?? true,

      lastPriceSync: json['lastPriceSync'] != null 

          ? DateTime.parse((json['lastPriceSync']).toString()) 

          : null,

      syncStatus: TagSyncStatus.fromString((json['syncStatus']).toString() ?? 'pending'),

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





