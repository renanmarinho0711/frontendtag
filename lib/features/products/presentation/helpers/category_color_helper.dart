import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// ==============================================================================
/// CATEGORY COLOR HELPER - Isolador de Cores para Categorias de Produtos
/// ==============================================================================
/// 
/// Mapeia Categoria para cor dinâmica usando BuildContext.
/// Antes: product_model.dart Categoria.color hardcoded
/// Depois: CategoryColorHelper.getColor(context, categoria) - dinâmico
/// 
/// BENEFÍCIOS:
/// - ✅ Cores dinâmicas por tema
/// - ✅ Lógica visual fora de models
/// - ✅ Fácil de estender para novas categorias
/// - ✅ Reutilizável em qualquer widget
/// 
/// ==============================================================================

// Enum para categorias (exemplo - ajuste conforme seu sistema)
enum Categoria {
  eletronicos('Eletrônicos'),
  alimentos('Alimentos'),
  bebidas('Bebidas'),
  roupa('Roupas'),
  cosmeticos('Cosméticos'),
  outros('Outros');

  final String label;
  const Categoria(this.label);
}

class CategoryColorHelper {
  CategoryColorHelper._();

  /// Retorna a cor dinâmica para uma Categoria específica
  static Color getColor(BuildContext context, Categoria categoria) {
    final colors = ThemeColors.of(context);
    
    switch (categoria) {
      case Categoria.eletronicos:
        return colors.categoryElectronicos;
      case Categoria.alimentos:
        return colors.categoryAlimentos;
      case Categoria.bebidas:
        return colors.categoriaBebidas;
      case Categoria.roupa:
        return colors.categoriaRoupa;
      case Categoria.cosmeticos:
        return colors.categoriaCosmeticos;
      case Categoria.outros:
        return colors.categoryDefault;
    }
  }

  /// Retorna um ícone apropriado para a categoria
  static IconData getIcon(Categoria categoria) {
    switch (categoria) {
      case Categoria.eletronicos:
        return Icons.devices;
      case Categoria.alimentos:
        return Icons.restaurant;
      case Categoria.bebidas:
        return Icons.local_bar;
      case Categoria.roupa:
        return Icons.checkroom;
      case Categoria.cosmeticos:
        return Icons.beauty_products;
      case Categoria.outros:
        return Icons.category;
    }
  }

  /// Retorna nome formatado da categoria
  static String getLabel(Categoria categoria) {
    return categoria.label;
  }
}
