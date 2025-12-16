import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tipografia do aplicativo TagBean
abstract class AppTypography {
  static const String _fontFamily = 'Inter';
  
  // Display
  static TextStyle displayLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: color,
  );
  
  static TextStyle displayMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: color,
  );
  
  static TextStyle displaySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    color: color,
  );
  
  // Headline
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: color,
  );
  
  static TextStyle headlineMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: color,
  );
  
  static TextStyle headlineSmall({Color? color}) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: color,
  );
  
  // Title
  static TextStyle titleLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
    color: color,
  );
  
  static TextStyle titleMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: color,
  );
  
  static TextStyle titleSmall({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: color,
  );
  
  // Body
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: color,
  );
  
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: color,
  );
  
  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: color,
  );
  
  // Label
  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: color,
  );
  
  static TextStyle labelMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: color,
  );
  
  static TextStyle labelSmall({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: color,
  );
  
  /// TextTheme para modo claro
  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: displayLarge(color: AppColors.textPrimaryLight),
    displayMedium: displayMedium(color: AppColors.textPrimaryLight),
    displaySmall: displaySmall(color: AppColors.textPrimaryLight),
    headlineLarge: headlineLarge(color: AppColors.textPrimaryLight),
    headlineMedium: headlineMedium(color: AppColors.textPrimaryLight),
    headlineSmall: headlineSmall(color: AppColors.textPrimaryLight),
    titleLarge: titleLarge(color: AppColors.textPrimaryLight),
    titleMedium: titleMedium(color: AppColors.textPrimaryLight),
    titleSmall: titleSmall(color: AppColors.textPrimaryLight),
    bodyLarge: bodyLarge(color: AppColors.textPrimaryLight),
    bodyMedium: bodyMedium(color: AppColors.textPrimaryLight),
    bodySmall: bodySmall(color: AppColors.textSecondaryLight),
    labelLarge: labelLarge(color: AppColors.textPrimaryLight),
    labelMedium: labelMedium(color: AppColors.textSecondaryLight),
    labelSmall: labelSmall(color: AppColors.textSecondaryLight),
  );
  
  /// TextTheme para modo escuro
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: displayLarge(color: AppColors.textPrimaryDark),
    displayMedium: displayMedium(color: AppColors.textPrimaryDark),
    displaySmall: displaySmall(color: AppColors.textPrimaryDark),
    headlineLarge: headlineLarge(color: AppColors.textPrimaryDark),
    headlineMedium: headlineMedium(color: AppColors.textPrimaryDark),
    headlineSmall: headlineSmall(color: AppColors.textPrimaryDark),
    titleLarge: titleLarge(color: AppColors.textPrimaryDark),
    titleMedium: titleMedium(color: AppColors.textPrimaryDark),
    titleSmall: titleSmall(color: AppColors.textPrimaryDark),
    bodyLarge: bodyLarge(color: AppColors.textPrimaryDark),
    bodyMedium: bodyMedium(color: AppColors.textPrimaryDark),
    bodySmall: bodySmall(color: AppColors.textSecondaryDark),
    labelLarge: labelLarge(color: AppColors.textPrimaryDark),
    labelMedium: labelMedium(color: AppColors.textSecondaryDark),
    labelSmall: labelSmall(color: AppColors.textSecondaryDark),
  );
}
