mport 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart';
import 'theme_colors_dynamic.dart';
import 'theme_colors.dart';

// =============================================================================
// GRADIENTES DINAMICOS
// =============================================================================

/// Gradientes dinamicos que respondem ao tema atual
/// 
/// Esta classe substitui AppGradients para suporte a temas dinamicos.
/// Todos os gradientes agora respondem as mudancas de tema em tempo real.
/// 
/// CORRIGIDO EM SPRINT ATUAL:
/// - Removido uso de `dynamicThemeColorsProvider` (nao existe)
/// - Agora usa `themeProvider` para obter o tema atual
/// - Converte tema ID para ThemeColorsData usando factory method
class DynamicGradients {
  
  /// Gradiente do header principal baseado no tema atual
  static LinearGradient primaryHeader(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.moduleDashboard, themeColors.moduleDashboardDark],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
  
  /// Gradiente de fundo escuro baseado no tema atual  
  static LinearGradient darkBackground(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.primaryDashboardDark, themeColors.primaryDashboard],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
  
  /// Gradiente de sucesso baseado no tema atual
  static LinearGradient success(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.success, themeColors.success.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente de alerta baseado no tema atual
  static LinearGradient alert(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [AppThemeColors.alertOrangeMain, AppThemeColors.alertOrangeMain.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente azul ciano baseado no tema atual
  static LinearGradient blueCyan(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.secondary, themeColors.secondary.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente de produto verde baseado no tema atual
  static LinearGradient greenProduct(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.success, themeColors.success.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente de detalhes de estrategia baseado no tema atual
  static LinearGradient strategyDetail(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.primary, themeColors.primary.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente azul de sincronizacao baseado no tema atual
  static LinearGradient syncBlue(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.secondary, themeColors.secondary.withOpacity(0.9)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
  
  /// Gradiente baseado em cor customizada
  static LinearGradient fromBaseColor(WidgetRef ref, Color base) {
    return LinearGradient(
      colors: [base, base.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

// =============================================================================
// GRADIENTES DE MODULOS DINAMICOS
// =============================================================================

/// Gradientes de modulos dinamicos
class DynamicModuleGradients {
  
  /// Gradiente do modulo de produtos baseado no tema atual
  static LinearGradient produtos(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.moduleDashboard, themeColors.moduleDashboardDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Gradiente do modulo de precificacao baseado no tema atual
  static LinearGradient precificacao(WidgetRef ref) {
    // CORRIGIDO: Usa themeProvider ao inves de dynamicThemeColorsProvider
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);
    
    return LinearGradient(
      colors: [themeColors.primary, themeColors.primary.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}



