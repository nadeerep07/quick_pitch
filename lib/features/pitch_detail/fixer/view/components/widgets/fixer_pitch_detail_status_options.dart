import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

Future<bool?> showRequestPaymentDialog(
  BuildContext context,
  Responsive res,
  PitchModel currentPitch,
) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Request Payment'),
      content: Text(
        'Request payment of \$${currentPitch.budget.toStringAsFixed(2)} from the poster?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Request'),
        ),
      ],
    ),
  );
}
