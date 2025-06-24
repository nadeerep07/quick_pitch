part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email, password;
  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String email, password;
  SignUpRequested(this.email, this.password);
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

class GoogleSignInRequested extends AuthEvent{}
