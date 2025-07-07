part of 'task_post_cubit.dart';

@immutable
sealed class TaskPostState {}

final class TaskPostInitial extends TaskPostState {}

final class TaskPostLoading extends TaskPostState{}

final class TaskPostSuccess extends TaskPostState{}
final class TaskPostUpdated extends TaskPostState{
  
}

final class TaskPostError extends TaskPostState{
  final String message;
 TaskPostError( this.message);
}
