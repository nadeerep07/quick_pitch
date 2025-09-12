import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/view/widgets/fixer_review_section/review_rating_widget.dart';
import 'package:quick_pitch_app/features/review/view/widgets/rating_card/star_rating_display.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String reviewerName;
  final String? reviewerImageUrl;

  const ReviewCard({
    super.key,
    required this.review,
    required this.reviewerName,
    this.reviewerImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: res.hp(1)),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: res.wp(5),
                  backgroundImage:
                      reviewerImageUrl != null
                          ? NetworkImage(reviewerImageUrl!)
                          : null,
                  child:
                      reviewerImageUrl == null
                          ? Text(
                            reviewerName.isNotEmpty
                                ? reviewerName[0].toUpperCase()
                                : '?',
                          )
                          : null,
                ),
                SizedBox(width: res.wp(3)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewerName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      StarRatingDisplay(
                        rating: review.rating,
                        starSize: res.wp(4),
                        showText: false,
                      ),
                    ],
                  ),
                ),

                Text(
                  _formatDate(review.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1.5)),

            Text(review.comment, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}
