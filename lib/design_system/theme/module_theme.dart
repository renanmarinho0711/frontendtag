import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/icons.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Dados de tema para cada m�dulo
/// 
/// Encapsula �cone, nome e gradiente de cada m�dulo do sistema.
/// Facilita a cria��o de cards, menus e componentes que representam m�dulos.
class ModuleThemeData {
  final String label;
  final IconData icon;
  final List<Color> gradient;

  const ModuleThemeData({
    required this.label,
    required this.icon,
    required this.gradient,
  });
}

/// Temas dos m�dulos da aplica��o
/// 
/// Centraliza a configura��o visual de cada m�dulo.
/// 
/// Uso:
/// ```dart
/// final theme = ModuleThemes.produtos;
/// Icon(theme.icon)
/// Text(theme.label)
/// Container(decoration: BoxDecoration(gradient: LinearGradient(colors: theme.gradient)))
/// ```
class ModuleThemes {
  ModuleThemes._();

  static const produtos = ModuleThemeData(
    label: 'Produtos',
    icon: AppIcons.produtos,
    gradient: AppThemeColors.produtosGradient,
  );

  static const etiquetas = ModuleThemeData(
    label: 'Etiquetas',
    icon: AppIcons.etiquetas,
    gradient: AppThemeColors.etiquetasGradient,
  );

  static const estrategias = ModuleThemeData(
    label: 'Estrat�gias',
    icon: AppIcons.estrategias,
    gradient: AppThemeColors.estrategiasGradient,
  );

  static const sincronizacao = ModuleThemeData(
    label: 'Sincroniza��o',
    icon: AppIcons.sincronizacao,
    gradient: AppThemeColors.sincronizacaoGradient,
  );

  static const precificacao = ModuleThemeData(
    label: 'Precifica��o',
    icon: AppIcons.precificacao,
    gradient: AppThemeColors.precificacaoGradient,
  );

  static const categorias = ModuleThemeData(
    label: 'Categorias',
    icon: AppIcons.categorias,
    gradient: AppThemeColors.categoriasGradient,
  );

  static const importacao = ModuleThemeData(
    label: 'Importa��o',
    icon: AppIcons.importacao,
    gradient: AppThemeColors.importacaoGradient,
  );

  static const relatÃ³rios = ModuleThemeData(
    label: 'Relat�rios',
    icon: AppIcons.relatÃ³rios,
    gradient: AppThemeColors.relatÃ³riosGradient,
  );

  static const configuracoes = ModuleThemeData(
    label: 'Configura��es',
    icon: AppIcons.configuracoes,
    gradient: AppThemeColors.configuracoesGradient,
  );

  static const dashboard = ModuleThemeData(
    label: 'Dashboard',
    icon: AppIcons.dashboard,
    gradient: [AppThemeColors.primary, AppThemeColors.primaryDark],
  );

  /// Retorna o tema de um m�dulo pelo nome
  static ModuleThemeData? getByName(String name) {
    switch (name.toLowerCase()) {
      case 'produtos':
        return produtos;
      case 'etiquetas':
        return etiquetas;
      case 'estrategias':
      case 'estrat�gias':
        return estrategias;
      case 'sincronizacao':
      case 'sincroniza��o':
        return sincronizacao;
      case 'precificacao':
      case 'precifica��o':
        return precificacao;
      case 'categorias':
        return categorias;
      case 'importacao':
      case 'importa��o':
        return importacao;
      case 'relatÃ³rios':
      case 'relat�rios':
        return relatÃ³rios;
      case 'configuracoes':
      case 'configura��es':
        return configuracoes;
      case 'dashboard':
        return dashboard;
      default:
        return null;
    }
  }

  /// Lista de todos os m�dulos
  static List<ModuleThemeData> get all => [
    dashboard,
    produtos,
    etiquetas,
    estrategias,
    sincronizacao,
    precificacao,
    categorias,
    importacao,
    relatÃ³rios,
    configuracoes,
  ];
}



