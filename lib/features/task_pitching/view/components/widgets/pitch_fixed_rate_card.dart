import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/payment_type_card.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class PitchFixedRateCard extends StatelessWidget {
  const PitchFixedRateCard({
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
      icon: Icons.price_check,
      title: 'Fixed Rate',
      isSelected: formState.paymentType == PaymentType.fixed,
      onTap: () => context.read<PitchFormCubit>().changePaymentType(PaymentType.fixed),
      res: res,
    );
  }
}
