import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Centralized Material 3 theme built from design-system tokens.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.blue,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.blueLight,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: AppColors.dangerBg,
      outline: AppColors.border,
      outlineVariant: AppColors.borderStrong,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.inter().fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: AppColors.text,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderBase,
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textPlaceholder, fontSize: 15),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.inter().fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          minimumSize: const Size.fromHeight(44),
          side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.inter().fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
