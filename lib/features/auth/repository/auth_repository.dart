import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthServices _authServices = AuthServices();

  Future<User> signIn(String email, String password) async {
    final credential = await _authServices.signIn(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      return user;
    } else {
      throw Exception("Login failed");
    }
  }

  Future<User> createAccount(String email, String password) async {
    final credential = await _authServices.createAccount(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      return user;
    } else {
      throw Exception("User creation failed");
    }
  }

  Future<void> forgetPassword(String email) {
    return _authServices.forgetPassword(email: email);
  }

  Future<User> signInWithGoogle() async {
    final credential = await _authServices.signInWithGoogle();
    final user = credential.user;
    if (user != null) {
      return user;
    } else {
      throw Exception("Google Sign-In failed");
    }
  }
    Future<bool> isEmailVerified(User user) async {
    await user.reload();
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

//get ui for exixting user
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Stream<User?> get userStream => _authServices.userChanges;
}
