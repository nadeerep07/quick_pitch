import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/view/widgets/rating_card/star_rating_display.dart';

class ExistingReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String posterName;
  final VoidCallback onEdit;

  const ExistingReviewCard({
    required this.review,
    required this.posterName,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.rate_review, color: Colors.blue, size: res.wp(6)),
                SizedBox(width: res.wp(2)),
                Text(
                  'Rate Poster',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1.5)),
            Container(
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
                        'You have reviewed this poster',
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
            ),
            SizedBox(height: res.hp(1.5)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit, size: res.wp(4)),
                    label: const Text('Edit Review'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
