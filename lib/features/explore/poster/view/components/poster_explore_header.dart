import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/main_widget/all_skills_bottom_sheet.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/poster_explore_search_bar.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/poster_explore_skill_chips.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/main_widget/view_toggle_switch.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';

class PosterExploreHeader extends StatelessWidget {
  final PosterExploreLoaded state;

  const PosterExploreHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: res.hp(28),
      floating: true,
      pinned: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, res.hp(28)),
              painter: MainBackgroundPainter(),
            ),
            Positioned(
              left: res.wp(5),
              right: res.wp(5),
              bottom: res.hp(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(theme, res,context),
                  SizedBox(height: res.hp(2.5)),
                  PosterExploreSearchBar(
                    onChanged: context.read<PosterExploreCubit>().updateSearch,
                    query: state.query,
                  ),
                  SizedBox(height: res.hp(2)),
                  PosterExploreSkillChips(
                    skills: state.skills,
                    selectedSkills: state.selectedSkills,
                    onTap: context.read<PosterExploreCubit>().toggleSkill,
                    onMoreTap: () {
                      _showAllSkillsBottomSheet(context, state);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, Responsive res,BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find Fixers',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: res.hp(0.5)),
              Text(
                'Discover skilled professionals near you',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
        ViewToggleSwitch(
          isMapView: state.isMapView,
          onToggle: (_) => context.read<PosterExploreCubit>().toggleMapView(),
        ),
      ],
    );
  }

  void _showAllSkillsBottomSheet(BuildContext context, PosterExploreLoaded state) {
    final cubit = context.read<PosterExploreCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: AllSkillsBottomSheet(
            skills: state.skills,
            selectedSkills: state.selectedSkills,
            onToggleSkill: cubit.toggleSkill,
          ),
        );
      },
    );
  }
}
