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

        emit(FixerHomeLoaded(
          userProfile: userProfile,
          newTasks: newTasks,
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
}
