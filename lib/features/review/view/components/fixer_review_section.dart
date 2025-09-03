import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/review/view/widgets/review_rating_widget.dart';
import 'package:quick_pitch_app/features/review/viewmodel/review/cubit/fixer_review_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// ------------------------
class FixerReviewSection extends StatelessWidget {
  final PitchModel pitch;
  final String posterId;
  final String posterName;
  final String? posterImageUrl;

  const FixerReviewSection({
    super.key,
    required this.pitch,
    required this.posterId,
    required this.posterName,
    this.posterImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) {
        final cubit = FixerReviewCubit(ReviewService());
        final currentUserId = 'current_user_id'; // replace with auth user
        cubit.checkReviewStatus(currentUserId, pitch.id);
        return cubit;
      },
      child: BlocBuilder<FixerReviewCubit, FixerReviewState>(
        builder: (context, state) {
          final cubit = context.read<FixerReviewCubit>();

          void _showReviewDialog() {
            showDialog(
              context: context,
              builder: (context) => ReviewRatingWidget(
                revieweeId: posterId,
                revieweeName: posterName,
                pitchId: pitch.id,
                taskId: pitch.taskId ?? '',
                reviewerType: 'fixer',
                existingReview: state.existingReview,
                onReviewSubmitted: () {
                  cubit.checkReviewStatus('current_user_id', pitch.id);
                },
              ),
            );
          }

          if (state.isLoading) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(res.wp(4)),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          }

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

                  /// Existing Review
                  if (state.existingReview != null) ...[
                    _existingReviewCard(state.existingReview!, res, theme),
                    SizedBox(height: res.hp(1.5)),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showReviewDialog,
                            icon: Icon(Icons.edit, size: res.wp(4)),
                            label: const Text('Edit Review'),
                          ),
                        ),
                      ],
                    ),
                  ]

                  /// Can review
                  else if (state.canReview &&
                      pitch.status == 'completed' &&
                      pitch.paymentStatus == 'completed') ...[
                    _reviewPrompt(res, theme, _showReviewDialog),
                  ]

                  /// Payment not completed
                  else if (pitch.status == 'completed' &&
                      pitch.paymentStatus != 'completed') ...[
                    _paymentPendingCard(res, theme),
                  ]

                  /// Task not completed
                  else ...[
                    _taskPendingCard(res, theme),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _existingReviewCard(ReviewModel review, Responsive res, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
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
    );
  }

  Widget _reviewPrompt(Responsive res, ThemeData theme, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: res.wp(4),
                backgroundImage: posterImageUrl != null ? NetworkImage(posterImageUrl!) : null,
                child: posterImageUrl == null
                    ? Text(
                        posterName.isNotEmpty ? posterName[0].toUpperCase() : '?',
                        style: TextStyle(fontSize: res.wp(3)),
                      )
                    : null,
              ),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How was $posterName?',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Rate your experience with this poster',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(1.5)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(Icons.rate_review, size: res.wp(4)),
              label: const Text('Write Review'),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: res.hp(1.2))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentPendingCard(Responsive res, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.payment, color: Colors.orange[600], size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Text(
              'You can review this poster once the payment is completed',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.orange[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskPendingCard(Responsive res, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.pending, color: Colors.grey[600], size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Text(
              'Reviews can be submitted after task completion and payment',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
