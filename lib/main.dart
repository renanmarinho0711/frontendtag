mport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/l10n/app_localizations.dart';
import 'core/di/injection.dart';
import 'core/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/widgets/stubs.dart';

/// # TagBean - Aplicação Principal
///
/// Sistema de gerenciamento de tags e produtos.
///
/// ## Arquitetura:
/// - **State Management**: Riverpod
/// - **Navigation**: GoRouter
/// - **Theme**: Material Design 3
/// - **DI**: GetIt + Injectable
/// - **i18n**: Custom Localization
/// - **Architecture**: Clean Architecture
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurações do sistema
  await _setupSystemUI();

  // Inicializar injeção de dependências
  await configureDependencies();

  // Inicializar serviços
  await _initializeServices();

  // Obter SharedPreferences para os providers
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override do SharedPreferences provider
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const TagBeanApp(),
    ),
  );
}

/// Configura UI do sistema (status bar, orientação, etc)
Future<void> _setupSystemUI() async {
  // Orientação preferencial
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Status bar transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

/// Inicializa serviços necessários
Future<void> _initializeServices() async {
  // TODO: Inicializar Firebase, API, Storage, etc
}

/// Widget principal da aplicação
class TagBeanApp extends ConsumerWidget {
  const TagBeanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      // Configuração do Router
      routerConfig: router,

      // Informações da App
      title: 'TagBean',
      debugShowCheckedModeBanner: false,

      // Temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Localização
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Builder para responsividade e overlays
      builder: (context, child) {
        return ResponsiveWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// Provider para controle do tema
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  // TODO: Ler do storage local
  return ThemeMode.system;
});

/// Wrapper para configurações responsivas
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Define tamanho mínimo/máximo de fonte baseado no dispositivo
    final mediaQuery = MediaQuery.of(context);
    final scale = mediaQuery.textScaleFactor.clamp(0.8, 1.3);

    return MediaQuery(
      data: mediaQuery.copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}



