import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Gradientes padronizados da aplica��o
/// 
/// Centraliza todos os gradientes usados em headers, cards e componentes.
/// Evita duplica��o de cores hardcoded.
/// 
/// Uso: 
/// ```dart
/// decoration: BoxDecoration(
///   gradient: AppGradients.primaryHeader(context),
/// )
/// ```
class AppGradients {
  AppGradients._();

  // ========== GRADIENTES PRINCIPAIS ==========
  
  /// Gradiente principal do header/drawer (roxo)
  static LinearGradient primaryHeader(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.moduleDashboard, AppThemeColors.moduleDashboardDark],
  );

  /// Gradiente roxo escuro (para relat�rios e cards escuros)
  /// Mapeia gradientDarkNavy -> moduleDashboardDark para funcionar dinamicamente
  static LinearGradient purpleDark(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.moduleDashboardDark, AppThemeColors.primaryDark],
  );

  /// Gradiente de sugest�es de IA (laranja/rosa)
  /// Mapeia gradientSugestoesStart/End -> suggestionCardStart/End
  static LinearGradient sugestoesIA(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.suggestionCardStart, AppThemeColors.suggestionCardEnd],
  );

  /// Gradiente de estrat�gias (laranja)
  static LinearGradient estrategias(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.moduleEstrategias, AppThemeColors.moduleEstrategiasDark],
  );

  /// Gradiente azul claro (sincroniza��o)
  static LinearGradient sync(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.moduleSincronizacao, AppThemeColors.moduleSincronizacaoDark],
  );

  /// Gradiente rosa/amarelo (importa��o)
  static LinearGradient import(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.modulePrecificacao, AppThemeColors.modulePrecificacaoDark],
  );

  /// Gradiente verde (novo produto)
  static LinearGradient greenProduct(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.moduleProdutos, AppThemeColors.moduleProdutosDark],
  );

  /// Gradiente cinza escuro (hist�rico/neutro)
  static LinearGradient historyIcon(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.grey700, AppThemeColors.grey800],
  );

  // ========== GRADIENTES DO DASHBOARD ==========
  
  /// Gradiente do header principal do dashboard (roxo/roxo escuro)
  static LinearGradient dashboardHeader(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleDashboard, AppThemeColors.moduleDashboardDark],
  );
  
  /// Gradiente verde para sucesso/crescimento
  static LinearGradient successGradient(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.moduleProdutos, AppThemeColors.moduleProdutosDark],
  );
  
  /// Gradiente verde alternativo (mais escuro)
  static LinearGradient successGradientAlt(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.successMaterial, AppThemeColors.successDark],
  );
  
  /// Gradiente azul claro para sincroniza��o
  static LinearGradient syncBlue(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.moduleSincronizacao, AppThemeColors.moduleSincronizacaoDark],
  );

  // ========== CORES ESTRAT�GICAS ==========
  
  /// Cores para badges e elementos de estrat�gia
  static Color strategyOrange(BuildContext context) => AppThemeColors.moduleEstrategiasDark;
  static Color strategyOrangeLight(BuildContext context) => AppThemeColors.moduleEstrategias;
  static Color strategyPink(BuildContext context) => AppThemeColors.suggestionCardEnd;
  static Color strategyPurple(BuildContext context) => AppThemeColors.moduleDashboardDark;
  static Color strategyPurpleLight(BuildContext context) => AppThemeColors.moduleDashboard;
  static Color strategySyncBlue(BuildContext context) => AppThemeColors.moduleSincronizacao;
  static Color strategySyncCyan(BuildContext context) => AppThemeColors.moduleSincronizacaoDark;

  // ========== OVERLAYS ==========
  
  /// Overlay branco semi-transparente para glassmorphism
  static Color overlayWhite20(BuildContext context) => AppThemeColors.surface.withValues(alpha: 0.2);
  static Color overlayWhite15(BuildContext context) => AppThemeColors.surface.withValues(alpha: 0.15);
  static Color overlayWhite30(BuildContext context) => AppThemeColors.surface.withValues(alpha: 0.3);
  static Color overlayWhite80(BuildContext context) => AppThemeColors.surface.withValues(alpha: 0.8);
  static Color overlayWhite90(BuildContext context) => AppThemeColors.surface.withValues(alpha: 0.9);
  
  /// Overlay preto semi-transparente
  static Color overlayBlack05(BuildContext context) => AppThemeColors.black.withValues(alpha: 0.05);
  
  /// Overlay colorido baseado em gradiente
  static Color overlayPrimaryHeader30(BuildContext context) => AppThemeColors.moduleDashboard.withValues(alpha: 0.3);
  static Color overlaySugestoesIA30(BuildContext context) => AppThemeColors.suggestionCardStart.withValues(alpha: 0.3);
  static Color overlayEstrategias08(BuildContext context) => AppThemeColors.moduleEstrategiasDark.withValues(alpha: 0.08);

  // ========== CORES PURAS PARA REFER�NCIA ==========
  
  /// Branco puro (para textos em gradientes)
  static Color white(BuildContext context) => AppThemeColors.surface;
  
  /// Surface branca (alias para AppThemeColors.surface)
  static Color surface(BuildContext context) => AppThemeColors.surface;

  // ========== GRADIENTES DIN�MICOS ==========

  /// Cria um gradiente suave a partir de uma cor base (para stat cards)
  static LinearGradient statCard(Color baseColor) {
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.1),
        baseColor.withValues(alpha: 0.05),
      ],
    );
  }

  /// Cria um gradiente para items de estrat�gia
  static LinearGradient estrategiaItem(Color baseColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor.withValues(alpha: 0.15),
        baseColor.withValues(alpha: 0.08),
      ],
    );
  }

  /// Cria um gradiente din�mico a partir de uma cor
  static LinearGradient dynamicFromColor(Color baseColor, {double startOpacity = 0.2, double endOpacity = 0.1}) {
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: startOpacity),
        baseColor.withValues(alpha: endOpacity),
      ],
    );
  }

  /// Cria gradiente a partir de uma cor base (para stat cards)
  static LinearGradient fromBaseColor(BuildContext context, Color base) {
    return LinearGradient(
      colors: [
        base.withValues(alpha: 0.1),
        base.withValues(alpha: 0.05),
      ],
    );
  }

  // ========== GRADIENTES ESPEC�FICOS DO DASHBOARD ==========

  /// Gradiente para metric cards
  static LinearGradient metrics(Color baseColor) {
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.1),
        baseColor.withValues(alpha: 0.05),
      ],
    );
  }

  /// Gradiente para success cards
  static LinearGradient success(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.success, AppThemeColors.successIcon],
  );

  /// Gradiente para alert cards  
  /// Mapeia alertRedCoral -> alertRedMain
  static LinearGradient alert(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.alertRedMain, AppThemeColors.errorDark],
  );

  /// Gradiente para strategy detail cards
  /// Mapeia strategyOrangeLight/Dark -> moduleEstrategias/Dark
  static LinearGradient strategyDetail(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleEstrategias, AppThemeColors.moduleEstrategiasDark],
  );

  /// Gradiente para background (light -> medium -> dark)
  static LinearGradient background(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppThemeColors.grey50,
      AppThemeColors.grey100,
      AppThemeColors.grey200,
    ],
  );

  /// Gradiente para user menu
  static LinearGradient userMenu(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.grey200, AppThemeColors.grey300],
  );

  /// Gradiente para alertas (erro + warning)
  static LinearGradient alertCard(BuildContext context) => LinearGradient(
    colors: [AppThemeColors.errorBackground, AppThemeColors.warningBackground],
  );

  /// Cria gradiente com fade a partir de uma cor
  static LinearGradient colorFade(Color color, {double endOpacity = 0.7}) {
    return LinearGradient(
      colors: [color, color.withValues(alpha: endOpacity)],
    );
  }
  
  // ========== GRADIENTES DE CATEGORIAS/M�DULOS (TOP 10) ==========
  
  /// Gradiente roxo principal (dashboard, m�dulos principais) - 53x
  static LinearGradient purpleMain(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleDashboard, AppThemeColors.moduleDashboardDark],
  );
  
  /// Gradiente verde teal (sucesso, sync) - 27x
  static LinearGradient greenTeal(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleProdutos, AppThemeColors.moduleProdutosDark],
  );
  
  /// Gradiente roxo m�dio (categorias) - 16x
  /// Mapeia purpleMedium/Deep -> moduleCategorias/Dark
  static LinearGradient purpleMedium(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleCategorias, AppThemeColors.moduleCategoriasDark],
  );
  
  /// Gradiente rosa-amarelo (importa��o, destaque) - 13x
  static LinearGradient roseGold(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.modulePrecificacao, AppThemeColors.modulePrecificacaoDark],
  );
  
  /// Gradiente vermelho (erro, alertas) - 12x
  /// Mapeia alertRedDarkest -> errorDark
  static LinearGradient redAlert(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.redMain, AppThemeColors.errorDark],
  );
  
  /// Gradiente azul cyan (sincroniza��o, info) - 11x
  static LinearGradient blueCyan(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleSincronizacao, AppThemeColors.moduleSincronizacaoDark],
  );
  
  /// Gradiente azul m�dio (info, links) - 11x
  /// Mapeia feedbackInfoDark -> infoDark
  static LinearGradient blueMedium(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.blueMain, AppThemeColors.infoDark],
  );
  
  /// Gradiente laranja (warning, notifica��es) - 11x
  static LinearGradient orangeWarning(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.orangeMain, AppThemeColors.orangeDark],
  );
  
  /// Gradiente verde escuro elegante para headers premium (tema light)
  /// Mapeia gradientDarkStart/End -> greenDark/greenTeal
  static LinearGradient darkBackground(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.greenDark, AppThemeColors.greenTeal],
  );
  
  /// Gradiente verde principal (sucesso, crescimento) - 10x
  /// Mapeia feedbackSuccessDark -> successDark
  static LinearGradient greenMain(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.greenMain, AppThemeColors.successDark],
  );
  
  /// Gradiente pastel mint/pink (tags, etiquetas) - encontrado em m�ltiplos m�dulos
  /// Mapeia mintPastel/pinkPastel -> successPastel/errorPastel
  static LinearGradient pastelMint(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.successPastel, AppThemeColors.errorPastel],
  );

  // ========== GRADIENTES POR M�DULO (HEADERS) ==========
  
  /// Gradiente do m�dulo Produtos (verde teal)
  static LinearGradient produtos(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleProdutos, AppThemeColors.moduleProdutosDark],
  );
  
  /// Gradiente do m�dulo Etiquetas/Tags (rosa/vermelho)
  static LinearGradient etiquetas(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleEtiquetas, AppThemeColors.moduleEtiquetasDark],
  );
  
  /// Gradiente do m�dulo Estrat�gias (laranja)
  static LinearGradient estrategiasModule(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleEstrategias, AppThemeColors.moduleEstrategiasDark],
  );
  
  /// Gradiente do m�dulo Sincroniza��o (azul cyan)
  static LinearGradient sincronizacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleSincronizacao, AppThemeColors.moduleSincronizacaoDark],
  );
  
  /// Gradiente do m�dulo Precifica��o (rosa/amarelo)
  static LinearGradient precificacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.modulePrecificacao, AppThemeColors.modulePrecificacaoDark],
  );
  
  /// Gradiente do m�dulo Categorias (cyan/roxo)
  static LinearGradient categorias(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleCategorias, AppThemeColors.moduleCategoriasDark],
  );
  
  /// Gradiente do m�dulo Importa��o/Exporta��o (pastel)
  static LinearGradient importacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleImportacao, AppThemeColors.moduleImportacaoDark],
  );
  
  /// Gradiente do m�dulo Relat�rios (laranja/rosa)
  static LinearGradient relatÃ³rios(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.modulerelatÃ³rios, AppThemeColors.modulerelatÃ³riosDark],
  );
  
  /// Gradiente do m�dulo Configura��es (cinza/preto)
  static LinearGradient configuracoes(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.moduleConfiguracoes, AppThemeColors.moduleConfiguracoesDark],
  );
}






