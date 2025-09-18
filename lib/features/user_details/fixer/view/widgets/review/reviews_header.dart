import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ReviewsHeader extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final VoidCallback onViewAllPressed;

  const ReviewsHeader({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reviews',
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          TextButton(
            onPressed: onViewAllPressed,
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(3),
                vertical: res.hp(0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: res.wp(1)),
                Icon(
                  Icons.arrow_forward_ios,
                  size: res.sp(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
