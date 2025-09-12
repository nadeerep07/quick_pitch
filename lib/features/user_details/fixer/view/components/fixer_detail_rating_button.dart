import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/rating/fixer_detail_rating_content.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/cubit/review_visibility_cubit.dart';

/// Main Rating + Message Button Section
class FixerDetailRatingButton extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel fixer;

  const FixerDetailRatingButton({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.fixer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewVisibilityCubit(),
      child: FixerDetailRatingContent(
        res: res,
        colorScheme: colorScheme,
        fixer: fixer,
      ),
    );
  }
}
