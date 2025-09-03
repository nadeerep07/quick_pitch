import 'package:flutter/material.dart';

class PaymentBuildDescription extends StatelessWidget {
  final bool isFromRequest;
  final ThemeData theme;

  const PaymentBuildDescription({
    super.key,
    required this.isFromRequest,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isFromRequest
          ? 'You are about to approve and process the payment request via Razorpay.'
          : 'You are about to pay the fixer for the completed task via Razorpay.',
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }
}
