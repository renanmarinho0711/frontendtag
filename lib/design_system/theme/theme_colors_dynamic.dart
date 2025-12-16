// REMOVIDO CICLO: import 'package:tagbean/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importação dos temas
import 'package:tagbean/design_system/theme/theme_colors.dart' as theme_default;
import 'package:tagbean/design_system/theme/temas/theme_colors_t01_emerald_power.dart' as t01;
import 'package:tagbean/design_system/theme/temas/theme_colors_t02_royal_blue.dart' as t02;
import 'package:tagbean/design_system/theme/temas/theme_colors_t03_crimson_fire.dart' as t03;
import 'package:tagbean/design_system/theme/temas/theme_colors_t04_purple_reign.dart' as t04;
import 'package:tagbean/design_system/theme/temas/theme_colors_t05_sunset_orange.dart' as t05;
import 'package:tagbean/design_system/theme/temas/theme_colors_t06_ocean_teal.dart' as t06;
import 'package:tagbean/design_system/theme/temas/theme_colors_t07_lime_fresh.dart' as t07;
import 'package:tagbean/design_system/theme/temas/theme_colors_t08_pink_passion.dart' as t08;
import 'package:tagbean/design_system/theme/temas/theme_colors_t09_amber_gold.dart' as t09;
import 'package:tagbean/design_system/theme/temas/theme_colors_t11_rose_red.dart' as t11;
import 'package:tagbean/design_system/theme/temas/theme_colors_t13_violet_dream.dart' as t13;
import 'package:tagbean/design_system/theme/temas/theme_colors_t15_fuchsia_pop.dart' as t15;
import 'package:tagbean/design_system/theme/temas/theme_colors_v01_dark_mode.dart' as v01;
import 'package:tagbean/design_system/theme/temas/theme_colors_v02_light_pastel.dart' as v02;
import 'package:tagbean/design_system/theme/temas/theme_colors_v03_christmas.dart' as v03;
import 'package:tagbean/design_system/theme/temas/theme_colors_v04_halloween.dart' as v04;
import 'package:tagbean/design_system/theme/temas/theme_colors_v05_easter.dart' as v05;
import 'package:tagbean/design_system/theme/temas/theme_colors_v06_valentine.dart' as v06;
import 'package:tagbean/design_system/theme/temas/theme_colors_v07_summer_beach.dart' as v07;
import 'package:tagbean/design_system/theme/temas/theme_colors_v08_autumn_forest.dart' as v08;
import 'package:tagbean/design_system/theme/temas/theme_colors_v09_corporate_blue.dart' as v09;
import 'package:tagbean/design_system/theme/temas/theme_colors_v10_energetic_sport.dart' as v10;

import 'theme_provider.dart';

/// ==============================================================================
/// ThemeColors - Classe de cores dinâmicas baseada no tema selecionado
/// ==============================================================================
/// 
/// USO:
/// Em vez de: ThemeColors.of(context).surface
/// Use: ThemeColors.of(context).surface
///
/// Esta classe lê o tema atual do provider e retorna as cores correspondentes.
/// ==============================================================================

class ThemeColors extends InheritedWidget {
  final ThemeColorsData colors;

  const ThemeColors({
    super.key,
    required this.colors,
    required super.child,
  });

  static ThemeColorsData of(BuildContext context) {
    final ThemeColors? result = context.dependOnInheritedWidgetOfExactType<ThemeColors>();
    if (result != null) {
      return result.colors;
    }
    // Fallback para tema padrão se não encontrar o InheritedWidget
    return ThemeColorsData.fromThemeId('default');
  }

  /// Método estático para obter cores sem context (usando themeId diretamente)
  static ThemeColorsData fromThemeId(String themeId) {
    return ThemeColorsData.fromThemeId(themeId);
  }

  @override
  bool updateShouldNotify(ThemeColors oldWidget) {
    return colors != oldWidget.colors;
  }
}

/// Widget que fornece ThemeColors para toda a árvore de widgets
class ThemeColorsProvider extends ConsumerWidget {
  final Widget child;

  const ThemeColorsProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final colors = ThemeColorsData.fromThemeId(themeState.currentThemeId);

    return ThemeColors(
      colors: colors,
      child: child,
    );
  }
}

/// Classe que contém todas as cores do tema
/// Gerada dinamicamente com base no themeId selecionado
class ThemeColorsData {
  final String themeId;

  // ===========================================================================
  // 1. SUPERFÍCIES E FUNDOS
  // ===========================================================================
  final Color backgroundLight;
  final Color surface;
  final Color surfaceVariant;
  final Color inputBackground;
  final Color backgroundMedium;
  final Color backgroundDark;
  final Color transparent;

  // Overlays
  final Color surfaceOverlay10;
  final Color surfaceOverlay15;
  final Color surfaceOverlay20;
  final Color surfaceOverlay25;
  final Color surfaceOverlay30;
  final Color surfaceOverlay50;
  final Color surfaceOverlay60;
  final Color surfaceOverlay70;
  final Color surfaceOverlay80;
  final Color surfaceOverlay85;
  final Color surfaceOverlay90;
  final Color surfaceOverlay95;

  final Color shadowVeryLight;
  final Color shadowLight;
  final Color shadowMedium;
  final Color shadowRegular;

  final Color textPrimaryOverlay05;
  final Color textPrimaryOverlay06;
  final Color textPrimaryOverlay10;

  final Color overlay05;
  final Color overlay08;
  final Color overlay10;
  final Color overlay15;
  final Color overlay20;
  final Color overlay30;

  final Color primaryOverlay05;
  final Color primaryOverlay10;
  final Color primaryOverlay20;
  final Color primaryOverlay30;

  final Color successOverlay05;
  final Color successOverlay10;
  final Color successOverlay20;

  // ===========================================================================
  // 2. TEXTO
  // ===========================================================================
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textLight;
  final Color textDisabled;

  final Color textSecondaryOverlay05;
  final Color textSecondaryOverlay10;
  final Color textSecondaryOverlay15;
  final Color textSecondaryOverlay20;
  final Color textSecondaryOverlay30;
  final Color textSecondaryOverlay40;
  final Color textSecondaryOverlay50;
  final Color textSecondaryOverlay60;
  final Color textSecondaryOverlay70;
  final Color textSecondaryOverlay80;

  // ===========================================================================
  // 3. BORDAS E DIVISORES
  // ===========================================================================
  final Color border;
  final Color borderLight;
  final Color borderMedium;
  final Color borderDark;
  final Color divider;

  // ===========================================================================
  // 4. OVERLAYS
  // ===========================================================================
  final Color overlayLight;
  final Color overlayLighter;
  final Color overlayDark;

  // ===========================================================================
  // 5. STATUS E FEEDBACK
  // ===========================================================================
  // Erro
  final Color error;
  final Color errorBackground;
  final Color errorLight;
  final Color errorDark;
  final Color errorBorder;
  final Color errorText;
  final Color errorMain;
  final Color errorIcon;
  final Color errorPastel;
  final Color urgent;
  final Color urgentDark;

  // Info
  final Color info;
  final Color infoBackground;
  final Color infoLight;
  final Color infoBorder;
  final Color infoText;
  final Color infoIcon;
  final Color infoDark;
  final Color infoPastel;
  final Color infoModuleBackground;
  final Color infoModuleBackgroundAlt;
  final Color infoModuleBorder;

  // Sucesso
  final Color success;
  final Color successBackground;
  final Color successLight;
  final Color successDark;
  final Color successBorder;
  final Color successText;
  final Color successIcon;
  final Color successPastel;
  final Color successMaterial;

  // Alerta
  final Color warning;
  final Color warningBackground;
  final Color warningLight;
  final Color warningDark;
  final Color warningBorder;
  final Color warningText;
  final Color warningIcon;
  final Color warningPastel;

  // ===========================================================================
  // 6. CORES PRIMÁRIAS
  // ===========================================================================
  final Color primary;
  final Color primaryMain;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryPastel;
  final Color secondary;

  final Color primaryDashboard;
  final Color primaryDashboardDark;

