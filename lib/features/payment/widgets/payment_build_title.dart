import 'package:flutter/material.dart';

class PaymentBuildTitle extends StatelessWidget {
  final bool isFromRequest;
  final ThemeData theme;

  const PaymentBuildTitle({
    super.key,
    required this.isFromRequest,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => Text(
        isFromRequest ? 'Approve Payment Request' : 'Confirm Payment',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      );
}
