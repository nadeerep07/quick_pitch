import 'dart:ui';

import 'package:quick_pitch_app/core/config/app_colors.dart';

class AppTextStyles {
  static final heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryColor,
  );

  static final subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryColor,
  );

  static final link = TextStyle(
    color: AppColors.linkColor,
    fontWeight: FontWeight.w500,
  );
}
