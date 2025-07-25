import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/main/poster/repository/poster_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

part 'poster_home_state.dart';

class PosterHomeCubit extends Cubit<PosterHomeState> {
  final PosterRepository repository;
  StreamSubscription? _profileSub;
  StreamSubscription? _tasksSub;
  PosterHomeCubit(this.repository) : super(PosterHomeInitial());

  void streamPosterHomeData() async {
  emit(PosterHomeLoading());

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    emit(PosterHomeError("User not authenticated"));
    return;
  }

  UserProfileModel? profile;
  List<TaskPostModel>? tasks;
  List<UserProfileModel> fixers = [];

  void tryEmitLoaded() async {
    if (profile != null && tasks != null) {
      // update postIds inside posterData
      final postIds = tasks!.map((task) => task.id).toList();
      final updatedProfile = profile!.copyWith(
        posterData: profile!.posterData?.copyWith(postIds: postIds),
      );
      await repository.updateUserProfile(updatedProfile);

      // fetch fixers only once when everything is ready
      fixers = await repository.fetchRecommendedFixers();

      emit(PosterHomeLoaded(
        userProfile: updatedProfile,
        tasks: tasks!,
        fixers: fixers,
      ));
    }
  }

  _profileSub = repository.streamUserProfile(user.uid).listen((p) {
    if (p == null) {
      emit(PosterHomeError("User profile not found"));
    } else {
      profile = p;
      tryEmitLoaded();
    }
  });

  _tasksSub = repository.streamTasksByUser(user.uid).listen((t) {
    tasks = t;
    tryEmitLoaded();
  });
}


  @override
  Future<void> close() {
    _profileSub?.cancel();
    _tasksSub?.cancel();
    return super.close();
  }
}
