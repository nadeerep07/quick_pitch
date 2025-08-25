import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/error_view.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/map_view/fixer_bottom_sheet.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/map_content.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/poster_explore_map/cubit/poster_explore_map_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/poster_explore_map/cubit/poster_explore_map_state.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';


class PosterExploreMapView extends StatelessWidget {
  final List<UserProfileModel> fixers;
  final Position? posterLocation;

  const PosterExploreMapView({
    super.key,
    required this.fixers,
    required this.posterLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PosterExploreMapCubit()
        ..initializeMap(fixers: fixers, posterLocation: posterLocation),
      child: Scaffold(
        body: BlocConsumer<PosterExploreMapCubit, PosterExploreMapState>(
          listener: (context, state) {
            if (state is PosterExploreMapError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red[600],
                ),
              );
            } else if (state is PosterExploreMapLoaded &&
                state.selectedFixer != null) {
              _showFixerBottomSheet(context, state.selectedFixer!, state.posterLocation);
            }
          },
          builder: (context, state) {
            if (state is PosterExploreMapLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PosterExploreMapError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<PosterExploreMapCubit>()
                    .initializeMap(fixers: fixers, posterLocation: posterLocation);
                },
              );
            } else if (state is PosterExploreMapLoaded) {
              return MapContent(state: state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showFixerBottomSheet(
    BuildContext context,
    UserProfileModel fixer,
    Position? posterLocation,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FixerBottomSheet(
        fixer: fixer,
        posterLocation: posterLocation,
        onViewProfile: () {
          Navigator.pop(context);
          // Navigate to profile screen
        },
      ),
    ).then((_) {
      context.read<PosterExploreMapCubit>().clearSelectedFixer();
    });
  }
}
