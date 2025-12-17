import 'package:flutter/material.dart';

/// ==============================================================================
/// TEMA: ROYAL BLUE - Azul Real Intenso
/// ==============================================================================
///
/// Conceito Visual:
/// Fundo branco, cards azul royal sólido, alto contraste
/// Tema claro, moderno e estimulante para uso diurno, focado em produtividade e clareza.
/// Cores vibrantes e frescas que transmitem energia, foco e progresso contínuo.
/// Evita tons pesados ou monótonos, priorizando contraste e legibilidade.
/// 
/// Paleta Base:
/// - Primária (Teal Fresh): #0D9488  (vibrante e refrescante)
/// - Secundária (Fresh Cyan): #06B6D4 (dinamismo e energia)
/// - Terciária (Emerald Green): #10B981 (crescimento e sucesso)
/// - Acento (Lime Green): #84CC16 (destaque e vitalidade)
/// - Fundos: Branco puro #FFFFFF e cinzas muito claros (#F8FAFC, #F1F5F9)
/// - Texto principal: Cinza escuro #1E293B (alto contraste)
/// - Texto secundário: Cinza médio #64748B
/// - Texto terciário: Cinza claro #94A3B8
///
/// ==============================================================================

class AppThemeColors {
  AppThemeColors._();

  // ===========================================================================
  // 1. SUPERFÍCIES E FUNDOS (BACKGROUNDS) - "CLAREZA E FRESCOR DIURNO"
  // ===========================================================================

  /// Fundo principal claro (Scaffold). Branco puro para máxima clareza.
  static const Color backgroundLight = Color(0xFFFFFFFF);

  /// Superfície elevada (Cards, Modais). Branco puro para destaque sutil.
  static const Color surface = Color(0xFFFFFFFF);

  /// Superfície variante (Sidebars, AppBars). Cinza muito claro para leve separação.
  static const Color surfaceVariant = Color(0xFFF9FAFB);

  /// Fundo de inputs (Campos de texto). Cinza claríssimo para conforto visual.
  static const Color inputBackground = Color(0xFFF9FAFB);

  /// Fundo secundário para áreas de separação. Cinza claro e neutro.
  static const Color backgroundMedium = Color(0xFFF3F4F6);

  /// Fundo escuro para contraste suave, mantendo leveza.
  static const Color backgroundDark = Color(0xFFE2E8F0);

  /// Transparente, para usos diversos.
  static const Color transparent = Color(0x00000000);

  // ===========================================================================
  // 1.1. OVERLAYS PRÉ-DEFINIDOS - OPACIDADES (Preto com transparência)
  // ===========================================================================

  static const Color surfaceOverlay10 = Color(0x1A000000);
  static const Color surfaceOverlay15 = Color(0x26000000);
  static const Color surfaceOverlay20 = Color(0x33000000);
  static const Color surfaceOverlay25 = Color(0x40000000);
  static const Color surfaceOverlay30 = Color(0x4D000000);
  static const Color surfaceOverlay50 = Color(0x80000000);
  static const Color surfaceOverlay70 = Color(0xB3000000);
  static const Color surfaceOverlay80 = Color(0xCC000000);
  static const Color surfaceOverlay85 = Color(0xD9000000);
  static const Color surfaceOverlay90 = Color(0xE6000000);

