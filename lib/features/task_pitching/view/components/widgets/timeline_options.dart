import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/timeline_option.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';

class TimelineOptions extends StatelessWidget {
  const TimelineOptions({
    super.key,
    required this.context,
    required this.icon,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.res,
  });

  final BuildContext context;
  final IconData icon;
  final String title;
  final String value;
  final String? groupValue;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return TimelineOption(
      icon: icon,
      title: title,
      value: value,
      groupValue: groupValue,
      onChanged: (value) => context.read<PitchFormCubit>().changeTimeline(value),
      res: res,
    );
  }
}
