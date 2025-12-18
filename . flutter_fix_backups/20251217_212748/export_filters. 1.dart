/// Filtros para exportação
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

  factory ExportFilters.fromJson(Map<String, dynamic> json) {
    return ExportFilters(
      categoryId: json['categoryId'],
      categoryIds: (json['categoryIds'] as List?)?.map((e) => e.toString()).toList(),
      isActive: json['isActive'],
      minPrice: json['minPrice']?.toDouble(),
      maxPrice: json['maxPrice']?.toDouble(),
      minStock: json['minStock'],
      maxStock: json['maxStock'],
      createdFrom: json['createdFrom'] != null 
          ? DateTime.tryParse(json['createdFrom']) 
          : null,
      createdTo: json['createdTo'] != null 
          ? DateTime.tryParse(json['createdTo']) 
          : null,
      searchTerm: json['searchTerm'],
    );
  }

  ExportFilters copyWith({
    String? categoryId,
    List<String>? categoryIds,
    bool? isActive,
    double? minPrice,
    double? maxPrice,
    int? minStock,
    int? maxStock,
    DateTime? createdFrom,
    DateTime? createdTo,
    String? searchTerm,
  }) {
    return ExportFilters(
      categoryId: categoryId ?? this.categoryId,
      categoryIds: categoryIds ?? this.categoryIds,
      isActive: isActive ?? this.isActive,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      createdFrom: createdFrom ?? this.createdFrom,
      createdTo: createdTo ?? this.createdTo,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
