import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreService {
  final PosterExploreRepository _repository;

  PosterExploreService(this._repository);

  Future<List<dynamic>> loadInitialData() async {
    return Future.wait([
      _repository.fetchFixers(),
      _repository.fetchAdminSkills(),
      _repository.getCurrentPositionWithFallback(),
    ]);
  }

  Future<Position?> fetchCurrentPosition() async {
    return _repository.getCurrentPositionWithFallback();
  }

  Future<List<FixerWork>> fetchFixerWorks(String fixerId) async {
    return _repository.fetchFixerWorks(fixerId);
  }

  List<UserProfileModel> applyFilters({
    required List<UserProfileModel> fixers,
    required String query,
    required List<String> selectedSkills,
    required bool nearbyEnabled,
    required double radiusKm,
    Position? posterLocation,
  }) {
    var filtered = fixers.where((fixer) {
      // Text search filter
      if (query.isNotEmpty) {
        final queryLower = query.toLowerCase();
        final nameMatch = fixer.name.toLowerCase().contains(queryLower);
        final skillsMatch = fixer.fixerData?.skills
                ?.any((skill) => skill.toLowerCase().contains(queryLower)) ??
            false;

        if (!nameMatch && !skillsMatch) return false;
      }

      // Skills filter
      if (selectedSkills.isNotEmpty) {
        final fixerSkills = fixer.fixerData?.skills ?? [];
        final hasSelectedSkill = selectedSkills
            .any((selectedSkill) => fixerSkills.contains(selectedSkill));

        if (!hasSelectedSkill) return false;
      }

      return true;
    }).toList();

    // Nearby filter
    if (nearbyEnabled && posterLocation != null) {
      filtered = filtered.where((fixer) {
        if (fixer.fixerData?.latitude == null ||
            fixer.fixerData?.longitude == null ||
            fixer.fixerData!.latitude == 0.0 ||
            fixer.fixerData!.longitude == 0.0) {
          return false;
        }

        final distance = PosterExploreRepository.haversineKm(
          posterLocation.latitude,
          posterLocation.longitude,
          fixer.fixerData!.latitude,
          fixer.fixerData!.longitude,
        );

        return distance <= radiusKm;
      }).toList();

      // Sort by distance
      filtered.sort((a, b) {
        final distanceA = PosterExploreRepository.haversineKm(
          posterLocation.latitude,
          posterLocation.longitude,
          a.fixerData!.latitude,
          a.fixerData!.longitude,
        );
        final distanceB = PosterExploreRepository.haversineKm(
          posterLocation.latitude,
          posterLocation.longitude,
          b.fixerData!.latitude,
          b.fixerData!.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
    }

    return filtered;
  }
}