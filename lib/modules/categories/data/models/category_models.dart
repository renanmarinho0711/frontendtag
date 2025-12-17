// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tagbean/design_system/design_system.dart';
import 'package:flutter/material.dart';



/// Enum para status da categoria
enum CategoryStatus {
  active,
  inactive,
  archived;

  String get label {
    switch (this) {
      case CategoryStatus.active:
        return 'Ativa';
      case CategoryStatus.inactive:
        return 'Inativa';
      case CategoryStatus.archived:
        return 'Arquivada';
    }
  }

  Color get color {
    switch (this) {
      case CategoryStatus.active:
        return AppThemeColors.greenMaterial;
      case CategoryStatus.inactive:
        return AppThemeColors.orangeMaterial;
      case CategoryStatus.archived:
        return AppThemeColors.grey500;
    }
  }

  /// Obtém a cor dinâmica do status (requer BuildContext)
  Color dynamicColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    switch (this) {
      case CategoryStatus.active:
        return colors.greenMaterial;
      case CategoryStatus.inactive:
        return colors.orangeMaterial;
      case CategoryStatus.archived:
        return colors.grey500;
    }
  }

  IconData get icon {
    switch (this) {
      case CategoryStatus.active:
        return Icons.check_circle_rounded;
      case CategoryStatus.inactive:
        return Icons.pause_circle_rounded;
      case CategoryStatus.archived:
        return Icons.archive_rounded;
    }
  }
}

/// Modelo de Categoria
class CategoryModel {
  final String id;
  final String nome;
  final String? descricao;
  final String? icone;
  final Color cor;
  final String? parentId;
  final int quantidadeProdutos;
  final CategoryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.nome,
    this.descricao,
    this.icone,
    required this.cor,
    this.parentId,
    this.quantidadeProdutos = 0,
    this.status = CategoryStatus.active,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verifica se a categoria est� ativa
  bool get isActive => status == CategoryStatus.active;

  /// Verifica se tem subcategorias
  bool get hasParent => parentId != null;

  /// Retorna o IconData baseado na string do �cone
  IconData get iconData {
    if (icone == null) return Icons.category_rounded;
    
    final iconMap = {
      'local_drink_rounded': Icons.local_drink_rounded,
      'restaurant_rounded': Icons.restaurant_rounded,
      'cake_rounded': Icons.cake_rounded,
      'coffee_rounded': Icons.coffee_rounded,
      'fastfood_rounded': Icons.fastfood_rounded,
      'icecream_rounded': Icons.icecream_rounded,
      'liquor_rounded': Icons.liquor_rounded,
      'lunch_dining_rounded': Icons.lunch_dining_rounded,
      'local_pizza_rounded': Icons.local_pizza_rounded,
      'emoji_food_beverage_rounded': Icons.emoji_food_beverage_rounded,
      'bakery_dining_rounded': Icons.bakery_dining_rounded,
      'ramen_dining_rounded': Icons.ramen_dining_rounded,
      'set_meal_rounded': Icons.set_meal_rounded,
      'breakfast_dining_rounded': Icons.breakfast_dining_rounded,
      'dinner_dining_rounded': Icons.dinner_dining_rounded,
      'category_rounded': Icons.category_rounded,
    };
    
    return iconMap[icone] ?? Icons.category_rounded;
  }

