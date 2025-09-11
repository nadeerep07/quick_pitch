import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  final bool isFromRequest;
  final ThemeData theme;

  const DialogTitle({required this.isFromRequest, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      isFromRequest ? 'Approve Payment Request' : 'Confirm Payment',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.green[700],
      ),
      textAlign: TextAlign.center,
    );
  }
}
