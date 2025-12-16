import 'package:flutter/material.dart';

/// Sistema de sombras do TagBean
abstract class AppShadows {
  // Sombras para modo claro
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 25,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Sombras para cards
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Sombra para botões elevados
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Sombra para navegação inferior
  static List<BoxShadow> get bottomNavShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, -2),
    ),
  ];
}
