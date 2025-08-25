import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/main/view_toggle_button.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';

class ExploreAppBar extends StatelessWidget {
  final PosterExploreLoaded state;

  const ExploreAppBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Title and count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find Fixers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  '${state.filteredFixers.length} available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ViewToggleButton(
            isMapView: state.isMapView,
            onToggle: () => context.read<PosterExploreCubit>().toggleMapView(),
          ),
        ],
      ),
    );
  }
}
