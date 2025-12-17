import 'package:flutter/material.dart';
import 'typography.dart';

// Constantes de cores locais para o tema
// Nota: Estas são usadas apenas para inicialização do ThemeData
// Widgets devem usar ThemeColors.of(context) para cores dinâmicas
class _ThemeDefaults {
  static const Color primary = Color(0xFF00A86B);
  static const Color secondary = Color(0xFF008B5A);
  static const Color error = Color(0xFFE53935);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkInput = Color(0xFF3D3D3D);
  static const Color darkDropdown = Color(0xFF2D2D2D);
}

/// Tema principal da aplicação TagBean
class AppTheme {
  AppTheme._();

  /// Gera um tema baseado em cores primãria e secundãria
  static ThemeData generateTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Cores dinâmicas
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: _ThemeDefaults.error,
        surface: _ThemeDefaults.surface,
        onPrimary: _ThemeDefaults.surface,
        onSecondary: _ThemeDefaults.surface,
        onSurface: _ThemeDefaults.textPrimary,
        onError: _ThemeDefaults.surface,
      ),
      scaffoldBackgroundColor: _ThemeDefaults.backgroundLight,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _ThemeDefaults.surface,
        foregroundColor: _ThemeDefaults.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: _ThemeDefaults.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: _ThemeDefaults.textPrimary,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: _ThemeDefaults.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Botães com cores dinâmicas
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: _ThemeDefaults.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: primaryColor),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _ThemeDefaults.grey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ThemeDefaults.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ThemeDefaults.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ThemeDefaults.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ThemeDefaults.error, width: 2),
        ),
        labelStyle: const TextStyle(color: _ThemeDefaults.grey600),
        hintStyle: const TextStyle(color: _ThemeDefaults.grey400),
        errorStyle: const TextStyle(color: _ThemeDefaults.error),
      ),
      
      // Dividers
      dividerTheme: const DividerThemeData(
        color: _ThemeDefaults.divider,
        thickness: 1,
        space: 0,
      ),
      
      // Bottom Navigation com cores dinâmicas
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _ThemeDefaults.surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: _ThemeDefaults.grey400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Navigation Rail com cores dinâmicas
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: _ThemeDefaults.surface,
        selectedIconTheme: IconThemeData(color: primaryColor),
        unselectedIconTheme: const IconThemeData(color: _ThemeDefaults.grey400),
        selectedLabelTextStyle: TextStyle(color: primaryColor),
        unselectedLabelTextStyle: const TextStyle(color: _ThemeDefaults.grey600),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentTextStyle: const TextStyle(color: _ThemeDefaults.surface),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: _ThemeDefaults.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Chip com cores dinâmicas
      chipTheme: ChipThemeData(
        backgroundColor: _ThemeDefaults.grey100,
        selectedColor: primaryColor.withValues(alpha: 0.2),
        labelStyle: const TextStyle(fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      
      // Floating Action Button com cores dinâmicas
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: _ThemeDefaults.surface,
        elevation: 4,
      ),
      
      // Checkbox com cores dinâmicas
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      
      // Switch com cores dinâmicas
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return _ThemeDefaults.grey400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withValues(alpha: 0.5);
          }
          return _ThemeDefaults.grey300;
        }),
      ),
      
      // Radio com cores dinâmicas
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return _ThemeDefaults.grey400;
        }),
      ),
      
      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: _ThemeDefaults.grey200,
      ),
      
      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        thumbColor: primaryColor,
        inactiveTrackColor: _ThemeDefaults.grey300,
      ),
      
      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: _ThemeDefaults.grey600,
        indicatorColor: primaryColor,
      ),
    );
  }

  /// Tema claro (usa cores padrão)
  static ThemeData get lightTheme {
    return generateTheme(
      primaryColor: _ThemeDefaults.primary,
      secondaryColor: _ThemeDefaults.secondary,
    );
  }

  /// Tema escuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Cores
      primaryColor: _ThemeDefaults.primary,
      colorScheme: const ColorScheme.dark(
        primary: _ThemeDefaults.primary,
        secondary: _ThemeDefaults.secondary,
        error: _ThemeDefaults.error,
        surface: _ThemeDefaults.darkSurface,
        onPrimary: _ThemeDefaults.surface,
        onSecondary: _ThemeDefaults.surface,
        onSurface: _ThemeDefaults.surface,
        onError: _ThemeDefaults.surface,
      ),
      scaffoldBackgroundColor: _ThemeDefaults.darkBackground,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _ThemeDefaults.darkSurface,
        foregroundColor: _ThemeDefaults.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: _ThemeDefaults.surface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: _ThemeDefaults.surface,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: _ThemeDefaults.darkCard,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _ThemeDefaults.darkInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ThemeDefaults.grey700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ThemeDefaults.grey700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ThemeDefaults.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: _ThemeDefaults.grey400),
        hintStyle: const TextStyle(color: _ThemeDefaults.grey600),
      ),
      
      // Dividers
      dividerTheme: const DividerThemeData(
        color: _ThemeDefaults.grey800,
        thickness: 1,
        space: 0,
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _ThemeDefaults.darkDropdown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentTextStyle: const TextStyle(color: _ThemeDefaults.surface),
      ),
    );
  }
}





