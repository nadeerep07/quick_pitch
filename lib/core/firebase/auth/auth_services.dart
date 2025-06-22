import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? get currentUser => firebaseAuth.currentUser;

    Stream<User?> get userChanges => firebaseAuth.authStateChanges();

    Future<UserCredential> signIn({
      required String email,
      required String password,
    }) async {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    Future<UserCredential> createAccount({
      required String email,
      required String password,
    }) async {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    Future<void> forgetPassword({
      required String email,
    }) async {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    }
}
