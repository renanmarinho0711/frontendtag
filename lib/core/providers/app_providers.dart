mport 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// # Providers Globais do TagBean
/// 
/// Centraliza todos os providers principais da aplicação.
/// 
/// ## Estrutura:
/// ```
/// App Providers
/// ├── Theme (tema claro/escuro)
/// ├── Locale (idioma)
/// ├── Auth (autenticação)
/// ├── User (dados do usuário)
/// ├── Settings (configurações)
/// └── Connectivity (conexão)
/// ```

// ═══════════════════════════════════════════════════════════════════════════
// SHARED PREFERENCES
// ═══════════════════════════════════════════════════════════════════════════

/// Provider para SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

// ═══════════════════════════════════════════════════════════════════════════
// THEME PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

/// Provider para controle do tema
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

/// Notifier para gerenciar o tema
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _key = 'theme_mode';
  
  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadTheme();
  }
  
  void _loadTheme() {
    final savedTheme = _prefs.getString(_key);
    state = switch (savedTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, mode.name);
  }
  
  void toggleTheme() {
    setThemeMode(
      state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LOCALE PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

/// Provider para idioma da aplicação
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

/// Notifier para gerenciar idioma
class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  static const _key = 'locale';
  
  LocaleNotifier(this._prefs) : super(const Locale('pt', 'BR')) {
    _loadLocale();
  }
  
  void _loadLocale() {
    final savedLocale = _prefs.getString(_key);
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      state = Locale(parts[0], parts.length > 1 ? parts[1] : null);
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _prefs.setString(_key, locale.toString());
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP SETTINGS PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

/// Provider para configurações da aplicação
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppSettingsNotifier(prefs);
});

/// Modelo de configurações
class AppSettings {
  final bool showOnboarding;
  final bool enableNotifications;
  final bool enableAnalytics;
  final bool useBiometrics;
  final bool autoSync;
  final int syncInterval; // em minutos
  final String defaultView; // 'grid' ou 'list'
  final bool compactMode;
  
  const AppSettings({
    this.showOnboarding = true,
    this.enableNotifications = true,
    this.enableAnalytics = false,
    this.useBiometrics = false,
    this.autoSync = true,
    this.syncInterval = 30,
    this.defaultView = 'grid',
    this.compactMode = false,
  });
  
  AppSettings copyWith({
    bool? showOnboarding,
    bool? enableNotifications,
    bool? enableAnalytics,
    bool? useBiometrics,
    bool? autoSync,
    int? syncInterval,
    String? defaultView,
    bool? compactMode,
  }) {
    return AppSettings(
      showOnboarding: showOnboarding ?? this.showOnboarding,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      autoSync: autoSync ?? this.autoSync,
      syncInterval: syncInterval ?? this.syncInterval,
      defaultView: defaultView ?? this.defaultView,
      compactMode: compactMode ?? this.compactMode,
    );
  }
}

/// Notifier para gerenciar configurações
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;
  
  AppSettingsNotifier(this._prefs) : super(const AppSettings()) {
    _loadSettings();
  }
  
  void _loadSettings() {
    state = AppSettings(
      showOnboarding: _prefs.getBool('show_onboarding') ?? true,
      enableNotifications: _prefs.getBool('enable_notifications') ?? true,
      enableAnalytics: _prefs.getBool('enable_analytics') ?? false,
      useBiometrics: _prefs.getBool('use_biometrics') ?? false,
      autoSync: _prefs.getBool('auto_sync') ?? true,
      syncInterval: _prefs.getInt('sync_interval') ?? 30,
      defaultView: _prefs.getString('default_view') ?? 'grid',
      compactMode: _prefs.getBool('compact_mode') ?? false,
    );
  }
  
  Future<void> updateSettings(AppSettings settings) async {
    state = settings;
    await Future.wait([
      _prefs.setBool('show_onboarding', settings.showOnboarding),
      _prefs.setBool('enable_notifications', settings.enableNotifications),
      _prefs.setBool('enable_analytics', settings.enableAnalytics),
      _prefs.setBool('use_biometrics', settings.useBiometrics),
      _prefs.setBool('auto_sync', settings.autoSync),
      _prefs.setInt('sync_interval', settings.syncInterval),
      _prefs.setString('default_view', settings.defaultView),
      _prefs.setBool('compact_mode', settings.compactMode),
    ]);
  }
  
  Future<void> completeOnboarding() async {
    state = state.copyWith(showOnboarding: false);
    await _prefs.setBool('show_onboarding', false);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CONNECTIVITY PROVIDER
// ═══════════════════════════════════════════════════════════════════════════

/// Provider para status de conectividade
final connectivityProvider = StreamProvider<ConnectivityStatus>((ref) async* {
  // TODO: Implementar com connectivity_plus
  yield ConnectivityStatus.online;
});

/// Status de conectividade
enum ConnectivityStatus {
  online,
  offline,
  checking,
}