  CategoryModel copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? icone,
    Color? cor,
    String? parentId,
    int? quantidadeProdutos,
    CategoryStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      icone: icone ?? this.icone,
      cor: cor ?? this.cor,
      parentId: parentId ?? this.parentId,
      quantidadeProdutos: quantidadeProdutos ?? this.quantidadeProdutos,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      nome: json['name'] as String? ?? json['nome'] as String? ?? '',
      descricao: json['description'] as String? ?? json['descricao'] as String?,
      icone: json['icon'] as String? ?? json['icone'] as String?,
      cor: _parseColor(json['color'] ?? json['cor']),
      parentId: json['parentId'] as String?,
      quantidadeProdutos: json['productCount'] as int? ?? json['quantidadeProdutos'] as int? ?? 0,
      status: _parseStatus(json['isActive'] ?? json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'icone': icone,
      'cor': '#${cor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      'parentId': parentId,
      'quantidadeProdutos': quantidadeProdutos,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static Color _parseColor(dynamic colorValue) {
    if (colorValue == null) return AppThemeColors.grey500;
    if (colorValue is Color) return colorValue;
    if (colorValue is int) return Color(colorValue);
    if (colorValue is String) {
      // Remove # se existir
      String hex = colorValue.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    }
    return AppThemeColors.grey500;
  }

  static CategoryStatus _parseStatus(dynamic statusValue) {
    if (statusValue == null) return CategoryStatus.active;
    if (statusValue is bool) {
      return statusValue ? CategoryStatus.active : CategoryStatus.inactive;
    }
    if (statusValue is String) {
      return CategoryStatus.values.firstWhere(
        (s) => s.name == statusValue,
        orElse: () => CategoryStatus.active,
      );
    }
    return CategoryStatus.active;
  }
}

/// Modelo para estat�sticas de categoria
class CategoryStatsModel {
  final String categoryId;
  final String categoryName;
  final int totalProdutos;
  final int produtosAtivos;
  final int produtosInativos;
  final double valorTotalEstoque;
  final double margemMedia;
  final int vendasUltimos30Dias;
  final double receita30Dias;
  
  // Campos adicionais para estat�sticas detalhadas
  final int totalVendas;
  final double faturamento;
  final double percentualParticipacao;
  final double crescimento;
  final double ticketMedio;
  final double margemLucro;

