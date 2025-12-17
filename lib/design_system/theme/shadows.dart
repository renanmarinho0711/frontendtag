import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Sombras padronizadas da aplicação
/// 
/// Centraliza todos os BoxShadow utilizados no app.
/// Reduz repetição de código e garante consistência visual.
/// 
/// Uso:
/// ```dart
/// decoration: BoxDecoration(
///   boxShadow: AppShadows.elevatedCard,
/// )
/// ```
class AppShadows {
  AppShadows._();

  // Sombras para cards
  static List<BoxShadow> elevatedCard = [
    BoxShadow(
      color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> softCard = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> mediumCard = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.1),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // Sombras para botões
  static List<BoxShadow> button = [
    BoxShadow(
      color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonPressed = [
    BoxShadow(
      color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.2),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Sombras para elementos flutuantes
  static List<BoxShadow> floating = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  // Sombras sutis
  static List<BoxShadow> subtle = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Sem sombra (útil para estados hover/focus)
  static List<BoxShadow> none = [];

  // Sombra superior (para bottom navigation, etc)
  static List<BoxShadow> topShadow = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.1),
      blurRadius: 10,
      offset: const Offset(0, -2),
    ),
  ];

  // Sombra de sucesso (glow verde)
  static List<BoxShadow> successGlow = [
    BoxShadow(
      color: AppThemeColors.success.withValues(alpha: 0.5),
      blurRadius: 6,
      spreadRadius: 2,
    ),
  ];

  // Sombra de warning (glow laranja)
  static List<BoxShadow> warningGlow = [
    BoxShadow(
      color: AppThemeColors.moduleEstrategiasDark.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Sombra de sugestão (glow verde da marca)
  static List<BoxShadow> suggestionGlow = [
    BoxShadow(
      color: AppThemeColors.brandPrimaryGreen.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // ========== GRADIENT GLOWS ==========

  /// Sombra com glow de gradiente primário (roxo)
  static List<BoxShadow> primaryHeaderGlowMobile = [
    BoxShadow(
      color: AppThemeColors.moduleDashboard.withValues(alpha: 0.3),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> primaryHeaderGlowDesktop = [
    BoxShadow(
      color: AppThemeColors.moduleDashboard.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  /// Sombra com glow de estratégias (laranja)
  static List<BoxShadow> estrategiasGlowMobile = [
    BoxShadow(
      color: AppThemeColors.moduleEstrategiasDark.withValues(alpha: 0.08),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> estrategiasGlowDesktop = [
    BoxShadow(
      color: AppThemeColors.moduleEstrategiasDark.withValues(alpha: 0.08),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  /// Sombra com glow de sugestões IA (laranja/rosa)
  static List<BoxShadow> sugestoesGlowMobile = [
    BoxShadow(
      color: AppThemeColors.gradientSugestoesStart.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> sugestoesGlowDesktop = [
    BoxShadow(
      color: AppThemeColors.gradientSugestoesStart.withValues(alpha: 0.3),
      blurRadius: 25,
      offset: const Offset(0, 12),
    ),
  ];

  // ========== CARD SHADOWS RESPONSIVOS ==========

  /// Sombras para cards com tamanhos responsivos
  static List<BoxShadow> cardMobile = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cardDesktop = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.06),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> cardElevatedMobile = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.08),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> cardElevatedDesktop = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ========== QUICK ACTION SHADOWS ==========

  static List<BoxShadow> quickActionMobile = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.06),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> quickActionDesktop = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ];

  // ========== DASHBOARD SPECIFIC SHADOWS ==========

  /// Sombra para stat cards
  static List<BoxShadow> statCard = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Sombra para strategy cards
  static List<BoxShadow> strategyCard = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.08),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  /// Glow para sync items
  static List<BoxShadow> syncGlow = [
    BoxShadow(
      color: AppThemeColors.moduleSincronizacao.withValues(alpha: 0.3),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  /// Glow para notification button
  static List<BoxShadow> notificationGlow = [
    BoxShadow(
      color: AppThemeColors.alertErrorCardBorder.withValues(alpha: 0.3),
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];

  /// Glow para menu items
  static List<BoxShadow> menuItemGlow = [
    BoxShadow(
      color: AppThemeColors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}




