
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_header.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/main_widget/all_skills_bottom_sheet.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/poster_explore_empty.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/poster_explore_fixer_card.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/poster_explore_search_bar.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/poster_explore_skill_chips.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/main_widget/view_toggle_switch.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
class PosterExploreListContent extends StatelessWidget {
  final PosterExploreLoaded state;

  const PosterExploreListContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return CustomScrollView(
      slivers: [
        PosterExploreHeader(state: state),
        if (state.filteredFixers.isEmpty)
          const SliverFillRemaining(child: PosterExploreEmpty())
        else
          SliverPadding(
            padding: EdgeInsets.all(res.wp(5)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(
                  context: context,
                  title: state.selectedSkills.isNotEmpty || state.query.isNotEmpty
                      ? 'Search Results (${state.filteredFixers.length})'
                      : 'Popular Fixers',
                  fixers: state.popularFixers,
                ),
                if (state.nearbyEnabled && state.nearbyFixers.isNotEmpty)
                  _buildSection(
                    context: context,
                    title: 'Nearby Fixers (${state.nearbyFixers.length})',
                    fixers: state.nearbyFixers.take(5).toList(),
                    showDistance: true,
                    posterLocation: state.posterLocation,
                  ),
              ]),
            ),
          ),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<UserProfileModel> fixers,
    bool showDistance = false,
    Position? posterLocation,
  }) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: res.hp(2)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fixers.length,
          separatorBuilder: (_, __) => SizedBox(height: res.hp(2)),
          itemBuilder: (_, index) => PosterExploreFixerCard(
            fixer: fixers[index],
            showDistance: showDistance,
            posterLocation: posterLocation,
          ),
        ),
      ],
    );
  }
}
