import 'package:cloud_firestore/cloud_firestore.dart';

class PitchUpdateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPitchUpdate(String pitchId, String update) async {
    try {
      await _firestore.collection('pitches').doc(pitchId).collection('updates').add({
        'message': update,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('pitches').doc(pitchId).update({
        'latestUpdate': update,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add update: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPitchUpdates(String pitchId) async {
    try {
      final snapshot = await _firestore
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
}
