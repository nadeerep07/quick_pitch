import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_decline/decline_dialog_content.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

enum DeclineDialogType { pitch, hireRequest }

class PaymentDeclineDialog extends StatelessWidget {
  final DeclineDialogType type;
  final PitchModel? pitch;
  final HireRequest? hireRequest;
  final Function(String reason) onDeclinePayment;

  const PaymentDeclineDialog({
    super.key,
    required this.type,
    this.pitch,
    this.hireRequest,
    required this.onDeclinePayment,
  }) : assert(
          (type == DeclineDialogType.pitch && pitch != null) ||
              (type == DeclineDialogType.hireRequest && hireRequest != null),
          'Must provide either pitch or hireRequest based on type',
        );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: DeclineDialogContent(
        type: type,
        pitch: pitch,
        hireRequest: hireRequest,
        onDeclinePayment: onDeclinePayment,
      ),
    );
  }
}
