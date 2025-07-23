import 'package:cloud_firestore/cloud_firestore.dart';

class SkillService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'skills';

  /// Get real-time updates of skill names
  Stream<List<String>> getSkillNamesStream() {
    return _db.collection(_collection).orderBy('name').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc['name'] as String).toList();
      },
    );
  }

  Future<List<String>> fetchAllSkills() async {
    final snapshot = await _db.collection(_collection).orderBy('name').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }


}
