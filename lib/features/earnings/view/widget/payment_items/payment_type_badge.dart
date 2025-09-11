import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

/// ----------------------------
/// Section: Payment Type Badge
/// ----------------------------
class PaymentTypeBadge extends StatelessWidget {
  final bool isHireRequest;
  const PaymentTypeBadge({required this.isHireRequest});

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = isHireRequest ? Colors.orange : Colors.blue;
    final String badgeText = isHireRequest ? 'HIRE' : 'PITCH';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}

