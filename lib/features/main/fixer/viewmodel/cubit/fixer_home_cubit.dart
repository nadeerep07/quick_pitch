import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quick_pitch_app/features/main/fixer/repository/fixer_repository.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

part 'fixer_home_state.dart';

class FixerHomeCubit extends Cubit<FixerHomeState> {
  final FixerRepository _fixerRepository;
  StreamSubscription? _profileSub;

  FixerHomeCubit(this._fixerRepository) : super(FixerHomeInitial());

  Future<void> loadFixerHomeData(String fixerId) async {
    emit(FixerHomeLoading());

    try {
      _profileSub?.cancel(); // avoid memory leaks on repeated calls

      _profileSub = _fixerRepository.fixerProfileStream(fixerId).listen((snapshot) async {
        if (!snapshot.exists) {
          emit(FixerHomeError("Profile not found"));
          return;
        }

        final profileData = snapshot.data()!;
        final userProfile = UserProfileModel.fromJson(profileData);
        final newTasks = await _fixerRepository.fetchCategoryMatchedTasks();
        final activeTasks = await _fixerRepository.fetchActiveTasks(fixerId);
        final completedTasks = await _fixerRepository.fetchCompletedTasks(fixerId);
        
        // Load earnings data
        final totalEarnings = await _loadEarnings(fixerId);

        emit(FixerHomeLoaded(
          userProfile: userProfile,
          newTasks: newTasks,
          activeTasks: activeTasks,
          completedTasks: completedTasks,
          totalEarnings: totalEarnings, // Add earnings to state
        ));
      });
    } catch (e) {
      emit(FixerHomeError("Failed to load tasks: ${e.toString()}"));
    }
  }

  // Add this method to load earnings
  Future<double> _loadEarnings(String fixerId) async {
    try {
      // Use the repository method to fetch earnings
      // If your repository doesn't have this method, we'll add it
      final totalEarnings = await _fixerRepository.fetchTotalEarnings(fixerId);
      return totalEarnings;
    } catch (e) {
      print('Error loading earnings: $e');
      return 0.0; // Return 0 if there's an error
    }
  }

  // Method to refresh just earnings without reloading everything
  Future<void> refreshEarnings(String fixerId) async {
    final currentState = state;
    if (currentState is FixerHomeLoaded) {
      try {
        final totalEarnings = await _loadEarnings(fixerId);
        emit(currentState.copyWith(totalEarnings: totalEarnings));
      } catch (e) {
        // Keep current earnings if refresh fails
        print('Failed to refresh earnings: $e');
      }
    }
  }

  @override
  Future<void> close() {
    _profileSub?.cancel();
    return super.close();
  }

  void toggleFilter(String filter) {
    if (state is FixerHomeLoaded) {
      final current = state as FixerHomeLoaded;
      final filters = List<String>.from(current.selectedFilters);

      if (filter == 'All Tasks') {
        filters.clear();
      } else {
        if (filters.contains(filter)) {
          filters.remove(filter);
        } else {
          filters.add(filter);
        }
      }

      emit(current.copyWith(selectedFilters: filters));
    }
  }

  List<TaskPostModel> getFilteredTasks() {
    if (state is FixerHomeLoaded) {
      final current = state as FixerHomeLoaded;

      if (current.selectedFilters.isEmpty) {
        return current.newTasks;
      }

      return current.newTasks.where((task) {
        return current.selectedFilters.any((skill) => task.skills.contains(skill));
      }).toList();
    }
    return [];
  }
}