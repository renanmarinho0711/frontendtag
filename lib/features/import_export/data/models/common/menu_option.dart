import 'package:flutter/material.dart';

/// Opção de menu de importação/exportação
class ImportExportMenuOption {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final String? badge;
  final String itemCount;
  final String lastAction;
  final Widget? targetScreen;

  const ImportExportMenuOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradientColors,
    this.badge,
    required this.itemCount,
    required this.lastAction,
    this.targetScreen,
  });
}
