import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

/// # Sistema de Internacionalização do TagBean
/// 
/// Suporte multi-idioma com fallback.
/// 
/// ## Idiomas Suportados:
/// - Português (pt-BR) - Padrão
/// - Inglês (en-US)
/// 
/// ## Estrutura de Arquivos:
/// ```
/// l10n/
/// ├── app_localizations.dart
/// ├── l10n_delegate.dart
/// └── translations/
///     ├── pt_BR.json
///     └── en_US.json
/// ```
class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;
  
  AppLocalizations(this.locale);
  
  /// Helper para acessar localização do contexto
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('pt', 'BR'));
  }
  
  /// Delegate para o sistema de localização
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  /// Lista de idiomas suportados
  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ];
  
  /// Carrega as traduções do arquivo JSON
  Future<bool> load() async {
    final String jsonString = await rootBundle.loadString(
      'assets/l10n/${locale.languageCode}_${locale.countryCode}.json',
    );
    
    _localizedStrings = json.decode(jsonString);
    return true;
  }
  
  /// Retorna a tradução para a chave especificada
  String translate(String key, {Map<String, dynamic>? args}) {
    String translation = _getNestedTranslation(key) ?? key;
    
    // Substitui placeholders {key} pelos valores em args
    if (args != null) {
      args.forEach((argKey, value) {
        translation = translation.replaceAll('{$argKey}', value.toString());
      });
    }
    
    return translation;
  }
  
  /// Busca tradução aninhada usando dot notation
  String? _getNestedTranslation(String key) {
    final keys = key.split('.');
    dynamic current = _localizedStrings;
    
    for (final k in keys) {
      if (current is Map && current.containsKey(k)) {
        current = current[k];
      } else {
        return null;
      }
    }
    
    return current?.toString();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TRADUÇÕES COMUNS - Atalhos para uso direto
  // ═══════════════════════════════════════════════════════════════════════════
  
  // App
  String get appName => translate('app.name');
  String get appDescription => translate('app.description');
  
  // Common
  String get save => translate('common.save');
  String get cancel => translate('common.cancel');
  String get delete => translate('common.delete');
  String get edit => translate('common.edit');
  String get add => translate('common.add');
  String get search => translate('common.search');
  String get filter => translate('common.filter');
  String get loading => translate('common.loading');
  String get error => translate('common.error');
  String get success => translate('common.success');
  String get warning => translate('common.warning');
  String get info => translate('common.info');
  String get confirm => translate('common.confirm');
  String get yes => translate('common.yes');
  String get no => translate('common.no');
  String get ok => translate('common.ok');
  String get close => translate('common.close');
  String get back => translate('common.back');
  String get next => translate('common.next');
  String get previous => translate('common.previous');
  String get finish => translate('common.finish');
  
  // Auth
  String get login => translate('auth.login');
  String get logout => translate('auth.logout');
  String get register => translate('auth.register');
  String get forgotPassword => translate('auth.forgotPassword');
  String get email => translate('auth.email');
  String get password => translate('auth.password');
  String get confirmPassword => translate('auth.confirmPassword');
  
  // Dashboard
  String get dashboard => translate('dashboard.title');
  String get welcome => translate('dashboard.welcome');
  String get recentActivity => translate('dashboard.recentActivity');
  String get quickActions => translate('dashboard.quickActions');
  
  // Products
  String get products => translate('products.title');
  String get newProduct => translate('products.new');
  String get editProduct => translate('products.edit');
  String get productName => translate('products.name');
  String get productDescription => translate('products.description');
  String get productPrice => translate('products.price');
  String get productStock => translate('products.stock');
  
  // Tags
  String get tags => translate('tags.title');
  String get bindTag => translate('tags.bind');
  String get unbindTag => translate('tags.unbind');
  String get tagCode => translate('tags.code');
  String get tagStatus => translate('tags.status');
  
  // Messages
  String get saveSuccess => translate('messages.saveSuccess');
  String get deleteSuccess => translate('messages.deleteSuccess');
  String get operationError => translate('messages.operationError');
  String get networkError => translate('messages.networkError');
  String get validationError => translate('messages.validationError');
  
  // Validation
  String get fieldRequired => translate('validation.required');
  String get invalidEmail => translate('validation.invalidEmail');
  String get passwordTooShort => translate('validation.passwordTooShort');
  String get passwordsDoNotMatch => translate('validation.passwordsDoNotMatch');
}

/// Delegate para carregar AppLocalizations
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['pt', 'en'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
