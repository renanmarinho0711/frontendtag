import 'package:flutter/material.dart';

/// Tema de categoria de produtos
/// 
/// Define cores, ícones e gradientes para cada categoria de produto.
class CategoryTheme {
  final IconData icon;
  final Color color;
  final LinearGradient gradient;

  const CategoryTheme({
    required this.icon,
    required this.color,
    required this.gradient,
  });
}

/// Temas de categorias de produtos
/// 
/// Centraliza todos os temas visuais das categorias.
/// Uso: CategoryThemes.byName['Bebidas']
class CategoryThemes {
  CategoryThemes._();

  static const CategoryTheme bebidas = CategoryTheme(
    icon: Icons.local_drink_rounded,
    color: Color(0xFF2196F3), // categoryBebidas
    gradient: LinearGradient(
      colors: [Color(0xFF2196F3), Color(0xFF1565C0)], // categoryBebidas, categoryBebidasDark
    ),
  );

  static const CategoryTheme mercearia = CategoryTheme(
    icon: Icons.shopping_basket_rounded,
    color: Color(0xFFFF9800), // categoryMercearia
    gradient: LinearGradient(
      colors: [Color(0xFFFF9800), Color(0xFFEF6C00)], // categoryMercearia, categoryMerceariaDark
    ),
  );

  static const CategoryTheme pereciveis = CategoryTheme(
    icon: Icons.restaurant_rounded,
    color: Color(0xFFF44336), // categoryPereciveis
    gradient: LinearGradient(
      colors: [Color(0xFFF44336), Color(0xFFD32F2F)], // categoryPereciveis, categoryPereciveisDark
    ),
  );

  static const CategoryTheme limpeza = CategoryTheme(
    icon: Icons.cleaning_services_rounded,
    color: Color(0xFF00BCD4), // categoryLimpeza
    gradient: LinearGradient(
      colors: [Color(0xFF00BCD4), Color(0xFF0097A7)], // categoryLimpeza, categoryLimpezaDark
    ),
  );

  static const CategoryTheme higiene = CategoryTheme(
    icon: Icons.wash_rounded,
    color: Color(0xFFE91E63), // categoryHigiene
    gradient: LinearGradient(
      colors: [Color(0xFFE91E63), Color(0xFFC2185B)], // categoryHigiene, categoryHigieneDark
    ),
  );

  static const CategoryTheme hortifruti = CategoryTheme(
    icon: Icons.eco_rounded,
    color: Color(0xFF4CAF50), // categoryHortifruti
    gradient: LinearGradient(
      colors: [Color(0xFF4CAF50), Color(0xFF388E3C)], // categoryHortifruti, categoryHortifrutiDark
    ),
  );

  static const CategoryTheme frios = CategoryTheme(
    icon: Icons.ac_unit_rounded,
    color: Color(0xFF03A9F4), // categoryFrios
    gradient: LinearGradient(
      colors: [Color(0xFF03A9F4), Color(0xFF0288D1)], // categoryFrios, categoryFriosDark
    ),
  );

  static const CategoryTheme padaria = CategoryTheme(
    icon: Icons.bakery_dining_rounded,
    color: Color(0xFF795548), // categoryPadaria
    gradient: LinearGradient(
      colors: [Color(0xFF795548), Color(0xFF5D4037)], // categoryPadaria, categoryPadariaDark
    ),
  );

  static const CategoryTheme pet = CategoryTheme(
    icon: Icons.pets_rounded,
    color: Color(0xFF9C27B0), // categoryPet
    gradient: LinearGradient(
      colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)], // categoryPet, categoryPetDark
    ),
  );

  /// Mapa de categorias por nome
  static const Map<String, CategoryTheme> byName = {
    'Bebidas': bebidas,
    'Mercearia': mercearia,
    'Perecíveis': pereciveis,
    'Limpeza': limpeza,
    'Higiene': higiene,
    'Hortifruti': hortifruti,
    'Frios': frios,
    'Padaria': padaria,
    'Pet': pet,
  };

  /// Retorna o tema da categoria, ou um tema padrão se não existir
  static CategoryTheme getTheme(String categoria) {
    return byName[categoria] ?? bebidas;
  }
}



