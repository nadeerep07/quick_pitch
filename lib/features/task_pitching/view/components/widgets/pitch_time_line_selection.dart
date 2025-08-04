import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/timeline_options.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class PitchTimeLineSelection extends StatelessWidget {
  const PitchTimeLineSelection({
    super.key,
    required this.res,
    required this.colorScheme,
  });

  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(res.wp(3)),
      ),
      child: BlocBuilder<PitchFormCubit, PitchFormState>(
        builder: (context, formState) {
          return Column(
            children: [
              TimelineOptions(context: context, icon: Icons.flash_on, title: 'As soon as possible', value: 'ASAP', groupValue: formState.timeline, res: res),
              Divider(height: 1, indent: res.wp(4), endIndent: res.wp(4)),
              TimelineOptions(context: context, icon: Icons.calendar_view_day, title: 'Within 1–3 days', value: '1-3 days', groupValue: formState.timeline, res: res),
              Divider(height: 1, indent: res.wp(4), endIndent: res.wp(4)),
              TimelineOptions(context: context, icon: Icons.event_available, title: 'Flexible', value: 'Flexible', groupValue: formState.timeline, res: res),
            ],
          );
        },
      ),
    );
  }
}
