import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';

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
Future<List<TaskPostModel>> getTasksByUser(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('poster_tasks')
      .where('posterId', isEqualTo: userId)
      .get();

  return snapshot.docs.map((doc) => TaskPostModel.fromMap(doc.data())).toList();
}


}