// Espaçamentos padronizados da aplicação
/// 
/// Centraliza todos os valores de padding, margin e espaçamento
/// utilizados no app. Garante consistência e facilita ajustes globais.
/// 
/// Uso: 
/// ```dart
/// padding: EdgeInsets.all(AppSpacing.lg)
/// SizedBox(height: AppSpacing.md)
/// ```
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Espaçamentos específicos comuns
  static const double cardPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double elementSpacing = 12.0;
  static const double listItemSpacing = 8.0;

  // Padding específico para AppBar
  static const double appBarHorizontalMobile = 16.0;
  static const double appBarHorizontalTablet = 20.0;
  static const double appBarHorizontalDesktop = 24.0;

  // Espaçamentos específicos do dashboard
  static const double statSpacing = 12.0; // Entre stat cards
  static const double strategySpacing = 8.0; // Entre strategy items
  static const double searchBarHorizontalPadding = 10.0; // Padding horizontal searchbar

  // ========== DASHBOARD PRODUTOS ESPECÍFICO ==========

  /// Espaçamento entre seções principais do dashboard
  static const double dashboardSectionGap = 20.0;

  /// Espaçamento interno de welcome metrics
  static const double welcomeMetricGap = 8.0;

  /// Espaçamento entre alertas
  static const double alertsGap = 12.0;

  // ========== PRODUTOS DASHBOARD ==========

  /// Espaçamento interno de welcome cards
  static const double welcomeInnerSpacing = 10.0;

  /// Gap entre alerta ícone e conteúdo
  static const double alertIconGap = 10.0;

  // ========== DASHBOARD SPECIFIC SPACING ==========

  /// Espaçamento padrão entre cards no dashboard
  static const double dashboardCardGap = 16.0;

  /// Espaçamento interno padrão de containers
  static const double dashboardContainerPadding = 16.0;
}

/// Alias para compatibilidade
typedef Spacing = AppSpacing;



