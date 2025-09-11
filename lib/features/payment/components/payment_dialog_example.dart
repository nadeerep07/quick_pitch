import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/payment/components/payment_decline_dialog.dart';
import 'package:quick_pitch_app/features/payment/components/razorpay_config.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_dialog/payment_error_dialog.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_dialog/payment_success_dialog.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentDialogExample extends StatelessWidget {
  final PitchModel pitch;

  const PaymentDialogExample({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showPaymentConfirmation(context),
              child: const Text('Initiate Payment'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showPaymentDecline(context),
              child: const Text('Decline Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentConfirmationDialog(
        paymentType: PaymentType.pitch,
        pitch: pitch,
        razorpayKeyId: RazorpayConfig.keyId,
        userPhone: '+919876543210', // Replace with user model
        userName: 'John Doe', // Replace with user model
        isFromRequest: true,
        onPaymentSuccess: (paymentId, amount) {
          _showPaymentSuccessDialog(context, paymentId, amount);
        },
        onPaymentError: (error) {
          _showPaymentErrorDialog(context, error);
        },
      ),
    );
  }

  void _showPaymentDecline(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PaymentDeclineDialog(
        type: DeclineDialogType.pitch,
        pitch: pitch,
        onDeclinePayment: (reason) {
          debugPrint('Payment declined: $reason');
        },
      ),
    );
  }

  void _showPaymentSuccessDialog(
    BuildContext context,
    String paymentId,
    double amount,
  ) {
    showDialog(
      context: context,
      builder: (context) => PaymentSuccessDialog(
        paymentId: paymentId,
        amount: amount,
      ),
    );
  }

  void _showPaymentErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => PaymentErrorDialog(
        error: error,
        onRetry: () {
          Navigator.of(context).pop();
          _showPaymentConfirmation(context);
        },
      ),
    );
  }
}
