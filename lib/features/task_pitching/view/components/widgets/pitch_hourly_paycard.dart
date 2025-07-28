import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/payment_type_card.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class PitchHourlyPaycard extends StatelessWidget {
  const PitchHourlyPaycard({
    super.key,
    required this.context,
    required this.res,
    required this.formState,
  });

  final BuildContext context;
  final Responsive res;
  final PitchFormState formState;

  @override
  Widget build(BuildContext context) {
    return PaymentTypeCard(
      icon: Icons.timer,
      title: 'Hourly Pay',
      isSelected: formState.paymentType == PaymentType.hourly,
      onTap: () => context.read<PitchFormCubit>().changePaymentType(PaymentType.hourly),
      res: res,
    );
  }
}
