import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitPitch(PitchModel pitch) async {
    try {
      await _firestore.collection('pitches').doc(pitch.id).set(pitch.toJson());
      //  print(" Pitch saved to Firestore");
    } catch (e) {
      //   print(" Error saving pitch: $e");
      throw Exception("Failed to submit pitch");
    }
  }

  Future<List<Map<String, dynamic>>> getPitchesGroupedByTask() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    try {
      // 1️⃣ Get tasks of current poster
      final tasksSnapshot =
          await _firestore
              .collection('poster_tasks')
              .where('posterId', isEqualTo: currentUser.uid)
              .get();

      final tasks =
          tasksSnapshot.docs
              .map((doc) => TaskPostModel.fromMap(doc.data()))
              .toList();

      //  For each task, fetch its pitches
      List<Map<String, dynamic>> result = [];
      for (final task in tasks) {
        final pitchesSnapshot =
            await _firestore
                .collection('pitches')
                .where('taskId', isEqualTo: task.id)
                .orderBy('createdAt', descending: true)
                .get();

        final pitches =
            pitchesSnapshot.docs
                .map((doc) => PitchModel.fromJson(doc.data()))
                .toList();

        if (pitches.isNotEmpty) {
          result.add({'task': task, 'pitches': pitches});
        }
      }

      return result;
    } catch (e) {
      //  print("Error fetching grouped pitches: $e");
      throw Exception("Failed to fetch grouped pitches");
    }
  }

  Future<List<PitchModel>> fetchFixerPitches(String fixerId) async {
    try {
      final snapshot =
          await _firestore
              .collection('pitches')
              .where('fixerId', isEqualTo: fixerId)
              .get();

      List<PitchModel> pitches = [];

      for (var doc in snapshot.docs) {
        final pitchData = doc.data();

        // Step 1: fetch related task
        final taskDoc =
            await _firestore
                .collection('poster_tasks')
                .doc(pitchData['taskId'])
                .get();

        String? posterName;
        String? posterImage;

        if (taskDoc.exists) {
          final posterId = taskDoc['posterId'];

          // Step 2: fetch poster details
          final posterDoc =
              await _firestore
                  .collection('users')
                  .doc(posterId)
                  .collection('roles')
                  .doc('poster')
                  .get();

          if (posterDoc.exists) {
            posterName = posterDoc['name'];
            posterImage = posterDoc['profileImageUrl'];
          }
        }

        // Step 3: build PitchModel with poster info
        pitches.add(
          PitchModel.fromJson({
            ...pitchData,
            'id': doc.id,
            'posterName': posterName,
            'posterImage': posterImage,
          }),
        );
      }

      return pitches;
    } catch (e) {
      throw Exception('Error fetching fixer pitches: $e');
    }
  }

  /// Get live updates for a task
  Stream<List<PitchModel>> getPitchesForTask(String taskId) {
    return _firestore
        .collection('pitches')
        .where('taskId', isEqualTo: taskId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => PitchModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  Future<void> updatePitchProgress(String pitchId, int progress) async {
    try {
      await _firestore.collection('pitches').doc(pitchId).update({
        'progress': progress,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update progress: $e');
    }
  }

  Future<void> markPitchAsCompleted(String pitchId, String notes) async {
    try {
      await _firestore.collection('pitches').doc(pitchId).update({
        'status': 'completed',
        'completionNotes': notes,
        'completionDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark as completed: $e');
    }
  }

  Future<void> addPitchUpdate(String pitchId, String update) async {
    try {
      // Add to updates subcollection
      await _firestore
          .collection('pitches')
          .doc(pitchId)
          .collection('updates')
          .add({
            'message': update,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update latest update in main pitch document
      await _firestore.collection('pitches').doc(pitchId).update({
        'latestUpdate': update,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add update: $e');
    }
  }

  Future<void> requestPayment(String pitchId) async {
    try {
      await _firestore.collection('pitches').doc(pitchId).update({
        'paymentStatus': 'requested',
        'paymentRequestedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to request payment: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPitchUpdates(String pitchId) async {
    try {
      final snapshot =
          await _firestore
              .collection('pitches')
              .doc(pitchId)
              .collection('updates')
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch updates: $e');
    }
  }

  Stream<PitchModel> getPitchStream(String pitchId) {
    return _firestore
        .collection('pitches')
        .doc(pitchId)
        .snapshots()
        .map((snapshot) => PitchModel.fromJson(snapshot.data()!));
  }

  Future<void> updatePitchStatus(String pitchId, String status) async {
    try {
      await _firestore.collection('pitches').doc(pitchId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}
