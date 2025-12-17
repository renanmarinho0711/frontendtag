import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Gradientes padronizados da aplicação
/// 
/// Centraliza todos os gradientes usados em headers, cards e componentes.
/// Evita duplicação de cores hardcoded.
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
    colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
  );

  /// Gradiente roxo escuro (para relatórios e cards escuros)
  /// Mapeia gradientDarkNavy -> moduleDashboardDark para funcionar dinamicamente
  static LinearGradient purpleDark(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).moduleDashboardDark, ThemeColors.of(context).primaryDark],
  );

  /// Gradiente de sugestões de IA (laranja/rosa)
  /// Mapeia gradientSugestoesStart/End -> suggestionCardStart/End
  static LinearGradient sugestoesIA(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).suggestionCardStart, ThemeColors.of(context).suggestionCardEnd],
  );

  /// Gradiente de Estratégias (laranja)
  static LinearGradient estrategias(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark],
  );

  /// Gradiente azul claro (sincronização)
  static LinearGradient sync(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark],
  );

  /// Gradiente rosa/amarelo (importação)
  static LinearGradient import(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).modulePrecificacao, ThemeColors.of(context).modulePrecificacaoDark],
  );

  /// Gradiente verde (novo produto)
  static LinearGradient greenProduct(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark],
  );

  /// Gradiente cinza escuro (histórico/neutro)
  static LinearGradient historyIcon(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).grey700, ThemeColors.of(context).grey800],
  );

  // ========== GRADIENTES DO DASHBOARD ==========
  
  /// Gradiente do header principal do dashboard (roxo/roxo escuro)
  static LinearGradient dashboardHeader(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
  );
  
  /// Gradiente verde para sucesso/crescimento
  static LinearGradient successGradient(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark],
  );
  
  /// Gradiente verde alternativo (mais escuro)
  static LinearGradient successGradientAlt(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).successMaterial, ThemeColors.of(context).successDark],
  );
  
  /// Gradiente azul claro para sincronização
  static LinearGradient syncBlue(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark],
  );

  // ========== CORES ESTRATãGICAS ==========
  
  /// Cores para badges e elementos de estratãgia
  static Color strategyOrange(BuildContext context) => ThemeColors.of(context).moduleEstrategiasDark;
  static Color strategyOrangeLight(BuildContext context) => ThemeColors.of(context).moduleEstrategias;
  static Color strategyPink(BuildContext context) => ThemeColors.of(context).suggestionCardEnd;
  static Color strategyPurple(BuildContext context) => ThemeColors.of(context).moduleDashboardDark;
  static Color strategyPurpleLight(BuildContext context) => ThemeColors.of(context).moduleDashboard;
  static Color strategySyncBlue(BuildContext context) => ThemeColors.of(context).moduleSincronizacao;
  static Color strategySyncCyan(BuildContext context) => ThemeColors.of(context).moduleSincronizacaoDark;

  // ========== OVERLAYS ==========
  
  /// Overlay branco semi-transparente para glassmorphism
  static Color overlayWhite20(BuildContext context) => ThemeColors.of(context).surface.withValues(alpha: 0.2);
  static Color overlayWhite15(BuildContext context) => ThemeColors.of(context).surface.withValues(alpha: 0.15);
  static Color overlayWhite30(BuildContext context) => ThemeColors.of(context).surface.withValues(alpha: 0.3);
  static Color overlayWhite80(BuildContext context) => ThemeColors.of(context).surface.withValues(alpha: 0.8);
  static Color overlayWhite90(BuildContext context) => ThemeColors.of(context).surface.withValues(alpha: 0.9);
  
  /// Overlay preto semi-transparente
  static Color overlayBlack05(BuildContext context) => ThemeColors.of(context).black.withValues(alpha: 0.05);
  
  /// Overlay colorido baseado em gradiente
  static Color overlayPrimaryHeader30(BuildContext context) => ThemeColors.of(context).moduleDashboard.withValues(alpha: 0.3);
  static Color overlaySugestoesIA30(BuildContext context) => ThemeColors.of(context).suggestionCardStart.withValues(alpha: 0.3);
  static Color overlayEstrategias08(BuildContext context) => ThemeColors.of(context).moduleEstrategiasDark.withValues(alpha: 0.08);

  // ========== CORES PURAS PARA REFERãNCIA ==========
  
  /// Branco puro (para textos em gradientes)
  static Color white(BuildContext context) => ThemeColors.of(context).surface;
  
  /// Surface branca (alias para ThemeColors.of(context).surface)
  static Color surface(BuildContext context) => ThemeColors.of(context).surface;

  // ========== GRADIENTES DINãMICOS ==========

  /// Cria um gradiente suave a partir de uma cor base (para stat cards)
  static LinearGradient statCard(Color baseColor) {
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.1),
        baseColor.withValues(alpha: 0.05),
      ],
    );
  }

  /// Cria um gradiente para items de estratãgia
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

  /// Cria um gradiente dinâmico a partir de uma cor
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

  // ========== GRADIENTES ESPECãFICOS DO DASHBOARD ==========

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
    colors: [ThemeColors.of(context).success, ThemeColors.of(context).successIcon],
  );

  /// Gradiente para alert cards  
  /// Mapeia alertRedCoral -> alertRedMain
  static LinearGradient alert(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).alertRedMain, ThemeColors.of(context).errorDark],
  );

  /// Gradiente para strategy detail cards
  /// Mapeia strategyOrangeLight/Dark -> moduleEstratégias/Dark
  static LinearGradient strategyDetail(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark],
  );

  /// Gradiente para background (light -> medium -> dark)
  static LinearGradient background(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      ThemeColors.of(context).grey50,
      ThemeColors.of(context).grey100,
      ThemeColors.of(context).grey200,
    ],
  );

  /// Gradiente para user menu
  static LinearGradient userMenu(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).grey200, ThemeColors.of(context).grey300],
  );

  /// Gradiente para alertas (erro + warning)
  static LinearGradient alertCard(BuildContext context) => LinearGradient(
    colors: [ThemeColors.of(context).errorBackground, ThemeColors.of(context).warningBackground],
  );

  /// Cria gradiente com fade a partir de uma cor
  static LinearGradient colorFade(Color color, {double endOpacity = 0.7}) {
    return LinearGradient(
      colors: [color, color.withValues(alpha: endOpacity)],
    );
  }
  
  // ========== GRADIENTES DE CATEGORIAS/MãDULOS (TOP 10) ==========
  
  /// Gradiente roxo principal (dashboard, módulos principais) - 53x
  static LinearGradient purpleMain(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
  );
  
  /// Gradiente verde teal (sucesso, sync) - 27x
  static LinearGradient greenTeal(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark],
  );
  
  /// Gradiente roxo Médio (categorias) - 16x
  /// Mapeia purpleMedium/Deep -> moduleCategorias/Dark
  static LinearGradient purpleMedium(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleCategorias, ThemeColors.of(context).moduleCategoriasDark],
  );
  
  /// Gradiente rosa-amarelo (importação, destaque) - 13x
  static LinearGradient roseGold(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).modulePrecificacao, ThemeColors.of(context).modulePrecificacaoDark],
  );
  
  /// Gradiente vermelho (erro, alertas) - 12x
  /// Mapeia alertRedDarkest -> errorDark
  static LinearGradient redAlert(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).redMain, ThemeColors.of(context).errorDark],
  );
  
  /// Gradiente azul cyan (sincronização, info) - 11x
  static LinearGradient blueCyan(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark],
  );
  
  /// Gradiente azul Médio (info, links) - 11x
  /// Mapeia feedbackInfoDark -> infoDark
  static LinearGradient blueMedium(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).blueMain, ThemeColors.of(context).infoDark],
  );
  
  /// Gradiente laranja (warning, Notificações) - 11x
  static LinearGradient orangeWarning(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).orangeMain, ThemeColors.of(context).orangeDark],
  );
  
  /// Gradiente verde escuro elegante para headers premium (tema light)
  /// Mapeia gradientDarkStart/End -> greenDark/greenTeal
  static LinearGradient darkBackground(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).greenDark, ThemeColors.of(context).greenTeal],
  );
  
  /// Gradiente verde principal (sucesso, crescimento) - 10x
  /// Mapeia feedbackSuccessDark -> successDark
  static LinearGradient greenMain(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).greenMain, ThemeColors.of(context).successDark],
  );
  
  /// Gradiente pastel mint/pink (tags, etiquetas) - encontrado em mãltiplos módulos
  /// Mapeia mintPastel/pinkPastel -> successPastel/errorPastel
  static LinearGradient pastelMint(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).successPastel, ThemeColors.of(context).errorPastel],
  );

  // ========== GRADIENTES POR MãDULO (HEADERS) ==========
  
  /// Gradiente do módulo Produtos (verde teal)
  static LinearGradient produtos(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleProdutos, ThemeColors.of(context).moduleProdutosDark],
  );
  
  /// Gradiente do módulo Etiquetas/Tags (rosa/vermelho)
  static LinearGradient etiquetas(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleEtiquetas, ThemeColors.of(context).moduleEtiquetasDark],
  );
  
  /// Gradiente do módulo Estratégias (laranja)
  static LinearGradient estrategiasModule(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleEstrategias, ThemeColors.of(context).moduleEstrategiasDark],
  );
  
  /// Gradiente do módulo Sincronização (azul cyan)
  static LinearGradient sincronizacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleSincronizacao, ThemeColors.of(context).moduleSincronizacaoDark],
  );
  
  /// Gradiente do módulo Precificação (rosa/amarelo)
  static LinearGradient precificacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).modulePrecificacao, ThemeColors.of(context).modulePrecificacaoDark],
  );
  
  /// Gradiente do módulo Categorias (cyan/roxo)
  static LinearGradient categorias(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleCategorias, ThemeColors.of(context).moduleCategoriasDark],
  );
  
  /// Gradiente do módulo Importação/ExportAção (pastel)
  static LinearGradient importacao(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleImportacao, ThemeColors.of(context).moduleImportacaoDark],
  );
  
  /// Gradiente do módulo Relatórios (laranja/rosa)
  static LinearGradient relatorios(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleRelatorios, ThemeColors.of(context).moduleRelatoriosDark],
  );
  
  /// Gradiente do módulo Configurações (cinza/preto)
  static LinearGradient configuracoes(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.of(context).moduleConfiguracoes, ThemeColors.of(context).moduleConfiguracoesDark],
  );
}






