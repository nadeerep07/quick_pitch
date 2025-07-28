import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_input.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/section_title.dart';

class PitchSection extends StatelessWidget {
  const PitchSection({
    super.key,
    required this.context,
    required TextEditingController pitchController,
    required this.res,
    required this.colorScheme,
  }) : _pitchController = pitchController;

  final BuildContext context;
  final TextEditingController _pitchController;
  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(context: context, title: 'YOUR PITCH', res: res, colorScheme: colorScheme),
        SizedBox(height: res.hp(1)),
        PitchInput(pitchController: _pitchController, res: res, colorScheme: colorScheme),
      ],
    );
  }
}
