import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/fixer_count_badge.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/google_map_widget.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/map_loading_overlay.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/recenter_button.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_bottom_sheet/fixer-detail_bottom_sheet.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/poster_explore_map/cubit/poster_explore_map_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';


class PosterExploreMapView extends StatelessWidget {
  final List<UserProfileModel> fixers;
  final Position? posterLocation;

  const PosterExploreMapView({
    super.key,
    required this.fixers,
    this.posterLocation,
  });

  void _showFixerDetails(BuildContext context, UserProfileModel fixer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FixerDetailsBottomSheet(
        fixer: fixer,
        posterLocation: posterLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return BlocProvider(
      create: (_) => PosterExploreMapCubit()
        ..loadMarkers(
          fixers: fixers,
          posterLocation: posterLocation,
          onFixerTap: (fixer) => _showFixerDetails(context, fixer),
        ),
      child: BlocBuilder<PosterExploreMapCubit, PosterExploreMapState>(
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMapWidget(
                controller: state.controller,
                posterLocation: posterLocation,
                fixers: fixers,
                markers: state.markers,
                onMapCreated: (controller) {
                  context.read<PosterExploreMapCubit>().setMapController(controller);
                },
              ),

              if (state.isLoading) const MapLoadingOverlay(),

              Positioned(
                top: res.hp(2),
                right: res.wp(4),
                child: FixerCountBadge(count: fixers.length),
              ),

              Positioned(
                bottom: res.hp(12),
                right: res.wp(4),
                child: RecenterButton(
                  controller: state.controller,
                  posterLocation: posterLocation,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
