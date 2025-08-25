import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'poster_explore_map_state.dart';

class PosterExploreMapCubit extends Cubit<PosterExploreMapState> {
  GoogleMapController? _mapController;

  PosterExploreMapCubit() : super(const PosterExploreMapInitial());

  void initializeMap({
    required List<UserProfileModel> fixers,
    required Position? posterLocation,
  }) {
    try {
      emit(const PosterExploreMapLoading());

      final initialPosition = _getInitialPosition(fixers, posterLocation);
      final markers = _createMarkers(fixers, posterLocation);

      emit(PosterExploreMapLoaded(
        markers: markers,
        initialPosition: initialPosition,
        fixers: fixers,
        posterLocation: posterLocation,
      ));
    } catch (e) {
      emit(PosterExploreMapError('Failed to initialize map: ${e.toString()}'));
    }
  }

  void updateFixers(List<UserProfileModel> fixers, Position? posterLocation) {
    final currentState = state;
    if (currentState is PosterExploreMapLoaded) {
      try {
        final markers = _createMarkers(fixers, posterLocation);
        emit(currentState.copyWith(
          markers: markers,
          fixers: fixers,
          posterLocation: posterLocation,
        ));
      } catch (e) {
        emit(PosterExploreMapError('Failed to update fixers: ${e.toString()}'));
      }
    }
  }

  void selectFixer(UserProfileModel fixer) {
    final currentState = state;
    if (currentState is PosterExploreMapLoaded) {
      emit(currentState.copyWith(selectedFixer: fixer));
    }
  }

  void clearSelectedFixer() {
    final currentState = state;
    if (currentState is PosterExploreMapLoaded) {
      emit(currentState.copyWith(clearSelectedFixer: true));
    }
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void animateToLocation(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newLatLng(location));
  }

  void animateToMyLocation(Position? posterLocation) {
    if (posterLocation != null) {
      animateToLocation(LatLng(posterLocation.latitude, posterLocation.longitude));
    }
  }

  void zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  LatLng _getInitialPosition(List<UserProfileModel> fixers, Position? posterLocation) {
    if (posterLocation != null) {
      return LatLng(posterLocation.latitude, posterLocation.longitude);
    }
    
    if (fixers.isNotEmpty) {
      final firstFixerWithLocation = fixers.firstWhere(
        (fixer) => fixer.fixerData?.latitude != null && 
                   fixer.fixerData?.longitude != null &&
                   fixer.fixerData!.latitude != 0.0 &&
                   fixer.fixerData!.longitude != 0.0,
        orElse: () => fixers.first,
      );
      
      if (firstFixerWithLocation.fixerData?.latitude != null &&
          firstFixerWithLocation.fixerData?.longitude != null) {
        return LatLng(
          firstFixerWithLocation.fixerData!.latitude,
          firstFixerWithLocation.fixerData!.longitude,
        );
      }
    }
    
    // Default to Kozhikode
    return const LatLng(11.2588, 75.7804);
  }

  Set<Marker> _createMarkers(List<UserProfileModel> fixers, Position? posterLocation) {
    final markers = <Marker>{};

    // Add poster location marker
    if (posterLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('poster_location'),
          position: LatLng(posterLocation.latitude, posterLocation.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
        ),
      );
    }

    // Add fixer markers
    for (int i = 0; i < fixers.length; i++) {
      final fixer = fixers[i];
      if (_isValidLocation(fixer)) {
        markers.add(
          Marker(
            markerId: MarkerId('fixer_${fixer.uid}'),
            position: LatLng(
              fixer.fixerData!.latitude,
              fixer.fixerData!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: fixer.name,
              snippet: fixer.fixerData?.skills?.take(2).join(', ') ?? '',
            ),
            onTap: () => selectFixer(fixer),
          ),
        );
      }
    }

    return markers;
  }

  bool _isValidLocation(UserProfileModel fixer) {
    return fixer.fixerData?.latitude != null && 
           fixer.fixerData?.longitude != null &&
           fixer.fixerData!.latitude != 0.0 &&
           fixer.fixerData!.longitude != 0.0;
  }

  @override
  Future<void> close() {
    _mapController?.dispose();
    return super.close();
  }
}