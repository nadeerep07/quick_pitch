import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/review/view/widgets/fixer_review_section/existing_review_card.dart';
import 'package:quick_pitch_app/features/review/view/widgets/fixer_review_section/payment_pending_card.dart';
import 'package:quick_pitch_app/features/review/view/widgets/fixer_review_section/review_prompt_card.dart';
import 'package:quick_pitch_app/features/review/view/widgets/fixer_review_section/review_rating_widget.dart';
import 'package:quick_pitch_app/features/review/view/widgets/fixer_review_section/task_pending_card.dart';
import 'package:quick_pitch_app/features/review/viewmodel/review/cubit/fixer_review_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

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
   

    return BlocProvider(
      create: (_) {
        final cubit = FixerReviewCubit(ReviewService());
        final currentUserId = 'current_user_id'; // replace with auth user
        cubit.checkReviewStatus(currentUserId, pitch.id);
        return cubit;
      },
      child: BlocBuilder<FixerReviewCubit, FixerReviewState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingCard();
          }

          if (state.existingReview != null) {
            return ExistingReviewCard(
              review: state.existingReview!,
              posterName: posterName,
              onEdit: () => _showReviewDialog(context, state.existingReview),
            );
          }

          if (state.canReview &&
              pitch.status == 'completed' &&
              pitch.paymentStatus == 'completed') {
            return ReviewPromptCard(
              posterName: posterName,
              posterImageUrl: posterImageUrl,
              onWriteReview: () => _showReviewDialog(context, state.existingReview),
            );
          }

          if (pitch.status == 'completed' && pitch.paymentStatus != 'completed') {
            return const PaymentPendingCard();
          }

          return const TaskPendingCard();
        },
      ),
    );
  }

  void _showReviewDialog(BuildContext context, ReviewModel? existingReview) {
    showDialog(
      context: context,
      builder: (context) => ReviewRatingWidget(
        revieweeId: posterId,
        revieweeName: posterName,
        pitchId: pitch.id,
        taskId: pitch.taskId ?? '',
        reviewerType: 'fixer',
        existingReview: existingReview,
        onReviewSubmitted: () {
          context.read<FixerReviewCubit>().checkReviewStatus('current_user_id', pitch.id);
        },
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard();

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
