import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String message;

  const ErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        message,
        style: TextStyle(color: colorScheme.onPrimary),
      ),
    );
  }
}
