import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FixerFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<DocumentSnapshot<Map<String, dynamic>>> getFixerRoleDoc(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc('fixer')
        .get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fixerProfileStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc('fixer')
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUnassignedPendingTasks() {
    return _firestore
        .collection('poster_tasks')
        .where('assignedFixerId', isEqualTo: null)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getActiveTasks(String fixerId) {
    return _firestore
        .collection('poster_tasks')
        .where('assignedFixerId', isEqualTo: fixerId)
        .where('status', isEqualTo: 'accepted')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCompletedTasks(String fixerId) {
    return _firestore
        .collection('poster_tasks')
        .where('assignedFixerId', isEqualTo: fixerId)
        .where('status', isEqualTo: 'completed')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCompletedPitches(String fixerId) {
    return _firestore
        .collectionGroup('pitches')
        .where('fixerId', isEqualTo: fixerId)
        .where('paymentStatus', isEqualTo: 'completed')
        .get();
  }
}
