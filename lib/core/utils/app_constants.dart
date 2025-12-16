/// # Constantes da Aplicação TagBean
/// 
/// Centraliza todas as constantes utilizadas no app.
/// 
/// ## Organização:
/// - API endpoints
/// - Timeouts e delays
/// - Limites e validações
/// - Keys para storage
/// - Mensagens padrão
class AppConstants {
  AppConstants._();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String appName = 'TagBean';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String bundleId = 'com.tagbean.app';
  
  // ═══════════════════════════════════════════════════════════════════════════
  // API CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.tagbean.com.br',
  );
  
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const int maxRetries = 3;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PAGINATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int initialPage = 1;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDATION RULES
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxEmailLength = 255;
  static const int maxProductNameLength = 200;
  static const int maxDescriptionLength = 1000;
  static const int maxTagCodeLength = 50;
  static const double minPrice = 0.01;
  static const double maxPrice = 999999.99;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STORAGE KEYS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyLastSync = 'last_sync';
  static const String keyDeviceId = 'device_id';
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CACHE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UI DELAYS & ANIMATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration snackBarDuration = Duration(seconds: 4);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FORMATS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String currencySymbol = 'R\$';
  static const String decimalSeparator = ',';
  static const String thousandsSeparator = '.';
  
  // ═══════════════════════════════════════════════════════════════════════════
  // REGEX PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp phoneRegex = RegExp(
    r'^\(?([0-9]{2})\)?[-. ]?([0-9]{4,5})[-. ]?([0-9]{4})$',
  );
  
  static final RegExp cpfRegex = RegExp(
    r'^\d{3}\.\d{3}\.\d{3}-\d{2}$',
  );
  
  static final RegExp cnpjRegex = RegExp(
    r'^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$',
  );
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String genericErrorMessage = 'Algo deu errado. Tente novamente.';
  static const String networkErrorMessage = 'Sem conexão com a internet.';
  static const String timeoutErrorMessage = 'A operação demorou muito. Tente novamente.';
  static const String unauthorizedMessage = 'SessÃ£o expirada. Faça login novamente.';
  static const String validationErrorMessage = 'Por favor, verifique os dados informados.';
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SUCCESS MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String saveSuccessMessage = 'Salvo com sucesso!';
  static const String updateSuccessMessage = 'Atualizado com sucesso!';
  static const String deleteSuccessMessage = 'Removido com sucesso!';
  static const String syncSuccessMessage = 'Sincronizado com sucesso!';
}
