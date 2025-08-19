import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreCubit extends Cubit<PosterExploreState> {
  final PosterExploreRepository _repository;
  Timer? _debounceTimer;

  PosterExploreCubit({required PosterExploreRepository repository})
      : _repository = repository,
        super(const PosterExploreInitial());

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> load() async {
    emit(const PosterExploreLoading());
    
    try {
      final results = await Future.wait([
        _repository.fetchFixers(),
        _repository.fetchAdminSkills(),
        _repository.getCurrentPositionWithFallback(),
      ]);

      final fixers = results[0] as List<UserProfileModel>;
      final skills = results[1] as List<String>;
      final position = results[2] as Position?;

      emit(PosterExploreLoaded(
        allFixers: fixers,
        filteredFixers: fixers,
        skills: skills,
        selectedSkills: const [],
        query: '',
        nearbyEnabled: false,
        radiusKm: 15.0,
        posterLocation: position,
      ));
    } catch (e) {
      emit(PosterExploreError('Failed to load data: ${e.toString()}'));
    }
  }

  void updateSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final currentState = state;
      if (currentState is PosterExploreLoaded) {
        final filtered = _applyFilters(
          fixers: currentState.allFixers,
          query: query, 
          selectedSkills: currentState.selectedSkills,
          nearbyEnabled: currentState.nearbyEnabled,
          radiusKm: currentState.radiusKm,
          posterLocation: currentState.posterLocation,
        );

        emit(currentState.copyWith(
          query: query,
          filteredFixers: filtered,
        ));
      }
    });
  }

  void toggleSkill(String skill) {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      final selectedSkills = List<String>.from(currentState.selectedSkills);
      
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }

      final filtered = _applyFilters(
        fixers: currentState.allFixers,
        query: currentState.query,
        selectedSkills: selectedSkills,
        nearbyEnabled: currentState.nearbyEnabled,
        radiusKm: currentState.radiusKm,
        posterLocation: currentState.posterLocation,
      );

      emit(currentState.copyWith(
        selectedSkills: selectedSkills,
        filteredFixers: filtered,
      ));
    }
  }

  void clearFilters() {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      emit(currentState.copyWith(
        query: '',
        selectedSkills: const [],
        nearbyEnabled: false,
        filteredFixers: currentState.allFixers,
      ));
    }
  }

  void setNearbyRadius(double radiusKm) {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      final filtered = _applyFilters(
        fixers: currentState.allFixers,
        query: currentState.query,
        selectedSkills: currentState.selectedSkills,
        nearbyEnabled: currentState.nearbyEnabled,
        radiusKm: radiusKm,
        posterLocation: currentState.posterLocation,
      );

      emit(currentState.copyWith(
        radiusKm: radiusKm,
        filteredFixers: filtered,
      ));
    }
  }

  void toggleNearby(bool enabled) {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      final filtered = _applyFilters(
        fixers: currentState.allFixers,
        query: currentState.query,
        selectedSkills: currentState.selectedSkills,
        nearbyEnabled: enabled,
        radiusKm: currentState.radiusKm,
        posterLocation: currentState.posterLocation,
      );

      emit(currentState.copyWith(
        nearbyEnabled: enabled,
        filteredFixers: filtered,
      ));
    }
  }

  Future<void> refreshLocation() async {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      try {
        final position = await _repository.getCurrentPositionWithFallback();
        
        final filtered = _applyFilters(
          fixers: currentState.allFixers,
          query: currentState.query,
          selectedSkills: currentState.selectedSkills,
          nearbyEnabled: currentState.nearbyEnabled,
          radiusKm: currentState.radiusKm,
          posterLocation: position,
        );

        emit(currentState.copyWith(
          posterLocation: position,
          filteredFixers: filtered,
        ));
      } catch (e) {
        // Handle location refresh error silently or show a snackbar
      }
    }
  }

  List<UserProfileModel> _applyFilters({
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
            ?.any((skill) => skill.toLowerCase().contains(queryLower)) ?? false;
        
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

      // Sort by distance if nearby is enabled
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
