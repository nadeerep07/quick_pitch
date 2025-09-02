import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/payment_request_cubit.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/payment_request/payment_request_form.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentRequestDialog extends StatelessWidget {
  final PitchModel pitch;
  final Future<void> Function(double amount, String notes) onRequestPayment;

  const PaymentRequestDialog({
    super.key,
    required this.pitch,
    required this.onRequestPayment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentRequestCubit(),
      child: PaymentRequestForm(pitch: pitch, onRequestPayment: onRequestPayment),
    );
  }
}
