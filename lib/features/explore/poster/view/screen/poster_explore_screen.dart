import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/all_skills_bottom_sheet.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_empty.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_fixer_card.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_nearby_toggle.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_shimmer.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_skill_chips.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_search_bar.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreScreen extends StatefulWidget {
  const PosterExploreScreen({super.key});

  @override
  State<PosterExploreScreen> createState() => _PosterExploreScreenState();
}

class _PosterExploreScreenState extends State<PosterExploreScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final res = Responsive(context);
    final theme = Theme.of(context);

    return BlocProvider(
      create:
          (context) =>
              PosterExploreCubit(repository: PosterExploreRepository())..load(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<PosterExploreCubit, PosterExploreState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Header with search
                SliverAppBar(
                  expandedHeight: res.hp(28),
                  floating: true,
                  pinned: true,
                  snap: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
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
                              SizedBox(height: res.hp(2.5)),
                              PosterExploreSearchBar(
                                onChanged:
                                    context
                                        .read<PosterExploreCubit>()
                                        .updateSearch,
                                query:
                                    state is PosterExploreLoaded
                                        ? state.query
                                        : '',
                              ),
                              SizedBox(height: res.hp(2)),
                              if (state is PosterExploreLoaded)
                                PosterExploreSkillChips(
                                  skills: state.skills,
                                  selectedSkills: state.selectedSkills,
                                  onTap:
                                      context
                                          .read<PosterExploreCubit>()
                                          .toggleSkill,
                                  onMoreTap: () {
                                    final cubit =
                                        context
                                            .read<
                                              PosterExploreCubit
                                            >(); // get cubit before bottom sheet

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        return BlocProvider.value(
                                          value:
                                              cubit, 
                                          child: AllSkillsBottomSheet(
                                            skills: state.skills,
                                            selectedSkills:
                                                state.selectedSkills,
                                            onToggleSkill: cubit.toggleSkill,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    titlePadding: EdgeInsets.zero,
                  ),
                ),

                // Content
                if (state is PosterExploreLoading)
                  const SliverFillRemaining(child: PosterExploreShimmer())
                else if (state is PosterExploreError)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: res.hp(2)),
                          Text(
                            'Something went wrong',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          SizedBox(height: res.hp(1)),
                          Text(
                            state.message,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: res.hp(4)),
                          ElevatedButton.icon(
                            onPressed:
                                () => context.read<PosterExploreCubit>().load(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: res.wp(6),
                                vertical: res.hp(1.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is PosterExploreLoaded)
                  _buildContent(context, state, res, theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PosterExploreLoaded state,
    Responsive res,
    ThemeData theme,
  ) {
    return SliverPadding(
      padding: EdgeInsets.all(res.wp(5)),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Nearby toggle and controls
          PosterExploreNearbyToggle(
            enabled: state.nearbyEnabled,
            radius: state.radiusKm,
            hasLocation: state.posterLocation != null,
            onToggle: context.read<PosterExploreCubit>().toggleNearby,
            onRadiusChanged: context.read<PosterExploreCubit>().setNearbyRadius,
            onLocationRefresh:
                context.read<PosterExploreCubit>().refreshLocation,
          ),

          SizedBox(height: res.hp(3)),

          // Results
          if (state.filteredFixers.isEmpty)
            const PosterExploreEmpty()
          else ...[
            // Popular/All Results Section
            _buildSection(
              title:
                  state.selectedSkills.isNotEmpty || state.query.isNotEmpty
                      ? 'Search Results (${state.filteredFixers.length})'
                      : 'Popular Fixers',
              fixers: state.popularFixers,
              showAll: state.filteredFixers.length > 10,
              onSeeAll: () {
                // Navigate to all results
              },
            ),

            if (state.nearbyEnabled && state.nearbyFixers.isNotEmpty) ...[
              SizedBox(height: res.hp(4)),
              _buildSection(
                title: 'Nearby Fixers (${state.nearbyFixers.length})',
                fixers: state.nearbyFixers.take(5).toList(),
                showAll: state.nearbyFixers.length > 5,
                showDistance: true,
                posterLocation: state.posterLocation,
                onSeeAll: () {
                  // Navigate to nearby results
                },
              ),
            ],
          ],
        ]),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<UserProfileModel> fixers,
    bool showAll = false,
    bool showDistance = false,
    Position? posterLocation,
    VoidCallback? onSeeAll,
  }) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showAll && onSeeAll != null)
              TextButton(onPressed: onSeeAll, child: Text('See All')),
          ],
        ),
        SizedBox(height: res.hp(2)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fixers.length,
          separatorBuilder: (context, index) => SizedBox(height: res.hp(2)),
          itemBuilder: (context, index) {
            return PosterExploreFixerCard(
              fixer: fixers[index],
              showDistance: showDistance,
              posterLocation: posterLocation,
            );
          },
        ),
      ],
    );
  }
}
