import 'package:cloud_firestore/cloud_firestore.dart';

class PitchStatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> markPitchAsCompleted({
    required String pitchId,
    required String taskId,
    required String notes,
  }) async {
    final batch = _firestore.batch();

    try {
      final pitchRef = _firestore.collection('pitches').doc(pitchId);
      final taskRef = _firestore.collection('poster_tasks').doc(taskId);

      batch.update(pitchRef, {
        'status': 'completed',
        'completionNotes': notes,
        'completionDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batch.update(taskRef, {
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark pitch and task as completed: $e');
    }
  }
}
