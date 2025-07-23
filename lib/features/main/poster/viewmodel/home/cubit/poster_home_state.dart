part of 'poster_home_cubit.dart';


sealed class PosterHomeState {}

final class PosterHomeInitial extends PosterHomeState {}

class PosterHomeLoading extends PosterHomeState{}

class PosterHomeLoaded extends PosterHomeState {
 final UserProfileModel userProfile;
  final List<TaskPostModel> tasks;
  final List<UserProfileModel> fixers;

  PosterHomeLoaded({
    required this.userProfile,
    required this.tasks,
    required this.fixers,
  });

  PosterHomeLoaded copyWith({
    UserProfileModel? userProfile,
    List<TaskPostModel>? tasks,
    List<UserProfileModel>? fixers,
  }) {
    return PosterHomeLoaded(
      userProfile: userProfile ?? this.userProfile,
      tasks: tasks ?? this.tasks,
      fixers: fixers ?? this.fixers,
    );
  }
}



class PosterHomeError extends PosterHomeState {
  final String message;
  PosterHomeError(this.message);
}