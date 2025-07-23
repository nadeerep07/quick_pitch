import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterDetailRatingButton extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;

  const PosterDetailRatingButton({
    super.key,
    required this.res,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Rating chip
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(3),
            vertical: res.hp(0.8),
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, 
                  size: res.sp(16), color: Colors.amber),
              SizedBox(width: res.wp(1)),
              Text(
                "4.5",
                style: TextStyle(
                  fontSize: res.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: res.wp(1)),
              Text(
                "(12 reviews)",
                style: TextStyle(
                  fontSize: res.sp(12),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        Spacer(),
        
        // Action buttons
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.message_outlined),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(width: res.wp(2)),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.favorite_border_outlined),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}