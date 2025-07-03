import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PosterRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;


  Future<Map<String, dynamic>?> getUserDetails() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await fireStore.collection('users').doc(uid).get();
    final data = doc.data();

    // print("Fetched user data: $data");
    return data;
  }


}