import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

abstract class PosterExploreState {
  const PosterExploreState();
}

class PosterExploreInitial extends PosterExploreState {
  const PosterExploreInitial();
}

class PosterExploreLoading extends PosterExploreState {
  const PosterExploreLoading();
}

class PosterExploreLoaded extends PosterExploreState {
  final List<UserProfileModel> allFixers;
  final List<UserProfileModel> filteredFixers;
  final List<String> skills;
  final List<String> selectedSkills;
  final String query;
  final bool nearbyEnabled;
  final double radiusKm;
  final Position? posterLocation;
  final bool isLoadingMore;
  final bool isMapView;
  final Map<String, List<FixerWork>> fixerWorks; // New field

  const PosterExploreLoaded({
    required this.allFixers,
    required this.filteredFixers,
    required this.skills,
    required this.selectedSkills,
    required this.query,
    required this.nearbyEnabled,
    required this.radiusKm,
    this.posterLocation,
    this.isLoadingMore = false,
    this.isMapView = false,
    this.fixerWorks = const {}, // New field
  });

  PosterExploreLoaded copyWith({
    List<UserProfileModel>? allFixers,
    List<UserProfileModel>? filteredFixers,
    List<String>? skills,
    List<String>? selectedSkills,
    String? query,
    bool? nearbyEnabled,
    double? radiusKm,
    Position? posterLocation,
    bool? isLoadingMore,
    bool? isMapView,
    Map<String, List<FixerWork>>? fixerWorks,
  }) {
    return PosterExploreLoaded(
      allFixers: allFixers ?? this.allFixers,
      filteredFixers: filteredFixers ?? this.filteredFixers,
      skills: skills ?? this.skills,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      query: query ?? this.query,
      nearbyEnabled: nearbyEnabled ?? this.nearbyEnabled,
      radiusKm: radiusKm ?? this.radiusKm,
      posterLocation: posterLocation ?? this.posterLocation,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMapView: isMapView ?? this.isMapView,
      fixerWorks: fixerWorks ?? this.fixerWorks,
    );
  }

  List<UserProfileModel> get popularFixers => filteredFixers.take(10).toList();
  
  List<UserProfileModel> get nearbyFixers {
    if (!nearbyEnabled || posterLocation == null) return [];
    
    return filteredFixers
        .where((fixer) => 
            fixer.fixerData != null &&
            fixer.fixerData!.latitude != 0.0 &&
            fixer.fixerData!.longitude != 0.0)
        .map((fixer) {
      final distance = PosterExploreRepository.haversineKm(
        posterLocation!.latitude,
        posterLocation!.longitude,
        fixer.fixerData!.latitude,
        fixer.fixerData!.longitude,
      );
      return fixer.copyWith(
        fixerData: fixer.fixerData!.copyWith(distance: distance),
      );
    })
        .where((fixer) => fixer.fixerData!.distance! <= radiusKm)
        .toList()
      ..sort((a, b) => a.fixerData!.distance!.compareTo(b.fixerData!.distance!));
  }

  List<UserProfileModel> get fixersWithLocation {
    return filteredFixers
        .where((fixer) => 
            fixer.fixerData != null &&
            fixer.fixerData!.latitude != 0.0 &&
            fixer.fixerData!.longitude != 0.0)
        .toList();
  }

  // Get recent works for a fixer
  List<FixerWork> getFixerWorks(String fixerId) {
    return fixerWorks[fixerId] ?? [];
  }
}

class PosterExploreError extends PosterExploreState {
  final String message;
  const PosterExploreError(this.message);
}