import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/detail_header/poster_avatar.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/detail_header/poster_info.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/detail_header/status_and_message.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchHeaderCard extends StatelessWidget {
  final PitchModel currentPitch;
  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool isAssigned;
  final bool isCompleted;

  const FixerPitchHeaderCard({
    super.key,
    required this.currentPitch,
    required this.res,
    required this.theme,
    required this.colorScheme,
    required this.isAssigned,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Row(
          children: [
            PosterAvatar(
              imageUrl: currentPitch.posterImage,
              colorScheme: colorScheme,
              res: res,
            ),
            SizedBox(width: res.wp(4)),
            Expanded(
              child: PosterInfo(
                posterName: currentPitch.posterName,
                createdAt: currentPitch.createdAt,
                theme: theme,
                colorScheme: colorScheme,
                res: res,
              ),
            ),
            StatusAndMessage(
              pitch: currentPitch,
              theme: theme,
              res: res,
              isAssigned: isAssigned,
              isCompleted: isCompleted,
            ),
          ],
        ),
      ),
    );
  }
}

