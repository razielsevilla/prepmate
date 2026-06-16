import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        primary: AppColors.forest,
        secondary: AppColors.fern,
        surface: AppColors.cream,
        onSurface: AppColors.soil,
        error: AppColors.today,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.dmSerifDisplay(
          color: AppColors.forest,
          fontSize: 36,
        ),
        displayMedium: GoogleFonts.dmSerifDisplay(
          color: AppColors.forest,
          fontSize: 32,
        ),
        displaySmall: GoogleFonts.dmSerifDisplay(
          color: AppColors.forest,
          fontSize: 28,
        ),
        headlineLarge: GoogleFonts.dmSerifDisplay(
          color: AppColors.forest,
          fontSize: 24,
        ),
        titleLarge: GoogleFonts.inter(
          color: AppColors.soil,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.soil,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.soil,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.soil),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cream,
        selectedItemColor: AppColors.forest,
        unselectedItemColor: AppColors.slate,
      ),
    );
  }
}
