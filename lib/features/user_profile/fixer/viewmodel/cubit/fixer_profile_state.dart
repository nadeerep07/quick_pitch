part of 'fixer_profile_cubit.dart';

sealed class FixerProfileState extends Equatable {
  const FixerProfileState();

  @override
  List<Object?> get props => [];
}

final class FixerProfileInitial extends FixerProfileState {}
final class FixerProfileLoading extends FixerProfileState{}
final class FixerProfileLoaded extends FixerProfileState {
  final UserProfileModel fixerProfile;

  const FixerProfileLoaded(this.fixerProfile);

  @override
  List<Object?> get props => [fixerProfile];
}class FixerProfileUpdated extends FixerProfileState {
  final String? coverImageUrl;
  final String? profileImageUrl;

  const FixerProfileUpdated({this.coverImageUrl, this.profileImageUrl});

  @override
  List<Object?> get props => [coverImageUrl, profileImageUrl];
}

final class FixerProfileError extends FixerProfileState{
  final String message;
  const FixerProfileError({required this.message});
}
final class FixerProfileUpdatingImage extends FixerProfileState {
  final UserProfileModel fixerProfile;

  const FixerProfileUpdatingImage(this.fixerProfile);

  @override
  List<Object?> get props => [fixerProfile];
}

