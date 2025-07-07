part of 'poster_home_cubit.dart';


sealed class PosterHomeState {}

final class PosterHomeInitial extends PosterHomeState {}

class PosterHomeLoading extends PosterHomeState{}

class PosterHomeLoaded extends PosterHomeState {
  final String? profileImageUrl;
  final String name;
  final String role;
  final List<TaskPostModel> tasks;

  PosterHomeLoaded({
    this.profileImageUrl,
    required this.name,
    required this.role,
    required this.tasks,
  });
}



class PosterHomeError extends PosterHomeState {
  final String message;
  PosterHomeError(this.message);
}