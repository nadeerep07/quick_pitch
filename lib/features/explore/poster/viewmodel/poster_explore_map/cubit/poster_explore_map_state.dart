import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

abstract class PosterExploreMapState extends Equatable {
  const PosterExploreMapState();

  @override
  List<Object?> get props => [];
}

class PosterExploreMapInitial extends PosterExploreMapState {
  const PosterExploreMapInitial();
}

class PosterExploreMapLoading extends PosterExploreMapState {
  const PosterExploreMapLoading();
}

class PosterExploreMapLoaded extends PosterExploreMapState {
  final Set<Marker> markers;
  final LatLng initialPosition;
  final List<UserProfileModel> fixers;
  final Position? posterLocation;
  final UserProfileModel? selectedFixer;

  const PosterExploreMapLoaded({
    required this.markers,
    required this.initialPosition,
    required this.fixers,
    this.posterLocation,
    this.selectedFixer,
  });

  PosterExploreMapLoaded copyWith({
    Set<Marker>? markers,
    LatLng? initialPosition,
    List<UserProfileModel>? fixers,
    Position? posterLocation,
    UserProfileModel? selectedFixer,
    bool clearSelectedFixer = false,
  }) {
    return PosterExploreMapLoaded(
      markers: markers ?? this.markers,
      initialPosition: initialPosition ?? this.initialPosition,
      fixers: fixers ?? this.fixers,
      posterLocation: posterLocation ?? this.posterLocation,
      selectedFixer: clearSelectedFixer ? null : (selectedFixer ?? this.selectedFixer),
    );
  }

  @override
  List<Object?> get props => [markers, initialPosition, fixers, posterLocation, selectedFixer];
}

class PosterExploreMapError extends PosterExploreMapState {
  final String message;

  const PosterExploreMapError(this.message);

  @override
  List<Object?> get props => [message];
}
