import 'package:flutter/material.dart';
import 'theme_colors_dynamic.dart';

/// Gradientes especãficos dos módulos
/// 
/// Centraliza todos os gradientes utilizados para representar
/// visualmente cada módulo do sistema. Substitui valores hardcoded
/// espalhados pelos screens.
/// 
/// Uso: ModuleGradients.produtos, ModuleGradients.etiquetas, etc.
class ModuleGradients {
  ModuleGradients._();

  static LinearGradient produtos(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark],
  );

  static LinearGradient etiquetas(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleEtiquetas, ThemeColors.of(context).moduleEtiquetasDark],
  );

  static LinearGradient estrategias(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark],
  );

  static LinearGradient sincronizacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark],
  );

  static LinearGradient precificacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).modulePrecificacao, ThemeColors.of(context).modulePrecificacaoDark],
  );

  static LinearGradient categorias(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleCategorias, ThemeColors.of(context).moduleCategoriasDark],
  );

  static LinearGradient importacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleImportacao, ThemeColors.of(context).moduleImportacaoDark],
  );

  static LinearGradient relatorios(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleRelatorios, ThemeColors.of(context).moduleRelatoriosDark],
  );

  static LinearGradient configuracoes(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleConfiguracoes, ThemeColors.of(context).moduleConfiguracoesDark],
  );

  static LinearGradient dashboard(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
  );
}



