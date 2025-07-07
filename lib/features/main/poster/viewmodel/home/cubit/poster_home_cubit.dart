import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/main/poster/repository/poster_repository.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';

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

    final imageUrl = userData['profileImageUrl'] as String?;
    final name = userData['name'] as String;
    final role = userData['activeRole'] as String;

    final tasks = await repository.getTasksByUser(user.uid);

    emit(PosterHomeLoaded(
      profileImageUrl: imageUrl,
      name: name,
      role: role,
      tasks: tasks,
    ));
  } catch (e) {
    emit(PosterHomeError('Failed to load home data: ${e.toString()}'));
  }
}

}
