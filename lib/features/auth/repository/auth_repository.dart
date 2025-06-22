import 'package:quick_pitch_app/core/firebase/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthServices _authServices = AuthServices();

  Future<UserCredential> signIn(String email, String password) {
    return _authServices.signIn(email: email, password: password);
  }

  Future<UserCredential> createAccount(String email, String password) {
    return _authServices.createAccount(email: email, password: password);
  }

  Future<void> forgetPassword(String email) {
    return _authServices.forgetPassword(email: email);
  }

  Stream<User?> get userStream => _authServices.userChanges;
}
