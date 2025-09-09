import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class HireRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new hire request
  Future<void> createHireRequest({
    required FixerWork work,
    required UserProfileModel fixer,
    required UserProfileModel poster,
    String? message,
  }) async {
    final request = HireRequest(
      id: '',
      workId: work.id,
      fixerId: fixer.uid,
      posterId: poster.uid,
      posterName: poster.name,
      posterImage: poster.profileImageUrl ?? '',
      workTitle: work.title,
      workDescription: work.description,
      workAmount: work.amount,
      workImages: work.images,
      workTime: work.time,
      status: HireRequestStatus.pending,
      createdAt: DateTime.now(),
      message: message,
    );

    await _firestore
        .collection('hire_requests')
        .add(request.toFirestore());
  }

  /// Get hire requests for a specific fixer
  Stream<List<HireRequest>> getFixerHireRequests(String fixerId) {
    return _firestore
        .collection('hire_requests')
        .where('fixerId', isEqualTo: fixerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HireRequest.fromFirestore(doc))
            .toList());
  }

  /// Get hire requests sent by a specific poster
  Stream<List<HireRequest>> getPosterHireRequests(String posterId) {
    return _firestore
        .collection('hire_requests')
        .where('posterId', isEqualTo: posterId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HireRequest.fromFirestore(doc))
            .toList());
  }

  /// Update hire request status
  Future<void> updateRequestStatus({
    required String requestId,
    required HireRequestStatus status,
    String? message,
  }) async {
    final updateData = {
      'status': status.name,
      'respondedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (message != null) {
      updateData['message'] = message;
    }

    await _firestore
        .collection('hire_requests')
        .doc(requestId)
        .update(updateData);
  }

  /// Accept a hire request
  Future<void> acceptRequest(String requestId, {String? message}) async {
    await updateRequestStatus(
      requestId: requestId,
      status: HireRequestStatus.accepted,
      message: message,
    );
  }

  /// Decline a hire request
  Future<void> declineRequest(String requestId, {String? message}) async {
    await updateRequestStatus(
      requestId: requestId,
      status: HireRequestStatus.declined,
      message: message,
    );
  }

Future<void> completeRequest(String requestId) async {
  print('Repository: Completing request $requestId'); // Debug
  try {
    await updateRequestStatus(
      requestId: requestId,
      status: HireRequestStatus.completed,
      message: 'Work completed',
    );
    print('Repository: Request completed successfully'); // Debug
  } catch (error) {
    print('Repository error: $error'); // Debug
    rethrow;
  }
}

  /// Cancel a hire request (by poster)
  Future<void> cancelRequest(String requestId, {String? message}) async {
    await updateRequestStatus(
      requestId: requestId,
      status: HireRequestStatus.cancelled,
      message: message,
    );
  }

  /// Get a specific hire request
  Future<HireRequest?> getHireRequest(String requestId) async {
    final doc = await _firestore
        .collection('hire_requests')
        .doc(requestId)
        .get();

    if (!doc.exists) return null;

    return HireRequest.fromFirestore(doc);
  }

  /// Check if a poster has already sent a request for a specific work
  Future<bool> hasExistingRequest({
    required String workId,
    required String posterId,
  }) async {
    final query = await _firestore
        .collection('hire_requests')
        .where('workId', isEqualTo: workId)
        .where('posterId', isEqualTo: posterId)
        .where('status', whereIn: [
          HireRequestStatus.pending.name,
          HireRequestStatus.accepted.name,
        ])
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  /// Get statistics for fixer dashboard
  Future<Map<String, int>> getFixerRequestStats(String fixerId) async {
    final requests = await _firestore
        .collection('hire_requests')
        .where('fixerId', isEqualTo: fixerId)
        .get();

    final stats = <String, int>{
      'total': requests.docs.length,
      'pending': 0,
      'accepted': 0,
      'declined': 0,
      'completed': 0,
      'cancelled': 0,
    };

    for (final doc in requests.docs) {
      final status = doc.data()['status'] as String;
      stats[status] = (stats[status] ?? 0) + 1;
    }

    return stats;
  }
}