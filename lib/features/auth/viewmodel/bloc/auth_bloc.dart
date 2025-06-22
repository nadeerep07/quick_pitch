import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signIn(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.createAccount(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      try {
        await authRepository.forgetPassword(event.email);
        emit(PasswordResetSent());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
