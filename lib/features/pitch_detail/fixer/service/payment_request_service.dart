import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Request payment for a completed pitch
  Future<void> requestPayment({
    required String pitchId,
    required String taskId,
    required double requestedAmount,
    required String notes,
  }) async {
    final batch = _firestore.batch();

    try {
      final pitchRef = _firestore.collection('pitches').doc(pitchId);
      final taskRef = _firestore.collection('poster_tasks').doc(taskId);

      // Update pitch with payment request details
      batch.update(pitchRef, {
        'paymentStatus': 'requested',
        'requestedPaymentAmount': requestedAmount,
        'paymentRequestNotes': notes,
        'paymentRequestedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update task status to indicate payment is requested
      batch.update(taskRef, {
        'paymentStatus': 'requested',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to request payment: $e');
    }
  }

  /// Cancel a payment request
  Future<void> cancelPaymentRequest({
    required String pitchId,
    required String taskId,
  }) async {
    final batch = _firestore.batch();

    try {
      final pitchRef = _firestore.collection('pitches').doc(pitchId);
      final taskRef = _firestore.collection('poster_tasks').doc(taskId);

      batch.update(pitchRef, {
        'paymentStatus': null,
        'requestedPaymentAmount': null,
        'paymentRequestNotes': null,
        'paymentRequestedAt': null,
        'paymentDeclineReason': null, // Clear any previous decline reason
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batch.update(taskRef, {
        'paymentStatus': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to cancel payment request: $e');
    }
  }

  /// Decline a payment request with reason
  Future<void> declinePaymentRequest({
    required String pitchId,
    required String taskId,
    required String reason,
  }) async {
    final batch = _firestore.batch();

    try {
      final pitchRef = _firestore.collection('pitches').doc(pitchId);
      final taskRef = _firestore.collection('poster_tasks').doc(taskId);

      batch.update(pitchRef, {
        'paymentStatus': 'declined',
        'paymentDeclineReason': reason,
        'paymentDeclinedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batch.update(taskRef, {
        'paymentStatus': 'declined',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to decline payment request: $e');
    }
  }

  /// Mark payment as completed (called by poster or payment system)
  Future<void> markPaymentCompleted({
    required String pitchId,
    required String taskId,
    String? transactionId,
  }) async {
    final batch = _firestore.batch();

    try {
      final pitchRef = _firestore.collection('pitches').doc(pitchId);
      final taskRef = _firestore.collection('poster_tasks').doc(taskId);

      final updateData = {
        'paymentStatus': 'completed',
        'paymentCompletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (transactionId != null) {
        updateData['transactionId'] = transactionId;
      }

      batch.update(pitchRef, updateData);
      batch.update(taskRef, updateData);

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark payment as completed: $e');
    }
  }

  /// Get payment status for a pitch
  Future<Map<String, dynamic>?> getPaymentStatus(String pitchId) async {
    try {
      final doc = await _firestore.collection('pitches').doc(pitchId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return {
        'paymentStatus': data['paymentStatus'],
        'requestedPaymentAmount': data['requestedPaymentAmount'],
        'paymentRequestNotes': data['paymentRequestNotes'],
        'paymentRequestedAt': data['paymentRequestedAt'],
        'transactionId': data['transactionId'],
      };
    } catch (e) {
      throw Exception('Failed to get payment status: $e');
    }
  }

  /// Stream payment status changes for real-time updates
  Stream<Map<String, dynamic>?> getPaymentStatusStream(String pitchId) {
    return _firestore
        .collection('pitches')
        .doc(pitchId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return {
        'paymentStatus': data['paymentStatus'],
        'requestedPaymentAmount': data['requestedPaymentAmount'],
        'paymentRequestNotes': data['paymentRequestNotes'],
        'paymentRequestedAt': data['paymentRequestedAt'],
        'paymentDeclineReason': data['paymentDeclineReason'],
        'transactionId': data['transactionId'],
      };
    });
  }
}