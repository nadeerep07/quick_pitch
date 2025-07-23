import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    
    Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) {
    throw Exception("Google Sign-In aborted by user.");
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await firebaseAuth.signInWithCredential(credential);
}
Future<void> logout() async {
  await firebaseAuth.signOut();
  await GoogleSignIn().signOut(); 
}


}
