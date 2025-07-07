part of 'poster_home_cubit.dart';


sealed class PosterHomeState {}

final class PosterHomeInitial extends PosterHomeState {}

class PosterHomeLoading extends PosterHomeState{}

class PosterHomeLoaded extends PosterHomeState {
  final String? profileImageUrl;
  final String name;
  final String role;
  final List<TaskPostModel> tasks;
  final List<UserProfileModel> fixers;

  PosterHomeLoaded({
    required this.profileImageUrl,
    required this.name,
    required this.role,
    required this.tasks,
    required this.fixers,
  });

  PosterHomeLoaded copyWith({
    String? profileImageUrl,
    String? name,
    String? role,
    List<TaskPostModel>? tasks,
    List<UserProfileModel>? fixers,
  }) {
    return PosterHomeLoaded(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      name: name ?? this.name,
      role: role ?? this.role,
      tasks: tasks ?? this.tasks,
      fixers: fixers ?? this.fixers,
    );
  }
}



class PosterHomeError extends PosterHomeState {
  final String message;
  PosterHomeError(this.message);
}