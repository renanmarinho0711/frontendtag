import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// # Tema Principal do TagBean
/// 
/// Esta classe centraliza toda a configuração de temas do aplicativo.
/// Implementa Material Design 3 com suporte a tema claro e escuro.
/// 
/// ## Estrutura de Componentes:
/// 
/// ```
/// AppTheme
///   ├── lightTheme
///   │   ├── ColorScheme (cores do Material 3)
///   │   ├── Typography (estilos de texto)
///   │   ├── Component Themes
///   │   │   ├── AppBarTheme
///   │   │   ├── CardTheme
///   │   │   ├── ButtonThemes
///   │   │   ├── InputDecorationTheme
///   │   │   └── etc...
///   │   └── Custom Properties
///   └── darkTheme (mesma estrutura)
/// ```
class AppTheme {
  AppTheme._();
  
  /// ## Tema Claro
  /// 
  /// Configuração completa do tema claro seguindo as diretrizes:
  /// - Background principal: grey50
  /// - Cards e superfícies: white
  /// - Texto principal: grey900
  /// - Cores de ação: primary (indigo)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTypography.lightTextTheme,
      
      // Componentes de AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.titleLarge(color: AppColors.textPrimaryLight),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryLight,
          size: 24,
        ),
      ),
      
      /// BottomNavigationBar - Light
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey600,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      /// NavigationBar - Light
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primary.withOpacity(0.2),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.all(
          AppTypography.labelMedium(color: AppColors.textPrimaryLight),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.grey600, size: 24);
        }),
      ),
      
      /// Cards - Light
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: AppSpacing.paddingSm,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          side: const BorderSide(color: AppColors.borderLight, width: 0),
        ),
      ),
      
      /// ElevatedButton - Light
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey500,
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      
      /// OutlinedButton - Light
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.grey500,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      
      /// InputDecoration - Light
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.bodyMedium(color: AppColors.grey700),
        hintStyle: AppTypography.bodyMedium(color: AppColors.grey600),
        errorStyle: AppTypography.bodySmall(color: AppColors.error),
        prefixIconColor: AppColors.grey500,
        suffixIconColor: AppColors.grey500,
      ),
      
      /// Chip - Light
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey200,
        deleteIconColor: AppColors.grey600,
        disabledColor: AppColors.grey300,
        selectedColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: AppTypography.labelMedium(color: AppColors.grey900),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      ),
      
      /// Dialog - Light
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.headlineSmall(color: AppColors.textPrimaryLight),
        contentTextStyle: AppTypography.bodyLarge(color: AppColors.textSecondaryLight),
      ),
      
      /// SnackBar - Light
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey800,
        contentTextStyle: AppTypography.bodyMedium(color: AppColors.white),
        actionTextColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      /// Divider - Light
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      
      /// Outros componentes Light
      iconTheme: const IconThemeData(
        color: AppColors.grey800,
        size: 24,
      ),
      
      /// PopupMenuTheme
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surfaceLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        textStyle: AppTypography.bodyMedium(color: AppColors.textPrimaryLight),
      ),
      
      /// TooltipTheme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.grey800,
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        textStyle: AppTypography.bodySmall(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      
      /// ExpansionTileTheme
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      ),
      
      /// DatePickerTheme
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surfaceLight,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: AppColors.white,
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.white;
          }
          return AppColors.textPrimaryLight;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
      ),
      
      /// TimePickerTheme
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surfaceLight,
        hourMinuteColor: AppColors.grey100,
        hourMinuteTextColor: AppColors.textPrimaryLight,
        dayPeriodColor: AppColors.grey100,
        dayPeriodTextColor: AppColors.textPrimaryLight,
        dialBackgroundColor: AppColors.grey100,
        dialHandColor: AppColors.primary,
        dialTextColor: AppColors.textPrimaryLight,
        entryModeIconColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
      ),
      
      /// DrawerTheme
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 16,
        width: 280,
      ),
      
      /// NavigationDrawerTheme
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primary.withOpacity(0.1),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        labelTextStyle: MaterialStateProperty.all(
          AppTypography.bodyMedium(color: AppColors.textPrimaryLight),
        ),
      ),
      
      /// NavigationRailTheme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedIconTheme: const IconThemeData(
          color: AppColors.primary,
          size: 24,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppColors.grey500,
          size: 24,
        ),
        selectedLabelTextStyle: AppTypography.labelMedium(color: AppColors.primary),
        unselectedLabelTextStyle: AppTypography.labelMedium(color: AppColors.grey500),
        indicatorColor: AppColors.primary.withOpacity(0.1),
        useIndicator: true,
      ),
    );
  }
  
  /// ## Tema Escuro
  /// 
  /// Configuração completa do tema escuro:
  /// - Background principal: grey900
  /// - Cards e superfícies: grey800
  /// - Texto principal: grey50
  /// - Cores de ação mantêm vibrância
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTypography.darkTextTheme,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.accent,
        tertiaryContainer: AppColors.accentDark,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
        error: AppColors.error,
        errorContainer: AppColors.errorLight,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onTertiary: AppColors.white,
        onSurface: AppColors.textPrimaryDark,
        onBackground: AppColors.textPrimaryDark,
        onError: AppColors.white,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.grey700,
        shadow: AppColors.black,
        scrim: AppColors.black,
      ),
      
      /// AppBar - Dark
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.titleLarge(color: AppColors.textPrimaryDark),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryDark,
          size: 24,
        ),
      ),
      
      /// BottomNavigationBar - Dark
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.grey600,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      /// NavigationBar - Dark
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withOpacity(0.2),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.all(
          AppTypography.labelMedium(color: AppColors.textPrimaryDark),
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.primaryLight, size: 24);
          }
          return const IconThemeData(color: AppColors.grey600, size: 24);
        }),
      ),
      
      /// Cards - Dark
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: AppSpacing.paddingSm,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          side: const BorderSide(color: AppColors.borderDark, width: 0),
        ),
      ),
      
      /// ElevatedButton - Dark
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grey700,
          disabledForegroundColor: AppColors.grey500,
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      
      /// OutlinedButton - Dark
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          disabledForegroundColor: AppColors.grey600,
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      
      /// InputDecoration - Dark
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.bodyMedium(color: AppColors.grey400),
        hintStyle: AppTypography.bodyMedium(color: AppColors.grey600),
        errorStyle: AppTypography.bodySmall(color: AppColors.error),
        prefixIconColor: AppColors.grey500,
        suffixIconColor: AppColors.grey500,
      ),
      
      /// Chip - Dark
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey800,
        deleteIconColor: AppColors.grey400,
        disabledColor: AppColors.grey900,
        selectedColor: AppColors.primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: AppTypography.labelMedium(color: AppColors.grey300),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      ),
      
      /// Dialog - Dark
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.headlineSmall(color: AppColors.textPrimaryDark),
        contentTextStyle: AppTypography.bodyLarge(color: AppColors.textSecondaryDark),
      ),
      
      /// SnackBar - Dark
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey700,
        contentTextStyle: AppTypography.bodyMedium(color: AppColors.white),
        actionTextColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      /// Divider - Dark
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      
      /// Outros componentes Dark
      iconTheme: const IconThemeData(
        color: AppColors.grey400,
        size: 24,
      ),
      
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 16,
      ),
      
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.grey700,
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        textStyle: AppTypography.bodySmall(color: AppColors.white),
      ),
    );
  }
}