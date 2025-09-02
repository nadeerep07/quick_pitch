import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// Completion note widget
class CompletionNote extends StatelessWidget {
  final PitchModel pitch;
  const CompletionNote({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final note =
        pitch.completionNotes ?? pitch.latestUpdate ?? 'Task completed successfully';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100, width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.sticky_note_2_outlined,
              size: 14, color: Colors.blue.shade600),
          const SizedBox(width: 6),
          Text('Completion Note',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 11)),
        ]),
        const SizedBox(height: 6),
        Text(note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue.shade600, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}

