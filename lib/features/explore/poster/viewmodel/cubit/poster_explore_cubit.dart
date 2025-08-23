import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/explore/poster/service/poster_explore_service.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_state.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreCubit extends Cubit<PosterExploreState> {
  final PosterExploreService _service;
  Timer? _debounceTimer;
  final Map<String, List<FixerWork>> _fixerWorksCache = {};

  PosterExploreCubit({required PosterExploreService service})
      : _service = service,
        super(const PosterExploreInitial());

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> load() async {
    emit(const PosterExploreLoading());
    try {
      final results = await _service.loadInitialData();

      final fixers = results[0] as List<UserProfileModel>;
      final skills = results[1] as List<String>;
      final position = results[2] as Position?;

      // Pre-load works for first few fixers for better UX
      await _preloadFixerWorks(fixers.take(5).toList());

      emit(PosterExploreLoaded(
        allFixers: fixers,
        filteredFixers: fixers,
        skills: skills,
        selectedSkills: const [],
        query: '',
        nearbyEnabled: false,
        radiusKm: 15.0,
        posterLocation: position,
        isMapView: false,
        fixerWorks: Map.from(_fixerWorksCache),
      ));
    } catch (e) {
      emit(PosterExploreError('Failed to load data: ${e.toString()}'));
    }
  }

  Future<void> _preloadFixerWorks(List<UserProfileModel> fixers) async {
    for (final fixer in fixers) {
      try {
        final works = await _service.fetchFixerWorks(fixer.uid);
        _fixerWorksCache[fixer.uid] = works;
      } catch (e) {
        // Silent fail for works loading
        _fixerWorksCache[fixer.uid] = [];
      }
    }
  }

  Future<void> loadFixerWorks(String fixerId) async {
    if (_fixerWorksCache.containsKey(fixerId)) {
      return; // Already loaded
    }

    try {
      final works = await _service.fetchFixerWorks(fixerId);
      _fixerWorksCache[fixerId] = works;
      
      final currentState = state;
      if (currentState is PosterExploreLoaded) {
        emit(currentState.copyWith(
          fixerWorks: Map.from(_fixerWorksCache),
        ));
      }
    } catch (e) {
      _fixerWorksCache[fixerId] = [];
    }
  }

  List<FixerWork> getFixerWorks(String fixerId) {
    return _fixerWorksCache[fixerId] ?? [];
  }

  void toggleMapView() {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      emit(currentState.copyWith(isMapView: !currentState.isMapView));
    }
  }

  void updateSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final currentState = state;
      if (currentState is PosterExploreLoaded) {
        final filtered = _service.applyFilters(
          fixers: currentState.allFixers,
          query: query,
          selectedSkills: currentState.selectedSkills,
          nearbyEnabled: currentState.nearbyEnabled,
          radiusKm: currentState.radiusKm,
          posterLocation: currentState.posterLocation,
        );

        emit(currentState.copyWith(query: query, filteredFixers: filtered));
      }
    });
  }

  void toggleSkill(String skill) {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      final selectedSkills = List<String>.from(currentState.selectedSkills);

      selectedSkills.contains(skill)
          ? selectedSkills.remove(skill)
          : selectedSkills.add(skill);

      final filtered = _service.applyFilters(
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
      final filtered = _service.applyFilters(
        fixers: currentState.allFixers,
        query: currentState.query,
        selectedSkills: currentState.selectedSkills,
        nearbyEnabled: currentState.nearbyEnabled,
        radiusKm: radiusKm,
        posterLocation: currentState.posterLocation,
      );

      emit(currentState.copyWith(radiusKm: radiusKm, filteredFixers: filtered));
    }
  }

  void toggleNearby(bool enabled) {
    final currentState = state;
    if (currentState is PosterExploreLoaded) {
      final filtered = _service.applyFilters(
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
        final position = await _service.fetchCurrentPosition();

        final filtered = _service.applyFilters(
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
      } catch (_) {
        // handle silently
      }
    }
  }
}
