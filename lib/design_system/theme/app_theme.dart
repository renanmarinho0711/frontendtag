mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'typography.dart';

/// Tema principal da aplica��o TagBean
class AppTheme {
  AppTheme._();

  /// Gera um tema baseado em cores prim�ria e secund�ria
  static ThemeData generateTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Cores din�micas
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: AppThemeColors.error,
        surface: AppThemeColors.surface,
        onPrimary: AppThemeColors.surface,
        onSecondary: AppThemeColors.surface,
        onSurface: AppThemeColors.textPrimary,
        onError: AppThemeColors.surface,
      ),
      scaffoldBackgroundColor: AppThemeColors.backgroundLight,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppThemeColors.surface,
        foregroundColor: AppThemeColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppThemeColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppThemeColors.textPrimary,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: AppThemeColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Bot�es com cores din�micas
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppThemeColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
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
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppThemeColors.grey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemeColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemeColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemeColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemeColors.error, width: 2),
        ),
        labelStyle: TextStyle(color: AppThemeColors.grey600),
        hintStyle: TextStyle(color: AppThemeColors.grey400),
        errorStyle: TextStyle(color: AppThemeColors.error),
      ),
      
      // Dividers
      dividerTheme: DividerThemeData(
        color: AppThemeColors.divider,
        thickness: 1,
        space: 0,
      ),
      
      // Bottom Navigation com cores din�micas
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppThemeColors.surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: AppThemeColors.grey400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Navigation Rail com cores din�micas
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppThemeColors.surface,
        selectedIconTheme: IconThemeData(color: primaryColor),
        unselectedIconTheme: IconThemeData(color: AppThemeColors.grey400),
        selectedLabelTextStyle: TextStyle(color: primaryColor),
        unselectedLabelTextStyle: TextStyle(color: AppThemeColors.grey600),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentTextStyle: TextStyle(color: AppThemeColors.surface),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppThemeColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Chip com cores din�micas
      chipTheme: ChipThemeData(
        backgroundColor: AppThemeColors.grey100,
        selectedColor: primaryColor.withValues(alpha: 0.2),
        labelStyle: TextStyle(fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      
      // Floating Action Button com cores din�micas
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: AppThemeColors.surface,
        elevation: 4,
      ),
      
      // Checkbox com cores din�micas
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      
      // Switch com cores din�micas
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return AppThemeColors.grey400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withValues(alpha: 0.5);
          }
          return AppThemeColors.grey300;
        }),
      ),
      
      // Radio com cores din�micas
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return AppThemeColors.grey400;
        }),
      ),
      
      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: AppThemeColors.grey200,
      ),
      
      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        thumbColor: primaryColor,
        inactiveTrackColor: AppThemeColors.grey300,
      ),
      
      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: AppThemeColors.grey600,
        indicatorColor: primaryColor,
      ),
    );
  }

  /// Tema claro (usa cores padr�o)
  static ThemeData get lightTheme {
    return generateTheme(
      primaryColor: AppThemeColors.primary,
      secondaryColor: AppThemeColors.secondary,
    );
  }

  /// Tema escuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Cores
      primaryColor: AppThemeColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppThemeColors.primary,
        secondary: AppThemeColors.secondary,
        error: AppThemeColors.error,
        surface: AppThemeColors.darkSurface,
        onPrimary: AppThemeColors.surface,
        onSecondary: AppThemeColors.surface,
        onSurface: AppThemeColors.surface,
        onError: AppThemeColors.surface,
      ),
      scaffoldBackgroundColor: AppThemeColors.darkBackground,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppThemeColors.darkSurface,
        foregroundColor: AppThemeColors.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppThemeColors.surface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppThemeColors.surface,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: AppThemeColors.darkCard,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppThemeColors.darkInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemeColors.grey700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemeColors.grey700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemeColors.primary, width: 2),
        ),
        labelStyle: TextStyle(color: AppThemeColors.grey400),
        hintStyle: TextStyle(color: AppThemeColors.grey600),
      ),
      
      // Dividers
      dividerTheme: DividerThemeData(
        color: AppThemeColors.grey800,
        thickness: 1,
        space: 0,
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppThemeColors.darkDropdown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentTextStyle: TextStyle(color: AppThemeColors.surface),
      ),
    );
  }
}





