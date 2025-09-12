import 'package:flutter/material.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final String paymentId;
  final double amount;

  const PaymentSuccessDialog({super.key, 
    required this.paymentId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          const Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Payment ID: $paymentId'),
          Text('Amount: ₹${amount.toStringAsFixed(2)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
