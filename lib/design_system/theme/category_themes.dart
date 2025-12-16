mport 'package:flutter/material.dart';
import 'theme_colors.dart';

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
    color: AppThemeColors.categoryBebidas,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryBebidas, AppThemeColors.categoryBebidasDark],
    ),
  );

  static const CategoryTheme mercearia = CategoryTheme(
    icon: Icons.shopping_basket_rounded,
    color: AppThemeColors.categoryMercearia,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryMercearia, AppThemeColors.categoryMerceariaDark],
    ),
  );

  static const CategoryTheme pereciveis = CategoryTheme(
    icon: Icons.restaurant_rounded,
    color: AppThemeColors.categoryPereciveis,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryPereciveis, AppThemeColors.categoryPereciveisDark],
    ),
  );

  static const CategoryTheme limpeza = CategoryTheme(
    icon: Icons.cleaning_services_rounded,
    color: AppThemeColors.categoryLimpeza,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryLimpeza, AppThemeColors.categoryLimpezaDark],
    ),
  );

  static const CategoryTheme higiene = CategoryTheme(
    icon: Icons.wash_rounded,
    color: AppThemeColors.categoryHigiene,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryHigiene, AppThemeColors.categoryHigieneDark],
    ),
  );

  static const CategoryTheme hortifruti = CategoryTheme(
    icon: Icons.eco_rounded,
    color: AppThemeColors.categoryHortifruti,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryHortifruti, AppThemeColors.categoryHortifrutiDark],
    ),
  );

  static const CategoryTheme frios = CategoryTheme(
    icon: Icons.ac_unit_rounded,
    color: AppThemeColors.categoryFrios,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryFrios, AppThemeColors.categoryFriosDark],
    ),
  );

  static const CategoryTheme padaria = CategoryTheme(
    icon: Icons.bakery_dining_rounded,
    color: AppThemeColors.categoryPadaria,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryPadaria, AppThemeColors.categoryPadariaDark],
    ),
  );

  static const CategoryTheme pet = CategoryTheme(
    icon: Icons.pets_rounded,
    color: AppThemeColors.categoryPet,
    gradient: LinearGradient(
      colors: [AppThemeColors.categoryPet, AppThemeColors.categoryPetDark],
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



