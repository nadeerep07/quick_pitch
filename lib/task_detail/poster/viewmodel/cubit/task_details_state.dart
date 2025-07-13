part of 'task_details_cubit.dart';

@immutable
sealed class TaskDetailsState {}

class TaskDetailLoading extends TaskDetailsState {}

class TaskDetailLoaded extends TaskDetailsState {
  final TaskPostModel task;
  TaskDetailLoaded(this.task);
}

class TaskDetailError extends TaskDetailsState {
  final String message;
  TaskDetailError(this.message);
}
