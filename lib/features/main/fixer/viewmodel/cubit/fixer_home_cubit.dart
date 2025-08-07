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


        emit(FixerHomeLoaded(
          userProfile: userProfile,
          newTasks: newTasks,
          activeTasks: activeTasks,
          completedTasks: completedTasks,
        ));
      });
    } catch (e) {
      emit(FixerHomeError("Failed to load tasks: ${e.toString()}"));
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