  // ===========================================================================
  // 7. MÓDULOS
  // ===========================================================================
  final Color moduleDashboard;
  final Color moduleDashboardDark;
  final Color moduleProdutos;
  final Color moduleProdutosDark;
  final Color moduleEtiquetas;
  final Color moduleEtiquetasDark;
  final Color moduleEstrategias;
  final Color moduleEstrategiasDark;
  final Color moduleSincronizacao;
  final Color moduleSincronizacaoDark;
  final Color modulePrecificacao;
  final Color modulePrecificacaoDark;
  final Color moduleCategorias;
  final Color moduleCategoriasDark;
  final Color moduleImportacao;
  final Color moduleImportacaoDark;
  final Color moduleRelatorios;
  final Color moduleRelatoriosDark;
  final Color moduleConfiguracoes;
  final Color moduleConfiguracoesDark;

  // ===========================================================================
  // 8. CORES AUXILIARES
  // ===========================================================================
  final Color grey50;
  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey800;
  final Color grey900;

  // Material Colors
  final Color blueCyan;
  final Color blueMaterial;
  final Color blueMain;
  final Color blueDark;
  final Color blueLight;
  final Color bluePastel;

  final Color greenMaterial;
  final Color greenMain;
  final Color greenDark;
  final Color greenTeal;
  final Color greenGradient;
  final Color greenGradientEnd;

  final Color redMain;
  final Color redDark;
  final Color redPastel;

  final Color orangeMain;
  final Color orangeDark;
  final Color orangeMaterial;

  final Color yellowGold;

  // Brown
  final Color brownMain;
  final Color brownDark;
  final Color brownSaddle;

  // Amber
  final Color amberMain;
  final Color amberLight;
  final Color amberDark;

  // Teal/Cyan
  final Color tealMain;
  final Color cyanMain;
  final Color materialTeal;

  // Extra cores
  final Color blueIndigo;
  final Color silver;
  final Color bronze;
  final Color green50;
  final Color green200;
  final Color green700;
  final Color red400;
  final Color orange100;

  // Overlays adicionais
  final Color greenMainOverlay30;
  final Color greenMaterialOverlay05;
  final Color greenMaterialOverlay15;
  final Color greenMaterialOverlay30;
  final Color orangeMainOverlay03;
  final Color tealMainOverlay60;
  final Color surfaceTinted;

  // Sync status
  final Color syncedBg;
  final Color syncedBorder;
  final Color syncedIcon;
  final Color syncPendingBg;
  final Color syncPendingBorder;
  final Color syncPendingIcon;
  final Color syncErrorBg;
  final Color syncErrorBorder;
  final Color syncErrorIcon;
  final Color notSyncedBg;
  final Color notSyncedBorder;
  final Color notSyncedIcon;

  // Alert extras
  final Color alertWarningLight;
  final Color alertOrangeMain;
  final Color alertWarningIcon;
  final Color alertRedMain;
  final Color alertWarningCardBackground;
  final Color alertWarningCardBorder;
  final Color alertErrorCardBackground;
  final Color alertErrorCardBorder;
  final Color alertWarningStart;
  final Color alertWarningEnd;
  final Color alertErrorBackground;

  // Onboarding
  final Color onboardingBackground1;
  final Color onboardingBackground2;
  final Color onboardingBorder;
  final Color onboardingIcon;
  final Color onboardingProgress;
  final Color nextStepIcon;

  // Suggestion
  final Color suggestionCardStart;
  final Color suggestionCardEnd;
  final Color suggestionAumentosBackground;
  final Color suggestionAumentosText;
  final Color suggestionPromocoesBackground;
  final Color suggestionPromocoesText;

  // Admin Panel
  final Color adminPanelBackground1;
  final Color adminPanelBackground2;

  // ===========================================================================
  // Status & Roles
  // ===========================================================================
  final Color roleSuperAdmin;
  final Color roleAdmin;
  final Color roleManager;
  final Color roleOperator;
  final Color roleViewer;
  final Color rolePlus;

  // Sync Status
  final Color syncPending;
  final Color syncSuccess;
  final Color syncError;
  final Color syncWarning;

  // Clearance Status
  final Color clearancePending;
  final Color clearanceApproved;
  final Color clearanceRejected;
  final Color clearanceExpired;

  // User Status
  final Color statusActive;
  final Color statusInactive;
  final Color statusPending;
  final Color statusBlocked;

  // Additional Colors
  final Color orangeAmber;

  // ERP Integration Colors
  final Color erpSAP;
  final Color erpTOTVS;
  final Color erpOracle;
  final Color erpSenior;
  final Color erpSankhya;
  final Color erpOmie;
  final Color erpBling;

  // Básicos
  final Color white;
  final Color white60;
  final Color white70;
  final Color white90;
  final Color black;
  final Color neutralBlack;
  final Color neutralWhite;

  // Brand
  final Color brandPrimaryGreen;
  final Color brandPrimaryGreenDark;

  // Ícones
  final Color iconDefault;

  // ===========================================================================
  // 10. CATEGORIAS
  // ===========================================================================
  final Color categoryVisualizar;
  final Color categoryVisualizarDark;
  final Color categoryNova;
  final Color categoryNovaDark;
  final Color categoryProdutos;
  final Color categoryProdutosDark;
  final Color categoryAdmin;
  final Color categoryAdminDark;
  final Color categoryStats;
  final Color categoryStatsDark;
  final Color categoryImportExport;
  final Color categoryImportExportDark;

  // ===========================================================================
  // 8.1 CORES DE LOGIN E BOTÃO DESABILITADO
  // ===========================================================================
  final LinearGradient brandLoginGradient;
  final Color disabledButton;

  // ===========================================================================
  // 8.2 CORES DE SINCRONIZAÇÃO
  // ===========================================================================
  final Color syncComplete;
  final Color syncCompleteDark;
  final Color syncPricesOnly;
  final Color syncPricesOnlyDark;
  final Color syncNewProducts;
  final Color syncNewProductsDark;
  final Color syncSettings;
  final Color syncSettingsDark;

  // ===========================================================================
  // 9. GRADIENTES (como List<Color>)
  // ===========================================================================
  final List<Color> produtosGradient;
  final List<Color> etiquetasGradient;
  final List<Color> estrategiasGradient;
  final List<Color> sincronizacaoGradient;
  final List<Color> precificacaoGradient;
  final List<Color> categoriasGradient;
  final List<Color> importacaoGradient;
  final List<Color> relatoriosGradient;
  final List<Color> configuracoesGradient;

