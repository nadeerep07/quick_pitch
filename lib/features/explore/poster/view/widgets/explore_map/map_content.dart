import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/map_controler.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/poster_explore_map/cubit/poster_explore_map_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/poster_explore_map/cubit/poster_explore_map_state.dart';


class MapContent extends StatelessWidget {
  final PosterExploreMapLoaded state;

  const MapContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            context.read<PosterExploreMapCubit>().setMapController(controller);
          },
          initialCameraPosition: CameraPosition(
            target: state.initialPosition,
            zoom: 12,
          ),
          markers: state.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          buildingsEnabled: true,
          compassEnabled: true,
          mapType: MapType.normal,
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: MapControls(state: state),
        ),
      ],
    );
  }
}
