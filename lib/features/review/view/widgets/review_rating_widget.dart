import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/review/viewmodel/review_rating/cubit/review_rating_cubit.dart';

/// ------------------------
/// Widget
/// ------------------------
class ReviewRatingWidget extends StatelessWidget {
  final String revieweeId;
  final String revieweeName;
  final String pitchId;
  final String taskId;
  final String reviewerType; // 'poster' or 'fixer'
  final VoidCallback? onReviewSubmitted;
  final ReviewModel? existingReview;

  const ReviewRatingWidget({
    super.key,
    required this.revieweeId,
    required this.revieweeName,
    required this.pitchId,
    required this.taskId,
    required this.reviewerType,
    this.onReviewSubmitted,
    this.existingReview,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return BlocProvider(
      create:
          (_) => ReviewRatingCubit(
            ReviewService(),
            existingReview: existingReview,
          ),
      child: BlocBuilder<ReviewRatingCubit, ReviewRatingState>(
        builder: (context, state) {
          final cubit = context.read<ReviewRatingCubit>();

          Widget _buildStarRating() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1.0;
                return GestureDetector(
                  onTap: () => cubit.updateRating(starValue),
                  child: Icon(
                    state.rating >= starValue ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: res.wp(8),
                  ),
                );
              }),
            );
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(res.wp(5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rate & Review',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: res.hp(1)),
                  Text(
                    'How was your experience with $revieweeName?',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: res.hp(3)),

                  // Star Rating
                  _buildStarRating(),
                  SizedBox(height: res.hp(2)),

                  Text(
                    _getRatingText(state.rating),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _getRatingColor(state.rating),
                    ),
                  ),
                  SizedBox(height: res.hp(3)),

                  // Comment TextField
                  TextField(
                    maxLines: 4,
                    maxLength: 500,
                    onChanged: cubit.updateComment,
                    controller: TextEditingController(text: state.comment),
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(3)),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed:
                              state.isSubmitting
                                  ? null
                                  : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: res.wp(3)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              state.isSubmitting
                                  ? null
                                  : () => cubit.submitReview(
                                    revieweeId: revieweeId,
                                    pitchId: pitchId,
                                    taskId: taskId,
                                    reviewerType: reviewerType,
                                    onSuccess: onReviewSubmitted,
                                    context: context,
                                  ),
                          child:
                              state.isSubmitting
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    existingReview != null
                                        ? 'Update'
                                        : 'Submit',
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return 'Tap to rate';
    if (rating <= 1) return 'Poor';
    if (rating <= 2) return 'Fair';
    if (rating <= 3) return 'Good';
    if (rating <= 4) return 'Very Good';
    return 'Excellent';
  }

  Color _getRatingColor(double rating) {
    if (rating == 0) return Colors.grey;
    if (rating <= 2) return Colors.red;
    if (rating <= 3) return Colors.orange;
    if (rating <= 4) return Colors.blue;
    return Colors.green;
  }
}

// Star Rating Display Widget
class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final double starSize;
  final bool showText;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.totalReviews = 0,
    this.starSize = 16,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final filled = rating > index;
          final halfFilled = rating > index && rating < index + 1;

          return Icon(
            halfFilled
                ? Icons.star_half
                : (filled ? Icons.star : Icons.star_border),
            color: Colors.amber,
            size: starSize,
          );
        }),

        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            '${rating.toStringAsFixed(1)}${totalReviews > 0 ? ' ($totalReviews)' : ''}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// Review Card Widget
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
