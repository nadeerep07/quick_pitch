import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/poster_explore_map_view.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/main_widget/view_toggle_switch.dart';

class PosterExploreMapContent extends StatelessWidget {
  final PosterExploreLoaded state;

  const PosterExploreMapContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Map
          PosterExploreMapView(
            fixers: state.fixersWithLocation,
            posterLocation: state.posterLocation,
          ),

          // Header overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + res.hp(1),
                left: res.wp(5),
                right: res.wp(5),
                bottom: res.hp(2),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Map View',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ViewToggleSwitch(
                    isMapView: state.isMapView,
                    onToggle: (_) => context.read<PosterExploreCubit>().toggleMapView(),
                  ),
                ],
              ),
            ),
          ),

          // // Filters overlay
          // if (state.query.isNotEmpty || state.selectedSkills.isNotEmpty)
          //   Positioned(
          //     bottom: res.hp(2),
          //     left: res.wp(5),
          //     right: res.wp(5),
          //     child: Container(
          //       padding: EdgeInsets.all(res.wp(4)),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(15),
          //         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
          //       ),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Active Filters', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          //           SizedBox(height: res.hp(1)),
          //           if (state.query.isNotEmpty) Text('Search: "${state.query}"'),
          //           if (state.selectedSkills.isNotEmpty) Text('Skills: ${state.selectedSkills.join(", ")}'),
          //           SizedBox(height: res.hp(1)),
          //           TextButton.icon(
          //             onPressed: () => context.read<PosterExploreCubit>().clearFilters(),
          //             icon: const Icon(Icons.clear),
          //             label: const Text('Clear Filters'),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
