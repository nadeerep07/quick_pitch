import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerCardRatingDistance extends StatelessWidget {
  final String distance;
  final double? averageRating;
  final int? totalReviews;

  const FixerCardRatingDistance({
    super.key, 
    required this.distance,
    this.averageRating,
    this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Row(
      children: [
        // Rating
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(2.5),
            vertical: res.hp(0.4),
          ),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(res.wp(2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: res.sp(14), color: Colors.amber[600]),
              SizedBox(width: res.wp(1)),
              Text(
                _formatRating(),
                style: TextStyle(
                  fontSize: res.sp(13),
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
              if (totalReviews != null && totalReviews! > 0) ...[
                SizedBox(width: res.wp(1)),
                Text(
                  '($totalReviews)',
                  style: TextStyle(
                    fontSize: res.sp(11),
                    fontWeight: FontWeight.w500,
                    color: Colors.amber[600],
                  ),
                ),
              ],
            ],
          ),
        ),

        if (distance.isNotEmpty) ...[
          SizedBox(width: res.wp(2.5)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(2.5),
              vertical: res.hp(0.4),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(res.wp(2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_rounded, size: res.sp(14), color: Colors.blue[600]),
                SizedBox(width: res.wp(1)),
                Text(
                  distance,
                  style: TextStyle(
                    fontSize: res.sp(13),
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatRating() {
    if (averageRating == null || averageRating == 0.0) {
      return 'New';
    }
    
    // Round to 1 decimal place
    return averageRating!.toStringAsFixed(1);
  }
}