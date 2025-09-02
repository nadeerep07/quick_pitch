import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/service/poster_explore_service.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_main/explore_app_bar_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_main/explore_List_view.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_main/explore_error_view.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_main/explore_filter_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_main/explore_search_section.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';
import 'package:quick_pitch_app/features/explore/poster/view/screen/poster_explore_map_view.dart';
import 'package:shimmer/shimmer.dart';

class PosterExploreScreen extends StatelessWidget {
  const PosterExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PosterExploreCubit(
        service: PosterExploreService(PosterExploreRepository()),
      )..load(),
      child: const _PosterExploreView(),
    );
  }
}



class _PosterExploreView extends StatelessWidget {
  const _PosterExploreView();

  @override
  Widget build(BuildContext context) {
    final refreshController = RefreshController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: MainBackgroundPainter(),
          ),
          SafeArea(
            child: BlocBuilder<PosterExploreCubit, PosterExploreState>(
              builder: (context, state) {
                if (state is PosterExploreLoading) {
                  return _buildShimmerList();
                } else if (state is PosterExploreError) {
                  return ExploreErrorView(
                    message: state.message,
                    onRetry: () => context.read<PosterExploreCubit>().load(),
                  );
                } else if (state is PosterExploreLoaded) {
                  return SmartRefresher(
                    controller: refreshController,
                    onRefresh: () async {
                      await context.read<PosterExploreCubit>().load();
                      refreshController.refreshCompleted();
                    },
                    child: Column(
                      children: [
                        ExploreAppBar(state: state),
                        if (!state.isMapView) ...[
                          ExploreSearchBar(
                            onChanged: (query) =>
                                context.read<PosterExploreCubit>().updateSearch(query),
                          ),
                          ExploreSkillsFilter(
                            state: state,
                            onSkillToggle: (skill) =>
                                context.read<PosterExploreCubit>().toggleSkill(skill),
                          ),
                        ],
                        Expanded(
                          child: state.isMapView
                              ? PosterExploreMapView(
                                  fixers: state.fixersWithLocation,
                                  posterLocation: state.posterLocation,
                                )
                              : PosterExploreListView(
                                  fixers: state.filteredFixers,
                                  posterLocation: state.posterLocation,
                                ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  ///  Shimmer placeholder list
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
