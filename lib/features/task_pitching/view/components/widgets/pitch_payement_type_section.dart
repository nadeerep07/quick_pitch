import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_fixed_rate_card.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_hourly_paycard.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/section_title.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class PitchPayementTypeSection extends StatelessWidget {
  const PitchPayementTypeSection({
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
        SectionTitle(context: context, title: 'PAYMENT TYPE', res: res, colorScheme: colorScheme),
        SizedBox(height: res.hp(1)),
        BlocBuilder<PitchFormCubit, PitchFormState>(
          builder: (context, formState) {
            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(res.wp(3)),
              ),
              child: Row(
                children: [
                  Expanded(child: PitchFixedRateCard(context: context, res: res, formState: formState)),
                  Expanded(child: PitchHourlyPaycard(context: context, res: res, formState: formState)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
