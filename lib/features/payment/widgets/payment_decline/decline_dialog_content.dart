import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/payment/components/payment_decline_dialog.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_decline/action_buttons.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_decline/custom_reason_field.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_decline/dialog_header.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_decline/reason_selector.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_decline/task_info_box.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class DeclineDialogContent extends StatelessWidget {
  final DeclineDialogType type;
  final PitchModel? pitch;
  final HireRequest? hireRequest;
  final Function(String reason) onDeclinePayment;

  DeclineDialogContent({
    required this.type,
    this.pitch,
    this.hireRequest,
    required this.onDeclinePayment,
  });

  final _reasonController = TextEditingController();

  final List<String> _predefinedReasons = [
    'Amount is higher than agreed budget',
    'Task was not completed as specified',
    'Work quality does not meet requirements',
    'Delivery was late',
    'Requirements were not followed',
    'Communication was poor',
    'Other (specify below)',
  ];

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(res.wp(5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DialogHeader(res: res, theme: theme),
                SizedBox(height: res.hp(1)),
                TaskInfoBox(
                  type: type,
                  pitch: pitch,
                  hireRequest: hireRequest,
                  theme: theme,
                  res: res,
                ),
                SizedBox(height: res.hp(2)),
                ReasonSelector(
                  predefinedReasons: _predefinedReasons,
                  selectedReason: state.selectedReason,
                  onSelectReason: (val) =>
                      context.read<PaymentCubit>().selectReason(val),
                  res: res,
                  theme: theme,
                ),
                if (state.selectedReason == 'Other (specify below)') ...[
                  SizedBox(height: res.hp(1)),
                  CustomReasonField(
                    controller: _reasonController,
                    res: res,
                  ),
                ],
                SizedBox(height: res.hp(3)),
                ActionButtons(
                  selectedReason: state.selectedReason,
                  reasonController: _reasonController,
                  onDeclinePayment: onDeclinePayment,
                  res: res,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
