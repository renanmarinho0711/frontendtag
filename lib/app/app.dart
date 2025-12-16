import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system/theme/theme_colors_dynamic.dart';
import '../design_system/theme/theme_provider.dart';

import '../core/services/navigation_service.dart'; // Importa navigationServiceProvider
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';

/// Widget principal da aplicação TagBean
class TagBeanApp extends ConsumerWidget {
  const TagBeanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationService = ref.watch(navigationServiceProvider);
    final themeState = ref.watch(themeProvider);
    final themeColors = ThemeColorsData.fromThemeId(themeState.currentThemeId);

    debugPrint('🎨 TEMA ATUAL: ${themeState.currentThemeId}');

    return ThemeColorsProvider(
      child: MaterialApp(
        title: 'TagBean',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: themeColors.primary,
            secondary: themeColors.secondary,
            surface: themeColors.surface,
            background: themeColors.backgroundLight,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.light,
        navigatorKey: navigationService.navigatorKey,
        home: const LoginScreen(),
      ),
    );
  }
}




