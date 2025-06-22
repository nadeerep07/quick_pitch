import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_pitch_app/shared/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor:  AppColors.primaryBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary ),
    useMaterial3: true,
    textTheme:  GoogleFonts.poppinsTextTheme()
  );
}