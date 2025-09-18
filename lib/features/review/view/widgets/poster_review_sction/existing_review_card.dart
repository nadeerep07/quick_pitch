import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/view/widgets/rating_card/star_rating_display.dart';

class ExistingReviewCard extends StatelessWidget {
  final ReviewModel review;
  final Responsive res;
  final ThemeData theme;

  const ExistingReviewCard({required this.review, required this.res, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha:0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: res.wp(4)),
              SizedBox(width: res.wp(2)),
              Text(
                'You have reviewed this fixer',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(1)),
          StarRatingDisplay(rating: review.rating, starSize: res.wp(4), showText: false),
          SizedBox(height: res.hp(0.5)),
          Text(
            review.comment,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
