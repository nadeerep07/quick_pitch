import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class RecenterButton extends StatelessWidget {
  final GoogleMapController? controller;
  final Position? posterLocation;

  const RecenterButton({
    super.key,
    required this.controller,
    required this.posterLocation,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.white,
      onPressed: () {
        if (posterLocation != null && controller != null) {
          controller!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(posterLocation!.latitude, posterLocation!.longitude),
            ),
          );
        }
      },
      child: Icon(Icons.my_location, color: Colors.blue, size: res.sp(20)),
    );
  }
}
