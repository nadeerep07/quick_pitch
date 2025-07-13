import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quick_pitch_app/features/main/fixer/repository/fixer_repository.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';

part 'fixer_home_state.dart';

class FixerHomeCubit extends Cubit<FixerHomeState> {

  final FixerRepository _fixerRepository ;
  FixerHomeCubit(this._fixerRepository, ) : super(FixerHomeInitial());

  Future<void> loadFixerHomeData(String fixerId) async {
    emit(FixerHomeLoading());

    try {
     final profileData = await _fixerRepository.fetchFixerProfile();

      final newTasks = await _fixerRepository.fetchCategoryMatchedTasks();
      // final activeTasks = await _fixerRepository.fetchFixerTasks(fixerId);

      emit(FixerHomeLoaded(
        profileImageUrl: profileData['profileImageUrl'] as String?,
        name: profileData['name'] as String,
        role: profileData['role'] as String,
        newTasks: newTasks,
        fixerProfile: profileData,
        // activeTasks: activeTasks,
      ));
    //  print("[FixerHomeCubit] Loaded tasks: ${profileData['name']} - ${newTasks.length} tasks found");
    } catch (e) {
      emit(FixerHomeError("Failed to load tasks: ${e.toString()}"));
    }
  }
}
