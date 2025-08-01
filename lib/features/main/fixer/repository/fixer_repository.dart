import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerRepository {
  Future<List<TaskPostModel>> fetchCategoryMatchedTasks() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("Fixer not logged in");

      final fixerRoleDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('roles')
              .doc('fixer')
              .get();

      if (!fixerRoleDoc.exists) throw Exception("Fixer role data not found");
      final data = fixerRoleDoc.data();

      final fixerSkillCategories = List<String>.from(
        data?['fixerData']?['skills'] ?? [],
      );

      // print("[FixerRepo] Fixer Skill Categories: $fixerSkillCategories");

      if (fixerSkillCategories.isEmpty) return [];

      final tasksSnapshot =
          await FirebaseFirestore.instance
              .collection('poster_tasks')
              .where('assignedFixerId', isEqualTo: null)
              .where('status', isEqualTo: 'pending')
              .orderBy('createdAt', descending: true)
              .get();

      //  print("[FixerRepo] Total tasks fetched: ${tasksSnapshot.docs.length}");

      final allTasks =
          tasksSnapshot.docs
              .map((doc) => TaskPostModel.fromMap(doc.data()))
              .toList();

      // for (final task in allTasks) {
      //  print("[FixerRepo] Task title: ${task.title}, category: ${task.skills}");
      // }

      final filtered =
          allTasks.where((task) {
            final taskSkills =
                task.skills.map((s) => s.toLowerCase().trim()).toSet();
            final fixerSkills =
                fixerSkillCategories.map((s) => s.toLowerCase().trim()).toSet();

            return taskSkills.intersection(fixerSkills).isNotEmpty;
          }).toList();

      // print("[FixerRepo] Filtered tasks count: ${filtered.length}");

      return filtered;
    } catch (e) {
      //  print("[FixerRepo] Error: $e");
      rethrow;
    }
  }

  Future<UserProfileModel> fetchFixerProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print('[FixerRepo] Fetching profile for UID: $uid');

    if (uid == null) throw Exception("Fixer not logged in");

    final fixerDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('roles')
            .doc('fixer')
            .get();

    if (!fixerDoc.exists) {
      print('[FixerRepo] Fixer profile not found!');
      throw Exception("Fixer profile not found");
    }

    final data = fixerDoc.data()!;
    // print('[FixerRepo] Fetched profile data: $data');

    final userProfile = UserProfileModel.fromJson(data);
    return userProfile;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fixerProfileStream(
    String uid,
  ) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc('fixer')
        .snapshots(); // listens to real-time changes
  }
}
