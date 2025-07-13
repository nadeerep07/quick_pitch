import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/repository/task_post_repository.dart';

part 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskPostRepository repository;
  TaskDetailsCubit(this.repository) : super(TaskDetailLoading());

    Future<void> loadTaskById(String taskId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('poster_tasks').doc(taskId).get();
      if (doc.exists) {
        final task = TaskPostModel.fromMap(doc.data()!);
        emit(TaskDetailLoaded(task));
      } else {
        emit(TaskDetailError("Task not found"));
      }
    } catch (e) {
      emit(TaskDetailError("Failed to load task"));
    }
  }
 Future<void> fetchTaskById(String id) async {
  try {
    emit(TaskDetailLoading());
    final task = await repository.getTaskById(id);
    if (task != null) {
      emit(TaskDetailLoaded(task)); 
    } else {
      emit(TaskDetailError("Task not found")); 
    }
  } catch (e) {
    emit(TaskDetailError("Something went wrong"));
  }
}

}
