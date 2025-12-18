import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

class MenuItemData {
  final IconData icon;
  final String title;
  final List<Color> Function(BuildContext) gradientBuilder;

  const MenuItemData({
    required this.icon,
    required this. title,
    required this.gradientBuilder,
  });

  List<Color> getGradient(BuildContext context) => gradientBuilder(context);
}

List<MenuItemData> getMenuItems() {
  return [
    MenuItemData(
      icon: Icons.dashboard_rounded,
      title: 'Dashboard',
      gradientBuilder: (ctx) => [
        ThemeColors.of(ctx).moduleDashboard,
        ThemeColors. of(ctx).moduleDashboardDark,
      ],
    ),
    MenuItemData(
      icon: Icons.inventory_2_rounded,
      title: 'Produtos',
      gradientBuilder: (ctx) => [
        ThemeColors.of(ctx).moduleProdutos,
        ThemeColors.of(ctx).moduleProdutosDark,
      ],
    ),
    MenuItemData(
      icon: Icons.label_rounded,
      title: 'Etiquetas',
      gradientBuilder: (ctx) => [
        ThemeColors.of(ctx).moduleEtiquetas,
        ThemeColors.of(ctx).moduleEtiquetasDark,
      ],
    ),
    // ...  demais itens
  ];
}