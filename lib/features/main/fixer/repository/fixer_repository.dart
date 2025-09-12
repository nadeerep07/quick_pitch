import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/main/fixer/service/fixer_service.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerRepository {
  final FixerFirebaseService _firebaseService;

  FixerRepository(this._firebaseService);

  Future<List<TaskPostModel>> fetchCategoryMatchedTasks() async {
    final uid = _firebaseService.currentUserId;
    if (uid == null) throw Exception("Fixer not logged in");

    final fixerRoleDoc = await _firebaseService.getFixerRoleDoc(uid);
    if (!fixerRoleDoc.exists) throw Exception("Fixer role data not found");

    final data = fixerRoleDoc.data();
    final fixerSkillCategories =
        List<String>.from(data?['fixerData']?['skills'] ?? []);

    if (fixerSkillCategories.isEmpty) return [];

    final tasksSnapshot = await _firebaseService.getUnassignedPendingTasks();
    final allTasks =
        tasksSnapshot.docs.map((doc) => TaskPostModel.fromMap(doc.data())).toList();

    return allTasks.where((task) {
      final taskSkills =
          task.skills.map((s) => s.toLowerCase().trim()).toSet();
      final fixerSkills =
          fixerSkillCategories.map((s) => s.toLowerCase().trim()).toSet();
      return taskSkills.intersection(fixerSkills).isNotEmpty;
    }).toList();
  }

  Future<UserProfileModel> fetchFixerProfile() async {
    final uid = _firebaseService.currentUserId;
    if (uid == null) throw Exception("Fixer not logged in");

    final fixerDoc = await _firebaseService.getFixerRoleDoc(uid);
    if (!fixerDoc.exists) throw Exception("Fixer profile not found");

    return UserProfileModel.fromJson(fixerDoc.data()!);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fixerProfileStream(String uid) {
    return _firebaseService.fixerProfileStream(uid);
  }

  Future<List<TaskPostModel>> fetchActiveTasks(String fixerId) async {
    final snapshot = await _firebaseService.getActiveTasks(fixerId);
    return snapshot.docs.map((doc) => TaskPostModel.fromMap(doc.data())).toList();
  }

  Future<List<TaskPostModel>> fetchCompletedTasks(String fixerId) async {
    final snapshot = await _firebaseService.getCompletedTasks(fixerId);
    return snapshot.docs.map((doc) => TaskPostModel.fromMap(doc.data())).toList();
  }

  Future<double> fetchTotalEarnings(String fixerId) async {
    try {
      final querySnapshot = await _firebaseService.getCompletedPitches(fixerId);

      double totalEarnings = 0.0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final amount = (data['requestedPaymentAmount'] ?? data['budget'] ?? 0.0);
        if (amount is num) totalEarnings += amount.toDouble();
      }
      return totalEarnings;
    } catch (e) {
      throw Exception('Failed to fetch earnings: ${e.toString()}');
    }
  }

  Future<double> fetchTotalEarningsSafe(String fixerId) async {
    try {
      return await fetchTotalEarnings(fixerId);
    } catch (_) {
      return 0.0;
    }
  }
}
