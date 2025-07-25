part of 'poster_profile_cubit.dart';

sealed class PosterProfileState extends Equatable {
  const PosterProfileState();

  @override
  List<Object?> get props => [];
}

final class PosterProfileInitial extends PosterProfileState {}
final class PosterProfileLoading extends PosterProfileState{}
final class PosterProfileLoaded extends PosterProfileState {
  final UserProfileModel posterProfile;

  const PosterProfileLoaded(this.posterProfile);

  @override
  List<Object?> get props => [posterProfile];
}class PosterProfileUpdated extends PosterProfileState {
  final String? coverImageUrl;
  final String? profileImageUrl;

  const PosterProfileUpdated({this.coverImageUrl, this.profileImageUrl});

  @override
  List<Object?> get props => [coverImageUrl, profileImageUrl];
}

final class PosterProfileError extends PosterProfileState{
  final String message;
  const PosterProfileError({required this.message});
}
final class PosterProfileUpdatingImage extends PosterProfileState {
  final UserProfileModel posterProfile;

  const PosterProfileUpdatingImage(this.posterProfile);

  @override
  List<Object?> get props => [posterProfile];
}

