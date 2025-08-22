import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class GoogleMapWidget extends StatelessWidget {
  final GoogleMapController? controller;
  final Position? posterLocation;
  final List<UserProfileModel> fixers;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const GoogleMapWidget({
    super.key,
    required this.controller,
    required this.posterLocation,
    required this.fixers,
    required this.markers,
    required this.onMapCreated,
  });

  LatLng _getInitialCameraPosition() {
    if (posterLocation != null) {
      return LatLng(posterLocation!.latitude, posterLocation!.longitude);
    }
    return const LatLng(19.0760, 72.8777); // Default Mumbai
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _getInitialCameraPosition(),
        zoom: 12.0,
      ),
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
    );
  }
}
