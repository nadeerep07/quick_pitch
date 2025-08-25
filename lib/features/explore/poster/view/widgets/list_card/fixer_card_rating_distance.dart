import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerCardRatingDistance extends StatelessWidget {
  final String distance;

  const FixerCardRatingDistance({super.key, required this.distance});

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
                '4.8', // TODO: dynamic rating
                style: TextStyle(
                  fontSize: res.sp(13),
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
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
}
