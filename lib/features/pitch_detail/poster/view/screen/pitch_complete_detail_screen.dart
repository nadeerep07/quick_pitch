import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/components/payment_decline_dialog.dart';
import 'package:quick_pitch_app/features/payment/components/razorpay_config.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/service/payment_request_service.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/fixer_profile_section.dart';
import 'package:quick_pitch_app/features/payment/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/payment/poster_payment_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_assigned_detail/pitch_assigned_detail_card.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchCompleteDetailScreen extends StatefulWidget {
  final TaskPostModel task;
  final String? pitchId;

  const PitchCompleteDetailScreen({
    super.key,
    required this.task,
    required this.pitchId,
  });

  @override
  State<PitchCompleteDetailScreen> createState() => _PitchCompleteDetailScreenState();
}

class _PitchCompleteDetailScreenState extends State<PitchCompleteDetailScreen> {
  final PaymentRequestService _paymentService = PaymentRequestService();
  bool _isProcessingPayment = false;

  void _showPaymentConfirmationDialog(PitchModel pitch, {bool isFromRequest = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PaymentConfirmationDialog(
        pitch: pitch,
        isFromRequest: isFromRequest,
        onPaymentSuccess: (paymentId, amount) => _processPayment(pitch, amount),
        onPaymentError: (error) => _showPaymentDeclineDialog(pitch),
        razorpayKeyId: RazorpayConfig.keyId,
        userPhone: '+919876543210', // Get from your user model
        userName: 'John Doe', // Get from your user model

      ),
    );
  }

  void _showPaymentDeclineDialog(PitchModel pitch) {
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDeclineDialog(
        pitch: pitch,
        onDeclinePayment: (reason) => _declinePaymentRequest(pitch, reason),
      ),
    );
  }

  Future<void> _processPayment(PitchModel pitch, double amount) async {
    setState(() => _isProcessingPayment = true);

    try {
      // Here you would integrate with your actual payment processing system
      // For now, we'll just mark the payment as completed
      await _paymentService.markPaymentCompleted(
        pitchId: pitch.id,
        taskId: widget.task.id,
        transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}', // Mock transaction ID
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Payment processed successfully!'),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Failed to process payment: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  Future<void> _declinePaymentRequest(PitchModel pitch, String reason) async {
    setState(() => _isProcessingPayment = true);

    try {
      // Decline the payment request with reason
      await _paymentService.declinePaymentRequest(
        pitchId: pitch.id,
        taskId: widget.task.id,
        reason: reason,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 8),
                Text('Payment request declined'),
              ],
            ),
            backgroundColor: Colors.orange[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Failed to decline request: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pitchDocRef = FirebaseFirestore.instance
        .collection('pitches')
        .doc(widget.pitchId);
    final theme = Theme.of(context);
    final res = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: pitchDocRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: res.hp(2)),
                        Text(
                          'Loading details...',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, 
                             size: res.wp(12), 
                             color: Colors.red),
                        SizedBox(height: res.hp(2)),
                        Text(
                          "Pitch not found",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: res.hp(1)),
                        Text(
                          "The pitch you're looking for doesn't exist.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: res.hp(3)),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back),
                          label: Text('Go Back'),
                        ),
                      ],
                    ),
                  );
                }

                final pitch = PitchModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>,
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Existing sections
                      FixerProfileSection(pitch: pitch),
                      SizedBox(height: res.hp(2)),
                      
                      PitchDetailCard(task: widget.task, pitch: pitch),
                      SizedBox(height: res.hp(3)),

                      // Payment section - Add this
                      PosterPaymentSection(
                        pitch: pitch,
                        onApprovePayment: pitch.paymentStatus == 'requested'
                            ? () => _showPaymentConfirmationDialog(pitch, isFromRequest: true)
                            : null,
                        onDeclinePayment: pitch.paymentStatus == 'requested'
                            ? () => _showPaymentDeclineDialog(pitch)
                            : null,
                        onInitiatePayment: pitch.paymentStatus == null
                            ? () => _showPaymentConfirmationDialog(pitch, isFromRequest: false)
                            : null,
                      ),
                      SizedBox(height: res.hp(2)),

                      // Update history if available
                      if (pitch.latestUpdate != null) ...[
                  //      PitchAssignedUpdateHistoryList(pitch: pitch),
                        SizedBox(height: res.hp(2)),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Processing overlay
          if (_isProcessingPayment)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(res.wp(6)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: res.hp(2)),
                        Text(
                          'Processing payment...',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}