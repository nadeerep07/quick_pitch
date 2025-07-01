import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading(AuthLoadingType.signup));
      try {
        final user = await authRepository.createAccount(
          event.email,
          event.password,
        );
        await user.sendEmailVerification();
        emit(AuthSuccess(event.email));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    //checking for role selcted or not
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading(AuthLoadingType.emailPassword));
      try {
        final user = await authRepository.signIn(event.email, event.password);
        final isVerified = await authRepository.isEmailVerified(user);
        if (!isVerified) {
          await user.sendEmailVerification();
          emit(UnverifiedEmail(email: event.email));
          return;
        }

        final doc = await authRepository.getUserDoc(user.uid);

        if (doc.exists && doc.data()!['role'] != null) {
          final role = doc.data()!['role'];
          emit(AuthRoleIdentified(role: role));
        } else {
          emit(AuthSuccess(event.email)); // No role → SelectRoleScreen
        }
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

    //checking for role selcted or not
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading(AuthLoadingType.google));
      try {
        final user = await authRepository.signInWithGoogle();

        final doc = await authRepository.getUserDoc(user.uid);
        if (doc.exists && doc.data()!['role'] != null) {
          final role = doc.data()!['role'];
          emit(AuthRoleIdentified(role: role));
        } else {
          emit(AuthSuccess(user.email ?? ''));
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
