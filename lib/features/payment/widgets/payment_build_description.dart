import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/payment/payment_confirmation_dialog.dart';

class PaymentBuildDescription extends StatelessWidget {
  final PaymentConfirmationDialog widget;
  final ThemeData theme;

  const PaymentBuildDescription({
    super.key,
    required this.widget,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.isFromRequest
          ? 'You are about to approve and process the payment request via Razorpay.'
          : 'You are about to pay the fixer for the completed task via Razorpay.',
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }
}
