import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/dialog_helper.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/fixer_avatar.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/fixer_name.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/view/components/completed_tab_sections/payment_status.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerSection extends StatelessWidget {
  final TaskPostModel task;
  final PitchModel acceptedPitch;
  const FixerSection({required this.task, required this.acceptedPitch});

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          leading: FixerAvatar(fixerId: acceptedPitch.fixerId),
          title: FixerName(fixerId: acceptedPitch.fixerId),
          trailing: Icon(Icons.expand_more, color: Colors.grey[600]),
          children: [
            if (acceptedPitch.completionNotes != null ||
                acceptedPitch.latestUpdate != null) ...[
              CompletionNote(pitch: acceptedPitch),
              const SizedBox(height: 12),
            ],
            PaymentStatus(pitch: acceptedPitch),
          ],
        ),
      );
}

