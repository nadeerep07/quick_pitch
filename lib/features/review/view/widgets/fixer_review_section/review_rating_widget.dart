import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/review/view/widgets/rating_card/comment_input_field.dart';
import 'package:quick_pitch_app/features/review/view/widgets/rating_card/rating_text.dart';
import 'package:quick_pitch_app/features/review/view/widgets/rating_card/review_action_buttons.dart';
import 'package:quick_pitch_app/features/review/view/widgets/rating_card/star_rating_input.dart';
import 'package:quick_pitch_app/features/review/viewmodel/review_rating/cubit/review_rating_cubit.dart';

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

                  /// ⭐ Star rating input
                  StarRatingInput(
                    rating: state.rating,
                    onRatingSelected: cubit.updateRating,
                    size: res.wp(8),
                  ),
                  SizedBox(height: res.hp(2)),

                  /// Rating text
                  RatingText(rating: state.rating, theme: theme),
                  SizedBox(height: res.hp(3)),

                  /// 📝 Comment field
                  CommentInputField(
                    comment: state.comment,
                    onChanged: cubit.updateComment,
                  ),
                  SizedBox(height: res.hp(3)),

                  /// Buttons
                  ReviewActionButtons(
                    isSubmitting: state.isSubmitting,
                    existingReview: existingReview,
                    onCancel: () => Navigator.of(context).pop(),
                    onSubmit:
                        () => cubit.submitReview(
                          revieweeId: revieweeId,
                          pitchId: pitchId,
                          taskId: taskId,
                          reviewerType: reviewerType,
                          onSuccess: onReviewSubmitted,
                          context: context,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
