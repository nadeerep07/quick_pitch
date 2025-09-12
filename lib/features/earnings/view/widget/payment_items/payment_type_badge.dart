import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';


class PaymentTypeBadge extends StatelessWidget {
  final bool isHireRequest;
  const PaymentTypeBadge({super.key, required this.isHireRequest});

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = isHireRequest ? Colors.orange : Colors.blue;
    final String badgeText = isHireRequest ? 'HIRE' : 'PITCH';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha:0.3)),
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

