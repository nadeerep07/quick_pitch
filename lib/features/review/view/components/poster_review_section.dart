import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/review/view/widgets/fixer_review_section/review_rating_widget.dart';
import 'package:quick_pitch_app/features/review/view/widgets/poster_review_sction/existing_review_card.dart';
import 'package:quick_pitch_app/features/review/view/widgets/poster_review_sction/loading_card.dart';
import 'package:quick_pitch_app/features/review/view/widgets/poster_review_sction/review_prompt_card.dart';
import 'package:quick_pitch_app/features/review/view/widgets/poster_review_sction/task_pending_card.dart';
import 'package:quick_pitch_app/features/review/viewmodel/review/cubit/poster_review_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PosterReviewSection extends StatelessWidget {
  final PitchModel pitch;
  final String fixerId;
  final String fixerName;
  final String? fixerImageUrl;

  const PosterReviewSection({
    super.key,
    required this.pitch,
    required this.fixerId,
    required this.fixerName,
    this.fixerImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return BlocProvider(
      create: (_) {
        final cubit = PosterReviewCubit(ReviewService());
        final currentUserId =uid! ; // replace with your auth user
        cubit.checkReviewStatus(currentUserId, pitch.id);
        return cubit;
      },
      child: BlocBuilder<PosterReviewCubit, PosterReviewState>(
        builder: (context, state) {
          final cubit = context.read<PosterReviewCubit>();

          void showReviewDialog() {
            showDialog(
              context: context,
              builder: (context) => ReviewRatingWidget(
                revieweeId: fixerId,
                revieweeName: fixerName,
                pitchId: pitch.id,
                taskId: pitch.taskId ,
                reviewerType: 'poster',
                existingReview: state.existingReview,
                onReviewSubmitted: () {
                  cubit.checkReviewStatus( uid!, pitch.id);
                },
              ),
            );
          }

          if (state.isLoading) return LoadingCard(res: res);

          return Card(
            child: Padding(
              padding: EdgeInsets.all(res.wp(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star_rate, color: Colors.amber, size: res.wp(6)),
                      SizedBox(width: res.wp(2)),
                      Text(
                        'Rate Fixer',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: res.hp(1.5)),

                  if (state.existingReview != null) ...[
                    ExistingReviewCard(review: state.existingReview!, res: res, theme: theme),
                    SizedBox(height: res.hp(1.5)),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: showReviewDialog,
                            icon: Icon(Icons.edit, size: res.wp(4)),
                            label: const Text('Edit Review'),
                          ),
                        ),
                      ],
                    ),
                  ] else if (state.canReview && pitch.status == 'completed') ...[
                    ReviewPromptCard(
                      res: res,
                      theme: theme,
                      fixerName: fixerName,
                      fixerImageUrl: fixerImageUrl,
                      onPressed: showReviewDialog,
                    ),
                  ] else ...[
                    TaskPendingCard(res: res, theme: theme),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
