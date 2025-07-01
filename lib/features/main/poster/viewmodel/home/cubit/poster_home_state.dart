part of 'poster_home_cubit.dart';


sealed class PosterHomeState {}

final class PosterHomeInitial extends PosterHomeState {}

class PosterHomeLoading extends PosterHomeState{}

class PosterHomeLoaded extends PosterHomeState{
  final String? profileImageUrl;
  final String name;
  final String role;
  PosterHomeLoaded({required this.profileImageUrl,required this.name,required this.role});
}

class PosterHomeError extends PosterHomeState {
  final String message;
  PosterHomeError(this.message);
}