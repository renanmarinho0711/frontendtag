import 'package:flutter/material.dart';

/// Tipos de operação em lote
enum OperationType {
  updatePrices('update_prices', 'Atualizar Preços em Lote', Icons.attach_money_rounded),
  deleteProducts('delete_products', 'Excluir Produtos em Lote', Icons.delete_sweep_rounded),
  associateTags('associate_tags', 'Associar Tags em Lote', Icons.link_rounded),
  updateCategories('update_categories', 'Atualizar Categorias', Icons.category_rounded),
  disassociateTags('disassociate_tags', 'Desassociar Tags em Lote', Icons.link_off_rounded),
  updateStock('update_stock', 'Atualizar Estoque em Lote', Icons.inventory_rounded);

  const OperationType(this.id, this.label, this.icon);
  
  final String id;
  final String label;
  final IconData icon;
}
