import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/rating/message_button.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/rating/rating_chip.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/rating/reviews_section.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/cubit/review_visibility_cubit.dart';

class FixerDetailRatingContent extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel fixer;

  const FixerDetailRatingContent({super.key, 
    required this.res,
    required this.colorScheme,
    required this.fixer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewVisibilityCubit, bool>(
      builder: (context, showReviews) {
        return Column(
          children: [
            Row(
              children: [
                RatingChip(res: res, colorScheme: colorScheme, fixer: fixer),
                const Spacer(),
                MessageButton(res: res, colorScheme: colorScheme, fixer: fixer),
              ],
            ),
            if (showReviews)
            ReviewsSection(
                res: res,
                colorScheme: colorScheme,
                fixer: fixer,
              ),
          ],
        );
      },
    );
  }
}

