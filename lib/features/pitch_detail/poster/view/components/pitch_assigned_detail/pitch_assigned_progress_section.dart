import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchProgressSection extends StatelessWidget {
  final PitchModel pitch;

  const PitchProgressSection({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (pitch.progress ?? 0).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Progress",
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          color: theme.colorScheme.primary,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "$progress%",
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
