/// Constantes da aplicação
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = 'SolTag';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Sistema de Gestão de Etiquetas Eletrônicas';

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyTokenExpiry = 'token_expiry';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUsername = 'username';
  static const String keyStoreId = 'store_id';
  static const String keyUserRoles = 'user_roles';
  static const String keyRememberMe = 'remember_me';
  static const String keyLastSync = 'last_sync';
  static const String keyWorkContext = 'work_context';
  static const String keyClientId = 'client_id';

  // Paginação
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validação
  static const int minPasswordLength = 6;
  static const int maxProductNameLength = 100;
  static const int maxDescriptionLength = 500;

  // Timeouts
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration tooltipDuration = Duration(seconds: 2);
  static const Duration syncInterval = Duration(minutes: 15);

  // Animações
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 600);
}





