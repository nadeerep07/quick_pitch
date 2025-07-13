import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class PosterRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserDetails() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await fireStore
            .collection('users')
            .doc(uid)
            .collection('roles')
            .doc('poster')
            .get();
    final data = doc.data();

    //  print("Fetched user data: $data");
    return data;
  }

  Future<List<TaskPostModel>> getTasksByUser(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('poster_tasks')
            .where('posterId', isEqualTo: userId)
            .get();

    return snapshot.docs
        .map((doc) => TaskPostModel.fromMap(doc.data()))
        .toList();
  }

  Future<List<UserProfileModel>> fetchRecommendedFixers() async {
final snapshot = await fireStore
    .collectionGroup('roles')
    .where('role', isEqualTo: 'fixer')
    .get();


    return snapshot.docs
        .map((doc) => UserProfileModel.fromJson(doc.data()))
        .toList();
  }
}
