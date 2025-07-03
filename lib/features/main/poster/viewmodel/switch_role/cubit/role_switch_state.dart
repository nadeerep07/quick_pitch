part of 'role_switch_cubit.dart';

@immutable
sealed class RoleSwitchState {}

final class RoleSwitchInitial extends RoleSwitchState {}

class RoleSwitchLoading extends RoleSwitchState {}

class RoleSwitchSuccess extends RoleSwitchState {
  final String newRole;
  RoleSwitchSuccess(this.newRole);
}

class RoleSwitchIncompleteProfile extends RoleSwitchState {
  final String missingRole;
  RoleSwitchIncompleteProfile(this.missingRole);
}

class RoleSwitchError extends RoleSwitchState {
  final String message;
  RoleSwitchError(this.message);
}