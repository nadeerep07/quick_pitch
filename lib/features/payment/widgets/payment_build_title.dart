import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/payment/payment_confirmation_dialog.dart';

class PaymentBuildTitle extends StatelessWidget {
  const PaymentBuildTitle({
    super.key,
    required this.widget,
    required this.theme,
  });

  final PaymentConfirmationDialog widget;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Text(
        widget.isFromRequest ? 'Approve Payment Request' : 'Confirm Payment',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      );
}
