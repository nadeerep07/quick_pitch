part of 'profile_edit_cubit.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object?> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditLoading extends ProfileEditState {}

class ProfileEditLoaded extends ProfileEditState {
  final UserProfileModel profile;

  const ProfileEditLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileEditSuccess extends ProfileEditState {}

class ProfileEditError extends ProfileEditState {
  final String message;

  const ProfileEditError(this.message);

  @override
  List<Object?> get props => [message];
}
