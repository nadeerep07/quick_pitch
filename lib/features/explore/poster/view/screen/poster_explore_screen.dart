import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/service/poster_explore_service.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_error_view.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_list_content.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_loading_view.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_map_content.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';

class PosterExploreScreen extends StatelessWidget {
  const PosterExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PosterExploreCubit(
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<PosterExploreCubit, PosterExploreState>(
        builder: (context, state) {
          if (state is PosterExploreLoaded && state.isMapView) {
            return PosterExploreMapContent(state: state);
          }
          if (state is PosterExploreLoading) {
            return const PosterExploreLoadingView();
          }
          if (state is PosterExploreError) {
            return PosterExploreErrorView(message: state.message);
          }
          if (state is PosterExploreLoaded) {
            return PosterExploreListContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
