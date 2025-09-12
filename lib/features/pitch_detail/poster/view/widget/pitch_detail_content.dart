import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class PitchDetailContent extends StatelessWidget {
  final TaskPostModel task;
  final PitchModel pitch;
  final Responsive res;

  const PitchDetailContent({
    super.key,
    required this.task,
    required this.pitch,
    required this.res,
  });

  void _showPaymentConfirmationDialog(
    BuildContext context,
    PitchModel pitch, {
    bool isFromRequest = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PaymentConfirmationDialog(
        paymentType: PaymentType.pitch,
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
        type: DeclineDialogType.pitch,
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
        _showSnack(context, 'Payment processed successfully!',
            Colors.green[600], Icons.check_circle);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnack(context, 'Failed to process payment: $e',
            Colors.red[600], Icons.error);
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
        _showSnack(context, 'Payment request declined',
            Colors.orange[600], Icons.info);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnack(context, 'Failed to decline request: $e',
            Colors.red[600], Icons.error);
      }
    } finally {
      paymentCubit.stopProcessing();
    }
  }

  void _showSnack(
      BuildContext context, String message, Color? color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FixerProfileSection(pitch: pitch),
          SizedBox(height: res.hp(2)),
          PitchDetailCard(task: task, pitch: pitch),
          SizedBox(height: res.hp(3)),

          /// Payment Section
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
  }
}