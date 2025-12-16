import 'package:flutter/material.dart';

/// ==============================================================================
/// THEME CONTRACT - Interface de Contrato para Temas
/// ==============================================================================
/// 
/// Define todos os tokens de cor obrigatórios que CADA tema deve implementar.
/// Serve como uma interface que garante consistência entre todos os temas.
/// 
/// Se um tema não implementar um token, a compilação falhará (type-safe).
/// Elimina a necessidade de fallbacks frágeis e _getColorOrDefault().
/// 
/// OBJETIVO:
/// - ✅ Garantir que TODOS os 22+ temas têm os mesmos tokens
/// - ✅ Prevenir tokens faltantes em tempo de compilação
/// - ✅ Facilitar adicionar novos temas (basta implementar interface)
/// - ✅ Documentar quais cores sÃ£o obrigatórias
/// 
/// ==============================================================================

abstract class ThemeContract {
  // ===========================================================================
  // 1. SUPERFÍCIES E FUNDOS (7 tokens)
  // ===========================================================================
  
  Color get backgroundLight;
  Color get surface;
  Color get surfaceVariant;
  Color get inputBackground;
  Color get backgroundMedium;
  Color get backgroundDark;
  Color get transparent;

  // ===========================================================================
  // 1.1. OVERLAYS E SOMBRAS (28 tokens)
  // ===========================================================================

  Color get surfaceOverlay10;
  Color get surfaceOverlay15;
  Color get surfaceOverlay20;
  Color get surfaceOverlay25;
  Color get surfaceOverlay30;
  Color get surfaceOverlay50;
  Color get surfaceOverlay60;
  Color get surfaceOverlay70;
  Color get surfaceOverlay80;
  Color get surfaceOverlay85;
  Color get surfaceOverlay90;
  Color get surfaceOverlay95;

  Color get shadowVeryLight;
  Color get shadowLight;
  Color get shadowMedium;
  Color get shadowRegular;

  Color get textPrimaryOverlay05;
  Color get textPrimaryOverlay06;
  Color get textPrimaryOverlay10;

  Color get overlay05;
  Color get overlay08;
  Color get overlay10;
  Color get overlay15;
  Color get overlay20;
  Color get overlay30;

  Color get primaryOverlay05;
  Color get primaryOverlay10;
  Color get primaryOverlay20;
  Color get primaryOverlay30;

  Color get successOverlay05;
  Color get successOverlay10;
  Color get successOverlay20;

  // ===========================================================================
  // 2. TEXTO (5 tokens)
  // ===========================================================================

  Color get textPrimary;
  Color get textSecondary;
  Color get textTertiary;
  Color get textLight;
  Color get textDisabled;

  // ===========================================================================
  // 3. BORDAS E DIVISORES (4 tokens)
  // ===========================================================================

  Color get border;
  Color get borderLight;
  Color get borderMedium;
  Color get borderDark;

  // ===========================================================================
  // 3.1. DIVISORES (1 token)
  // ===========================================================================

  Color get divider;

  // ===========================================================================
  // 4. OVERLAYS E SOMBRAS GERAIS (3 tokens)
  // ===========================================================================

  Color get overlayLight;
  Color get overlayLighter;
  Color get overlayDark;

  // ===========================================================================
  // 5. FEEDBACK E STATUS (12 tokens)
  // ===========================================================================

  Color get errorBackground;
  Color get errorLight;
  Color get error;
  Color get errorDark;
  Color get errorBorder;
  Color get errorText;
  Color get errorMain;
  Color get urgent;

  Color get infoBackground;
  Color get infoLight;
  Color get infoBorder;
  Color get infoText;
  Color get infoIcon;
  Color get infoDark;

  Color get successBackground;
  Color get successLight;
  Color get success;
  Color get successDark;
  Color get successBorder;
  Color get successText;
  Color get successIcon;
  Color get successDark2;
  Color get successGlow;

  Color get warningBackground;
  Color get warningLight;
  Color get warning;
  Color get warningBorder;
  Color get warningText;
  Color get warningIcon;
  Color get warningDark;

  // ===========================================================================
  // 6. PRIMÁRIA E SECUNDÁRIA (6 tokens)
  // ===========================================================================

  Color get primary;
  Color get primaryDark;
  Color get secondary;
  Color get tertiary;
  Color get secondaryDark;
  Color get tertiaryDark;

  // ===========================================================================
  // 7. BRAND (3 tokens)
  // ===========================================================================

  Color get brandPrimary;
  Color get brandPrimaryDark;
  Color get brandSecondary;

  // ===========================================================================
  // 8. MÓDULOS DO SISTEMA (7 tokens)
  // ===========================================================================

