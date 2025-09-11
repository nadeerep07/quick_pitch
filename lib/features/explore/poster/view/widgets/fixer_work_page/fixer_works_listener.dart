import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_state.dart';
import 'fixer_works_scroll_view.dart';
import 'fixer_works_snackbar.dart';

class FixerWorksListener extends StatelessWidget {
  final UserProfileModel fixer;
  final ScrollController scrollController;
  final Animation<double> fadeAnimation;
  final AnimationController fadeController;
  final FixerWorksCubit fixerWorksCubit;

  const FixerWorksListener({
    super.key,
    required this.fixer,
    required this.scrollController,
    required this.fadeAnimation,
    required this.fadeController,
    required this.fixerWorksCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FixerWorksCubit, FixerWorksState>(
      listener: (context, state) {
        if (state is FixerWorksError) {
          FixerWorksSnackBar.show(context, state.message);
        } else if (state is FixerWorksLoaded) {
          fadeController.forward();
        }
      },
      builder: (context, state) {
        return FixerWorksScrollView(
          fixer: fixer,
          state: state,
          scrollController: scrollController,
          fadeAnimation: fadeAnimation,
          fixerWorksCubit: fixerWorksCubit,
        );
      },
    );
  }
}
