import 'package:bloc/bloc.dart';
import 'package:quick_pitch_app/features/main/fixer/repository/fixer_repository.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

part 'fixer_home_state.dart';

class FixerHomeCubit extends Cubit<FixerHomeState> {
  final FixerRepository _fixerRepository;
  FixerHomeCubit(this._fixerRepository) : super(FixerHomeInitial());

  Future<void> loadFixerHomeData(String fixerId) async {
    emit(FixerHomeLoading());

    try {
      final profileData = await _fixerRepository.fetchFixerProfile();
      //  print("[FixerHomeCubit] Final profileData: $profileData");

      final newTasks = await _fixerRepository.fetchCategoryMatchedTasks();
      // final activeTasks = await _fixerRepository.fetchFixerTasks(fixerId);

      emit(FixerHomeLoaded(userProfile: profileData, newTasks: newTasks));

      // print(
      //   "[FixerHomeCubit] Loaded tasks: ${profileData['userId']} - ${newTasks.length} tasks found",
      // );
    } catch (e) {
      //  print(e);
      emit(FixerHomeError("Failed to load tasks: ${e.toString()}"));
    }
  }
}