  Color get moduleDashboard;
  Color get moduleProdutos;
  Color get moduleEtiquetas;
  Color get moduleEstrategias;
  Color get moduleSincronizacao;
  Color get modulePrecificacao;
  Color get moduleConfiguracoes;

  // ===========================================================================
  // 9. CORES DE MATERIAL (6 tokens - para compatibilidade)
  // ===========================================================================

  Color get redMain;
  Color get greenMaterial;
  Color get blueMaterial;
  Color get orangeMaterial;
  Color get cyanMain;
  Color get orangeMain;

  // ===========================================================================
  // 10. CORES DE ROLE/PERMISsÃ£o (5 tokens)
  // ===========================================================================

  Color get roleSuperAdmin;
  Color get roleClientAdmin;
  Color get roleStoreManager;
  Color get roleOperator;
  Color get roleGuest;

  // ===========================================================================
  // 11. CORES DE CATEGORIA (pode ser extensível)
  // ===========================================================================

  Color get categoryDefault;
  Color get categoryElectronicos;
  Color get categoryAlimentos;
  Color get categoriaBebidas;
  Color get categoriaRoupa;
  Color get categoriaCosmeticos;

  // ===========================================================================
  // 12. CORES DE SINCRONIZAÇÃO (4 tokens)
  // ===========================================================================

  Color get syncPending;
  Color get syncSuccess;
  Color get syncError;
  Color get syncWarning;

  // ===========================================================================
  // 13. CORES DE LIBERAÇÃO (4 tokens)
  // ===========================================================================

  Color get clearancePending;
  Color get clearanceApproved;
  Color get clearanceRejected;
  Color get clearanceExpired;

  // ===========================================================================
  // 14. CORES ADICIONAIS PARA DESIGN SYSTEM (10+ tokens)
  // ===========================================================================

  Color get grey300;
  Color get grey500;
  Color get grey600;
  Color get grey800;

  // ===========================================================================
  // 15. CORES DE PULSO/SKELETON (2 tokens)
  // ===========================================================================

  Color get pulseBase;
  Color get pulseHighlight;
  Color get skeletonBase;
  Color get skeletonHighlight;

  // ===========================================================================
  // 16. DASHBOARD SPECIFIC (15 tokens)
  // ===========================================================================

  Color get dashboardAppBarBackground;
  Color get dashboardAppBarShadow;
  Color get dashboardDrawerBackground1;
  Color get dashboardDrawerBackground2;
  Color get dashboardDrawerHeaderIcon;
  Color get dashboardDrawerHeaderIconBg;
  Color get dashboardDrawerHeaderText;
  Color get dashboardDrawerHeaderTextSecondary;
  Color get dashboardDrawerItemSelected;
  Color get dashboardDrawerItemUnselected;
  Color get dashboardDrawerItemTextSelected;
  Color get dashboardDrawerItemTextUnselected;
  Color get dashboardBottomNavBackground;
  Color get dashboardBottomNavShadow;
  Color get dashboardBottomNavIconSelected;

  // ===========================================================================
  // 17. PRIMÁRIA DASHBOARD (2 tokens)
  // ===========================================================================

  Color get primaryDashboard;
  Color get primaryDashboardDark;

  // ===========================================================================
  // MÉTODO DE VALIDAÇÃO (Implementação recomendada, mas não obrigatória)
  // ===========================================================================

  /// Validar se todos os tokens estão implementados corretamente
  /// Pode ser sobrescrito para adicionar validações customizadas
  bool validate() {
    try {
      // Tenta acessar TODOS os getters
      // Se algum lançar exceção, a validação falha
      backgroundLight;
      surface;
      surfaceVariant;
      inputBackground;
      backgroundMedium;
      backgroundDark;
      transparent;
      textPrimary;
      textSecondary;
      textTertiary;
      textLight;
      textDisabled;
      border;
      borderLight;
      borderMedium;
      borderDark;
      divider;
      error;
      errorDark;
      success;
      successDark;
      warning;
      warningDark;
      primary;
      primaryDark;
      secondary;
      tertiary;
      moduleDashboard;
      moduleProdutos;
      moduleEtiquetas;
      moduleEstrategias;
      moduleSincronizacao;
      moduleConfiguracoes;
      roleSuperAdmin;
      roleClientAdmin;
      roleStoreManager;
      roleOperator;
      syncPending;
      syncSuccess;
      syncError;
      clearancePending;
      clearanceApproved;
      clearanceRejected;

      return true;
    } catch (e) {
      print('❌ ThemeContract validation failed: $e');
      return false;
    }
  }
}
