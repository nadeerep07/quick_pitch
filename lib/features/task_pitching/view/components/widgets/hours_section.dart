import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/hours_input.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/section_title.dart';

class HoursSection extends StatelessWidget {
  const HoursSection({
    super.key,
    required this.context,
    required TextEditingController hoursController,
    required this.res,
    required this.colorScheme,
  }) : _hoursController = hoursController;

  final BuildContext context;
  final TextEditingController _hoursController;
  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(context: context, title: 'ESTIMATED HOURS', res: res, colorScheme: colorScheme),
        SizedBox(height: res.hp(1)),
        HoursInput(hoursController: _hoursController, res: res, colorScheme: colorScheme),
      ],
    );
  }
}
