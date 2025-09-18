import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';

/// Full Review Card for bottom sheet
class FullReviewCard extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final ReviewModel review;
  final String reviewerName;
  final String? reviewerImage;

  const FullReviewCard({super.key, 
    required this.res,
    required this.colorScheme,
    required this.review,
    required this.reviewerName,
    required this.reviewerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: .2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Info and Rating
          Row(
            children: [
              CircleAvatar(
                radius: res.wp(5),
                backgroundImage: reviewerImage != null
                    ? NetworkImage(reviewerImage!)
                    : null,
                child: reviewerImage == null
                    ? Icon(
                        Icons.person,
                        size: res.sp(16),
                        color: colorScheme.onSurface,
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
                      style: TextStyle(
                        fontSize: res.sp(14),
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: res.hp(0.5)),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_outline,
                          size: res.sp(14),
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(review.createdAt),
                style: TextStyle(
                  fontSize: res.sp(12),
                  color: colorScheme.onSurface.withValues(alpha:0.6),
                ),
              ),
            ],
          ),
          
          // Review Text
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: res.hp(2)),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: res.sp(14),
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ],
        ],
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