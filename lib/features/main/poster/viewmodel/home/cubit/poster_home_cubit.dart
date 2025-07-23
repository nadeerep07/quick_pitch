import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/main/poster/repository/poster_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

part 'poster_home_state.dart';

class PosterHomeCubit extends Cubit<PosterHomeState> {
  final PosterRepository repository;
  PosterHomeCubit(this.repository) : super(PosterHomeInitial());
Future<void> fetchPosterHomeData() async {
  emit(PosterHomeLoading());
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final userData = await repository.getUserDetails();
    if (userData == null) throw Exception("User data not found");

  

    final tasks = await repository.getTasksByUser(user.uid);

    emit(PosterHomeLoaded(
    userProfile: userData,
      tasks: tasks,
      fixers: [],
    ));
        final fixers = await repository.fetchRecommendedFixers();

    // Emit combined updated state
    final currentState = state;
    if (currentState is PosterHomeLoaded) {
      emit(currentState.copyWith(fixers: fixers));
    }

  } catch (e) {
    emit(PosterHomeError('Failed to load home data: ${e.toString()}'));
  }
}

}
