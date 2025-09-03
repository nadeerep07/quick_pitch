import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/payment/components/payment_decline_dialog.dart';
import 'package:quick_pitch_app/features/payment/components/razorpay_config.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentDialogExample extends StatelessWidget {
  final PitchModel pitch;

  const PaymentDialogExample({
    super.key,
    required this.pitch,
  });

  void _showPaymentConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentConfirmationDialog(
        pitch: pitch,
        razorpayKeyId: RazorpayConfig.keyId,
     //   userEmail: 'user@example.com', // Get from your user model
        userPhone: '+919876543210', // Get from your user model
        userName: 'John Doe', // Get from your user model
        isFromRequest: true, // or false based on your use case
        onPaymentSuccess: (paymentId, amount) {
          // Handle successful payment
          print('Payment successful: $paymentId, Amount: $amount');
          // Update your backend, show success message, etc.
          _showPaymentSuccessDialog(context, paymentId, amount);
        },
        onPaymentError: (error) {
          // Handle payment error
          print('Payment error: $error');
          _showPaymentErrorDialog(context, error);
        },
      ),
    );
  }

  void _showPaymentDecline(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PaymentDeclineDialog(
        pitch: pitch,
        onDeclinePayment: (reason) {
          // Handle payment decline
          print('Payment declined: $reason');
          // Update your backend, notify the fixer, etc.
        },
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context, String paymentId, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Payment ID: $paymentId'),
            Text('Amount: ₹${amount.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red, size: 60),
            SizedBox(height: 16),
            Text(
              'Payment Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(error),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showPaymentConfirmation(context);
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showPaymentConfirmation(context),
              child: Text('Initiate Payment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showPaymentDecline(context),
              child: Text('Decline Payment'),
            ),
          ],
        ),
      ),
    );
  }
}