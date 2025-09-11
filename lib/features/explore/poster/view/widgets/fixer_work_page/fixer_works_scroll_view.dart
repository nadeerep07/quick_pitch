import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/fixer_works_app_bar.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_fixer_work_page/fixer_works_content.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_state.dart';

class FixerWorksScrollView extends StatelessWidget {
  final UserProfileModel fixer;
  final FixerWorksState state;
  final ScrollController scrollController;
  final Animation<double> fadeAnimation;
  final FixerWorksCubit fixerWorksCubit;

  const FixerWorksScrollView({
    super.key,
    required this.fixer,
    required this.state,
    required this.scrollController,
    required this.fadeAnimation,
    required this.fixerWorksCubit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        FixerWorksAppBar(
          fixer: fixer,
          state: state,
          onClose: () => Navigator.of(context).pop(),
        ),
        SliverToBoxAdapter(
          child: FixerWorksContent(
            state: state,
            fixer: fixer,
            fadeAnimation: fadeAnimation,
            onRefresh: () => fixerWorksCubit.refreshWorks(fixer.uid),
            onRetry: () => fixerWorksCubit.loadFixerWorks(fixer.uid),
          ),
        ),
      ],
    );
  }
}
