import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class PitchDetailRepository {
  final FirebaseFirestore _firestore;

  PitchDetailRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Accept a pitch: assign fixer, update task, reject others
Future<void> acceptPitch(PitchModel pitch, TaskPostModel task) async {
  final taskDoc = _firestore.collection('poster_tasks').doc(task.id);
  final taskSnapshot = await taskDoc.get();

  if (taskSnapshot['status'] == 'assigned') {
    throw Exception("Task already assigned to another fixer");
  }

  try {
     final fixerRoleDoc = await _firestore
        .collection('users')
        .doc(pitch.fixerId)
        .collection('roles')
        .doc('fixer')
        .get();

    final fixerName = fixerRoleDoc.data()?['name'] ?? 'Unknown Fixer';
    // Update task
    await taskDoc.update({
      'status': 'assigned',
      'assignedFixerId': pitch.fixerId,
      'assignedFixerName':fixerName
    });

    //  Mark this pitch as accepted
    await _firestore.collection('pitches').doc(pitch.id).update({
      'status': 'accepted',
    });

    // Reject all other pitches for the same task
    final allPitchesSnapshot = await _firestore
        .collection('pitches')
        .where('taskId', isEqualTo: task.id)
        .get();

    for (var doc in allPitchesSnapshot.docs) {
      if (doc.id != pitch.id) {
        await doc.reference.update({'status': 'rejected'});
      }
    }
  } catch (e) {
    throw Exception("Failed to accept pitch: $e");
  }
}


  /// Reject a pitch
  Future<void> rejectPitch(PitchModel pitch,String reason) async {
   
    try {
      await _firestore.collection('pitches').doc(pitch.id).update({
        'status': 'rejected',
        'rejectionMessage': reason,  
        'rejectedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to reject pitch: $e");
    }
  }
}
