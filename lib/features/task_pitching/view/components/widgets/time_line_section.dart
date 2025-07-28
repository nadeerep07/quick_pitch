import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_time_line_selection.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/section_title.dart';

class TimeLineSection extends StatelessWidget {
  const TimeLineSection({
    super.key,
    required this.context,
    required this.res,
    required this.colorScheme,
  });

  final BuildContext context;
  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(context: context, title: 'PREFERRED TIMELINE', res: res, colorScheme: colorScheme),
        SizedBox(height: res.hp(1)),
        PitchTimeLineSelection(res: res, colorScheme: colorScheme),
      ],
    );
  }
}
