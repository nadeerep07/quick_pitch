import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/explore_map/custom_mark_painter.dart';

class MarkerHelper {
  static Future<Set<Marker>> generateMarkers({
    required List<UserProfileModel> fixers,
    required Position? posterLocation,
    required Function(UserProfileModel) onFixerTap,
  }) async {
    final markers = <Marker>{};

    if (posterLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(posterLocation.latitude, posterLocation.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    for (final fixer in fixers) {
      if (fixer.fixerData?.latitude != null &&
          fixer.fixerData?.longitude != null &&
          fixer.fixerData!.latitude != 0.0 &&
          fixer.fixerData!.longitude != 0.0) {
        final certificateColor = MarkerGenerator.getCertificateStatusColor(
          fixer.fixerData?.certificateStatus,
        );

        final customMarker = await MarkerGenerator.createCustomMarker(
          fixer: fixer,
          certificateColor: certificateColor,
        );

        markers.add(
          Marker(
            markerId: MarkerId('fixer_${fixer.uid}'),
            position: LatLng(fixer.fixerData!.latitude, fixer.fixerData!.longitude),
            icon: customMarker,
            onTap: () => onFixerTap(fixer),
          ),
        );
      }
    }

    return markers;
  }
}
