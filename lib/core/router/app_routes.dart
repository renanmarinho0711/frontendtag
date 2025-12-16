// # Definição de Rotas do TagBean
/// 
/// Centraliza todas as rotas do aplicativo como constantes.
/// Facilita refatoração e evita strings hardcoded.
abstract class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot';
  
  // Main
  static const String dashboard = '/dashboard';
  
  // Products
  static const String products = '/products';
  static const String newProduct = '/products/new';
  static String productDetails(String id) => '/products/$id';
  
  // Tags
  static const String tags = '/tags';
  static const String bindTag = '/tags/bind';
  static String tagDetails(String id) => '/tags/$id';
  
  // Reports
  static const String reports = '/reports';
  static const String dailyReport = '/reports/daily';
  static const String monthlyReport = '/reports/monthly';
  static const String customReport = '/reports/custom';
  
  // Settings
  static const String settings = '/settings';
  static const String profile = '/settings/profile';
  static const String storeSettings = '/settings/store';
  static const String themeSettings = '/settings/theme';
  
  // Quick actions - rotas diretas para ações frequentes
  static const String quickBindTag = '/tags/bind?quick=true';
  static const String quickUpdatePrices = '/products?action=update-prices';
  static const String quickAddProduct = '/products/new?quick=true';
  static const String quickDailyReport = '/reports/daily?quick=true';
}
