part of 'fixer_home_cubit.dart';


sealed class FixerHomeState {}

final class FixerHomeInitial extends FixerHomeState {}

final class FixerHomeLoading extends FixerHomeState {}


class FixerHomeLoaded extends FixerHomeState {
  final UserProfileModel userProfile;
  final List<TaskPostModel> newTasks;

  

  FixerHomeLoaded({
    required this.userProfile,
    required this.newTasks,
    
    // required this.activeTasks,
  });
}

class FixerHomeError extends FixerHomeState {
  final String message;
  FixerHomeError(this.message);
}