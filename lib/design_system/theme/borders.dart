mport 'package:flutter/material.dart';

/// Border radius padronizados da aplicação
/// 
/// Centraliza todos os valores de BorderRadius utilizados no app.
/// Garante consistência visual em cards, botões, inputs, etc.
/// 
/// Uso: 
/// ```dart
/// borderRadius: AppRadius.card
/// borderRadius: AppRadius.button
/// ```
class AppRadius {
  AppRadius._();

  static const BorderRadius xxxs = BorderRadius.all(Radius.circular(2)); // Caso raro
  static const BorderRadius xxs = BorderRadius.all(Radius.circular(5));
  static const BorderRadius xs = BorderRadius.all(Radius.circular(4));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));
  static const BorderRadius mdPlus = BorderRadius.all(Radius.circular(14)); // Caso especial dashboard
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(20));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(24));

  // Alias semnticos para componentes específicos
  static const BorderRadius card = lg;
  static const BorderRadius button = md;
  static const BorderRadius input = md;
  static const BorderRadius dialog = lg;
  static const BorderRadius bottomSheet = xl;
  static const BorderRadius snackbar = md; // 12
  static const BorderRadius badge = BorderRadius.all(Radius.circular(6));

  // Radius circulares
  static const double circular = 999;
  static const BorderRadius pill = BorderRadius.all(Radius.circular(circular));

  // Radius específicos para AppBar
  static const BorderRadius appBar = xl; // 20
  static const BorderRadius appBarMobile = lg; // 16
  static const BorderRadius appBarTablet = BorderRadius.all(Radius.circular(18));

  // Pills para status badges
  static const BorderRadius pillSmall = BorderRadius.all(Radius.circular(10));

  // Radius responsivos para metric cards
  static BorderRadius metricCardMobile = const BorderRadius.all(Radius.circular(12));
  static BorderRadius metricCardTablet = const BorderRadius.all(Radius.circular(14));
  static BorderRadius metricCardDesktop = md; // 12

  // Radius para notification button
  static BorderRadius notificationButtonMobile = const BorderRadius.all(Radius.circular(10));
  static BorderRadius notificationButtonDesktop = md; // 12

  // Radius para icon buttons
  static BorderRadius iconButtonSmall = const BorderRadius.all(Radius.circular(6));
  static BorderRadius iconButtonMedium = sm; // 8
  static BorderRadius iconButtonLarge = const BorderRadius.all(Radius.circular(10));

  // Radius para navigation rail items
  static BorderRadius navRailItemTablet = const BorderRadius.all(Radius.circular(10));
  static BorderRadius navRailItemDesktop = md; // 12

  // Radius para avatars e badges
  static BorderRadius badgeSmall = const BorderRadius.all(Radius.circular(5));
  static BorderRadius badgeMedium = const BorderRadius.all(Radius.circular(6));

  // Radius para estratégia cards
  static BorderRadius estrategiaCardMobile = sm; // 8
  static BorderRadius estrategiaCardDesktop = const BorderRadius.all(Radius.circular(10));

  // Radius para dashboard stat icons
  static BorderRadius statIconMobile = const BorderRadius.all(Radius.circular(10));
  static BorderRadius statIconTablet = md; // 12
  static BorderRadius statIconDesktop = const BorderRadius.all(Radius.circular(14));

  // Radius para modal/sheet
  static BorderRadius modalLarge = const BorderRadius.all(Radius.circular(20));
  static BorderRadius modalXLarge = xxl; // 24

  // Radius para stat cards
  static BorderRadius statCard = md; // 12
  static BorderRadius statCardMobile = const BorderRadius.all(Radius.circular(10));
  static BorderRadius statCardTablet = const BorderRadius.all(Radius.circular(11));

  // Radius para strategy cards
  static BorderRadius strategyCard = md; // 12
  static BorderRadius strategyCardMobile = sm; // 8
  static BorderRadius strategyCardTablet = const BorderRadius.all(Radius.circular(10));

  // Radius para sync items
  static BorderRadius syncItem = md; // 12
  static BorderRadius syncItemMobile = const BorderRadius.all(Radius.circular(10));

  // Radius para menu items expandidos
  static BorderRadius menuItemExpanded = md; // 12
  static BorderRadius menuItemExpandedMobile = sm; // 8
}




