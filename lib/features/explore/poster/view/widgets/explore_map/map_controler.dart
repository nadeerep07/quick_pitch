import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/control_button.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/poster_explore_map/cubit/poster_explore_map_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/poster_explore_map/cubit/poster_explore_map_state.dart';


class MapControls extends StatelessWidget {
  final PosterExploreMapLoaded state;

  const MapControls({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ControlButton(
          icon: Icons.my_location,
          color: AppColors.primary,
          onPressed: () {
            context.read<PosterExploreMapCubit>().animateToMyLocation(state.posterLocation);
          },
        ),
        const SizedBox(height: 8),
        ControlButton(
          icon: Icons.add,
          onPressed: () => context.read<PosterExploreMapCubit>().zoomIn(),
        ),
        const SizedBox(height: 8),
        ControlButton(
          icon: Icons.remove,
          onPressed: () => context.read<PosterExploreMapCubit>().zoomOut(),
        ),
      ],
    );
  }
}
