import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/cubit/review_visibility_cubit.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/widgets/poster_detail_review_button/favorite_button.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/widgets/poster_detail_review_button/message_button.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/widgets/poster_detail_review_button/rating_chip.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/widgets/poster_detail_review_button/reviews_section.dart';

/// Main entry widget
class PosterDetailRatingButton extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel poster;

  const PosterDetailRatingButton({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewVisibilityCubit(),
      child: _PosterDetailRatingContent(
        res: res,
        colorScheme: colorScheme,
        poster: poster,
      ),
    );
  }
}

/// Content wrapper with cubit state
class _PosterDetailRatingContent extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel poster;

  const _PosterDetailRatingContent({
    required this.res,
    required this.colorScheme,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewVisibilityCubit, bool>(
      builder: (context, showReviews) {
        return Column(
          children: [
            Row(
              children: [
                RatingChip(res: res, colorScheme: colorScheme, poster: poster),
                const Spacer(),
                MessageButton(res: res, colorScheme: colorScheme, poster: poster),
                SizedBox(width: res.wp(2)),
                FavoriteButton(res: res, colorScheme: colorScheme),
              ],
            ),
            if (showReviews)
              ReviewsSection(
                res: res,
                colorScheme: colorScheme,
                poster: poster,
              ),
          ],
        );
      },
    );
  }
}
