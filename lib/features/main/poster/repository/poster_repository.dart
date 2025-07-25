import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/main/poster/model/poster_data.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class PosterRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<UserProfileModel?> getUserDetails() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await fireStore
            .collection('users')
            .doc(uid)
            .collection('roles')
            .doc('poster')
            .get();

    final data = (doc.data());

    final userProfile = UserProfileModel.fromJson(data!);
    return userProfile;
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
    final snapshot =
        await fireStore
            .collectionGroup('roles')
            .where('role', isEqualTo: 'fixer')
            .get();

    return snapshot.docs
        .map((doc) => UserProfileModel.fromJson(doc.data()))
        .toList();
  }

  static Future<UserProfileModel> fetchUserProfile(String userId) async {
    // print('Fetching user profile for userId: $userId');

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('roles')
            .doc('fixer')
            .get();

    if (!doc.exists) {
      // print(' User document not found for userId: $userId');
      throw Exception('User document not found');
    }

    final data = doc.data() ?? {};
    //  print('User document data: $data');

    final userProfile = UserProfileModel.fromJson(data);
    // print('Parsed UserProfileModel: $userProfile');

    return userProfile;
  }

  // Future<List<String>> getPostIdsForPoster(String posterId) async {
  //   final querySnapshot =
  //       await fireStore
  //           .collection('tasks')
  //           .where('posterId', isEqualTo: posterId)
  //           .get();

  //   return querySnapshot.docs.map((doc) => doc.id).toList();
  // }

  Future<void> savePosterData(PosterData data, String uid, String role) async {
    await fireStore
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc(role)
        .set(data.toJson(), SetOptions(merge: true));
  }

  Future<void> updateUserProfile(UserProfileModel profile) async {
    await fireStore
        .collection('users')
        .doc(profile.uid)
        .collection('roles')
        .doc(profile.role)
        .update(profile.toRoleJson(),);
  }

  Stream<UserProfileModel?> streamUserProfile(String uid) {
    return fireStore.collection('users').doc(uid).collection('roles').doc('poster').snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserProfileModel.fromJson(snapshot.data()!);
    });
  }

  Stream<List<TaskPostModel>> streamTasksByUser(String userId) {
    return fireStore
        .collection('poster_tasks')
        .where('posterId', isEqualTo: userId)
        .snapshots()
        .map(
          (query) =>
              query.docs
                  .map((doc) => TaskPostModel.fromMap(doc.data()))
                  .toList(),
        );
  }
}
