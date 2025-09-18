import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ReviewsEmptyView extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;

  const ReviewsEmptyView({
    super.key,
    required this.res,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: res.sp(48), color: colorScheme.outline),
          SizedBox(height: res.hp(2)),
          Text('No reviews yet', style: TextStyle(fontSize: res.sp(16), color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}
