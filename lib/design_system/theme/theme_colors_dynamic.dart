import 'package:tagbean/design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importação do tema padrão
import 'package:tagbean/design_system/theme/theme_colors.dart' as theme_default;

import 'package:tagbean/design_system/theme/theme_provider.dart';

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
  // 4.1. OVERLAYS BRANCOS PARA TELA DE LOGIN
  // ===========================================================================
  // OVERLAY BRANCO PARA BADGE "PREÇO INTELIGENTE" NA TELA DE LOGIN
  final Color loginBadgeBackground;
  // OVERLAY BRANCO PARA BORDA DO BADGE NA TELA DE LOGIN
  final Color loginBadgeBorder;
  // OVERLAY BRANCO PARA INDICADOR "SISTEMA ONLINE" NA TELA DE LOGIN
  final Color loginStatusBackground;

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
  final Color redDark;
  final Color cyanDark;
  final Color orangeAmber;

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
  final Color infoModuleIcon;
  final Color infoModuleText;

  // Report colors
  final Color reportOperacional;
  final Color reportOperacionalDark;
  final Color reportVendas;
  final Color reportVendasDark;
  final Color reportPerformance;
  final Color reportPerformanceDark;
  final Color reportAuditoria;
  final Color reportAuditoriaDark;

  // Stats colors
  final Color statTagsIcon;
  final Color statTagsBackground;
  final Color statTagsBorder;
  final Color statVendasIcon;
  final Color statVendasBackground;
  final Color statVendasBorder;
  final Color statInsightsIcon;
  final Color statInsightsBackground;
  final Color statInsightsBorder;
  final Color statLogsIcon;
  final Color statLogsBackground;
  final Color statLogsBorder;
  final Color statsOverviewBackground1;
  final Color statsOverviewBackground2;
  final Color quickActionsReportsBackground1;
  final Color quickActionsReportsBackground2;

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
  final Color secondaryLight;
  final Color secondaryDark;

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

  // Drawer e Navegação
  final Color drawerHeader;
  final Color drawerHeaderDark;
  final Color drawerBackground;
  final Color navItemActive;
  final Color navItemActiveDark;
  final Color navItemHover;
  final Color navBadge;
  final Color dashboardCardBorder;

  // Menu e Notificações
  final Color notificationBadge;
  final Color notificationBadgeDark;
  final Color userMenuBackground;
  final Color userMenuBackgroundDark;

  // Ícones
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconDisabled;
  final Color iconOnPrimary;
  final Color iconOnSurface;

  // Interações
  final Color hover;
  final Color focus;
  final Color pressed;
  final Color selected;
  final Color disabled;
  final Color disabledText;

  // Superfícies especiais
  final Color cardBackground;
  final Color modalBackground;
  final Color tooltipBackground;
  final Color surfaceLow;
  final Color surfaceHigh;
  final Color surfaceTintedDark;

  // Pulso/Animação
  final Color pulseBase;
  final Color pulseHighlight;

  // Shimmer
  final Color shimmerBase;
  final Color shimmerHighlight;

  // Material Teal
  final Color materialTealShade;

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
  final Color redPastel;

  final Color orangeMain;
  final Color orangeDark;
  final Color orangeMaterial;
  final Color orangeDeep;

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

  // Básicos
  final Color white;
  final Color white60;
  final Color white70;
  final Color white90;
  final Color black;
  final Color neutralBlack;
  final Color neutralWhite;

  // Status
  final Color statusActive;
  final Color statusInactive;
  final Color statusPending;
  final Color statusBlocked;

  // Roles
  final Color roleAdmin;
  final Color roleManager;
  final Color roleSuperAdmin;
  final Color roleOperator;
  final Color roleViewer;

  // Brand
  final Color brandPrimaryGreen;
  final Color brandPrimaryGreenDark;
  final LinearGradient brandLoginGradient;
  final Color disabledButton;

  // Pricing
  final Color pricingPercentage;
  final Color pricingPercentageDark;
  final Color pricingFixedValue;
  final Color pricingFixedValueDark;
  final Color pricingIndividual;
  final Color pricingIndividualDark;
  final Color pricingMarginReview;
  final Color pricingMarginReviewDark;
  final Color pricingDynamic;
  final Color pricingDynamicDark;
  final Color pricingHistory;
  final Color pricingHistoryDark;

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
  // 11. PROPRIEDADES ADICIONAIS
  // ===========================================================================
  final Color greenLightMaterial;
  final Color gold;
  final Color strategyCardSugestoesBackground;
  final Color strategyCardSugestoesBorder;
  final Color purpleMedium;
  final Color surfacePastel;
  final Color surfaceOverlay40;
  
  // Quick Actions
  final Color quickActionExportarTudo;
  final Color quickActionAgendar;
  final Color quickActionEmail;
  final Color quickActionsImportBackground1;
  final Color quickActionsImportBackground2;
  final Color quickActionTemplateBackground;
  final Color quickActionTemplateBorder;
  final Color quickActionUploadBackground;
  final Color quickActionUploadBorder;
  final Color quickActionHistoricoBackground;
  final Color quickActionHistoricoBorder;
  
  // Import/Export colors
  final Color importProdutos;
  final Color importProdutosDark;
  final Color importTags;
  final Color importTagsDark;
  final Color exportProdutos;
  final Color exportProdutosDark;
  final Color exportTags;
  final Color exportTagsDark;
  final Color batchOperations;
  final Color batchOperationsDark;
  final Color importHistorico;
  final Color importHistoricoDark;
  
  // Stats Import icons
  final Color statProdutosIcon;
  final Color statTagsESLIcon;
  final Color statSyncIcon;
  final Color statPendentesIcon;
  
  // ERP Integration colors
  final Color erpSAP;
  final Color erpTOTVS;
  final Color erpOracle;
  final Color erpSenior;
  final Color erpSankhya;
  final Color erpOmie;
  final Color erpBling;
  
  // BlueCyan overlays
  final Color blueCyanOverlay05;

  // Sync action colors
  final Color syncComplete;
  final Color syncCompleteDark;
  final Color syncPricesOnly;
  final Color syncPricesOnlyDark;
  final Color syncNewProducts;
  final Color syncNewProductsDark;
  final Color syncSettings;
  final Color syncSettingsDark;

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
    // Overlays brancos para tela de login
    required this.loginBadgeBackground,
    required this.loginBadgeBorder,
    required this.loginStatusBackground,
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
    required this.urgentDark,
    required this.redDark,
    required this.cyanDark,
    required this.orangeAmber,
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
    required this.infoModuleIcon,
    required this.infoModuleText,
    // Report colors
    required this.reportOperacional,
    required this.reportOperacionalDark,
    required this.reportVendas,
    required this.reportVendasDark,
    required this.reportPerformance,
    required this.reportPerformanceDark,
    required this.reportAuditoria,
    required this.reportAuditoriaDark,
    // Stats colors
    required this.statTagsIcon,
    required this.statTagsBackground,
    required this.statTagsBorder,
    required this.statVendasIcon,
    required this.statVendasBackground,
    required this.statVendasBorder,
    required this.statInsightsIcon,
    required this.statInsightsBackground,
    required this.statInsightsBorder,
    required this.statLogsIcon,
    required this.statLogsBackground,
    required this.statLogsBorder,
    required this.statsOverviewBackground1,
    required this.statsOverviewBackground2,
    required this.quickActionsReportsBackground1,
    required this.quickActionsReportsBackground2,
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
    required this.secondaryLight,
    required this.secondaryDark,
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
    // Drawer e Navegação
    required this.drawerHeader,
    required this.drawerHeaderDark,
    required this.drawerBackground,
    required this.navItemActive,
    required this.navItemActiveDark,
    required this.navItemHover,
    required this.navBadge,
    required this.dashboardCardBorder,
    // Menu e Notificações
    required this.notificationBadge,
    required this.notificationBadgeDark,
    required this.userMenuBackground,
    required this.userMenuBackgroundDark,
    // Ícones
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconDisabled,
    required this.iconOnPrimary,
    required this.iconOnSurface,
    // Interações
    required this.hover,
    required this.focus,
    required this.pressed,
    required this.selected,
    required this.disabled,
    required this.disabledText,
    // Superfícies especiais
    required this.cardBackground,
    required this.modalBackground,
    required this.tooltipBackground,
    required this.surfaceLow,
    required this.surfaceHigh,
    required this.surfaceTintedDark,
    // Pulso/Animação
    required this.pulseBase,
    required this.pulseHighlight,
    // Shimmer
    required this.shimmerBase,
    required this.shimmerHighlight,
    // Material Teal
    required this.materialTealShade,
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
    required this.redPastel,
    required this.orangeMain,
    required this.orangeDark,
    required this.orangeMaterial,
    required this.orangeDeep,
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
    // Basicos
    required this.white,
    required this.white60,
    required this.white70,
    required this.white90,
    required this.black,
    required this.neutralBlack,
    required this.neutralWhite,
    // Status
    required this.statusActive,
    required this.statusInactive,
    required this.statusPending,
    required this.statusBlocked,
    // Roles
    required this.roleAdmin,
    required this.roleManager,
    required this.roleSuperAdmin,
    required this.roleOperator,
    required this.roleViewer,
    required this.brandPrimaryGreen,
    required this.brandPrimaryGreenDark,
    required this.brandLoginGradient,
    required this.disabledButton,
    // Pricing
    required this.pricingPercentage,
    required this.pricingPercentageDark,
    required this.pricingFixedValue,
    required this.pricingFixedValueDark,
    required this.pricingIndividual,
    required this.pricingIndividualDark,
    required this.pricingMarginReview,
    required this.pricingMarginReviewDark,
    required this.pricingDynamic,
    required this.pricingDynamicDark,
    required this.pricingHistory,
    required this.pricingHistoryDark,
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
    // Propriedades adicionais
    required this.greenLightMaterial,
    required this.gold,
    required this.strategyCardSugestoesBackground,
    required this.strategyCardSugestoesBorder,
    required this.purpleMedium,
    required this.surfacePastel,
    required this.surfaceOverlay40,
    // Quick Actions
    required this.quickActionExportarTudo,
    required this.quickActionAgendar,
    required this.quickActionEmail,
    required this.quickActionsImportBackground1,
    required this.quickActionsImportBackground2,
    required this.quickActionTemplateBackground,
    required this.quickActionTemplateBorder,
    required this.quickActionUploadBackground,
    required this.quickActionUploadBorder,
    required this.quickActionHistoricoBackground,
    required this.quickActionHistoricoBorder,
    // Import/Export colors
    required this.importProdutos,
    required this.importProdutosDark,
    required this.importTags,
    required this.importTagsDark,
    required this.exportProdutos,
    required this.exportProdutosDark,
    required this.exportTags,
    required this.exportTagsDark,
    required this.batchOperations,
    required this.batchOperationsDark,
    required this.importHistorico,
    required this.importHistoricoDark,
    // Stats Import icons
    required this.statProdutosIcon,
    required this.statTagsESLIcon,
    required this.statSyncIcon,
    required this.statPendentesIcon,
    // ERP Integration colors
    required this.erpSAP,
    required this.erpTOTVS,
    required this.erpOracle,
    required this.erpSenior,
    required this.erpSankhya,
    required this.erpOmie,
    required this.erpBling,
    // BlueCyan overlays
    required this.blueCyanOverlay05,
    // Sync action colors
    required this.syncComplete,
    required this.syncCompleteDark,
    required this.syncPricesOnly,
    required this.syncPricesOnlyDark,
    required this.syncNewProducts,
    required this.syncNewProductsDark,
    required this.syncSettings,
    required this.syncSettingsDark,
  });

  /// Factory que cria ThemeColorsData baseado no themeId
  factory ThemeColorsData.fromThemeId(String themeId) {
    // Sempre usa o tema padrão - acesso direto às propriedades estáticas
    return const ThemeColorsData(
      themeId: 'default',
      // ===============================================================
      // 1. SUPERFÍCIES E FUNDOS
      // ===============================================================
      backgroundLight: theme_default.AppThemeColors.backgroundLight,
      surface: theme_default.AppThemeColors.surface,
      surfaceVariant: theme_default.AppThemeColors.surfaceVariant,
      inputBackground: theme_default.AppThemeColors.inputBackground,
      backgroundMedium: theme_default.AppThemeColors.backgroundMedium,
      backgroundDark: theme_default.AppThemeColors.backgroundDark,
      transparent: theme_default.AppThemeColors.transparent,
      // ===============================================================
      // 2. OVERLAYS DE SUPERFÍCIE
      // ===============================================================
      surfaceOverlay10: theme_default.AppThemeColors.surfaceOverlay10,
      surfaceOverlay15: theme_default.AppThemeColors.surfaceOverlay15,
      surfaceOverlay20: theme_default.AppThemeColors.surfaceOverlay20,
      surfaceOverlay25: theme_default.AppThemeColors.surfaceOverlay25,
      surfaceOverlay30: theme_default.AppThemeColors.surfaceOverlay30,
      surfaceOverlay50: theme_default.AppThemeColors.surfaceOverlay50,
      surfaceOverlay60: Color(0x99000000),
      surfaceOverlay70: theme_default.AppThemeColors.surfaceOverlay70,
      surfaceOverlay80: theme_default.AppThemeColors.surfaceOverlay80,
      surfaceOverlay85: theme_default.AppThemeColors.surfaceOverlay85,
      surfaceOverlay90: theme_default.AppThemeColors.surfaceOverlay90,
      surfaceOverlay95: Color(0xF2000000),
      // ===============================================================
      // 3. SOMBRAS
      // ===============================================================
      shadowVeryLight: theme_default.AppThemeColors.shadowVeryLight,
      shadowLight: theme_default.AppThemeColors.shadowLight,
      shadowMedium: theme_default.AppThemeColors.shadowMedium,
      shadowRegular: theme_default.AppThemeColors.shadowRegular,
      // ===============================================================
      // 4. OVERLAYS DE TEXTO
      // ===============================================================
      textPrimaryOverlay05: theme_default.AppThemeColors.textPrimaryOverlay05,
      textPrimaryOverlay06: theme_default.AppThemeColors.textPrimaryOverlay06,
      textPrimaryOverlay10: theme_default.AppThemeColors.textPrimaryOverlay10,
      // ===============================================================
      // 5. OVERLAYS GERAIS
      // ===============================================================
      overlay05: theme_default.AppThemeColors.overlay05,
      overlay08: theme_default.AppThemeColors.overlay08,
      overlay10: theme_default.AppThemeColors.overlay10,
      overlay15: theme_default.AppThemeColors.overlay15,
      overlay20: theme_default.AppThemeColors.overlay20,
      overlay30: theme_default.AppThemeColors.overlay30,
      primaryOverlay05: theme_default.AppThemeColors.primaryOverlay05,
      primaryOverlay10: theme_default.AppThemeColors.primaryOverlay10,
      primaryOverlay20: theme_default.AppThemeColors.primaryOverlay20,
      primaryOverlay30: Color(0x4D6366F1),
      successOverlay05: theme_default.AppThemeColors.successOverlay05,
      successOverlay10: theme_default.AppThemeColors.successOverlay10,
      successOverlay20: theme_default.AppThemeColors.successOverlay20,
      // ===============================================================
      // 6. TEXTOS
      // ===============================================================
      textPrimary: theme_default.AppThemeColors.textPrimary,
      textSecondary: theme_default.AppThemeColors.textSecondary,
      textTertiary: theme_default.AppThemeColors.textTertiary,
      textLight: theme_default.AppThemeColors.textLight,
      textDisabled: theme_default.AppThemeColors.textDisabled,
      textSecondaryOverlay05: Color(0x0D64748B),
      textSecondaryOverlay10: Color(0x1A64748B),
      textSecondaryOverlay15: Color(0x2664748B),
      textSecondaryOverlay20: Color(0x3364748B),
      textSecondaryOverlay30: Color(0x4D64748B),
      textSecondaryOverlay40: Color(0x6664748B),
      textSecondaryOverlay50: Color(0x8064748B),
      textSecondaryOverlay60: Color(0x9964748B),
      textSecondaryOverlay70: Color(0xB364748B),
      textSecondaryOverlay80: Color(0xCC64748B),
      // ===============================================================
      // 7. BORDAS
      // ===============================================================
      border: theme_default.AppThemeColors.border,
      borderLight: theme_default.AppThemeColors.borderLight,
      borderMedium: theme_default.AppThemeColors.borderMedium,
      borderDark: theme_default.AppThemeColors.borderDark,
      divider: theme_default.AppThemeColors.divider,
      // ===============================================================
      // 8. OVERLAYS GERAIS (LIGHT/LIGHTER/DARK)
      // ===============================================================
      overlayLight: theme_default.AppThemeColors.overlayLight,
      overlayLighter: theme_default.AppThemeColors.overlayLighter,
      overlayDark: theme_default.AppThemeColors.overlayDark,
      // ===============================================================
      // 8.1. CORES ESPECÍFICAS DA TELA DE LOGIN
      // ===============================================================
      loginBadgeBackground: theme_default.AppThemeColors.loginBadgeBackground,
      loginBadgeBorder: theme_default.AppThemeColors.loginBadgeBorder,
      loginStatusBackground: theme_default.AppThemeColors.loginStatusBackground,
      // ===============================================================
      // 9. STATUS - ERRO
      // ===============================================================
      error: theme_default.AppThemeColors.error,
      errorBackground: theme_default.AppThemeColors.errorBackground,
      errorLight: theme_default.AppThemeColors.errorLight,
      errorDark: theme_default.AppThemeColors.errorDark,
      errorBorder: theme_default.AppThemeColors.errorBorder,
      errorText: theme_default.AppThemeColors.errorText,
      errorMain: theme_default.AppThemeColors.error,
      errorIcon: theme_default.AppThemeColors.error,
      errorPastel: Color(0xFFFEE2E2),
      urgent: theme_default.AppThemeColors.error,
      urgentDark: Color(0xFFB91C1C),
      redDark: Color(0xFFDC2626),
      cyanDark: Color(0xFF0891B2),
      orangeAmber: Color(0xFFF59E0B),
      // ===============================================================
      // 10. STATUS - INFO
      // ===============================================================
      info: theme_default.AppThemeColors.info,
      infoBackground: theme_default.AppThemeColors.infoBackground,
      infoLight: theme_default.AppThemeColors.infoLight,
      infoDark: theme_default.AppThemeColors.infoDark,
      infoBorder: theme_default.AppThemeColors.infoBorder,
      infoText: theme_default.AppThemeColors.infoText,
      infoIcon: Color(0xFF3B82F6),
      infoPastel: Color(0xFFE0F2FE),
      infoModuleBackground: Color(0xFFF0FDFF),
      infoModuleBackgroundAlt: Color(0xFFE0F7FF),
      infoModuleBorder: Color(0xFF99F6E4),
      infoModuleIcon: Color(0xFF15803D),
      infoModuleText: Color(0xFF0F766E),
      // Report colors
      reportOperacional: Color(0xFF22C55E),
      reportOperacionalDark: Color(0xFF16A34A),
      reportVendas: Color(0xFF10B981),
      reportVendasDark: Color(0xFF0B7A57),
      reportPerformance: Color(0xFF84CC16),
      reportPerformanceDark: Color(0xFF65A30D),
      reportAuditoria: Color(0xFF15803D),
      reportAuditoriaDark: Color(0xFF0D6F8B),
      // Stats colors
      statTagsIcon: Color(0xFF10B981),
      statTagsBackground: Color(0xFFF1F5F9),
      statTagsBorder: Color(0xFFA7F3D0),
      statVendasIcon: Color(0xFF22C55E),
      statVendasBackground: Color(0xFFF9FAFB),
      statVendasBorder: Color(0xFFBBF7D0),
      statInsightsIcon: Color(0xFF84CC16),
      statInsightsBackground: Color(0xFFF7FEE7),
      statInsightsBorder: Color(0xFFD9F99D),
      statLogsIcon: Color(0xFF15803D),
      statLogsBackground: Color(0xFFF0FDFA),
      statLogsBorder: Color(0xFF99F6E4),
      statsOverviewBackground1: Color(0xFFFFFFFF),
      statsOverviewBackground2: Color(0xFFF9FAFB),
      quickActionsReportsBackground1: Color(0xFFFFFFFF),
      quickActionsReportsBackground2: Color(0xFFF9FAFB),
      // ===============================================================
      // 11. STATUS - WARNING
      // ===============================================================
      warning: theme_default.AppThemeColors.warning,
      warningBackground: theme_default.AppThemeColors.warningBackground,
      warningLight: theme_default.AppThemeColors.warningLight,
      warningDark: theme_default.AppThemeColors.warningDark,
      warningBorder: theme_default.AppThemeColors.warningBorder,
      warningText: theme_default.AppThemeColors.warningText,
      warningIcon: Color(0xFFF59E0B),
      warningPastel: Color(0xFFFEF3C7),
      // ===============================================================
      // 12. STATUS - SUCCESS
      // ===============================================================
      success: theme_default.AppThemeColors.success,
      successBackground: theme_default.AppThemeColors.successBackground,
      successLight: theme_default.AppThemeColors.successLight,
      successDark: theme_default.AppThemeColors.successDark,
      successBorder: theme_default.AppThemeColors.successBorder,
      successText: theme_default.AppThemeColors.successText,
      successIcon: Color(0xFF10B981),
      successPastel: Color(0xFFD1FAE5),
      successMaterial: Color(0xFF4CAF50),
      // ===============================================================
      // 13. COR PRIMÁRIA
      // ===============================================================
      primary: theme_default.AppThemeColors.primary,
      primaryMain: theme_default.AppThemeColors.primary,
      primaryLight: theme_default.AppThemeColors.primaryLight,
      primaryDark: theme_default.AppThemeColors.primaryDark,
      primaryPastel: Color(0xFFE0E7FF),
      // ===============================================================
      // 14. COR SECUNDÁRIA
      // ===============================================================
      secondary: theme_default.AppThemeColors.secondary,
      secondaryLight: Color(0xFFA5B4FC),
      secondaryDark: Color(0xFF4338CA),
      // ===============================================================
      // 15. DASHBOARD
      // ===============================================================
      primaryDashboard: theme_default.AppThemeColors.primaryDashboard,
      primaryDashboardDark: theme_default.AppThemeColors.primaryDashboardDark,
      moduleDashboard: theme_default.AppThemeColors.moduleDashboard,
      moduleDashboardDark: theme_default.AppThemeColors.moduleDashboardDark,
      drawerHeader: Color(0xFF6366F1),
      drawerHeaderDark: Color(0xFF4F46E5),
      drawerBackground: Color(0xFFFFFFFF),
      navItemActive: Color(0xFF6366F1),
      navItemActiveDark: Color(0xFF4F46E5),
      navItemHover: Color(0xFFF1F5F9),
      navBadge: Color(0xFFEF4444),
      dashboardCardBorder: Color(0xFFE2E8F0),
      // ===============================================================
      // 16. MENU E NOTIFICAÇÕES
      // ===============================================================
      notificationBadge: Color(0xFFEF4444),
      notificationBadgeDark: Color(0xFFDC2626),
      userMenuBackground: Color(0xFFFFFFFF),
      userMenuBackgroundDark: Color(0xFFF9FAFB),
      // ===============================================================
      // 17. ÍCONES
      // ===============================================================
      iconPrimary: Color(0xFF6366F1),
      iconSecondary: Color(0xFF64748B),
      iconTertiary: Color(0xFF94A3B8),
      iconDisabled: Color(0xFFCBD5E1),
      iconOnPrimary: Color(0xFFFFFFFF),
      iconOnSurface: theme_default.AppThemeColors.iconOnSurface,
      iconDefault: theme_default.AppThemeColors.iconDefault,
      // ===============================================================
      // 18. INTERAÇÕES
      // ===============================================================
      hover: Color(0xFFF1F5F9),
      focus: Color(0xFFE0E7FF),
      pressed: Color(0xFFC7D2FE),
      selected: Color(0xFFEEF2FF),
      disabled: theme_default.AppThemeColors.disabled,
      disabledText: theme_default.AppThemeColors.disabledText,
      // ===============================================================
      // 19. SUPERFÍCIES ESPECIAIS
      // ===============================================================
      surfaceLow: theme_default.AppThemeColors.surfaceLow,
      surfaceHigh: theme_default.AppThemeColors.surfaceHigh,
      surfaceTinted: theme_default.AppThemeColors.surfaceTinted,
      surfaceTintedDark: theme_default.AppThemeColors.surfaceTintedDark,
      cardBackground: Color(0xFFFFFFFF),
      modalBackground: Color(0xFFFFFFFF),
      tooltipBackground: Color(0xFF1E293B),
      // ===============================================================
      // 20. AUXILIARES
      // ===============================================================
      pulseBase: theme_default.AppThemeColors.pulseBase,
      pulseHighlight: theme_default.AppThemeColors.pulseHighlight,
      shimmerBase: Color(0xFFE2E8F0),
      shimmerHighlight: Color(0xFFF1F5F9),
      // ===============================================================
      // 21. STATUS ESPECÍFICOS
      // ===============================================================
      statusActive: theme_default.AppThemeColors.statusActive,
      statusInactive: theme_default.AppThemeColors.statusInactive,
      statusPending: theme_default.AppThemeColors.statusPending,
      statusBlocked: theme_default.AppThemeColors.statusBlocked,
      // ===============================================================
      // 22. ROLES
      // ===============================================================
      roleAdmin: theme_default.AppThemeColors.roleAdmin,
      roleManager: theme_default.AppThemeColors.roleManager,
      roleSuperAdmin: theme_default.AppThemeColors.roleSuperAdmin,
      roleOperator: theme_default.AppThemeColors.roleOperator,
      roleViewer: theme_default.AppThemeColors.roleViewer,
      // ===============================================================
      // 23. BRAND
      // ===============================================================
      brandPrimaryGreen: theme_default.AppThemeColors.brandPrimaryGreen,
      brandPrimaryGreenDark: theme_default.AppThemeColors.brandPrimaryGreenDark,
      // GRADIENTE DO FUNDO DA TELA DE LOGIN
      brandLoginGradient: theme_default.AppThemeColors.brandLoginGradient,
      disabledButton: theme_default.AppThemeColors.disabledButton,
      // ===============================================================
      // 24. PRICING
      // ===============================================================
      pricingPercentage: theme_default.AppThemeColors.pricingPercentage,
      pricingPercentageDark: theme_default.AppThemeColors.pricingPercentageDark,
      pricingFixedValue: theme_default.AppThemeColors.pricingFixedValue,
      pricingFixedValueDark: theme_default.AppThemeColors.pricingFixedValueDark,
      pricingIndividual: theme_default.AppThemeColors.pricingIndividual,
      pricingIndividualDark: theme_default.AppThemeColors.pricingIndividualDark,
      pricingMarginReview: theme_default.AppThemeColors.pricingMarginReview,
      pricingMarginReviewDark: theme_default.AppThemeColors.pricingMarginReviewDark,
      pricingDynamic: theme_default.AppThemeColors.pricingDynamic,
      pricingDynamicDark: theme_default.AppThemeColors.pricingDynamicDark,
      pricingHistory: Color(0xFF15803D),
      pricingHistoryDark: Color(0xFF0D6F8B),
      // ===============================================================
      // 25. MÓDULOS
      // ===============================================================
      moduleProdutos: theme_default.AppThemeColors.moduleProdutos,
      moduleProdutosDark: theme_default.AppThemeColors.moduleProdutosDark,
      moduleEtiquetas: theme_default.AppThemeColors.moduleEtiquetas,
      moduleEtiquetasDark: theme_default.AppThemeColors.moduleEtiquetasDark,
      moduleEstrategias: theme_default.AppThemeColors.moduleEstrategias,
      moduleEstrategiasDark: theme_default.AppThemeColors.moduleEstrategiasDark,
      moduleSincronizacao: theme_default.AppThemeColors.moduleSincronizacao,
      moduleSincronizacaoDark: theme_default.AppThemeColors.moduleSincronizacaoDark,
      modulePrecificacao: theme_default.AppThemeColors.modulePrecificacao,
      modulePrecificacaoDark: theme_default.AppThemeColors.modulePrecificacaoDark,
      moduleCategorias: theme_default.AppThemeColors.moduleCategorias,
      moduleCategoriasDark: theme_default.AppThemeColors.moduleCategoriasDark,
      moduleImportacao: theme_default.AppThemeColors.moduleImportacao,
      moduleImportacaoDark: theme_default.AppThemeColors.moduleImportacaoDark,
      moduleRelatorios: theme_default.AppThemeColors.moduleRelatorios,
      moduleRelatoriosDark: theme_default.AppThemeColors.moduleRelatoriosDark,
      moduleConfiguracoes: theme_default.AppThemeColors.moduleConfiguracoes,
      moduleConfiguracoesDark: theme_default.AppThemeColors.moduleConfiguracoesDark,
      // ===============================================================
      // 26. ESCALA DE CINZA
      // ===============================================================
      grey50: theme_default.AppThemeColors.grey50,
      grey100: theme_default.AppThemeColors.grey100,
      grey200: theme_default.AppThemeColors.grey200,
      grey300: theme_default.AppThemeColors.grey300,
      grey400: theme_default.AppThemeColors.grey400,
      grey500: theme_default.AppThemeColors.grey500,
      grey600: theme_default.AppThemeColors.grey600,
      grey700: theme_default.AppThemeColors.grey700,
      grey800: theme_default.AppThemeColors.grey800,
      grey900: theme_default.AppThemeColors.grey900,
      white: theme_default.AppThemeColors.white,
      black: theme_default.AppThemeColors.black,
      // ===============================================================
      // 27. MATERIAL COLORS
      // ===============================================================
      materialTeal: theme_default.AppThemeColors.materialTeal,
      materialTealShade: Color(0xFF0D9488),
      greenLightMaterial: theme_default.AppThemeColors.greenLightMaterial,
      gold: theme_default.AppThemeColors.gold,
      // ===============================================================
      // 28. GRADIENTES DE MÓDULOS
      // ===============================================================
      produtosGradient: [theme_default.AppThemeColors.moduleProdutos, theme_default.AppThemeColors.moduleProdutosDark],
      etiquetasGradient: [theme_default.AppThemeColors.moduleEtiquetas, theme_default.AppThemeColors.moduleEtiquetasDark],
      estrategiasGradient: [theme_default.AppThemeColors.moduleEstrategias, theme_default.AppThemeColors.moduleEstrategiasDark],
      sincronizacaoGradient: [theme_default.AppThemeColors.moduleSincronizacao, theme_default.AppThemeColors.moduleSincronizacaoDark],
      precificacaoGradient: [theme_default.AppThemeColors.modulePrecificacao, theme_default.AppThemeColors.modulePrecificacaoDark],
      categoriasGradient: [theme_default.AppThemeColors.moduleCategorias, theme_default.AppThemeColors.moduleCategoriasDark],
      importacaoGradient: [theme_default.AppThemeColors.moduleImportacao, theme_default.AppThemeColors.moduleImportacaoDark],
      relatoriosGradient: [theme_default.AppThemeColors.moduleRelatorios, theme_default.AppThemeColors.moduleRelatoriosDark],
      configuracoesGradient: [theme_default.AppThemeColors.moduleConfiguracoes, theme_default.AppThemeColors.moduleConfiguracoesDark],
      // ===============================================================
      // 29. CARDS DE ESTRATÉGIA
      // ===============================================================
      strategyCardSugestoesBackground: theme_default.AppThemeColors.strategyCardSugestoesBackground,
      strategyCardSugestoesBorder: theme_default.AppThemeColors.strategyCardSugestoesBorder,
      // ===============================================================
      // 30. STATS E IMPORTS
      // ===============================================================
      statProdutosIcon: theme_default.AppThemeColors.statProdutosIcon,
      statTagsESLIcon: theme_default.AppThemeColors.statTagsESLIcon,
      statSyncIcon: theme_default.AppThemeColors.statSyncIcon,
      statPendentesIcon: theme_default.AppThemeColors.statPendentesIcon,
      // ===============================================================
      // 31. ERP
      // ===============================================================
      erpSAP: theme_default.AppThemeColors.erpSAP,
      erpTOTVS: theme_default.AppThemeColors.erpTOTVS,
      erpOracle: theme_default.AppThemeColors.erpOracle,
      erpSenior: theme_default.AppThemeColors.erpSenior,
      erpSankhya: theme_default.AppThemeColors.erpSankhya,
      erpOmie: theme_default.AppThemeColors.erpOmie,
      erpBling: theme_default.AppThemeColors.erpBling,
      // ===============================================================
      // 32. OUTROS
      // ===============================================================
      blueCyanOverlay05: Color(0x0D06B6D4),
      syncComplete: theme_default.AppThemeColors.syncComplete,
      syncCompleteDark: theme_default.AppThemeColors.syncCompleteDark,
      syncPricesOnly: theme_default.AppThemeColors.syncPricesOnly,
      syncPricesOnlyDark: theme_default.AppThemeColors.syncPricesOnlyDark,
      syncNewProducts: theme_default.AppThemeColors.syncNewProducts,
      syncNewProductsDark: theme_default.AppThemeColors.syncNewProductsDark,
      syncSettings: theme_default.AppThemeColors.syncSettings,
      syncSettingsDark: theme_default.AppThemeColors.syncSettingsDark,
      // ===============================================================
      // 33. CORES AUXILIARES ADICIONAIS
      // ===============================================================
      blueCyan: Color(0xFF06B6D4),
      blueMaterial: Color(0xFF2196F3),
      blueMain: Color(0xFF3B82F6),
      blueDark: Color(0xFF1E40AF),
      blueLight: Color(0xFF93C5FD),
      bluePastel: Color(0xFFDBEAFE),
      greenMaterial: Color(0xFF4CAF50),
      greenMain: Color(0xFF22C55E),
      greenDark: Color(0xFF16A34A),
      greenTeal: Color(0xFF14B8A6),
      greenGradient: Color(0xFF22C55E),
      greenGradientEnd: Color(0xFF16A34A),
      redMain: Color(0xFFEF4444),
      redPastel: Color(0xFFFEE2E2),
      orangeMain: Color(0xFFF97316),
      orangeDark: Color(0xFFEA580C),
      orangeMaterial: Color(0xFFFF9800),
      orangeDeep: Color(0xFFEA580C),
      yellowGold: Color(0xFFF59E0B),
      brownMain: Color(0xFFD97706),
      brownDark: Color(0xFFB45309),
      brownSaddle: Color(0xFF92400E),
      amberMain: Color(0xFFF59E0B),
      amberLight: Color(0xFFFCD34D),
      amberDark: Color(0xFFD97706),
      tealMain: Color(0xFF15803D),
      cyanMain: Color(0xFF15803D),
      blueIndigo: Color(0xFF6366F1),
      silver: Color(0xFF94A3B8),
      bronze: Color(0xFFD97706),
      green50: Color(0xFFECFDF5),
      green200: Color(0xFFA7F3D0),
      green700: Color(0xFF047857),
      red400: Color(0xFFF87171),
      orange100: Color(0xFFFFEDD5),
      greenMainOverlay30: Color(0x4D10B981),
      greenMaterialOverlay05: Color(0x0D10B981),
      greenMaterialOverlay15: Color(0x2610B981),
      greenMaterialOverlay30: Color(0x4D10B981),
      orangeMainOverlay03: Color(0x08F97316),
      tealMainOverlay60: Color(0x9915803D),
      syncedBg: Color(0xFFF1F5F9),
      syncedBorder: Color(0xFFA7F3D0),
      syncedIcon: Color(0xFF10B981),
      syncPendingBg: Color(0xFFFFFBEB),
      syncPendingBorder: Color(0xFFFDE68A),
      syncPendingIcon: Color(0xFFF59E0B),
      syncErrorBg: Color(0xFFFEF2F2),
      syncErrorBorder: Color(0xFFFECACA),
      syncErrorIcon: Color(0xFFEF4444),
      notSyncedBg: Color(0xFFF9FAFB),
      notSyncedBorder: Color(0xFFE2E8F0),
      notSyncedIcon: Color(0xFF94A3B8),
      alertWarningLight: Color(0xFFFFFBEB),
      alertOrangeMain: Color(0xFFF97316),
      alertWarningIcon: Color(0xFFF59E0B),
      alertRedMain: Color(0xFFEF4444),
      alertWarningCardBackground: Color(0xFFFFFBEB),
      alertWarningCardBorder: Color(0xFFFDE68A),
      alertErrorCardBackground: Color(0xFFFEF2F2),
      alertErrorCardBorder: Color(0xFFFECACA),
      alertWarningStart: Color(0xFFFDE68A),
      alertWarningEnd: Color(0xFFFCD34D),
      alertErrorBackground: Color(0xFFFEF2F2),
      onboardingBackground1: Color(0xFFF1F5F9),
      onboardingBackground2: Color(0xFFE2E8F0),
      onboardingBorder: Color(0xFFCBD5E1),
      onboardingIcon: Color(0xFF22C55E),
      onboardingProgress: Color(0xFF16A34A),
      nextStepIcon: Color(0xFF22C55E),
      suggestionCardStart: Color(0xFF10B981),
      suggestionCardEnd: Color(0xFF059669),
      suggestionAumentosBackground: Color(0xFFF1F5F9),
      suggestionAumentosText: Color(0xFF111827),
      suggestionPromocoesBackground: Color(0xFFFFFBEB),
      suggestionPromocoesText: Color(0xFF92400E),
      adminPanelBackground1: Color(0xFFFFFFFF),
      adminPanelBackground2: Color(0xFFF9FAFB),
      white60: Color(0x99FFFFFF),
      white70: Color(0xB3FFFFFF),
      white90: Color(0xE6FFFFFF),
      neutralBlack: Color(0xFF111827),
      neutralWhite: Color(0xFFFFFFFF),
      purpleMedium: Color(0xFF7C3AED),
      surfacePastel: Color(0xFFF9FAFB),
      surfaceOverlay40: Color(0x66000000),
      quickActionExportarTudo: Color(0xFF15803D),
      quickActionAgendar: Color(0xFF84CC16),
      quickActionEmail: Color(0xFF10B981),
      quickActionsImportBackground1: Color(0xFFFFFFFF),
      quickActionsImportBackground2: Color(0xFFF9FAFB),
      quickActionTemplateBackground: Color(0xFF15803D),
      quickActionTemplateBorder: Color(0xFF0D6F8B),
      quickActionUploadBackground: Color(0xFF10B981),
      quickActionUploadBorder: Color(0xFF0B7A57),
      quickActionHistoricoBackground: Color(0xFF15803D),
      quickActionHistoricoBorder: Color(0xFF0891B2),
      importProdutos: Color(0xFF15803D),
      importProdutosDark: Color(0xFF0D6F8B),
      importTags: Color(0xFF10B981),
      importTagsDark: Color(0xFF0B7A57),
      exportProdutos: Color(0xFF84CC16),
      exportProdutosDark: Color(0xFF65A30D),
      exportTags: Color(0xFF22C55E),
      exportTagsDark: Color(0xFF16A34A),
      batchOperations: Color(0xFFF59E0B),
      batchOperationsDark: Color(0xFFD97706),
      importHistorico: Color(0xFF15803D),
      importHistoricoDark: Color(0xFF0891B2),
      categoryVisualizar: Color(0xFF15803D),
      categoryVisualizarDark: Color(0xFF0D6F8B),
      categoryNova: Color(0xFF10B981),
      categoryNovaDark: Color(0xFF0B7A57),
      categoryProdutos: Color(0xFF22C55E),
      categoryProdutosDark: Color(0xFF16A34A),
      categoryAdmin: Color(0xFF059669),
      categoryAdminDark: Color(0xFF047857),
      categoryStats: Color(0xFF84CC16),
      categoryStatsDark: Color(0xFF65A30D),
      categoryImportExport: Color(0xFF22C55E),
      categoryImportExportDark: Color(0xFF16A34A),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeColorsData && other.themeId == themeId;
  }

  @override
  int get hashCode => themeId.hashCode;
}
