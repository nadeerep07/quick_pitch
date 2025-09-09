import 'package:cloud_firestore/cloud_firestore.dart';

class HirePaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Request payment for a completed hire request
  Future<void> requestPayment({
    required String hireRequestId,
    required double requestedAmount,
    required String notes,
  }) async {
    final batch = _firestore.batch();

    try {
      final hireRequestRef = _firestore
          .collection('hire_requests')
          .doc(hireRequestId);

      // Update hire request with payment request details
      batch.update(hireRequestRef, {
        'paymentStatus': 'requested',
        'requestedPaymentAmount': requestedAmount,
        'paymentRequestNotes': notes,
        'paymentRequestedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to request payment: $e');
    }
  }

  /// Cancel a payment request for hire request
  Future<void> cancelPaymentRequest({
    required String hireRequestId,
  }) async {
    final batch = _firestore.batch();

    try {
      final hireRequestRef = _firestore
          .collection('hire_requests')
          .doc(hireRequestId);

      batch.update(hireRequestRef, {
        'paymentStatus': null,
        'requestedPaymentAmount': null,
        'paymentRequestNotes': null,
        'paymentRequestedAt': null,
        'paymentDeclineReason': null,
        'paymentDeclinedAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to cancel payment request: $e');
    }
  }

  /// Decline a payment request with reason for hire request
  Future<void> declinePaymentRequest({
    required String hireRequestId,
    required String reason,
  }) async {
    final batch = _firestore.batch();

    try {
      final hireRequestRef = _firestore
          .collection('hire_requests')
          .doc(hireRequestId);

      batch.update(hireRequestRef, {
        'paymentStatus': 'declined',
        'paymentDeclineReason': reason,
        'paymentDeclinedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to decline payment request: $e');
    }
  }

  /// Mark payment as completed for hire request
  Future<void> markPaymentCompleted({
    required String hireRequestId,
    required double paidAmount,
    String? transactionId,
  }) async {
    final batch = _firestore.batch();

    try {
      final hireRequestRef = _firestore
          .collection('hire_requests')
          .doc(hireRequestId);

      final updateData = {
        'paymentStatus': 'completed',
        'paidAmount': paidAmount,
        'paymentCompletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (transactionId != null) {
        updateData['transactionId'] = transactionId;
      }

      batch.update(hireRequestRef, updateData);

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark payment as completed: $e');
    }
  }

  /// Get payment status for a hire request
  Future<Map<String, dynamic>?> getPaymentStatus(String hireRequestId) async {
    try {
      final doc = await _firestore
          .collection('hire_requests')
          .doc(hireRequestId)
          .get();
      
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return {
        'paymentStatus': data['paymentStatus'],
        'requestedPaymentAmount': data['requestedPaymentAmount'],
        'paymentRequestNotes': data['paymentRequestNotes'],
        'paymentRequestedAt': data['paymentRequestedAt'],
        'paidAmount': data['paidAmount'],
        'transactionId': data['transactionId'],
        'paymentDeclineReason': data['paymentDeclineReason'],
        'paymentCompletedAt': data['paymentCompletedAt'],
        'paymentDeclinedAt': data['paymentDeclinedAt'],
      };
    } catch (e) {
      throw Exception('Failed to get payment status: $e');
    }
  }

  /// Stream payment status changes for real-time updates
  Stream<Map<String, dynamic>?> getPaymentStatusStream(String hireRequestId) {
    return _firestore
        .collection('hire_requests')
        .doc(hireRequestId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return {
        'paymentStatus': data['paymentStatus'],
        'requestedPaymentAmount': data['requestedPaymentAmount'],
        'paymentRequestNotes': data['paymentRequestNotes'],
        'paymentRequestedAt': data['paymentRequestedAt'],
        'paidAmount': data['paidAmount'],
        'transactionId': data['transactionId'],
        'paymentDeclineReason': data['paymentDeclineReason'],
        'paymentCompletedAt': data['paymentCompletedAt'],
        'paymentDeclinedAt': data['paymentDeclinedAt'],
      };
    });
  }

  /// Get hire request details including associated work information
  Future<Map<String, dynamic>?> getHireRequestWithWork(String hireRequestId) async {
    try {
      final hireRequestDoc = await _firestore
          .collection('hire_requests')
          .doc(hireRequestId)
          .get();
      
      if (!hireRequestDoc.exists) return null;

      final hireRequestData = hireRequestDoc.data() as Map<String, dynamic>;
      
      // If hire request contains a reference to fixer_works
      if (hireRequestData.containsKey('fixerWorkId')) {
        final workDoc = await _firestore
            .collection('fixer_works')
            .doc(hireRequestData['fixerWorkId'])
            .get();
        
        if (workDoc.exists) {
          hireRequestData['workDetails'] = workDoc.data();
        }
      }

      return hireRequestData;
    } catch (e) {
      throw Exception('Failed to get hire request with work details: $e');
    }
  }

  /// Get all hire requests for a specific fixer work
  Future<List<Map<String, dynamic>>> getHireRequestsForWork(String fixerWorkId) async {
    try {
      final querySnapshot = await _firestore
          .collection('hire_requests')
          .where('fixerWorkId', isEqualTo: fixerWorkId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get hire requests for work: $e');
    }
  }
}