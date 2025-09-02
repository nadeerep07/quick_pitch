import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/detail_header/message_button.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/detail_header/status_badge.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// --------------------------
/// Status + Message button
/// --------------------------
class StatusAndMessage extends StatelessWidget {
  final PitchModel pitch;
  final ThemeData theme;
  final Responsive res;
  final bool isAssigned;
  final bool isCompleted;

  const StatusAndMessage({super.key, 
    required this.pitch,
    required this.theme,
    required this.res,
    required this.isAssigned,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatusBadge(
          status: pitch.status,
          theme: theme,
          res: res,
        ),
        if (isAssigned || isCompleted)
          MessageButton(
            pitch: pitch,
            theme: theme,
          ),
      ],
    );
  }
}