  const CategoryStatsModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalProdutos,
    required this.produtosAtivos,
    required this.produtosInativos,
    required this.valorTotalEstoque,
    required this.margemMedia,
    required this.vendasUltimos30Dias,
    required this.receita30Dias,
    this.totalVendas = 0,
    this.faturamento = 0.0,
    this.percentualParticipacao = 0.0,
    this.crescimento = 0.0,
    this.ticketMedio = 0.0,
    this.margemLucro = 0.0,
  });

  double get percentualAtivos => 
      totalProdutos > 0 ? (produtosAtivos / totalProdutos) * 100 : 0;

  /// Factory para criar inst�ncia vazia com apenas o ID
  factory CategoryStatsModel.empty(String categoryId) {
    return CategoryStatsModel(
      categoryId: categoryId,
      categoryName: '',
      totalProdutos: 0,
      produtosAtivos: 0,
      produtosInativos: 0,
      valorTotalEstoque: 0.0,
      margemMedia: 0.0,
      vendasUltimos30Dias: 0,
      receita30Dias: 0.0,
      totalVendas: 0,
      faturamento: 0.0,
      percentualParticipacao: 0.0,
      crescimento: 0.0,
      ticketMedio: 0.0,
      margemLucro: 0.0,
    );
  }

  factory CategoryStatsModel.fromJson(Map<String, dynamic> json) {
    return CategoryStatsModel(
      categoryId: json['categoryId'] as String? ?? json['id'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? json['nome'] as String? ?? '',
      totalProdutos: json['totalProdutos'] as int? ?? 0,
      produtosAtivos: json['produtosAtivos'] as int? ?? 0,
      produtosInativos: json['produtosInativos'] as int? ?? 0,
      valorTotalEstoque: (json['valorTotalEstoque'] as num?)?.toDouble() ?? 0.0,
      margemMedia: (json['margemMedia'] as num?)?.toDouble() ?? 0.0,
      vendasUltimos30Dias: json['vendasUltimos30Dias'] as int? ?? 0,
      receita30Dias: (json['receita30Dias'] as num?)?.toDouble() ?? 0.0,
      totalVendas: json['totalVendas'] as int? ?? 0,
      faturamento: (json['faturamento'] as num?)?.toDouble() ?? 0.0,
      percentualParticipacao: (json['percentualParticipacao'] as num?)?.toDouble() ?? 0.0,
      crescimento: (json['crescimento'] as num?)?.toDouble() ?? 0.0,
      ticketMedio: (json['ticketMedio'] as num?)?.toDouble() ?? 0.0,
      margemLucro: (json['margemLucro'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'totalProdutos': totalProdutos,
      'produtosAtivos': produtosAtivos,
      'produtosInativos': produtosInativos,
      'valorTotalEstoque': valorTotalEstoque,
      'margemMedia': margemMedia,
      'vendasUltimos30Dias': vendasUltimos30Dias,
      'receita30Dias': receita30Dias,
      'totalVendas': totalVendas,
      'faturamento': faturamento,
      'percentualParticipacao': percentualParticipacao,
      'crescimento': crescimento,
      'ticketMedio': ticketMedio,
      'margemLucro': margemLucro,
    };
  }
}

/// Modelo de produto simplificado para listagem por categoria
class CategoryProductModel {
  final String id;
  final String nome;
  final String? ean;
  final String? sku;
  final double preco;
  final int estoque;
  final bool ativo;
  final String? imagemUrl;

  const CategoryProductModel({
    required this.id,
    required this.nome,
    this.ean,
    this.sku,
    required this.preco,
    required this.estoque,
    this.ativo = true,
    this.imagemUrl,
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      id: json['id'] as String,
      nome: json['name'] as String? ?? json['nome'] as String? ?? '',
      ean: json['ean'] as String?,
      sku: json['sku'] as String?,
      preco: (json['price'] as num?)?.toDouble() ?? (json['preco'] as num?)?.toDouble() ?? 0.0,
      estoque: json['stock'] as int? ?? json['estoque'] as int? ?? 0,
      ativo: json['isActive'] as bool? ?? json['ativo'] as bool? ?? true,
      imagemUrl: json['imageUrl'] as String? ?? json['imagemUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'ean': ean,
      'sku': sku,
      'price': preco,
      'stock': estoque,
      'isActive': ativo,
      'imageUrl': imagemUrl,
    };
  }
}

/// Modelo de categoria sugerida pelo sistema
class SuggestedCategoryModel {
  final String nome;
  final String icone;
  final Color cor;
  final String? descricao;

  const SuggestedCategoryModel({
    required this.nome,
    required this.icone,
    required this.cor,
    this.descricao,
  });

  IconData get iconData {
    final iconMap = {
      'local_drink': Icons.local_drink_rounded,
      'local_drink_rounded': Icons.local_drink_rounded,
      'shopping_basket': Icons.shopping_basket_rounded,
      'shopping_basket_rounded': Icons.shopping_basket_rounded,
      'restaurant': Icons.restaurant_rounded,
      'restaurant_rounded': Icons.restaurant_rounded,
      'cleaning_services': Icons.cleaning_services_rounded,
      'cleaning_services_rounded': Icons.cleaning_services_rounded,
      'wash': Icons.wash_rounded,
      'wash_rounded': Icons.wash_rounded,
      'bakery_dining': Icons.bakery_dining_rounded,
      'bakery_dining_rounded': Icons.bakery_dining_rounded,
      'ac_unit': Icons.ac_unit_rounded,
      'ac_unit_rounded': Icons.ac_unit_rounded,
      'set_meal': Icons.set_meal_rounded,
      'set_meal_rounded': Icons.set_meal_rounded,
      'eco': Icons.eco_rounded,
      'eco_rounded': Icons.eco_rounded,
      'kitchen': Icons.kitchen_rounded,
      'kitchen_rounded': Icons.kitchen_rounded,
      'fastfood': Icons.fastfood_rounded,
      'fastfood_rounded': Icons.fastfood_rounded,
      'pets': Icons.pets_rounded,
      'pets_rounded': Icons.pets_rounded,
      'cake': Icons.cake_rounded,
      'cake_rounded': Icons.cake_rounded,
      'breakfast_dining': Icons.breakfast_dining_rounded,
      'breakfast_dining_rounded': Icons.breakfast_dining_rounded,
      'dinner_dining': Icons.dinner_dining_rounded,
      'dinner_dining_rounded': Icons.dinner_dining_rounded,
      'child_care': Icons.child_care_rounded,
      'child_care_rounded': Icons.child_care_rounded,
      'grass': Icons.grass_rounded,
      'grass_rounded': Icons.grass_rounded,
      'storefront': Icons.storefront_rounded,
      'storefront_rounded': Icons.storefront_rounded,
      'directions_car': Icons.directions_car_rounded,
      'directions_car_rounded': Icons.directions_car_rounded,
      'devices': Icons.devices_rounded,
      'devices_rounded': Icons.devices_rounded,
      'category': Icons.category_rounded,
      'category_rounded': Icons.category_rounded,
    };
    return iconMap[icone] ?? Icons.category_rounded;
  }

  factory SuggestedCategoryModel.fromJson(Map<String, dynamic> json) {
    return SuggestedCategoryModel(
      nome: json['name'] as String? ?? json['nome'] as String? ?? '',
      icone: json['icon'] as String? ?? json['icone'] as String? ?? 'category',
      cor: CategoryModel._parseColor(json['color'] ?? json['cor']),
      descricao: json['description'] as String? ?? json['descricao'] as String?,
    );
  }
}

/// Modelo de categoria com lista de produtos
class CategoryWithProductsModel {
  final String id;
  final String nome;
  final String? icone;
  final Color cor;
  final String? descricao;
  final int quantidadeProdutos;
  final List<CategoryProductModel> produtos;

  const CategoryWithProductsModel({
    required this.id,
    required this.nome,
    this.icone,
    required this.cor,
    this.descricao,
    required this.quantidadeProdutos,
    required this.produtos,
  });

  IconData get iconData {
    final iconMap = {
      'local_drink': Icons.local_drink_rounded,
      'local_drink_rounded': Icons.local_drink_rounded,
      'shopping_basket': Icons.shopping_basket_rounded,
      'shopping_basket_rounded': Icons.shopping_basket_rounded,
      'restaurant': Icons.restaurant_rounded,
      'restaurant_rounded': Icons.restaurant_rounded,
      'cleaning_services': Icons.cleaning_services_rounded,
      'cleaning_services_rounded': Icons.cleaning_services_rounded,
      'wash': Icons.wash_rounded,
      'wash_rounded': Icons.wash_rounded,
      'bakery_dining': Icons.bakery_dining_rounded,
      'bakery_dining_rounded': Icons.bakery_dining_rounded,
      'ac_unit': Icons.ac_unit_rounded,
      'ac_unit_rounded': Icons.ac_unit_rounded,
      'set_meal': Icons.set_meal_rounded,
      'set_meal_rounded': Icons.set_meal_rounded,
      'eco': Icons.eco_rounded,
      'eco_rounded': Icons.eco_rounded,
      'kitchen': Icons.kitchen_rounded,
      'kitchen_rounded': Icons.kitchen_rounded,
      'fastfood': Icons.fastfood_rounded,
      'fastfood_rounded': Icons.fastfood_rounded,
      'pets': Icons.pets_rounded,
      'pets_rounded': Icons.pets_rounded,
      'cake': Icons.cake_rounded,
      'cake_rounded': Icons.cake_rounded,
      'category': Icons.category_rounded,
      'category_rounded': Icons.category_rounded,
    };
    return iconMap[icone] ?? Icons.category_rounded;
  }

  factory CategoryWithProductsModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>? ?? [];
    return CategoryWithProductsModel(
      id: json['id'] as String,
      nome: json['name'] as String? ?? json['nome'] as String? ?? '',
      icone: json['icon'] as String? ?? json['icone'] as String?,
      cor: CategoryModel._parseColor(json['color'] ?? json['cor']),
      descricao: json['description'] as String? ?? json['descricao'] as String?,
      quantidadeProdutos: json['productCount'] as int? ?? json['quantidadeProdutos'] as int? ?? 0,
      produtos: productsJson.map((p) => CategoryProductModel.fromJson(p as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'icon': icone,
      'color': '#${cor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      'description': descricao,
      'productCount': quantidadeProdutos,
      'products': produtos.map((p) => p.toJson()).toList(),
    };
  }
}



