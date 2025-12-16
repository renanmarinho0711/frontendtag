import 'package:flutter/material.dart';
import 'theme_colors.dart';

/// Gradientes espec�ficos dos m�dulos
/// 
/// Centraliza todos os gradientes utilizados para representar
/// visualmente cada m�dulo do sistema. Substitui valores hardcoded
/// espalhados pelos screens.
/// 
/// Uso: ModuleGradients.produtos, ModuleGradients.etiquetas, etc.
class ModuleGradients {
  ModuleGradients._();

  static LinearGradient produtos(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleProdutos, AppThemeColors.moduleProdutosDark],
  );

  static LinearGradient etiquetas(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleEtiquetas, AppThemeColors.moduleEtiquetasDark],
  );

  static LinearGradient estrategias(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleEstrategias, AppThemeColors.moduleEstrategiasDark],
  );

  static LinearGradient sincronizacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleSincronizacao, AppThemeColors.moduleSincronizacaoDark],
  );

  static LinearGradient precificacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.modulePrecificacao, AppThemeColors.modulePrecificacaoDark],
  );

  static LinearGradient categorias(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleCategorias, AppThemeColors.moduleCategoriasDark],
  );

  static LinearGradient importacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleImportacao, AppThemeColors.moduleImportacaoDark],
  );

  static LinearGradient relatÃ³rios(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.modulerelatÃ³rios, AppThemeColors.modulerelatÃ³riosDark],
  );

  static LinearGradient configuracoes(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleConfiguracoes, AppThemeColors.moduleConfiguracoesDark],
  );

  static LinearGradient dashboard(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleDashboard, AppThemeColors.moduleDashboardDark],
  );
}



