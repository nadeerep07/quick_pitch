// File: fixer_pitch_detail_ui_helper.dart

import 'package:flutter/material.dart';

class FixerPitchProcessingOverlay extends StatelessWidget {
  const FixerPitchProcessingOverlay({
    super.key,
    required this.colorScheme,
    required this.theme,
    required this.message,
  });

  final ColorScheme colorScheme;
  final ThemeData theme;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
