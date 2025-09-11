import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/viewmodel/hire_payments/cubit/hire_payment_cubit.dart';
import 'package:quick_pitch_app/features/payment/components/razorpay_config.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';


class PaymentDialogs {
  static void showConfirmation(BuildContext context, HireRequest hireRequest, String userPhone, String userName, HirePaymentCubit cubit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PaymentConfirmationDialog(
        paymentType: PaymentType.hireRequest,
        hireRequest: hireRequest,
        razorpayKeyId: RazorpayConfig.keyId,
        userPhone: userPhone,
        userName: userName,
        isFromRequest: hireRequest.hasPaymentRequest,
        onPaymentSuccess: (paymentId, amount) {
          Navigator.of(dialogContext).pop();
          cubit.completePayment(
            hireRequestId: hireRequest.id,
            amount: amount,
            transactionId: paymentId,
          );
        },
        onPaymentError: (error) => showError(dialogContext, error),
      ),
    );
  }

  static Future<String?> showDeclineReasonDialog(BuildContext context) async {
    String reason = '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Decline Payment'),
        content: TextField(
          onChanged: (value) => reason = value,
          decoration: const InputDecoration(hintText: 'Enter reason...', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(dialogContext).pop(reason), child: const Text('Decline')),
        ],
      ),
    );
  }

  static void showSuccess(BuildContext context, String paymentId, double amount) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60),
          SizedBox(height: 16),
          Text('Payment Successful!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Payment ID: $paymentId'),
          Text('Amount: ₹${amount.toStringAsFixed(2)}'),
        ]),
        actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK'))],
      ),
    );
  }

  static void showError(BuildContext context, String error, [VoidCallback? retry]) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error, color: Colors.red, size: 60),
          SizedBox(height: 16),
          Text('Payment Failed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(error),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK')),
          if (retry != null) TextButton(onPressed: () { Navigator.of(dialogContext).pop(); retry(); }, child: const Text('Retry')),
        ],
      ),
    );
  }
}
