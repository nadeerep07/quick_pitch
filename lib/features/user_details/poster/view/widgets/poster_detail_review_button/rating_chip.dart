import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/cubit/review_visibility_cubit.dart';

class RatingChip extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel poster;

  const RatingChip({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ReviewVisibilityCubit>().toggle(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: res.wp(3),
          vertical: res.hp(0.8),
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: res.sp(16), color: Colors.amber),
            SizedBox(width: res.wp(1)),
            Text(
              poster.posterData?.ratingStats?.averageRating.toStringAsFixed(1) ?? '0.0',
              style: TextStyle(fontSize: res.sp(14), fontWeight: FontWeight.w600),
            ),
            SizedBox(width: res.wp(1)),
            Text(
              ' (${poster.posterData?.ratingStats?.totalReviews.toString() ?? '0'})',
              style: TextStyle(fontSize: res.sp(12), color: Colors.grey[600]),
            ),
            SizedBox(width: res.wp(1)),
            Icon(
              context.watch<ReviewVisibilityCubit>().state
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: res.sp(16),
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
