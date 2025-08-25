import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class ExploreFixerWorksRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const int _pageSize = 10;

  /// Loads initial works for a fixer
  Future<FixerWorksResult> loadFixerWorks(String fixerId) async {
    try {
      final query = await _firestore
          .collection('fixer_works')
          .where('fixerId', isEqualTo: fixerId)
          .orderBy('createdAt', descending: true)
          .limit(_pageSize)
          .get();

      final works = query.docs.map((doc) => FixerWork.fromFirestore(doc)).toList();
      final lastDocument = query.docs.isNotEmpty ? query.docs.last : null;
      final hasMoreData = query.docs.length == _pageSize;

      return FixerWorksResult(
        works: works,
        lastDocument: lastDocument,
        hasMoreData: hasMoreData,
      );
    } catch (e) {
      throw FixerWorksException('Failed to load works: ${e.toString()}');
    }
  }

  /// Loads more works for pagination
  Future<FixerWorksResult> loadMoreWorks(
    String fixerId,
    DocumentSnapshot lastDocument,
  ) async {
    try {
      final query = await _firestore
          .collection('fixer_works')
          .where('fixerId', isEqualTo: fixerId)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(_pageSize)
          .get();

      final works = query.docs.map((doc) => FixerWork.fromFirestore(doc)).toList();
      final newLastDocument = query.docs.isNotEmpty ? query.docs.last : null;
      final hasMoreData = query.docs.length == _pageSize;

      return FixerWorksResult(
        works: works,
        lastDocument: newLastDocument,
        hasMoreData: hasMoreData,
      );
    } catch (e) {
      throw FixerWorksException('Failed to load more works: ${e.toString()}');
    }
  }

  /// Gets the total count of works for a fixer
  Future<int> getWorksCount(String fixerId) async {
    try {
      final query = await _firestore
          .collection('fixer_works')
          .where('fixerId', isEqualTo: fixerId)
          .get();
      return query.docs.length;
    } catch (e) {
      throw FixerWorksException('Failed to get works count: ${e.toString()}');
    }
  }

  /// Stream to listen to real-time updates for fixer works
  Stream<List<FixerWork>> watchFixerWorks(String fixerId) {
    return _firestore
        .collection('fixer_works')
        .where('fixerId', isEqualTo: fixerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FixerWork.fromFirestore(doc))
            .toList());
  }
}

class FixerWorksResult {
  final List<FixerWork> works;
  final DocumentSnapshot? lastDocument;
  final bool hasMoreData;

  FixerWorksResult({
    required this.works,
    this.lastDocument,
    required this.hasMoreData,
  });
}

class FixerWorksException implements Exception {
  final String message;
  
  FixerWorksException(this.message);
  
  @override
  String toString() => 'FixerWorksException: $message';
}