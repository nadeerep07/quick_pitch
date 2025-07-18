part of 'fixer_home_cubit.dart';


sealed class FixerHomeState {}

final class FixerHomeInitial extends FixerHomeState {}

final class FixerHomeLoading extends FixerHomeState {}


class FixerHomeLoaded extends FixerHomeState {
    final String? profileImageUrl;
  final String name;
  final String role;
  final List<TaskPostModel> newTasks;
  final Map<String, dynamic> fixerProfile;
  

  FixerHomeLoaded({
    this.profileImageUrl,
    required this.name,
    required this.role,
    required this.newTasks,
    required this.fixerProfile,
    // required this.activeTasks,
  });
}

class FixerHomeError extends FixerHomeState {
  final String message;
  FixerHomeError(this.message);
}