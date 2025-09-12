import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';

class DialogDescription extends StatelessWidget {
  final bool isFromRequest;
  final PaymentType paymentType;
  final ThemeData theme;

  const DialogDescription({super.key, 
    required this.isFromRequest,
    required this.paymentType,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    String description;
    if (paymentType == PaymentType.pitch) {
      description = isFromRequest
          ? 'The fixer has requested payment for completing the task. Please review and approve.'
          : 'You are about to make a payment for the completed task.';
    } else {
      description = isFromRequest
          ? 'The fixer has requested payment for completing the hire request. Please review and approve.'
          : 'You are about to make a payment for the completed hire work.';
    }

    return Text(
      description,
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }
}
