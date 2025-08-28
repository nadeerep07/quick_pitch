import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class StatusColorUtil {
  static Color getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.icon2;
      case 'accepted':
        return AppColors.secondaryColor;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }
}