  // ===========================================================================
  // CONSTRUTOR
  // ===========================================================================
  const ThemeColorsData({
    required this.themeId,
    // Superfícies
    required this.backgroundLight,
    required this.surface,
    required this.surfaceVariant,
    required this.inputBackground,
    required this.backgroundMedium,
    required this.backgroundDark,
    required this.transparent,
    // Overlays de superfície
    required this.surfaceOverlay10,
    required this.surfaceOverlay15,
    required this.surfaceOverlay20,
    required this.surfaceOverlay25,
    required this.surfaceOverlay30,
    required this.surfaceOverlay50,
    required this.surfaceOverlay60,
    required this.surfaceOverlay70,
    required this.surfaceOverlay80,
    required this.surfaceOverlay85,
    required this.surfaceOverlay90,
    required this.surfaceOverlay95,
    required this.shadowVeryLight,
    required this.shadowLight,
    required this.shadowMedium,
    required this.shadowRegular,
    required this.textPrimaryOverlay05,
    required this.textPrimaryOverlay06,
    required this.textPrimaryOverlay10,
    required this.overlay05,
    required this.overlay08,
    required this.overlay10,
    required this.overlay15,
    required this.overlay20,
    required this.overlay30,
    required this.primaryOverlay05,
    required this.primaryOverlay10,
    required this.primaryOverlay20,
    required this.primaryOverlay30,
    required this.successOverlay05,
    required this.successOverlay10,
    required this.successOverlay20,
    // Texto
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textLight,
    required this.textDisabled,
    required this.textSecondaryOverlay05,
    required this.textSecondaryOverlay10,
    required this.textSecondaryOverlay15,
    required this.textSecondaryOverlay20,
    required this.textSecondaryOverlay30,
    required this.textSecondaryOverlay40,
    required this.textSecondaryOverlay50,
    required this.textSecondaryOverlay60,
    required this.textSecondaryOverlay70,
    required this.textSecondaryOverlay80,
    // Bordas
    required this.border,
    required this.borderLight,
    required this.borderMedium,
    required this.borderDark,
    required this.divider,
    // Overlays
    required this.overlayLight,
    required this.overlayLighter,
    required this.overlayDark,
    // Status
    required this.error,
    required this.errorBackground,
    required this.errorLight,
    required this.errorDark,
    required this.errorBorder,
    required this.errorText,
    required this.errorMain,
    required this.errorIcon,
    required this.errorPastel,
    required this.urgent,
    required this.info,
    required this.infoBackground,
    required this.infoLight,
    required this.infoBorder,
    required this.infoText,
    required this.infoIcon,
    required this.infoDark,
    required this.infoPastel,
    required this.infoModuleBackground,
    required this.infoModuleBackgroundAlt,
    required this.infoModuleBorder,
    required this.success,
    required this.successBackground,
    required this.successLight,
    required this.successDark,
    required this.successBorder,
    required this.successText,
    required this.successIcon,
    required this.successPastel,
    required this.successMaterial,
    required this.warning,
    required this.warningBackground,
    required this.warningLight,
    required this.warningDark,
    required this.warningBorder,
    required this.warningText,
    required this.warningIcon,
    required this.warningPastel,
    // Primárias
    required this.primary,
    required this.primaryMain,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryPastel,
    required this.secondary,
    required this.primaryDashboard,
    required this.primaryDashboardDark,
    // Módulos
    required this.moduleDashboard,
    required this.moduleDashboardDark,
    required this.moduleProdutos,
    required this.moduleProdutosDark,
    required this.moduleEtiquetas,
    required this.moduleEtiquetasDark,
    required this.moduleEstrategias,
    required this.moduleEstrategiasDark,
    required this.moduleSincronizacao,
    required this.moduleSincronizacaoDark,
    required this.modulePrecificacao,
    required this.modulePrecificacaoDark,
    required this.moduleCategorias,
    required this.moduleCategoriasDark,
    required this.moduleImportacao,
    required this.moduleImportacaoDark,
    required this.moduleRelatorios,
    required this.moduleRelatoriosDark,
    required this.moduleConfiguracoes,
    required this.moduleConfiguracoesDark,
    // Auxiliares
    required this.grey50,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey800,
    required this.grey900,
    required this.blueCyan,
    required this.blueMaterial,
    required this.blueMain,
    required this.blueDark,
    required this.blueLight,
    required this.bluePastel,
    required this.greenMaterial,
    required this.greenMain,
    required this.greenDark,
    required this.greenTeal,
    required this.greenGradient,
    required this.greenGradientEnd,
    required this.redMain,
    required this.redDark,
    required this.redPastel,
    required this.orangeMain,
    required this.orangeDark,
    required this.orangeMaterial,
    required this.yellowGold,
    // Brown
    required this.brownMain,
    required this.brownDark,
    required this.brownSaddle,
    // Amber
    required this.amberMain,
    required this.amberLight,
    required this.amberDark,
    // Teal/Cyan
    required this.tealMain,
    required this.cyanMain,
    required this.materialTeal,
    // Extra cores
    required this.blueIndigo,
    required this.silver,
    required this.bronze,
    required this.green50,
    required this.green200,
    required this.green700,
    required this.red400,
    required this.orange100,
    // Overlays adicionais
    required this.greenMainOverlay30,
    required this.greenMaterialOverlay05,
    required this.greenMaterialOverlay15,
    required this.greenMaterialOverlay30,
    required this.orangeMainOverlay03,
    required this.tealMainOverlay60,
    required this.surfaceTinted,
    // Sync status
    required this.syncedBg,
    required this.syncedBorder,
    required this.syncedIcon,
    required this.syncPendingBg,
    required this.syncPendingBorder,
    required this.syncPendingIcon,
    required this.syncErrorBg,
    required this.syncErrorBorder,
    required this.syncErrorIcon,
    required this.notSyncedBg,
    required this.notSyncedBorder,
    required this.notSyncedIcon,
    // Alert extras
    required this.alertWarningLight,
    required this.alertOrangeMain,
    required this.alertWarningIcon,
    required this.alertRedMain,
    required this.alertWarningCardBackground,
    required this.alertWarningCardBorder,
    required this.alertErrorCardBackground,
    required this.alertErrorCardBorder,
    required this.alertWarningStart,
    required this.alertWarningEnd,
    required this.alertErrorBackground,
    // Onboarding
    required this.onboardingBackground1,
    required this.onboardingBackground2,
    required this.onboardingBorder,
    required this.onboardingIcon,
    required this.onboardingProgress,
    required this.nextStepIcon,
    // Suggestion
    required this.suggestionCardStart,
    required this.suggestionCardEnd,
    required this.suggestionAumentosBackground,
    required this.suggestionAumentosText,
    required this.suggestionPromocoesBackground,
    required this.suggestionPromocoesText,
    // Admin Panel
    required this.adminPanelBackground1,
    required this.adminPanelBackground2,
    // Status & Roles
    required this.roleAdmin,
    required this.roleManager,
    required this.rolePlus,
    required this.roleSuperAdmin,
    required this.roleOperator,
    required this.roleViewer,
    required this.syncPending,
    required this.syncSuccess,
    required this.syncError,
    required this.syncWarning,
    required this.clearancePending,
    required this.clearanceApproved,
    required this.clearanceRejected,
    required this.clearanceExpired,
    // User Status
    required this.statusActive,
    required this.statusInactive,
    required this.statusPending,
    required this.statusBlocked,
    // Additional Colors
    required this.orangeAmber,
    required this.urgentDark,
    // ERP Integration Colors
    required this.erpSAP,
    required this.erpTOTVS,
    required this.erpOracle,
    required this.erpSenior,
    required this.erpSankhya,
    required this.erpOmie,
    required this.erpBling,
    // Basicos
    required this.white,
    required this.white60,
    required this.white70,
    required this.white90,
    required this.black,
    required this.neutralBlack,
    required this.neutralWhite,
    required this.brandPrimaryGreen,
    required this.brandPrimaryGreenDark,
    required this.iconDefault,
    // Categorias
    required this.categoryVisualizar,
    required this.categoryVisualizarDark,
    required this.categoryNova,
    required this.categoryNovaDark,
    required this.categoryProdutos,
    required this.categoryProdutosDark,
    required this.categoryAdmin,
    required this.categoryAdminDark,
    required this.categoryStats,
    required this.categoryStatsDark,
    required this.categoryImportExport,
    required this.categoryImportExportDark,
    // Login e Botão Desabilitado
    required this.brandLoginGradient,
    required this.disabledButton,
    // Sincronização
    required this.syncComplete,
    required this.syncCompleteDark,
    required this.syncPricesOnly,
    required this.syncPricesOnlyDark,
    required this.syncNewProducts,
    required this.syncNewProductsDark,
    required this.syncSettings,
    required this.syncSettingsDark,
    // Gradientes
    required this.produtosGradient,
    required this.etiquetasGradient,
    required this.estrategiasGradient,
    required this.sincronizacaoGradient,
    required this.precificacaoGradient,
    required this.categoriasGradient,
    required this.importacaoGradient,
    required this.relatoriosGradient,
    required this.configuracoesGradient,
  });

  /// Factory que cria ThemeColorsData baseado no themeId
  factory ThemeColorsData.fromThemeId(String themeId) {
    switch (themeId) {
      case 't01':
        return _buildFromTheme(themeId, t01.AppThemeColors);
      case 't02':
        return _buildFromTheme(themeId, t02.AppThemeColors);
      case 't03':
        return _buildFromTheme(themeId, t03.AppThemeColors);
      case 't04':
        return _buildFromTheme(themeId, t04.AppThemeColors);
      case 't05':
        return _buildFromTheme(themeId, t05.AppThemeColors);
      case 't06':
        return _buildFromTheme(themeId, t06.AppThemeColors);
      case 't07':
        return _buildFromTheme(themeId, t07.AppThemeColors);
      case 't08':
        return _buildFromTheme(themeId, t08.AppThemeColors);
      case 't09':
        return _buildFromTheme(themeId, t09.AppThemeColors);
      case 't11':
        return _buildFromTheme(themeId, t11.AppThemeColors);
      case 't13':
        return _buildFromTheme(themeId, t13.AppThemeColors);
      case 't15':
        return _buildFromTheme(themeId, t15.AppThemeColors);
      case 'v01':
        return _buildFromTheme(themeId, v01.AppThemeColors);
      case 'v02':
        return _buildFromTheme(themeId, v02.AppThemeColors);
      case 'v03':
        return _buildFromTheme(themeId, v03.AppThemeColors);
      case 'v04':
        return _buildFromTheme(themeId, v04.AppThemeColors);
      case 'v05':
        return _buildFromTheme(themeId, v05.AppThemeColors);
      case 'v06':
        return _buildFromTheme(themeId, v06.AppThemeColors);
      case 'v07':
        return _buildFromTheme(themeId, v07.AppThemeColors);
      case 'v08':
        return _buildFromTheme(themeId, v08.AppThemeColors);
      case 'v09':
        return _buildFromTheme(themeId, v09.AppThemeColors);
      case 'v10':
        return _buildFromTheme(themeId, v10.AppThemeColors);
      default:
        return _buildFromTheme('default', theme_default.AppThemeColors);
    }
  }

