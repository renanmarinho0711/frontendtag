import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/theme/theme_provider.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Gradientes dinâmicos que respondem ao tema atual
/// 
/// Esta classe substitui AppGradients para suporte a temas dinâmicos.
/// Todos os gradientes agora respondem ãs mudanças de tema em tempo real.
class DynamicGradients {
  
  /// Gradiente do header principal baseado no tema atual
  static LinearGradient primaryHeader(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.moduleDashboard, themeColors.moduleDashboardDark],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
  
  /// Gradiente de fundo escuro baseado no tema atual  
  static LinearGradient darkBackground(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.primaryDashboardDark, themeColors.primaryDashboard],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
  
  /// Gradiente de sucesso baseado no tema atual
  static LinearGradient success(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.success, themeColors.success.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente de alerta baseado no tema atual
  static LinearGradient alert(WidgetRef ref) {
    return LinearGradient(
      colors: [AppThemeColors.alertOrangeMain, AppThemeColors.alertOrangeMain.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente azul ciano baseado no tema atual
  static LinearGradient blueCyan(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.secondary, themeColors.secondary.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente de produto verde baseado no tema atual
  static LinearGradient greenProduct(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.success, themeColors.success.withValues(alpha: 0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente de detalhes de estratãgia baseado no tema atual
  static LinearGradient strategyDetail(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.primary, themeColors.primary.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente azul de sincronização baseado no tema atual
  static LinearGradient syncBlue(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.secondary, themeColors.secondary.withValues(alpha: 0.9)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
  
  /// Gradiente baseado em cor customizada
  static LinearGradient fromBaseColor(WidgetRef ref, Color base) {
    return LinearGradient(
      colors: [base, base.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

/// Gradientes de módulos dinâmicos
class DynamicModuleGradients {
  
  /// Gradiente do módulo de produtos baseado no tema atual
  static LinearGradient produtos(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.moduleDashboard, themeColors.moduleDashboardDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente do módulo de precificação baseado no tema atual
  static LinearGradient precificacao(WidgetRef ref) {
    final themeColors = ref.watch(dynamicThemeColorsProvider);
    return LinearGradient(
      colors: [themeColors.primary, themeColors.primary.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}