  static const Color shadowVeryLight = Color(0x0D000000);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x26000000);
  static const Color shadowRegular = Color(0x33000000);

  static const Color textPrimaryOverlay05 = Color(0x0D1E293B);
  static const Color textPrimaryOverlay06 = Color(0x0F1E293B);
  static const Color textPrimaryOverlay10 = Color(0x1A1E293B);

  // ===========================================================================
  // 1.2. OVERLAYS UNIVERSAIS - PRETO E CORES COM OPACIDADE
  // ===========================================================================

  static const Color overlay05 = Color(0x0D000000);
  static const Color overlay08 = Color(0x14000000);
  static const Color overlay10 = Color(0x1A000000);
  static const Color overlay15 = Color(0x26000000);
  static const Color overlay20 = Color(0x33000000);
  static const Color overlay30 = Color(0x4D000000);

  static const Color primaryOverlay05 = Color(0x0D0D9488);
  static const Color primaryOverlay10 = Color(0x1A0D9488);
  static const Color primaryOverlay20 = Color(0x330D9488);

  static const Color successOverlay05 = Color(0x0D10B981);
  static const Color successOverlay10 = Color(0x1A10B981);
  static const Color successOverlay20 = Color(0x3310B981);

  static const Color warningOverlay05 = Color(0x0DF59E0B);
  static const Color warningOverlay10 = Color(0x1AF59E0B);
  static const Color warningOverlay20 = Color(0x33F59E0B);

  static const Color pulseBase = Color(0x1AF8FAFF);
  static const Color pulseHighlight = Color(0x33B3E0F5);

  static const Color skeletonBase = Color(0x1A06B6D4);
  static const Color skeletonHighlight = Color(0x3306B6D4);

  // ===========================================================================
  // 2. TEXTO E TIPOGRAFIA - "LEGIBILIDADE E FOCO"
  // ===========================================================================

  /// Texto principal: Cinza escuro para alto contraste e legibilidade.
  static const Color textPrimary = Color(0xFF111827);

  /// Texto secundário: Cinza médio para hierarquia visual clara.
  static const Color textSecondary = Color(0xFF6B7280);

  /// Texto terciário: Cinza claro para legendas e detalhes sutis.
  static const Color textTertiary = Color(0xFF94A3B8);

  /// Texto claro para placeholders e estados desabilitados.
  static const Color textLight = Color(0xFFCBD5E1);

  /// Texto desabilitado: cinza muito claro para indicar inatividade.
  static const Color textDisabled = Color(0xFF94A3B8);

  // ===========================================================================
  // 3. BORDAS E DIVISORES - "LINHAS SUAVES E FUNCIONAIS"
  // ===========================================================================

  /// Borda padrão: cinza claro para separação discreta.
  static const Color border = Color(0xFFE2E8F0);

  /// Borda clara para áreas menos destacadas.
  static const Color borderLight = Color(0xFFF3F4F6);

  /// Borda média para elementos interativos.
  static const Color borderMedium = Color(0xFFCBD5E1);

  /// Borda escura para destaque sutil.
  static const Color borderDark = Color(0xFF6B7280);

  /// Divisor padrão: cinza claro para separar conteúdo.
  static const Color divider = Color(0xFFE2E8F0);

  // ===========================================================================
  // 4. OVERLAYS E SOMBRAS GERAIS - "PROFUNDIDADE CONTROLADA"
  // ===========================================================================

  static const Color overlayLight = Color(0x0D000000);
  static const Color overlayLighter = Color(0x08000000);
  static const Color overlayDark = Color(0x80000000);

  // ===========================================================================
  // 5. STATUS E FEEDBACK SEMÂNTICO - CORES VIBRANTES E CLARAS
  // ===========================================================================

  // --- ERRO ---
  static const Color errorBackground = Color(0xFFFEF2F2);
  static const Color errorLight = Color(0xFFFCA5A5);
  static const Color errorDark = Color(0xFFB91C1C);
  static const Color errorBorder = Color(0xFFFECACA);
  static const Color errorText = Color(0xFF991B1B);
  static const Color errorMain = Color(0xFFEF4444);
  static const Color urgent = Color(0xFFDC2626);

  // --- INFORMAÇÀO ---
  static const Color infoBackground = Color(0xFFF0FDFA);
  static const Color infoLight = Color(0xFF5EEAD4);
  static const Color infoBorder = Color(0xFF99F6E4);
  static const Color infoText = Color(0xFF0F766E);
  static const Color infoIcon = Color(0xFF4F46E5);
  static const Color infoDark = Color(0xFF2563EB);

  // --- SUCESSO ---
  static const Color successBackground = Color(0xFFECFDF5);
  static const Color successLight = Color(0xFF6EE7B7);
  static const Color successDark = Color(0xFF059669);
  static const Color successBorder = Color(0xFFA7F3D0);
  static const Color success = Color(0xFF10B981);
  static const Color successGlow = Color(0x4D10B981);
  static const Color successText = Color(0xFF1D4ED8);
  static const Color successIcon = Color(0xFF10B981);
  static const Color successDark2 = Color(0xFF047857);

  // --- ALERTA ---
  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color warningBorder = Color(0xFFFDE68A);
  static const Color warningText = Color(0xFF92400E);
  static const Color warningIcon = Color(0xFFF59E0B);

  // ===========================================================================
  // 6. DASHBOARD E NAVEGAÇÀO - CORES DINÂMICAS E LEVES
  // ===========================================================================

  /// Cor primária para dashboard: Teal Fresh, estimulando foco e clareza.
  static const Color primaryDashboard = Color(0xFF2563EB);
  static const Color primaryDashboardDark = Color(0xFF1D4ED8);

  // AppBar
  static const Color dashboardAppBarBackground = Color(0xFFFFFFFF);
  static const Color dashboardAppBarShadow = Color(0x1A0D9488);

  // Menu Lateral (Drawer)
  static const Color dashboardDrawerBackground1 = Color(0xFFFFFFFF);
  static const Color dashboardDrawerBackground2 = Color(0xFFF9FAFB);

  // Elementos do Drawer
  static const Color dashboardDrawerHeaderIcon = Color(0xFF2563EB);
  static const Color dashboardDrawerHeaderIconBg = Color(0xFFF3F4F6);
  static const Color dashboardDrawerHeaderText = Color(0xFF111827);
  static const Color dashboardDrawerHeaderTextSecondary = Color(0xFF6B7280);
  static const Color dashboardDrawerItemSelected = Color(0xFFF3F4F6);
  static const Color dashboardDrawerItemUnselected = transparent;
  static const Color dashboardDrawerItemTextSelected = Color(0xFF2563EB);
  static const Color dashboardDrawerItemTextUnselected = Color(0xFF6B7280);

  // Bottom Navigation
  static const Color dashboardBottomNavBackground = Color(0xFFFFFFFF);
  static const Color dashboardBottomNavShadow = Color(0x1A0D9488);
  static const Color dashboardBottomNavIconSelected = Color(0xFF2563EB);
  static const Color dashboardBottomNavIconUnselected = Color(0xFF94A3B8);
  static const Color dashboardBottomNavTextSelected = Color(0xFF2563EB);
  static const Color dashboardBottomNavTextUnselected = Color(0xFF94A3B8);

  // Navigation Rail
  static const Color dashboardRailBackground = Color(0xFFFFFFFF);
  static const Color dashboardRailShadow = Color(0x1A0D9488);
  static const Color dashboardRailToggleBackground = Color(0xFFF9FAFB);
  static const Color dashboardRailToggleIcon = Color(0xFF6B7280);
  static const Color dashboardRailItemIconSelected = Color(0xFFFFFFFF);
  static const Color dashboardRailItemIconUnselected = Color(0xFF6B7280);
  static const Color dashboardRailItemTextSelected = Color(0xFF2563EB);
  static const Color dashboardRailItemTextUnselected = Color(0xFF6B7280);

  static const Color dashboardLogoIconColor = Color(0xFF2563EB);

  // Barra de Busca
  static const Color dashboardSearchBackground = Color(0xFFF9FAFB);
  static const Color dashboardSearchHint = Color(0xFF94A3B8);
  static const Color dashboardSearchIcon = Color(0xFF6B7280);

  // Notificações e Badges
  static const Color dashboardNotificationBackground = Color(0xFFF3F4F6);
  static const Color dashboardNotificationBadge = Color(0xFFEF4444);
  static const Color dashboardNotificationIcon = Color(0xFF2563EB);

  // Status de Conexão
  static const Color dashboardConnectionBackground = Color(0xFFF3F4F6);
  static const Color dashboardConnectionBorder = Color(0xFFCBD5E1);
  static const Color dashboardConnectionDot = Color(0xFF10B981);
  static const Color dashboardConnectionDotGlow = Color(0x4D10B981);
  static const Color dashboardConnectionText = Color(0xFF111827);

  // User Menu
  static const Color dashboardUserMenuBackground1 = Color(0xFFFFFFFF);
  static const Color dashboardUserMenuBackground2 = Color(0xFFF9FAFB);
  static const Color dashboardUserMenuAvatarBg = Color(0xFF2563EB);
  static const Color dashboardUserMenuAvatarText = Color(0xFFFFFFFF);
  static const Color dashboardUserMenuText = Color(0xFF111827);
  static const Color dashboardUserMenuTextSecondary = Color(0xFF6B7280);
  static const Color dashboardUserMenuIcon = Color(0xFF6B7280);
  static const Color dashboardUserMenuIconDestructive = Color(0xFFEF4444);
  static const Color dashboardUserMenuTextDestructive = Color(0xFFEF4444);

  // Texto de Boas Vindas
  static const Color dashboardWelcomeText = Color(0xFF111827);
  static const Color dashboardWelcomeTextSecondary = Color(0xFF6B7280);
  static const Color dashboardWelcomeTextTertiary = Color(0xFF94A3B8);
  static const Color dashboardWelcomeIcon = Color(0xFF2563EB);

  // ===========================================================================
  // 7. CARDS E MÉTRICAS (KPIs) - DINÂMICOS E LEVES
  // ===========================================================================

  static const Color dashboardMetricsCardBackground = Color(0xFFFFFFFF);

  static const Color dashboardMetricsCardShadowBlue = Color(0x1A06B6D4);
  static const Color dashboardMetricsCardShadowPurple = Color(0x1A8B5CF6);
  static const Color dashboardMetricsCardShadowRed = Color(0x1AEF4444);
  static const Color dashboardMetricsCardShadowGreen = Color(0x1A10B981);
  static const Color dashboardMetricsCardShadowOrange = Color(0x1AF59E0B);

  // Cores de Identidade das Métricas - vibrantes e claras
  static const Color dashboardMetricsBlue = Color(0xFF4F46E5);
  static const Color dashboardMetricsPurple = Color(0xFF8B5CF6);
  static const Color dashboardMetricsRed = Color(0xFFEF4444);
  static const Color dashboardMetricsGreen = Color(0xFF10B981);
  static const Color dashboardMetricsOrange = Color(0xFFF59E0B);

  // Fundos Sutis para Cards
  static const Color dashboardMetricsBlueLight = Color(0xFFF0FDFF);
  static const Color dashboardMetricsBlueVeryLight = Color(0xFFE0F7FF);
  static const Color dashboardMetricsPurpleLight = Color(0xFFF5F3FF);
  static const Color dashboardMetricsPurpleVeryLight = Color(0xFFEDE9FE);
  static const Color dashboardMetricsRedLight = Color(0xFFFEF2F2);
  static const Color dashboardMetricsRedVeryLight = Color(0xFFFEE2E2);
  static const Color dashboardMetricsGreenLight = Color(0xFFECFDF5);
  static const Color dashboardMetricsGreenVeryLight = Color(0xFFD1FAE5);
  static const Color dashboardMetricsOrangeLight = Color(0xFFFFFBEB);
  static const Color dashboardMetricsOrangeVeryLight = Color(0xFFFEF3C7);

  // Bordas dos Cards
  static const Color dashboardMetricsBlueBorder = Color(0xFF99F6E4);
  static const Color dashboardMetricsPurpleBorder = Color(0xFFDDD6FE);
  static const Color dashboardMetricsRedBorder = Color(0xFFFECACA);
  static const Color dashboardMetricsGreenBorder = Color(0xFFA7F3D0);
  static const Color dashboardMetricsOrangeBorder = Color(0xFFFDE68A);

  static const Color dashboardMetricsValueText = Color(0xFF111827);
  static const Color dashboardMetricsLabelText = Color(0xFF6B7280);

  // Cards Genéricos
  static const Color dashboardCardBackground = Color(0xFFFFFFFF);
  static const Color dashboardCardShadow = Color(0x1A0D9488);
  static const Color dashboardCardTitle = Color(0xFF111827);
  static const Color dashboardCardSubtitle = Color(0xFF6B7280);

  // ===========================================================================
  // 8. CORES DE MÓDULOS - "PALETA MODERNA E DINÂMICA"
  // ===========================================================================

  static const Color moduleDashboard = Color(0xFF2563EB);       // Teal Fresh
  static const Color moduleDashboardDark = Color(0xFF1D4ED8);

  static const Color moduleProdutos = Color(0xFF4F46E5);        // Fresh Cyan
  static const Color moduleProdutosDark = Color(0xFF0D6F8B);

  static const Color moduleEtiquetas = Color(0xFF10B981);       // Emerald Green
  static const Color moduleEtiquetasDark = Color(0xFF0B7A57);

  static const Color moduleEstrategias = Color(0xFFEC4899);     // Lime Green
  static const Color moduleEstrategiasDark = Color(0xFFDB2777);

  static const Color moduleSincronizacao = Color(0xFF4F46E5);   // Fresh Cyan
  static const Color moduleSincronizacaoDark = Color(0xFF4338CA);

  static const Color modulePrecificacao = Color(0xFFF59E0B);    // Amber
  static const Color modulePrecificacaoDark = Color(0xFFD97706);

  static const Color moduleCategorias = Color(0xFF10B981);      // Emerald Green
  static const Color moduleCategoriasDark = Color(0xFF0B7A57);

  static const Color moduleImportacao = Color(0xFF2563EB);      // Teal Fresh
  static const Color moduleImportacaoDark = Color(0xFF1D4ED8);

  static const Color moduleRelatorios = Color(0xFF059669);      // Emerald Dark
  static const Color moduleRelatoriosDark = Color(0xFF047857);

  static const Color moduleConfiguracoes = Color(0xFF6B7280);   // Cinza médio
  static const Color moduleConfiguracoesDark = Color(0xFF475569);

  // ===========================================================================
  // 9. GRADIENTES - DINÂMICOS E MODERNOS
  // ===========================================================================

  static const List<Color> produtosGradient = [Color(0xFF4F46E5), Color(0xFF0D6F8B)];
  static const List<Color> etiquetasGradient = [Color(0xFF10B981), Color(0xFF0B7A57)];
  static const List<Color> estrategiasGradient = [Color(0xFFEC4899), Color(0xFFDB2777)];
  static const List<Color> sincronizacaoGradient = [Color(0xFF4F46E5), Color(0xFF4338CA)];
  static const List<Color> precificacaoGradient = [Color(0xFFF59E0B), Color(0xFFD97706)];
  static const List<Color> categoriasGradient = [Color(0xFF10B981), Color(0xFF0B7A57)];
  static const List<Color> importacaoGradient = [Color(0xFF2563EB), Color(0xFF1D4ED8)];
  static const List<Color> relatoriosGradient = [Color(0xFF059669), Color(0xFF047857)];
  static const List<Color> configuracoesGradient = [Color(0xFF6B7280), Color(0xFF475569)];

  static const List<Color> successGradient = [Color(0xFF10B981), Color(0xFF059669)];
  static const List<Color> warningGradient = [Color(0xFFF59E0B), Color(0xFFD97706)];
  static const List<Color> errorGradient = [Color(0xFFEF4444), Color(0xFFDC2626)];
  static const List<Color> infoGradient = [Color(0xFF4F46E5), Color(0xFF2563EB)];

  // ===========================================================================
  // 10. ELEMENTOS DE UI GERAIS - "INTERATIVIDADE E FEEDBACK"
  // ===========================================================================

  static const Color disabledButton = Color(0xFFE2E8F0);
  static const Color disabledText = Color(0xFF94A3B8);
  static const Color disabled = Color(0xFFCBD5E1);

  static const Color surfaceLow = Color(0xFFF9FAFB);
  static const Color surfaceHigh = Color(0xFFFFFFFF);
  static const Color surfaceTinted = Color(0xFFF3F4F6);
  static const Color surfaceTintedDark = Color(0xFFE2E8F0);

  // Menu de Usuário
  static const Color userMenuBackgroundStart = Color(0xFFFFFFFF);
  static const Color userMenuBackgroundEnd = Color(0xFFF9FAFB);
  static const Color userMenuAvatarBackground = Color(0xFF2563EB);
  static const Color userMenuAvatarText = Color(0xFFFFFFFF);
  static const Color userMenuHighlight = Color(0xFFF3F4F6);
  static const Color menuItemHover = Color(0xFFF9FAFB);
  static const Color avatarBackground = Color(0xFF2563EB);
  static const Color avatarText = Color(0xFFFFFFFF);
  static const Color destructive = Color(0xFFEF4444);

  // Ícones
  static const Color iconDefault = Color(0xFF6B7280);
  static const Color iconLight = Color(0xFF94A3B8);
  static const Color iconOnSurface = Color(0xFF059669);
  static const Color errorIcon = Color(0xFFEF4444);

  // ===========================================================================
  // 10.1. CORES CONDICIONAIS E ESTADOS DINÂMICOS
  // ===========================================================================

  static const Color connectionOnline = Color(0xFF10B981);
  static const Color connectionOffline = Color(0xFFEF4444);
  static const Color connectionPending = Color(0xFFF59E0B);
  static const Color connectionSyncing = Color(0xFF4F46E5);

  static const Color batteryHigh = Color(0xFF10B981);
  static const Color batteryMedium = Color(0xFFF59E0B);
  static const Color batteryLow = Color(0xFFEF4444);
  static const Color batteryCritical = Color(0xFFDC2626);

  static const Color erpConnected = Color(0xFF10B981);
  static const Color erpDisconnected = Color(0xFFEF4444);
  static const Color erpError = Color(0xFFDC2626);
  static const Color erpSyncing = Color(0xFF4F46E5);

  static const Color tagOnline = Color(0xFF10B981);
  static const Color tagOffline = Color(0xFFEF4444);
  static const Color tagPending = Color(0xFFF59E0B);
  static const Color tagError = Color(0xFFDC2626);

  static const Color productActive = Color(0xFF10B981);
  static const Color productInactive = Color(0xFF94A3B8);
  static const Color productOutOfStock = Color(0xFFEF4444);
  static const Color productLowStock = Color(0xFFF59E0B);

  // ===========================================================================
  // 11. CORES DE CATEGORIAS - "VARIEDADE MODERNA"
  // ===========================================================================

  static const Color categoryBebidas = Color(0xFF4F46E5);
  static const Color categoryBebidasDark = Color(0xFF0D6F8B);

  static const Color categoryMercearia = Color(0xFFF59E0B);
  static const Color categoryMerceariaDark = Color(0xFFD97706);

  static const Color categoryPereciveis = Color(0xFF10B981);
  static const Color categoryPereciveisDark = Color(0xFF0B7A57);

  static const Color categoryLimpeza = Color(0xFF4F46E5);
  static const Color categoryLimpezaDark = Color(0xFF4338CA);

  static const Color categoryHigiene = Color(0xFFEC4899);
  static const Color categoryHigieneDark = Color(0xFFDB2777);

  static const Color categoryHortifruti = Color(0xFFEC4899);
  static const Color categoryHortifrutiDark = Color(0xFFDB2777);

  static const Color categoryFrios = Color(0xFF2563EB);
  static const Color categoryFriosDark = Color(0xFF1D4ED8);

  static const Color categoryPadaria = Color(0xFFF97316);
  static const Color categoryPadariaDark = Color(0xFFEA580C);

  static const Color categoryPet = Color(0xFF8B5CF6);
  static const Color categoryPetDark = Color(0xFF7C3AED);

  // ===========================================================================
  // 12. INTEGRAÇÕES (ERP BRANDING) - CORES MODERNAS
  // ===========================================================================

  static const Color erpSAP = Color(0xFF4F46E5);
  static const Color erpTOTVS = Color(0xFF4F46E5);
  static const Color erpOracle = Color(0xFFEF4444);
  static const Color erpSenior = Color(0xFF10B981);
  static const Color erpSankhya = Color(0xFFEC4899);
  static const Color erpOmie = Color(0xFF2563EB);
  static const Color erpBling = Color(0xFF6B7280);

  // ===========================================================================
  // 13. ROLES E STATUS DE USUÁRIO - CORES FUNCIONAIS
  // ===========================================================================

  static const Color roleSuperAdmin = Color(0xFFEF4444);
  static const Color roleAdmin = Color(0xFF10B981);
  static const Color roleManager = Color(0xFF4F46E5);
  static const Color roleOperator = Color(0xFFF59E0B);
  static const Color roleViewer = Color(0xFF6B7280);

  static const Color statusActive = Color(0xFF10B981);
  static const Color statusInactive = Color(0xFF94A3B8);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusBlocked = Color(0xFFEF4444);

  // ===========================================================================
  // 14. HELPERS E PALETAS AUXILIARES - CINZAS E VERDES SUAVES
  // ===========================================================================

  // Escala de Cinza/Verde (Light Mode Base)
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF111827);
  static const Color grey900 = Color(0xFF0F172A);
  static const Color greySlate = Color(0xFF6B7280);
  static const Color greyDarkSlate = Color(0xFF111827);

  static const Color grey500Overlay10 = Color(0x1A64748B);

  // Básicos
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralBlack = Color(0xFF111827);

  static Color get neutralBlackOpacity05 => const Color(0x0D1E293B);
  static Color get neutralBlackOpacity10 => const Color(0x1A1E293B);

  // Aliases de Legado
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color info = Color(0xFF4F46E5);
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryMain = primary;
  static const Color secondary = Color(0xFF4F46E5);

  // Material Colors - DINÂMICOS E CLAROS
  static const Color materialBlue = Color(0xFF4F46E5);
  static const Color materialPurple = Color(0xFF8B5CF6);
  static const Color materialRed = Color(0xFFEF4444);
  static const Color materialGreen = Color(0xFF10B981);
  static const Color materialOrange = Color(0xFFF59E0B);
  static const Color materialTeal = Color(0xFF2563EB);

  // Shades Auxiliares
  static const Color blue50 = Color(0xFFF0FDFF);
  static const Color blue100 = Color(0xFFE0F7FF);
  static const Color blue200 = Color(0xFF99F6E4);
  static const Color blue = Color(0xFF4F46E5);

  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red200 = Color(0xFFFECACA);
  static const Color red400 = Color(0xFFF87171);
  static const Color red = Color(0xFFEF4444);

  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFEDD5);

  static const Color green50 = Color(0xFFECFDF5);
  static const Color green200 = Color(0xFFA7F3D0);
  static const Color green = Color(0xFF10B981);
  static const Color green700 = Color(0xFF047857);

  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white90 = Color(0xE6FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);

  static const Color black = Color(0xFF111827);
  static const Color black87 = Color(0xDE1E293B);
  static const Color black54 = Color(0x8A1E293B);
  static const Color black45 = Color(0x731E293B);
  static const Color black26 = Color(0x421E293B);
  static const Color black12 = Color(0x1F1E293B);

  // Brand Colors - Teal Fresh e Acentos
  static const Color brandPrimaryTeal = Color(0xFF2563EB);
  static const Color brandPrimaryTealDark = Color(0xFF1D4ED8);
  static const Color brandPrimaryTealLight = Color(0xFF3B82F6);
  static const Color brandAccentLime = Color(0xFFEC4899);

  // Aliases de compatibilidade (para código legado que usa brandPrimaryGreen)
  static const Color brandPrimaryGreen = brandPrimaryTeal;
  static const Color brandPrimaryGreenDark = brandPrimaryTealDark;
  static const Color brandPrimaryGreenLight = brandPrimaryTealLight;

  // Gradiente Principal: Teal Fresh vibrante
  static const LinearGradient brandPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
  );

  static const LinearGradient brandLoginGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2563EB), Color(0xFF1E3A3A)],
  );

  // ===========================================================================
  // 15. ELEMENTOS DE TELAS ESPECÍFICAS - CORES FUNCIONAIS
  // ===========================================================================

  // Cards de Categoria
  static const Color categoryVisualizar = Color(0xFF4F46E5);
  static const Color categoryVisualizarDark = Color(0xFF0D6F8B);

  static const Color categoryNova = Color(0xFF10B981);
  static const Color categoryNovaDark = Color(0xFF0B7A57);

  static const Color categoryProdutos = Color(0xFF2563EB);
  static const Color categoryProdutosDark = Color(0xFF1D4ED8);

  static const Color categoryAdmin = Color(0xFF059669);
  static const Color categoryAdminDark = Color(0xFF047857);

  static const Color categoryStats = Color(0xFFEC4899);
  static const Color categoryStatsDark = Color(0xFFDB2777);

  static const Color categoryImportExport = Color(0xFF2563EB);
  static const Color categoryImportExportDark = Color(0xFF1D4ED8);

  // Importação e Exportação - CORES DINÂMICAS
  static const Color importProdutos = Color(0xFF4F46E5);
  static const Color importProdutosDark = Color(0xFF0D6F8B);

  static const Color importTags = Color(0xFF10B981);
  static const Color importTagsDark = Color(0xFF0B7A57);

  static const Color exportProdutos = Color(0xFFEC4899);
  static const Color exportProdutosDark = Color(0xFFDB2777);

  static const Color exportTags = Color(0xFF22C55E);
  static const Color exportTagsDark = Color(0xFF16A34A);

  static const Color batchOperations = Color(0xFFF59E0B);
  static const Color batchOperationsDark = Color(0xFFD97706);

  static const Color importHistorico = Color(0xFF4F46E5);
  static const Color importHistoricoDark = Color(0xFF4338CA);

  // Stats Cards - Fundos claros e frescos
  static const Color statTagsBackground = Color(0xFFF3F4F6);
  static const Color statTagsIcon = Color(0xFF10B981);
  static const Color statTagsBorder = Color(0xFFA7F3D0);

  static const Color statVendasBackground = Color(0xFFF9FAFB);
  static const Color statVendasIcon = Color(0xFF22C55E);
  static const Color statVendasBorder = Color(0xFFBBF7D0);

  static const Color statInsightsBackground = Color(0xFFF7FEE7);
  static const Color statInsightsIcon = Color(0xFFEC4899);
  static const Color statInsightsBorder = Color(0xFFD9F99D);

  static const Color statLogsBackground = Color(0xFFF0FDFA);
  static const Color statLogsIcon = Color(0xFF4F46E5);
  static const Color statLogsBorder = Color(0xFF99F6E4);

  // Cards de Ações Rápidas - CORES VIBRANTES
  static const Color quickActionTemplateBackground = Color(0xFF4F46E5);
  static const Color quickActionTemplateIcon = Color(0xFFFFFFFF);
  static const Color quickActionTemplateBorder = Color(0xFF0D6F8B);

  static const Color quickActionUploadBackground = Color(0xFF10B981);
  static const Color quickActionUploadIcon = Color(0xFFFFFFFF);
  static const Color quickActionUploadBorder = Color(0xFF0B7A57);

  static const Color quickActionHistoricoBackground = Color(0xFF4F46E5);
  static const Color quickActionHistoricoIcon = Color(0xFFFFFFFF);
  static const Color quickActionHistoricoBorder = Color(0xFF4338CA);

  // Cards de Ações - Estratégias
  static const Color strategyCardSugestoesBackground = Color(0xFFF7FEE7);
  static const Color strategyCardSugestoesIcon = Color(0xFFEC4899);
  static const Color strategyCardSugestoesBorder = Color(0xFFD9F99D);

  static const Color strategyCardSecondaryBackground = Color(0xFFF3F4F6);
  static const Color strategyCardSecondaryIcon = Color(0xFF10B981);
  static const Color strategyCardSecondaryBorder = Color(0xFFA7F3D0);

  // ===========================================================================
  // CONTAINERS PRINCIPAIS - FUNDOS CLAROS E FUNCIONAIS
  // ===========================================================================

  static const Color statsOverviewBackground1 = Color(0xFFFFFFFF);
  static const Color statsOverviewBackground2 = Color(0xFFF9FAFB);

  static const Color quickActionsReportsBackground1 = Color(0xFFFFFFFF);
  static const Color quickActionsReportsBackground2 = Color(0xFFF9FAFB);

  static const Color quickActionsImportBackground1 = Color(0xFFFFFFFF);
  static const Color quickActionsImportBackground2 = Color(0xFFF9FAFB);

  static const Color quickActionsStrategiesBackground1 = Color(0xFFF7FEE7);
  static const Color quickActionsStrategiesBackground2 = Color(0xFFE6F2A2);

  static const Color statsOverviewImportBackground1 = Color(0xFFF0FDFA);
  static const Color statsOverviewImportBackground2 = Color(0xFFE0F7FF);

  // ===========================================================================
  // AÇÕES RÁPIDAS - BOTÕES VIBRANTES E FUNCIONAIS
  // ===========================================================================

  static const Color quickActionExportarTudo = Color(0xFF4F46E5);
  static const Color quickActionAgendar = Color(0xFFEC4899);
  static const Color quickActionEmail = Color(0xFF10B981);

  // ===========================================================================
  // PAINEL ADMINISTRATIVO - CORES CLARAS E PROFISSIONAIS
  // ===========================================================================

  static const Color adminPanelBackground1 = Color(0xFFFFFFFF);
  static const Color adminPanelBackground2 = Color(0xFFF9FAFB);

  static const Color adminPanelButtonLojas = Color(0xFF4F46E5);
  static const Color adminPanelButtonUsuarios = Color(0xFF10B981);
  static const Color adminPanelButtonConfig = Color(0xFF6B7280);

  // ===========================================================================
  // PRIMEIROS PASSOS (Onboarding Light) - GUIA SUAVE
  // ===========================================================================

  static const Color onboardingBackground1 = Color(0xFFF3F4F6);
  static const Color onboardingBackground2 = Color(0xFFE2E8F0);
  static const Color onboardingBorder = Color(0xFFCBD5E1);

  static const Color onboardingIcon = Color(0xFF2563EB);
  static const Color onboardingProgress = Color(0xFF1D4ED8);

  static const Color onboardingStepCompleted = Color(0xFF2563EB);
  static const Color onboardingStepPending = Color(0xFF4F46E5);
  static const Color onboardingStepPendingBg = Color(0xFFF0FDFF);

  // ===========================================================================
  // PRÓXIMO PASSO - INDICAÇÀO CLARA
  // ===========================================================================

  static const Color nextStepBackground1 = Color(0xFFF3F4F6);
  static const Color nextStepBackground2 = Color(0xFFE2E8F0);
  static const Color nextStepBorder = Color(0xFFCBD5E1);
  static const Color nextStepIcon = Color(0xFF2563EB);
  static const Color nextStepTitle = Color(0xFF111827);

  // Stats Importação - CORES FUNCIONAIS
  static const Color statProdutosBackground = Color(0xFFF0FDFF);
  static const Color statProdutosIcon = Color(0xFF4F46E5);
  static const Color statProdutosBorder = Color(0xFF99F6E4);

  static const Color statTagsESLBackground = Color(0xFFF3F4F6);
  static const Color statTagsESLIcon = Color(0xFF10B981);
  static const Color statTagsESLBorder = Color(0xFFA7F3D0);

  static const Color statSyncBackground = Color(0xFFF0FDFF);
  static const Color statSyncIcon = Color(0xFF4F46E5);
  static const Color statSyncBorder = Color(0xFF99F6E4);

  static const Color statPendentesBackground = Color(0xFFFFFBEB);
  static const Color statPendentesIcon = Color(0xFFF59E0B);
  static const Color statPendentesBorder = Color(0xFFFDE68A);

  // Relatórios - CORES DINÂMICAS
  static const Color reportOperacional = Color(0xFF2563EB);
  static const Color reportOperacionalDark = Color(0xFF1D4ED8);

  static const Color reportVendas = Color(0xFF10B981);
  static const Color reportVendasDark = Color(0xFF0B7A57);

  static const Color reportPerformance = Color(0xFFEC4899);
  static const Color reportPerformanceDark = Color(0xFFDB2777);

  static const Color reportAuditoria = Color(0xFF4F46E5);
  static const Color reportAuditoriaDark = Color(0xFF0D6F8B);

  // ===========================================================================
  // 16. PRECIFICAÇÀO E SINCRONIZAÇÀO - CORES FUNCIONAIS
  // ===========================================================================

  static const Color pricingPercentage = Color(0xFF4F46E5);
  static const Color pricingPercentageDark = Color(0xFF0D6F8B);
  static const Color pricingFixedValue = Color(0xFF10B981);
  static const Color pricingFixedValueDark = Color(0xFF0B7A57);
  static const Color pricingIndividual = Color(0xFFEC4899);
  static const Color pricingIndividualDark = Color(0xFFDB2777);
  static const Color pricingMarginReview = Color(0xFF4F46E5);
  static const Color pricingMarginReviewDark = Color(0xFF4338CA);
  static const Color pricingDynamic = Color(0xFF2563EB);
  static const Color pricingDynamicDark = Color(0xFF1D4ED8);
  static const Color pricingHistory = Color(0xFF4F46E5);
  static const Color pricingHistoryDark = Color(0xFF0D6F8B);

  static const Color syncComplete = Color(0xFF10B981);
  static const Color syncCompleteDark = Color(0xFF0B7A57);
  static const Color syncPricesOnly = Color(0xFF6EE7B7);
  static const Color syncPricesOnlyDark = Color(0xFF34D399);
  static const Color syncNewProducts = Color(0xFF22C55E);
  static const Color syncNewProductsDark = Color(0xFF16A34A);
  static const Color syncSettings = Color(0xFF2563EB);
  static const Color syncSettingsDark = Color(0xFF1D4ED8);

  // ===========================================================================
  // 17. ALERTA E HELPERS DE STATUS - CORES CLARAS E VIBRANTES
  // ===========================================================================

  static const Color alertWarningLight = Color(0xFFFFFBEB);
  static const Color alertOrangeMain = Color(0xFFF97316);
  static const Color alertWarningIcon = Color(0xFFF59E0B);
  static const Color alertRedMain = Color(0xFFEF4444);

  static const Color infoCardBg = Color(0xFFF0FDFF);
  static const Color infoCardBorder = Color(0xFF99F6E4);
  static const Color infoCardText = Color(0xFF0F766E);

  static const Color tipCardBg = Color(0xFFF3F4F6);
  static const Color tipCardBorder = Color(0xFFA7F3D0);
  static const Color tipCardText = Color(0xFF1D4ED8);

  static const Color warningCardBg = Color(0xFFFFFBEB);
  static const Color warningCardBorder = Color(0xFFFDE68A);
  static const Color warningCardText = Color(0xFF92400E);

  static const Color successCardBg = Color(0xFFECFDF5);
  static const Color successCardBorder = Color(0xFFA7F3D0);
  static const Color successCardText = Color(0xFF1D4ED8);

  static const Color errorCardBg = Color(0xFFFEF2F2);
  static const Color errorCardBorder = Color(0xFFFECACA);
  static const Color errorCardText = Color(0xFF991B1B);

  static const Color syncedBg = Color(0xFFF3F4F6);
  static const Color syncedBorder = Color(0xFFA7F3D0);
  static const Color syncedIcon = Color(0xFF10B981);

  static const Color syncPendingBg = Color(0xFFFFFBEB);
  static const Color syncPendingBorder = Color(0xFFFDE68A);
  static const Color syncPendingIcon = Color(0xFFF59E0B);

  static const Color syncErrorBg = Color(0xFFFEF2F2);
  static const Color syncErrorBorder = Color(0xFFFECACA);
  static const Color syncErrorIcon = Color(0xFFEF4444);

  static const Color notSyncedBg = Color(0xFFF9FAFB);
  static const Color notSyncedBorder = Color(0xFFE2E8F0);
  static const Color notSyncedIcon = Color(0xFF94A3B8);

  // ===========================================================================
  // 18. SUPORTE A DARK MODE (COMPATIBILIDADE) - Mapeados para Light
  // ===========================================================================

  static const Color darkSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFFF9FAFB);
  static const Color darkCard = Color(0xFFFFFFFF);
  static const Color darkDialog = Color(0xFFFFFFFF);
  static const Color darkInput = Color(0xFFF9FAFB);
  static const Color darkDropdown = Color(0xFFFFFFFF);

  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);

  // ===========================================================================
  // 19. PALETA EXPANDIDA - CORES MODERNAS E FUNCIONAIS
  // ===========================================================================

  static const Color statusGreen = Color(0xFF10B981);
  static const Color statusYellow = Color(0xFFF59E0B);
  static const Color statusOrangeDark = Color(0xFFEA580C);
  static const Color statusRedDark = Color(0xFFDC2626);
  static const Color statusBlueGrey = Color(0xFF6B7280);
  static const Color statusBlueGreyLight = Color(0xFF94A3B8);
  static const Color statusBlueGreyBg = Color(0xFFF9FAFB);

  static const Color gradientDarkTeal = Color(0xFF2563EB);
  static const Color gradientDarkTealLight = Color(0xFF3B82F6);

  // Aliases de compatibilidade (para código legado que usa gradientDarkNavy)
  static const Color gradientDarkNavy = gradientDarkTeal;
  static const Color gradientDarkNavyLight = gradientDarkTealLight;

  static const Color gradientSugestoesStart = Color(0xFFEC4899);
  static const Color gradientSugestoesEnd = Color(0xFF10B981);

  static const Color gradientDarkStart = Color(0xFF10B981);
  static const Color gradientDarkEnd = Color(0xFF059669);

  static const Color feedbackSuccessDark = Color(0xFF059669);
  static const Color feedbackInfoDark = Color(0xFF0D6F8B);

  static const Color alertRedCoral = Color(0xFFF43F5E);
  static const Color alertRedCoralDark = Color(0xFFE11D48);
  static const Color alertRedDarkest = Color(0xFFBE123C);

  static const Color strategyOrangeLight = Color(0xFFD9F99D);
  static const Color strategyOrangeDark = Color(0xFFDB2777);

  // Cores Vibrantes
  static const Color purpleMain = Color(0xFF8B5CF6);
  static const Color purpleMedium = Color(0xFF7C3AED);
  static const Color purpleDark = Color(0xFF6D28D9);
  static const Color purpleDeep = Color(0xFF5B21B6);
  static const Color purpleMaterial = Color(0xFF8B5CF6);
  static const Color purpleVibrant = Color(0xFFA855F7);

  static const Color greenMain = Color(0xFF10B981);
  static const Color greenTeal = Color(0xFF4F46E5);
  static const Color greenGradient = Color(0xFF059669);
  static const Color greenGradientEnd = Color(0xFF3B82F6);
  static const Color greenMaterial = Color(0xFF10B981);
  static const Color successMaterial = Color(0xFF10B981);
  static const Color greenDark = Color(0xFF059669);
  static const Color greenLightMaterial = Color(0xFF6EE7B7);

  static const Color blueMain = Color(0xFF4F46E5);
  static const Color blueCyan = Color(0xFF4F46E5);
  static const Color blueMaterial = Color(0xFF4F46E5);
  static const Color blueLight = Color(0xFF5EEAD4);
  static const Color blueDark = Color(0xFF0D6F8B);
  static const Color blueIndigo = Color(0xFF1D4ED8);

  static const Color cyanMain = Color(0xFF4F46E5);
  static const Color cyanDark = Color(0xFF4338CA);
  static const Color tealMain = Color(0xFF4F46E5);
  static const Color cyanGradientStart = Color(0xFF22D3EE);
  static const Color cyanGradientEnd = Color(0xFF4338CA);

  static const Color orangeMain = Color(0xFFF97316);
  static const Color orangeDark = Color(0xFFEA580C);
  static const Color orangeMaterial = Color(0xFFF97316);
  static const Color orangeDeep = Color(0xFFEA580C);
  static const Color orangeAmber = Color(0xFFF59E0B);

  static const Color yellowGold = Color(0xFFF59E0B);
  static const Color amberMain = Color(0xFFF59E0B);
  static const Color amberDark = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFCD34D);

  static const Color redMain = Color(0xFFEF4444);
  static const Color redDark = Color(0xFFDC2626);
  static const Color urgentDark = Color(0xFFB91C1C);

  static const Color pinkRose = Color(0xFFF43F5E);
  static const Color pinkDark = Color(0xFFE11D48);
  static const Color pinkBright = Color(0xFFFB7185);
  static const Color yellowGradient = Color(0xFFFDE047);

  static const Color brownMain = Color(0xFFD97706);
  static const Color brownDark = Color(0xFFB45309);
  static const Color brownSaddle = Color(0xFF92400E);

  // Tons pastel CLAROS E FUNCIONAIS
  static const Color infoPastel = Color(0xFFF0FDFF);
  static const Color successPastel = Color(0xFFECFDF5);
  static const Color warningPastel = Color(0xFFFFFBEB);
  static const Color errorPastel = Color(0xFFFEF2F2);
  static const Color redPastel = Color(0xFFFEF2F2);
  static const Color primaryPastel = Color(0xFFF3F4F6);

  static const Color alertWarningBackground = Color(0xFFFFFBEB);
  static const Color alertErrorBackground = Color(0xFFFEF2F2);
  static const Color alertWarningBackgroundAlt = Color(0xFFFEF3C7);

  static const Color alertWarningCardBackground = Color(0xFFFFFBEB);
  static const Color alertWarningCardBorder = Color(0xFFFDE68A);
  static const Color alertErrorCardBackground = Color(0xFFFEF2F2);
  static const Color alertErrorCardBorder = Color(0xFFFECACA);

  static const Color alertWarningStart = Color(0xFFFDE68A);
  static const Color alertWarningEnd = Color(0xFFFCD34D);
  static const Color alertErrorStart = Color(0xFFFECACA);
  static const Color alertErrorEnd = Color(0xFFFCA5A5);

  static const Color background = backgroundLight;

  // === CARDS INFORMATIVOS ===

  static const Color infoModuleBackground = Color(0xFFF0FDFF);
  static const Color infoModuleBackgroundAlt = Color(0xFFE0F7FF);
  static const Color infoModuleBorder = Color(0xFF99F6E4);
  static const Color infoModuleText = Color(0xFF0F766E);
  static const Color infoModuleIcon = Color(0xFF4F46E5);

  static const Color suggestionCardStart = Color(0xFF10B981);
  static const Color suggestionCardEnd = Color(0xFF059669);
  static const Color suggestionAumentosBackground = Color(0xFFF3F4F6);
  static const Color suggestionAumentosText = Color(0xFF111827);
  static const Color suggestionPromocoesBackground = Color(0xFFFFFBEB);
  static const Color suggestionPromocoesText = Color(0xFF92400E);

  static const Color gold = Color(0xFFF59E0B);
  static const Color goldDark = Color(0xFFD97706);
  static const Color goldLight = Color(0xFFFCD34D);
  static const Color goldPastel = Color(0xFFFFFBEB);

  static const Color mintPastel = Color(0xFFF3F4F6);
  static const Color pinkPastel = Color(0xFFFDF2F8);
  static const Color bluePastel = Color(0xFFF0FDFF);
  static const Color surfacePastel = Color(0xFFF9FAFB);

  static const Color silver = Color(0xFF94A3B8);
  static const Color bronze = Color(0xFFD97706);

  // Overlays
  static const Color surfaceOverlay05 = Color(0x0D000000);
  static const Color surfaceOverlay40 = Color(0x66000000);
  static const Color surfaceOverlay60 = Color(0x99000000);
  static const Color surfaceOverlay95 = Color(0xF2000000);

  static const Color primaryOverlay15 = Color(0x260D9488);
  static const Color primaryOverlay25 = Color(0x400D9488);
  static const Color primaryOverlay30 = Color(0x4D0D9488);
  static const Color primaryOverlay40 = Color(0x660D9488);
  static const Color primaryOverlay50 = Color(0x800D9488);

  static const Color secondaryOverlay05 = Color(0x0D06B6D4);
  static const Color secondaryOverlay10 = Color(0x1A06B6D4);
  static const Color secondaryOverlay15 = Color(0x2606B6D4);
  static const Color secondaryOverlay20 = Color(0x3306B6D4);
  static const Color secondaryOverlay30 = Color(0x4D06B6D4);

  static const Color textPrimaryOverlay15 = Color(0x261E293B);
  static const Color textPrimaryOverlay20 = Color(0x331E293B);
  static const Color textPrimaryOverlay30 = Color(0x4D1E293B);

  static const Color textSecondaryOverlay05 = Color(0x0D64748B);
  static const Color textSecondaryOverlay10 = Color(0x1A64748B);
  static const Color textSecondaryOverlay15 = Color(0x2664748B);
  static const Color textSecondaryOverlay20 = Color(0x3364748B);
  static const Color textSecondaryOverlay30 = Color(0x4D64748B);
  static const Color textSecondaryOverlay40 = Color(0x6664748B);
  static const Color textSecondaryOverlay50 = Color(0x8064748B);
  static const Color textSecondaryOverlay60 = Color(0x9964748B);
  static const Color textSecondaryOverlay70 = Color(0xB364748B);
  static const Color textSecondaryOverlay80 = Color(0xCC64748B);
  static const Color textSecondaryOverlay90 = Color(0xE664748B);

  // Black Overlays
  static const Color blackOverlay02 = Color(0x05000000);
  static const Color blackOverlay03 = Color(0x08000000);
  static const Color blackOverlay04 = Color(0x0A000000);
  static const Color blackOverlay06 = Color(0x0F000000);
  static const Color blackOverlay07 = Color(0x12000000);
  static const Color blackOverlay09 = Color(0x17000000);
  static const Color blackOverlay12 = Color(0x1F000000);
  static const Color blackOverlay18 = Color(0x2E000000);
  static const Color blackOverlay22 = Color(0x38000000);
  static const Color blackOverlay24 = Color(0x3D000000);
  static const Color blackOverlay25 = Color(0x40000000);
  static const Color blackOverlay26 = Color(0x421E293B);
  static const Color blackOverlay28 = Color(0x471E293B);
  static const Color blackOverlay32 = Color(0x521E293B);
  static const Color blackOverlay35 = Color(0x591E293B);
  static const Color blackOverlay40 = Color(0x661E293B);
  static const Color blackOverlay45 = Color(0x731E293B);
  static const Color blackOverlay50 = Color(0x801E293B);
  static const Color blackOverlay54 = Color(0x8A1E293B);
  static const Color blackOverlay60 = Color(0x991E293B);
  static const Color blackOverlay65 = Color(0xA61E293B);
  static const Color blackOverlay70 = Color(0xB31E293B);
  static const Color blackOverlay75 = Color(0xBF1E293B);
  static const Color blackOverlay80 = Color(0xCC1E293B);
  static const Color blackOverlay85 = Color(0xD91E293B);
  static const Color blackOverlay87 = Color(0xDE1E293B);
  static const Color blackOverlay90 = Color(0xE61E293B);

  static const Color whiteOverlay02 = Color(0x05FFFFFF);
  static const Color whiteOverlay03 = Color(0x08FFFFFF);
  static const Color whiteOverlay04 = Color(0x0AFFFFFF);
  static const Color whiteOverlay06 = Color(0x0FFFFFFF);
  static const Color whiteOverlay07 = Color(0x12FFFFFF);
  static const Color whiteOverlay09 = Color(0x17FFFFFF);
  static const Color whiteOverlay12 = Color(0x1FFFFFFF);
  static const Color whiteOverlay18 = Color(0x2EFFFFFF);
  static const Color whiteOverlay22 = Color(0x38FFFFFF);
  static const Color whiteOverlay24 = Color(0x3DFFFFFF);
  static const Color whiteOverlay25 = Color(0x40FFFFFF);
  static const Color whiteOverlay30 = Color(0x4DFFFFFF);
  static const Color whiteOverlay35 = Color(0x59FFFFFF);
  static const Color whiteOverlay40 = Color(0x66FFFFFF);
  static const Color whiteOverlay50 = Color(0x80FFFFFF);
  static const Color whiteOverlay60 = Color(0x99FFFFFF);
  static const Color whiteOverlay70 = Color(0xB3FFFFFF);
  static const Color whiteOverlay95 = Color(0xF2FFFFFF);

  static const Color blueMaterialOverlay05 = Color(0x0D06B6D4);
  static const Color blueMaterialOverlay10 = Color(0x1A06B6D4);
  static const Color blueMaterialOverlay15 = Color(0x2606B6D4);

  // Orange Overlays
  static const Color orangeMainOverlay03 = Color(0x08F97316);
  static const Color orangeMainOverlay05 = Color(0x0DF97316);
  static const Color orangeMainOverlay10 = Color(0x1AF97316);
  static const Color orangeMainOverlay15 = Color(0x26F97316);
  static const Color orangeMainOverlay20 = Color(0x33F97316);
  static const Color orangeMainOverlay30 = Color(0x4DF97316);

  // Green Material Overlays
  static const Color greenMaterialOverlay05 = Color(0x0D10B981);
  static const Color greenMaterialOverlay10 = Color(0x1A10B981);
  static const Color greenMaterialOverlay15 = Color(0x2610B981);
  static const Color greenMaterialOverlay20 = Color(0x3310B981);
  static const Color greenMaterialOverlay30 = Color(0x4D10B981);

  // Blue Cyan Overlays
  static const Color blueCyanOverlay05 = Color(0x0D06B6D4);
  static const Color blueCyanOverlay10 = Color(0x1A06B6D4);
  static const Color blueCyanOverlay15 = Color(0x2606B6D4);
  static const Color blueCyanOverlay20 = Color(0x3306B6D4);
  static const Color blueCyanOverlay30 = Color(0x4D06B6D4);
}