  /// Método auxiliar que constrói ThemeColorsData a partir de um tipo de tema
  static ThemeColorsData _buildFromTheme(String themeId, dynamic themeClass) {
    // Como todos os temas têm a mesma estrutura, usamos reflexão
    // Aqui usamos o tema padrão como base e sobrescrevemos
    return ThemeColorsData(
      themeId: themeId,
      // Superfícies - usando valores do tema
      backgroundLight: _getColor(themeClass, 'backgroundLight'),
      surface: _getColor(themeClass, 'surface'),
      surfaceVariant: _getColor(themeClass, 'surfaceVariant'),
      inputBackground: _getColor(themeClass, 'inputBackground'),
      backgroundMedium: _getColor(themeClass, 'backgroundMedium'),
      backgroundDark: _getColor(themeClass, 'backgroundDark'),
      transparent: _getColor(themeClass, 'transparent'),
      // Overlays
      surfaceOverlay10: _getColor(themeClass, 'surfaceOverlay10'),
      surfaceOverlay15: _getColor(themeClass, 'surfaceOverlay15'),
      surfaceOverlay20: _getColor(themeClass, 'surfaceOverlay20'),
      surfaceOverlay25: _getColor(themeClass, 'surfaceOverlay25'),
      surfaceOverlay30: _getColor(themeClass, 'surfaceOverlay30'),
      surfaceOverlay50: _getColor(themeClass, 'surfaceOverlay50'),
      surfaceOverlay60: _getColorOrDefault(themeClass, 'surfaceOverlay60', const Color(0x99000000)),
      surfaceOverlay70: _getColor(themeClass, 'surfaceOverlay70'),
      surfaceOverlay80: _getColor(themeClass, 'surfaceOverlay80'),
      surfaceOverlay85: _getColor(themeClass, 'surfaceOverlay85'),
      surfaceOverlay90: _getColor(themeClass, 'surfaceOverlay90'),
      surfaceOverlay95: _getColorOrDefault(themeClass, 'surfaceOverlay95', const Color(0xF2000000)),
      shadowVeryLight: _getColor(themeClass, 'shadowVeryLight'),
      shadowLight: _getColor(themeClass, 'shadowLight'),
      shadowMedium: _getColor(themeClass, 'shadowMedium'),
      shadowRegular: _getColor(themeClass, 'shadowRegular'),
      textPrimaryOverlay05: _getColor(themeClass, 'textPrimaryOverlay05'),
      textPrimaryOverlay06: _getColor(themeClass, 'textPrimaryOverlay06'),
      textPrimaryOverlay10: _getColor(themeClass, 'textPrimaryOverlay10'),
      overlay05: _getColor(themeClass, 'overlay05'),
      overlay08: _getColor(themeClass, 'overlay08'),
      overlay10: _getColor(themeClass, 'overlay10'),
      overlay15: _getColor(themeClass, 'overlay15'),
      overlay20: _getColor(themeClass, 'overlay20'),
      overlay30: _getColor(themeClass, 'overlay30'),
      primaryOverlay05: _getColor(themeClass, 'primaryOverlay05'),
      primaryOverlay10: _getColor(themeClass, 'primaryOverlay10'),
      primaryOverlay20: _getColor(themeClass, 'primaryOverlay20'),
      primaryOverlay30: _getColorOrDefault(themeClass, 'primaryOverlay30', const Color(0x4D22C55E)),
      successOverlay05: _getColor(themeClass, 'successOverlay05'),
      successOverlay10: _getColor(themeClass, 'successOverlay10'),
      successOverlay20: _getColor(themeClass, 'successOverlay20'),
      // Texto
      textPrimary: _getColor(themeClass, 'textPrimary'),
      textSecondary: _getColor(themeClass, 'textSecondary'),
      textTertiary: _getColor(themeClass, 'textTertiary'),
      textLight: _getColor(themeClass, 'textLight'),
      textDisabled: _getColor(themeClass, 'textDisabled'),
      textSecondaryOverlay05: _getColorOrDefault(themeClass, 'textSecondaryOverlay05', const Color(0x0D64748B)),
      textSecondaryOverlay10: _getColorOrDefault(themeClass, 'textSecondaryOverlay10', const Color(0x1A64748B)),
      textSecondaryOverlay15: _getColorOrDefault(themeClass, 'textSecondaryOverlay15', const Color(0x2664748B)),
      textSecondaryOverlay20: _getColorOrDefault(themeClass, 'textSecondaryOverlay20', const Color(0x3364748B)),
      textSecondaryOverlay30: _getColorOrDefault(themeClass, 'textSecondaryOverlay30', const Color(0x4D64748B)),
      textSecondaryOverlay40: _getColorOrDefault(themeClass, 'textSecondaryOverlay40', const Color(0x6664748B)),
      textSecondaryOverlay50: _getColorOrDefault(themeClass, 'textSecondaryOverlay50', const Color(0x8064748B)),
      textSecondaryOverlay60: _getColorOrDefault(themeClass, 'textSecondaryOverlay60', const Color(0x9964748B)),
      textSecondaryOverlay70: _getColorOrDefault(themeClass, 'textSecondaryOverlay70', const Color(0xB364748B)),
      textSecondaryOverlay80: _getColorOrDefault(themeClass, 'textSecondaryOverlay80', const Color(0xCC64748B)),
      // Bordas
      border: _getColor(themeClass, 'border'),
      borderLight: _getColor(themeClass, 'borderLight'),
      borderMedium: _getColor(themeClass, 'borderMedium'),
      borderDark: _getColor(themeClass, 'borderDark'),
      divider: _getColor(themeClass, 'divider'),
      // Overlays
      overlayLight: _getColor(themeClass, 'overlayLight'),
      overlayLighter: _getColor(themeClass, 'overlayLighter'),
      overlayDark: _getColor(themeClass, 'overlayDark'),
      // Status - Error
      error: _getColor(themeClass, 'error'),
      errorBackground: _getColor(themeClass, 'errorBackground'),
      errorLight: _getColor(themeClass, 'errorLight'),
      errorDark: _getColor(themeClass, 'errorDark'),
      errorBorder: _getColorOrDefault(themeClass, 'errorBorder', const Color(0xFFFECACA)),
      errorText: _getColor(themeClass, 'errorText'),
      errorMain: _getColor(themeClass, 'errorMain'),
      errorIcon: _getColor(themeClass, 'errorIcon'),
      errorPastel: _getColorOrDefault(themeClass, 'errorPastel', const Color(0xFFFEE2E2)),
      urgent: _getColor(themeClass, 'urgent'),
      // Status - Info
      info: _getColor(themeClass, 'info'),
      infoBackground: _getColor(themeClass, 'infoBackground'),
      infoLight: _getColor(themeClass, 'infoLight'),
      infoBorder: _getColor(themeClass, 'infoBorder'),
      infoText: _getColor(themeClass, 'infoText'),
      infoIcon: _getColor(themeClass, 'infoIcon'),
      infoDark: _getColor(themeClass, 'infoDark'),
      infoPastel: _getColorOrDefault(themeClass, 'infoPastel', const Color(0xFFE0F2FE)),
      infoModuleBackground: _getColorOrDefault(themeClass, 'infoModuleBackground', const Color(0xFFF0FDFF)),
      infoModuleBackgroundAlt: _getColorOrDefault(themeClass, 'infoModuleBackgroundAlt', const Color(0xFFE0F7FF)),
      infoModuleBorder: _getColorOrDefault(themeClass, 'infoModuleBorder', const Color(0xFF99F6E4)),
      // Status - Success
      success: _getColor(themeClass, 'success'),
      successBackground: _getColor(themeClass, 'successBackground'),
      successLight: _getColor(themeClass, 'successLight'),
      successDark: _getColor(themeClass, 'successDark'),
      successBorder: _getColor(themeClass, 'successBorder'),
      successText: _getColor(themeClass, 'successText'),
      successIcon: _getColor(themeClass, 'successIcon'),
      successPastel: _getColorOrDefault(themeClass, 'successPastel', const Color(0xFFD1FAE5)),
      successMaterial: _getColorOrDefault(themeClass, 'successMaterial', const Color(0xFF4CAF50)),
      // Status - Warning
      warning: _getColor(themeClass, 'warning'),
      warningBackground: _getColor(themeClass, 'warningBackground'),
      warningLight: _getColor(themeClass, 'warningLight'),
      warningDark: _getColor(themeClass, 'warningDark'),
      warningBorder: _getColor(themeClass, 'warningBorder'),
      warningText: _getColor(themeClass, 'warningText'),
      warningIcon: _getColor(themeClass, 'warningIcon'),
      warningPastel: _getColorOrDefault(themeClass, 'warningPastel', const Color(0xFFFEF3C7)),
      // Primárias
      primary: _getColor(themeClass, 'primary'),
      primaryMain: _getColor(themeClass, 'primaryMain'),
      primaryDark: _getColorOrDefault(themeClass, 'primaryDark', const Color(0xFF16A34A)),
      primaryLight: _getColorOrDefault(themeClass, 'primaryLight', const Color(0xFF4ADE80)),
      primaryPastel: _getColorOrDefault(themeClass, 'primaryPastel', const Color(0xFFBBF7D0)),
      secondary: _getColor(themeClass, 'secondary'),
      primaryDashboard: _getColor(themeClass, 'primaryDashboard'),
      primaryDashboardDark: _getColor(themeClass, 'primaryDashboardDark'),
      // Módulos
      moduleDashboard: _getColor(themeClass, 'moduleDashboard'),
      moduleDashboardDark: _getColor(themeClass, 'moduleDashboardDark'),
      moduleProdutos: _getColor(themeClass, 'moduleProdutos'),
      moduleProdutosDark: _getColor(themeClass, 'moduleProdutosDark'),
      moduleEtiquetas: _getColor(themeClass, 'moduleEtiquetas'),
      moduleEtiquetasDark: _getColor(themeClass, 'moduleEtiquetasDark'),
      moduleEstrategias: _getColor(themeClass, 'moduleEstrategias'),
      moduleEstrategiasDark: _getColor(themeClass, 'moduleEstrategiasDark'),
      moduleSincronizacao: _getColor(themeClass, 'moduleSincronizacao'),
      moduleSincronizacaoDark: _getColor(themeClass, 'moduleSincronizacaoDark'),
      modulePrecificacao: _getColor(themeClass, 'modulePrecificacao'),
      modulePrecificacaoDark: _getColor(themeClass, 'modulePrecificacaoDark'),
      moduleCategorias: _getColor(themeClass, 'moduleCategorias'),
      moduleCategoriasDark: _getColor(themeClass, 'moduleCategoriasDark'),
      moduleImportacao: _getColor(themeClass, 'moduleImportacao'),
      moduleImportacaoDark: _getColor(themeClass, 'moduleImportacaoDark'),
      moduleRelatorios: _getColor(themeClass, 'moduleRelatorios'),
      moduleRelatoriosDark: _getColor(themeClass, 'moduleRelatoriosDark'),
      moduleConfiguracoes: _getColor(themeClass, 'moduleConfiguracoes'),
      moduleConfiguracoesDark: _getColor(themeClass, 'moduleConfiguracoesDark'),
      // Auxiliares - Grey
      grey50: _getColor(themeClass, 'grey50'),
      grey100: _getColor(themeClass, 'grey100'),
      grey200: _getColor(themeClass, 'grey200'),
      grey300: _getColor(themeClass, 'grey300'),
      grey400: _getColor(themeClass, 'grey400'),
      grey500: _getColor(themeClass, 'grey500'),
      grey600: _getColor(themeClass, 'grey600'),
      grey700: _getColor(themeClass, 'grey700'),
      grey800: _getColor(themeClass, 'grey800'),
      grey900: _getColor(themeClass, 'grey900'),
      // Blues
      blueCyan: _getColorOrDefault(themeClass, 'blueCyan', const Color(0xFF06B6D4)),
      blueMaterial: _getColorOrDefault(themeClass, 'blueMaterial', const Color(0xFF2196F3)),
      blueMain: _getColorOrDefault(themeClass, 'blueMain', const Color(0xFF3B82F6)),
      blueDark: _getColorOrDefault(themeClass, 'blueDark', const Color(0xFF1E40AF)),
      blueLight: _getColorOrDefault(themeClass, 'blueLight', const Color(0xFF93C5FD)),
      bluePastel: _getColorOrDefault(themeClass, 'bluePastel', const Color(0xFFDBEAFE)),
      // Greens
      greenMaterial: _getColorOrDefault(themeClass, 'greenMaterial', const Color(0xFF4CAF50)),
      greenMain: _getColorOrDefault(themeClass, 'greenMain', const Color(0xFF22C55E)),
      greenDark: _getColorOrDefault(themeClass, 'greenDark', const Color(0xFF16A34A)),
      greenTeal: _getColorOrDefault(themeClass, 'greenTeal', const Color(0xFF14B8A6)),
      greenGradient: _getColorOrDefault(themeClass, 'greenGradient', const Color(0xFF22C55E)),
      greenGradientEnd: _getColorOrDefault(themeClass, 'greenGradientEnd', const Color(0xFF16A34A)),
      // Reds
      redMain: _getColorOrDefault(themeClass, 'redMain', const Color(0xFFEF4444)),
      redDark: _getColorOrDefault(themeClass, 'redDark', const Color(0xFFDC2626)),
      redPastel: _getColorOrDefault(themeClass, 'redPastel', const Color(0xFFFEE2E2)),
      // Oranges
      orangeMain: _getColorOrDefault(themeClass, 'orangeMain', const Color(0xFFF97316)),
      orangeDark: _getColorOrDefault(themeClass, 'orangeDark', const Color(0xFFEA580C)),
      orangeMaterial: _getColorOrDefault(themeClass, 'orangeMaterial', const Color(0xFFFF9800)),
      // Yellow
      yellowGold: _getColorOrDefault(themeClass, 'yellowGold', const Color(0xFFF59E0B)),
      // Brown
      brownMain: _getColorOrDefault(themeClass, 'brownMain', const Color(0xFFD97706)),
      brownDark: _getColorOrDefault(themeClass, 'brownDark', const Color(0xFFB45309)),
      brownSaddle: _getColorOrDefault(themeClass, 'brownSaddle', const Color(0xFF92400E)),
      // Amber
      amberMain: _getColorOrDefault(themeClass, 'amberMain', const Color(0xFFF59E0B)),
      amberLight: _getColorOrDefault(themeClass, 'amberLight', const Color(0xFFFCD34D)),
      amberDark: _getColorOrDefault(themeClass, 'amberDark', const Color(0xFFD97706)),
      // Teal/Cyan
      tealMain: _getColorOrDefault(themeClass, 'tealMain', const Color(0xFF15803D)),
      cyanMain: _getColorOrDefault(themeClass, 'cyanMain', const Color(0xFF15803D)),
      materialTeal: _getColorOrDefault(themeClass, 'materialTeal', const Color(0xFF22C55E)),
      // Extra cores
      blueIndigo: _getColorOrDefault(themeClass, 'blueIndigo', const Color(0xFF16A34A)),
      silver: _getColorOrDefault(themeClass, 'silver', const Color(0xFF94A3B8)),
      bronze: _getColorOrDefault(themeClass, 'bronze', const Color(0xFFD97706)),
      green50: _getColorOrDefault(themeClass, 'green50', const Color(0xFFECFDF5)),
      green200: _getColorOrDefault(themeClass, 'green200', const Color(0xFFA7F3D0)),
      green700: _getColorOrDefault(themeClass, 'green700', const Color(0xFF047857)),
      red400: _getColorOrDefault(themeClass, 'red400', const Color(0xFFF87171)),
      orange100: _getColorOrDefault(themeClass, 'orange100', const Color(0xFFFFEDD5)),
      // Overlays adicionais
      greenMainOverlay30: _getColorOrDefault(themeClass, 'greenMaterialOverlay30', const Color(0x4D10B981)),
      greenMaterialOverlay05: _getColorOrDefault(themeClass, 'greenMaterialOverlay05', const Color(0x0D10B981)),
      greenMaterialOverlay15: _getColorOrDefault(themeClass, 'greenMaterialOverlay15', const Color(0x2610B981)),
      greenMaterialOverlay30: _getColorOrDefault(themeClass, 'greenMaterialOverlay30', const Color(0x4D10B981)),
      orangeMainOverlay03: _getColorOrDefault(themeClass, 'orangeMainOverlay03', const Color(0x08F97316)),
      tealMainOverlay60: _getColorOrDefault(themeClass, 'tealMain', const Color(0xFF15803D)).withValues(alpha: 0.6),
      surfaceTinted: _getColorOrDefault(themeClass, 'surfaceVariant', const Color(0xFFF9FAFB)),
      // Sync status
      syncedBg: _getColorOrDefault(themeClass, 'syncedBg', const Color(0xFFF1F5F9)),
      syncedBorder: _getColorOrDefault(themeClass, 'syncedBorder', const Color(0xFFA7F3D0)),
      syncedIcon: _getColorOrDefault(themeClass, 'syncedIcon', const Color(0xFF10B981)),
      syncPendingBg: _getColorOrDefault(themeClass, 'syncPendingBg', const Color(0xFFFFFBEB)),
      syncPendingBorder: _getColorOrDefault(themeClass, 'syncPendingBorder', const Color(0xFFFDE68A)),
      syncPendingIcon: _getColorOrDefault(themeClass, 'syncPendingIcon', const Color(0xFFF59E0B)),
      syncErrorBg: _getColorOrDefault(themeClass, 'syncErrorBg', const Color(0xFFFEF2F2)),
      syncErrorBorder: _getColorOrDefault(themeClass, 'syncErrorBorder', const Color(0xFFFECACA)),
      syncErrorIcon: _getColorOrDefault(themeClass, 'syncErrorIcon', const Color(0xFFEF4444)),
      notSyncedBg: _getColorOrDefault(themeClass, 'notSyncedBg', const Color(0xFFF9FAFB)),
      notSyncedBorder: _getColorOrDefault(themeClass, 'notSyncedBorder', const Color(0xFFE2E8F0)),
      notSyncedIcon: _getColorOrDefault(themeClass, 'notSyncedIcon', const Color(0xFF94A3B8)),
      // Alert extras
      alertWarningLight: _getColorOrDefault(themeClass, 'alertWarningLight', const Color(0xFFFFFBEB)),
      alertOrangeMain: _getColorOrDefault(themeClass, 'alertOrangeMain', const Color(0xFFF97316)),
      alertWarningIcon: _getColorOrDefault(themeClass, 'alertWarningIcon', const Color(0xFFF59E0B)),
      alertRedMain: _getColorOrDefault(themeClass, 'alertRedMain', const Color(0xFFEF4444)),
      alertWarningCardBackground: _getColorOrDefault(themeClass, 'alertWarningCardBackground', const Color(0xFFFFFBEB)),
      alertWarningCardBorder: _getColorOrDefault(themeClass, 'alertWarningCardBorder', const Color(0xFFFDE68A)),
      alertErrorCardBackground: _getColorOrDefault(themeClass, 'alertErrorCardBackground', const Color(0xFFFEF2F2)),
      alertErrorCardBorder: _getColorOrDefault(themeClass, 'alertErrorCardBorder', const Color(0xFFFECACA)),
      alertWarningStart: _getColorOrDefault(themeClass, 'alertWarningStart', const Color(0xFFFDE68A)),
      alertWarningEnd: _getColorOrDefault(themeClass, 'alertWarningEnd', const Color(0xFFFCD34D)),
      alertErrorBackground: _getColorOrDefault(themeClass, 'alertErrorBackground', const Color(0xFFFEF2F2)),
      // Onboarding
      onboardingBackground1: _getColorOrDefault(themeClass, 'onboardingBackground1', const Color(0xFFF1F5F9)),
      onboardingBackground2: _getColorOrDefault(themeClass, 'onboardingBackground2', const Color(0xFFE2E8F0)),
      onboardingBorder: _getColorOrDefault(themeClass, 'onboardingBorder', const Color(0xFFCBD5E1)),
      onboardingIcon: _getColorOrDefault(themeClass, 'onboardingIcon', const Color(0xFF22C55E)),
      onboardingProgress: _getColorOrDefault(themeClass, 'onboardingProgress', const Color(0xFF16A34A)),
      nextStepIcon: _getColorOrDefault(themeClass, 'nextStepIcon', const Color(0xFF22C55E)),
      // Suggestion
      suggestionCardStart: _getColorOrDefault(themeClass, 'suggestionCardStart', const Color(0xFF10B981)),
      suggestionCardEnd: _getColorOrDefault(themeClass, 'suggestionCardEnd', const Color(0xFF059669)),
      suggestionAumentosBackground: _getColorOrDefault(themeClass, 'suggestionAumentosBackground', const Color(0xFFF1F5F9)),
      suggestionAumentosText: _getColorOrDefault(themeClass, 'suggestionAumentosText', const Color(0xFF111827)),
      suggestionPromocoesBackground: _getColorOrDefault(themeClass, 'suggestionPromocoesBackground', const Color(0xFFFFFBEB)),
      suggestionPromocoesText: _getColorOrDefault(themeClass, 'suggestionPromocoesText', const Color(0xFF92400E)),
      // Admin Panel
      adminPanelBackground1: _getColorOrDefault(themeClass, 'adminPanelBackground1', const Color(0xFFFFFFFF)),
      adminPanelBackground2: _getColorOrDefault(themeClass, 'adminPanelBackground2', const Color(0xFFF9FAFB)),
      // Status & Roles
      roleSuperAdmin: _getColorOrDefault(themeClass, 'roleSuperAdmin', const Color(0xFFEF4444)),
      roleAdmin: _getColorOrDefault(themeClass, 'roleAdmin', const Color(0xFF10B981)),
      roleManager: _getColorOrDefault(themeClass, 'roleManager', const Color(0xFF15803D)),
      roleOperator: _getColorOrDefault(themeClass, 'roleOperator', const Color(0xFFF59E0B)),
      roleViewer: _getColorOrDefault(themeClass, 'roleViewer', const Color(0xFF64748B)),
      rolePlus: _getColorOrDefault(themeClass, 'rolePlus', const Color(0xFF6366F1)),
      syncPending: _getColorOrDefault(themeClass, 'syncPending', const Color(0xFFF59E0B)),
      syncSuccess: _getColorOrDefault(themeClass, 'syncSuccess', const Color(0xFF10B981)),
      syncError: _getColorOrDefault(themeClass, 'syncError', const Color(0xFFEF4444)),
      syncWarning: _getColorOrDefault(themeClass, 'syncWarning', const Color(0xFFF59E0B)),
      clearancePending: _getColorOrDefault(themeClass, 'clearancePending', const Color(0xFFF59E0B)),
      clearanceApproved: _getColorOrDefault(themeClass, 'clearanceApproved', const Color(0xFF10B981)),
      clearanceRejected: _getColorOrDefault(themeClass, 'clearanceRejected', const Color(0xFFEF4444)),
      clearanceExpired: _getColorOrDefault(themeClass, 'clearanceExpired', const Color(0xFF6B7280)),
      // User Status
      statusActive: _getColorOrDefault(themeClass, 'statusActive', const Color(0xFF10B981)),
      statusInactive: _getColorOrDefault(themeClass, 'statusInactive', const Color(0xFF64748B)),
      statusPending: _getColorOrDefault(themeClass, 'statusPending', const Color(0xFFF59E0B)),
      statusBlocked: _getColorOrDefault(themeClass, 'statusBlocked', const Color(0xFFEF4444)),
      // Additional Colors
      orangeAmber: _getColorOrDefault(themeClass, 'orangeAmber', const Color(0xFFF59E0B)),
      urgentDark: _getColorOrDefault(themeClass, 'urgentDark', const Color(0xFFC41E3A)),
      // ERP Integration Colors
      erpSAP: _getColorOrDefault(themeClass, 'erpSAP', const Color(0xFF0066CC)),
      erpTOTVS: _getColorOrDefault(themeClass, 'erpTOTVS', const Color(0xFFED1C24)),
      erpOracle: _getColorOrDefault(themeClass, 'erpOracle', const Color(0xFFF80000)),
      erpSenior: _getColorOrDefault(themeClass, 'erpSenior', const Color(0xFF002868)),
      erpSankhya: _getColorOrDefault(themeClass, 'erpSankhya', const Color(0xFF004687)),
      erpOmie: _getColorOrDefault(themeClass, 'erpOmie', const Color(0xFF0050B3)),
      erpBling: _getColorOrDefault(themeClass, 'erpBling', const Color(0xFF2E8B57)),
      // Básicos
      white: _getColor(themeClass, 'white'),
      white60: _getColorOrDefault(themeClass, 'white60', const Color(0x99FFFFFF)),
      white70: _getColorOrDefault(themeClass, 'white70', const Color(0xB3FFFFFF)),
      white90: _getColorOrDefault(themeClass, 'white90', const Color(0xE6FFFFFF)),
      black: _getColor(themeClass, 'black'),
      neutralBlack: _getColorOrDefault(themeClass, 'neutralBlack', const Color(0xFF111827)),
      neutralWhite: _getColorOrDefault(themeClass, 'neutralWhite', const Color(0xFFFFFFFF)),
      // Brand
      brandPrimaryGreen: _getColor(themeClass, 'brandPrimaryGreen'),
      brandPrimaryGreenDark: _getColorOrDefault(themeClass, 'brandPrimaryGreenDark', const Color(0xFF16A34A)),
      // Icon
      iconDefault: _getColor(themeClass, 'iconDefault'),
      // Categorias
      categoryVisualizar: _getColorOrDefault(themeClass, 'categoryVisualizar', const Color(0xFF15803D)),
      categoryVisualizarDark: _getColorOrDefault(themeClass, 'categoryVisualizarDark', const Color(0xFF0D6F8B)),
      categoryNova: _getColorOrDefault(themeClass, 'categoryNova', const Color(0xFF10B981)),
      categoryNovaDark: _getColorOrDefault(themeClass, 'categoryNovaDark', const Color(0xFF0B7A57)),
      categoryProdutos: _getColorOrDefault(themeClass, 'categoryProdutos', const Color(0xFF22C55E)),
      categoryProdutosDark: _getColorOrDefault(themeClass, 'categoryProdutosDark', const Color(0xFF16A34A)),
      categoryAdmin: _getColorOrDefault(themeClass, 'categoryAdmin', const Color(0xFF059669)),
      categoryAdminDark: _getColorOrDefault(themeClass, 'categoryAdminDark', const Color(0xFF047857)),
      categoryStats: _getColorOrDefault(themeClass, 'categoryStats', const Color(0xFF84CC16)),
      categoryStatsDark: _getColorOrDefault(themeClass, 'categoryStatsDark', const Color(0xFF65A30D)),
      categoryImportExport: _getColorOrDefault(themeClass, 'categoryImportExport', const Color(0xFF22C55E)),
      categoryImportExportDark: _getColorOrDefault(themeClass, 'categoryImportExportDark', const Color(0xFF16A34A)),
      // Login e Botão Desabilitado
      brandLoginGradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF10B981)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      disabledButton: _getColorOrDefault(themeClass, 'disabledButton', const Color(0xFFD1D5DB)),
      // Sincronização
      syncComplete: _getColorOrDefault(themeClass, 'syncComplete', const Color(0xFF22C55E)),
      syncCompleteDark: _getColorOrDefault(themeClass, 'syncCompleteDark', const Color(0xFF16A34A)),
      syncPricesOnly: _getColorOrDefault(themeClass, 'syncPricesOnly', const Color(0xFF3B82F6)),
      syncPricesOnlyDark: _getColorOrDefault(themeClass, 'syncPricesOnlyDark', const Color(0xFF1E40AF)),
      syncNewProducts: _getColorOrDefault(themeClass, 'syncNewProducts', const Color(0xFFF97316)),
      syncNewProductsDark: _getColorOrDefault(themeClass, 'syncNewProductsDark', const Color(0xFFEA580C)),
      syncSettings: _getColorOrDefault(themeClass, 'syncSettings', const Color(0xFF22C55E)),
      syncSettingsDark: _getColorOrDefault(themeClass, 'syncSettingsDark', const Color(0xFF16A34A)),
      // Gradientes
      produtosGradient: _getGradient(themeClass, 'produtosGradient', [const Color(0xFF22C55E), const Color(0xFF16A34A)]),
      etiquetasGradient: _getGradient(themeClass, 'etiquetasGradient'),
      estrategiasGradient: _getGradient(themeClass, 'estrategiasGradient'),
      sincronizacaoGradient: _getGradient(themeClass, 'sincronizacaoGradient'),
      precificacaoGradient: _getGradient(themeClass, 'precificacaoGradient'),
      categoriasGradient: _getGradient(themeClass, 'categoriasGradient'),
      importacaoGradient: _getGradient(themeClass, 'importacaoGradient'),
      relatoriosGradient: _getGradient(themeClass, 'relatoriosGradient'),
      configuracoesGradient: _getGradient(themeClass, 'configuracoesGradient'),
    );
  }

  /// Helper para obter cor de uma classe de tema
  static Color _getColor(dynamic themeClass, String colorName) {
    try {
      switch (colorName) {
        case 'backgroundLight': return themeClass.backgroundLight;
        case 'surface': return themeClass.surface;
        case 'surfaceVariant': return themeClass.surfaceVariant;
        case 'inputBackground': return themeClass.inputBackground;
        case 'backgroundMedium': return themeClass.backgroundMedium;
        case 'backgroundDark': return themeClass.backgroundDark;
        case 'transparent': return themeClass.transparent;
        case 'surfaceOverlay10': return themeClass.surfaceOverlay10;
        case 'surfaceOverlay15': return themeClass.surfaceOverlay15;
        case 'surfaceOverlay20': return themeClass.surfaceOverlay20;
        case 'surfaceOverlay25': return themeClass.surfaceOverlay25;
        case 'surfaceOverlay30': return themeClass.surfaceOverlay30;
        case 'surfaceOverlay50': return themeClass.surfaceOverlay50;
        case 'surfaceOverlay70': return themeClass.surfaceOverlay70;
        case 'surfaceOverlay80': return themeClass.surfaceOverlay80;
        case 'surfaceOverlay85': return themeClass.surfaceOverlay85;
        case 'surfaceOverlay90': return themeClass.surfaceOverlay90;
        case 'shadowVeryLight': return themeClass.shadowVeryLight;
        case 'shadowLight': return themeClass.shadowLight;
        case 'shadowMedium': return themeClass.shadowMedium;
        case 'shadowRegular': return themeClass.shadowRegular;
        case 'textPrimaryOverlay05': return themeClass.textPrimaryOverlay05;
        case 'textPrimaryOverlay06': return themeClass.textPrimaryOverlay06;
        case 'textPrimaryOverlay10': return themeClass.textPrimaryOverlay10;
        case 'overlay05': return themeClass.overlay05;
        case 'overlay08': return themeClass.overlay08;
        case 'overlay10': return themeClass.overlay10;
        case 'overlay15': return themeClass.overlay15;
        case 'overlay20': return themeClass.overlay20;
        case 'overlay30': return themeClass.overlay30;
        case 'primaryOverlay05': return themeClass.primaryOverlay05;
        case 'primaryOverlay10': return themeClass.primaryOverlay10;
        case 'primaryOverlay20': return themeClass.primaryOverlay20;
        case 'successOverlay05': return themeClass.successOverlay05;
        case 'successOverlay10': return themeClass.successOverlay10;
        case 'successOverlay20': return themeClass.successOverlay20;
        case 'textPrimary': return themeClass.textPrimary;
        case 'textSecondary': return themeClass.textSecondary;
        case 'textTertiary': return themeClass.textTertiary;
        case 'textLight': return themeClass.textLight;
        case 'textDisabled': return themeClass.textDisabled;
        case 'border': return themeClass.border;
        case 'borderLight': return themeClass.borderLight;
        case 'borderMedium': return themeClass.borderMedium;
        case 'borderDark': return themeClass.borderDark;
        case 'divider': return themeClass.divider;
        case 'overlayLight': return themeClass.overlayLight;
        case 'overlayLighter': return themeClass.overlayLighter;
        case 'overlayDark': return themeClass.overlayDark;
        case 'error': return themeClass.error;
        case 'errorBackground': return themeClass.errorBackground;
        case 'errorLight': return themeClass.errorLight;
        case 'errorDark': return themeClass.errorDark;
        case 'errorText': return themeClass.errorText;
        case 'errorMain': return themeClass.errorMain;
        case 'errorIcon': return themeClass.errorIcon;
        case 'urgent': return themeClass.urgent;
        case 'info': return themeClass.info;
        case 'infoBackground': return themeClass.infoBackground;
        case 'infoLight': return themeClass.infoLight;
        case 'infoBorder': return themeClass.infoBorder;
        case 'infoText': return themeClass.infoText;
        case 'infoIcon': return themeClass.infoIcon;
        case 'infoDark': return themeClass.infoDark;
        case 'success': return themeClass.success;
        case 'successBackground': return themeClass.successBackground;
        case 'successLight': return themeClass.successLight;
        case 'successDark': return themeClass.successDark;
        case 'successBorder': return themeClass.successBorder;
        case 'successText': return themeClass.successText;
        case 'successIcon': return themeClass.successIcon;
        case 'warning': return themeClass.warning;
        case 'warningBackground': return themeClass.warningBackground;
        case 'warningLight': return themeClass.warningLight;
        case 'warningDark': return themeClass.warningDark;
        case 'warningBorder': return themeClass.warningBorder;
        case 'warningText': return themeClass.warningText;
        case 'warningIcon': return themeClass.warningIcon;
        case 'primary': return themeClass.primary;
        case 'primaryMain': return themeClass.primaryMain;
        case 'secondary': return themeClass.secondary;
        case 'primaryDashboard': return themeClass.primaryDashboard;
        case 'primaryDashboardDark': return themeClass.primaryDashboardDark;
        case 'moduleDashboard': return themeClass.moduleDashboard;
        case 'moduleDashboardDark': return themeClass.moduleDashboardDark;
        case 'moduleProdutos': return themeClass.moduleProdutos;
        case 'moduleProdutosDark': return themeClass.moduleProdutosDark;
        case 'moduleEtiquetas': return themeClass.moduleEtiquetas;
        case 'moduleEtiquetasDark': return themeClass.moduleEtiquetasDark;
        case 'moduleEstrategias': return themeClass.moduleEstrategias;
        case 'moduleEstrategiasDark': return themeClass.moduleEstrategiasDark;
        case 'moduleSincronizacao': return themeClass.moduleSincronizacao;
        case 'moduleSincronizacaoDark': return themeClass.moduleSincronizacaoDark;
        case 'modulePrecificacao': return themeClass.modulePrecificacao;
        case 'modulePrecificacaoDark': return themeClass.modulePrecificacaoDark;
        case 'moduleCategorias': return themeClass.moduleCategorias;
        case 'moduleCategoriasDark': return themeClass.moduleCategoriasDark;
        case 'moduleImportacao': return themeClass.moduleImportacao;
        case 'moduleImportacaoDark': return themeClass.moduleImportacaoDark;
        case 'moduleRelatorios': return themeClass.moduleRelatorios;
        case 'moduleRelatoriosDark': return themeClass.moduleRelatoriosDark;
        case 'moduleConfiguracoes': return themeClass.moduleConfiguracoes;
        case 'moduleConfiguracoesDark': return themeClass.moduleConfiguracoesDark;
        case 'grey50': return themeClass.grey50;
        case 'grey100': return themeClass.grey100;
        case 'grey200': return themeClass.grey200;
        case 'grey300': return themeClass.grey300;
        case 'grey400': return themeClass.grey400;
        case 'grey500': return themeClass.grey500;
        case 'grey600': return themeClass.grey600;
        case 'grey700': return themeClass.grey700;
        case 'grey800': return themeClass.grey800;
        case 'grey900': return themeClass.grey900;
        case 'white': return themeClass.white;
        case 'black': return themeClass.black;
        case 'brandPrimaryGreen': return themeClass.brandPrimaryGreen;
        case 'iconDefault': return themeClass.iconDefault;
        default: return theme_default.AppThemeColors.primary;
      }
    } catch (e) {
      return theme_default.AppThemeColors.primary;
    }
  }

  /// Helper para obter cor com valor padrão
  static Color _getColorOrDefault(dynamic themeClass, String colorName, Color defaultColor) {
    try {
      return _getColor(themeClass, colorName);
    } catch (e) {
      return defaultColor;
    }
  }

  /// Helper para obter gradiente
  static List<Color> _getGradient(dynamic themeClass, String gradientName, [List<Color>? defaultGradient]) {
    defaultGradient ??= [const Color(0xFF22C55E), const Color(0xFF16A34A)];
    try {
      switch (gradientName) {
        case 'produtosGradient': return themeClass.produtosGradient;
        case 'etiquetasGradient': return themeClass.etiquetasGradient;
        case 'estrategiasGradient': return themeClass.estrategiasGradient;
        case 'sincronizacaoGradient': return themeClass.sincronizacaoGradient;
        case 'precificacaoGradient': return themeClass.precificacaoGradient;
        case 'categoriasGradient': return themeClass.categoriasGradient;
        case 'importacaoGradient': return themeClass.importacaoGradient;
        case 'relatoriosGradient': return themeClass.relatoriosGradient;
        case 'configuracoesGradient': return themeClass.configuracoesGradient;
        case 'brandLoginGradient': return themeClass.brandLoginGradient;
        default: return defaultGradient;
      }
    } catch (e) {
      return defaultGradient;
    }
  }

  /// Método de resolução dinâmica de cores por chave semântica
  /// Usado para converter colorKey (String) em Color em tempo de runtime
  /// Especialmente importante para dados da camada de domínio (Models)
  Color? getColorByKey(String colorKey) {
    try {
      return _getColor(this, colorKey);
    } catch (e) {
      debugPrint('Color key not found: $colorKey, falling back to primary');
      return primary;
    }
  }

  /// Método helper que extrai cores usando reflexão/acesso por chave
  static Color _getColorFromInstance(ThemeColorsData instance, String colorName) {
    switch (colorName) {
      // Cores básicas
      case 'primary': return instance.primary;
      case 'secondary': return instance.secondary;
      case 'surface': return instance.surface;
      case 'error': return instance.error;
      case 'success': return instance.success;
      case 'warning': return instance.warning;
      case 'info': return instance.info;
      
      // Variantes
      case 'successLight': return instance.successLight;
      case 'successDark': return instance.successDark;
      case 'errorLight': return instance.errorLight;
      case 'errorDark': return instance.errorDark;
      case 'warningLight': return instance.warningLight;
      case 'warningDark': return instance.warningDark;
      case 'infoLight': return instance.infoLight;
      case 'infoDark': return instance.infoDark;
      
      // Ícones e texto
      case 'successIcon': return instance.successIcon;
      case 'errorIcon': return instance.errorIcon;
      case 'warningIcon': return instance.warningIcon;
      case 'infoIcon': return instance.infoIcon;
      case 'successText': return instance.successText;
      case 'errorText': return instance.errorText;
      case 'warningText': return instance.warningText;
      case 'infoText': return instance.infoText;
      
      // Pastel
      case 'successPastel': return instance.successPastel;
      case 'errorPastel': return instance.errorPastel;
      case 'warningPastel': return instance.warningPastel;
      case 'infoPastel': return instance.infoPastel;
      
      // Text
      case 'textPrimary': return instance.textPrimary;
      case 'textSecondary': return instance.textSecondary;
      case 'textTertiary': return instance.textTertiary;
      case 'disabled': return instance.textDisabled;
      
      // Status
      case 'urgent': return instance.urgent;
      
      // Fallback
      default: return instance.primary;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeColorsData && other.themeId == themeId;
  }

  @override
  int get hashCode => themeId.hashCode;
}

