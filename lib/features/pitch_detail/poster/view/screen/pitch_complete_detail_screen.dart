import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/components/payment_decline_dialog.dart';
import 'package:quick_pitch_app/features/payment/components/razorpay_config.dart';
import 'package:quick_pitch_app/features/payment/service/payment_request_service.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/payment/view/poster_payment_section.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/fixer_profile_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_assigned_detail/pitch_assigned_detail_card.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/review/view/components/poster_review_section.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';


// Main Screen
class PitchCompleteDetailScreen extends StatelessWidget {
  final TaskPostModel task;
  final String? pitchId;

  const PitchCompleteDetailScreen({
    super.key,
    required this.task,
    required this.pitchId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final res = Responsive(context);

    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, paymentState) {
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
                CustomPaint(
                  painter: MainBackgroundPainter(),
                  size: Size.infinite,
                ),
                _Body(
                  task: task,
                  pitchId: pitchId,
                  res: res,
                  theme: theme,
                ),
                if (paymentState.isProcessing)
                  _ProcessingOverlay(res: res, theme: theme),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TaskPostModel task;
  final String? pitchId;
  final Responsive res;
  final ThemeData theme;

  const _Body({
    required this.task,
    required this.pitchId,
    required this.res,
    required this.theme,
  });

  void _showPaymentConfirmationDialog(
      BuildContext context, PitchModel pitch,
      {bool isFromRequest = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PaymentConfirmationDialog(
        pitch: pitch,
        isFromRequest: isFromRequest,
        onPaymentSuccess: (paymentId, amount) =>
            _processPayment(context, pitch, amount),
        onPaymentError: (error) => _showPaymentDeclineDialog(context, pitch),
        razorpayKeyId: RazorpayConfig.keyId,
        userPhone: '+919876543210', // Replace with actual user phone
        userName: 'John Doe', // Replace with actual user name
      ),
    );
  }

  void _showPaymentDeclineDialog(BuildContext context, PitchModel pitch) {
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDeclineDialog(
        pitch: pitch,
        onDeclinePayment: (reason) =>
            _declinePaymentRequest(context, pitch, reason),
      ),
    );
  }

  Future<void> _processPayment(
      BuildContext context, PitchModel pitch, double amount) async {
    final paymentCubit = context.read<PaymentCubit>();
    final service = PaymentRequestService();

    paymentCubit.startProcessing();

    try {
      await service.markPaymentCompleted(
        pitchId: pitch.id,
        taskId: task.id,
        transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Failed to process payment: $e')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      paymentCubit.stopProcessing();
    }
  }

  Future<void> _declinePaymentRequest(
      BuildContext context, PitchModel pitch, String reason) async {
    final paymentCubit = context.read<PaymentCubit>();
    final service = PaymentRequestService();

    paymentCubit.startProcessing();

    try {
      await service.declinePaymentRequest(
        pitchId: pitch.id,
        taskId: task.id,
        reason: reason,
      );

      if (context.mounted) {
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Failed to decline request: $e')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      paymentCubit.stopProcessing();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pitchDocRef =
        FirebaseFirestore.instance.collection('pitches').doc(pitchId);

    return SafeArea(
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
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.grey[600]),
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
                  Icon(Icons.error_outline, size: res.wp(12), color: Colors.red),
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
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
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

          final pitch =
              PitchModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FixerProfileSection(pitch: pitch),
                SizedBox(height: res.hp(2)),
                PitchDetailCard(task: task, pitch: pitch),
                SizedBox(height: res.hp(3)),

                // Payment Section
                PosterPaymentSection(
                  pitch: pitch,
                  onApprovePayment: pitch.paymentStatus == 'requested'
                      ? () => _showPaymentConfirmationDialog(context,
                          pitch, isFromRequest: true)
                      : null,
                  onDeclinePayment: pitch.paymentStatus == 'requested'
                      ? () => _showPaymentDeclineDialog(context, pitch)
                      : null,
                  onInitiatePayment: pitch.paymentStatus == null
                      ? () => _showPaymentConfirmationDialog(context, pitch)
                      : null,
                ),
                SizedBox(height: res.hp(2)),

                PosterReviewSection(
                  pitch: pitch,
                  fixerId: pitch.fixerId,
                  fixerName: pitch.fixerName,
                  fixerImageUrl: pitch.fixerimageUrl,
                ),
                SizedBox(height: res.hp(2)),

                if (pitch.latestUpdate != null) ...[
                  // PitchAssignedUpdateHistoryList(pitch: pitch),
                  SizedBox(height: res.hp(2)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProcessingOverlay extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const _ProcessingOverlay({required this.res, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
