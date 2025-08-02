import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitPitch(PitchModel pitch) async {
    try {
      await _firestore
          .collection('pitches')
          .doc(pitch.id)
          .set(pitch.toJson()); 
    //  print(" Pitch saved to Firestore");
    } catch (e) {
      print(" Error saving pitch: $e");
      throw Exception("Failed to submit pitch");
    }
  }

Future<List<Map<String, dynamic>>> getPitchesGroupedByTask() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) throw Exception("User not logged in");

  try {
    // 1️⃣ Get tasks of current poster
    final tasksSnapshot = await _firestore
        .collection('poster_tasks')
        .where('posterId', isEqualTo: currentUser.uid)
        .get();

    final tasks = tasksSnapshot.docs
        .map((doc) => TaskPostModel.fromMap(doc.data()))
        .toList();

    //  For each task, fetch its pitches
    List<Map<String, dynamic>> result = [];
    for (final task in tasks) {
      final pitchesSnapshot = await _firestore
          .collection('pitches')
          .where('taskId', isEqualTo: task.id)
          .orderBy('createdAt', descending: true)
          .get();

      final pitches = pitchesSnapshot.docs
          .map((doc) => PitchModel.fromJson(doc.data()))
          .toList();

      if (pitches.isNotEmpty) {
        result.add({'task': task, 'pitches': pitches});
      }
    }

    return result;
  } catch (e) {
    print("Error fetching grouped pitches: $e");
    throw Exception("Failed to fetch grouped pitches");
  }
}



  /// Get live updates for a task
  Stream<List<PitchModel>> getPitchesForTask(String taskId) {
    return _firestore
        .collection('pitches')
        .where('taskId', isEqualTo: taskId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PitchModel.fromJson(doc.data())).toList());
  }
}
