import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_confirmation_dialog/detail_row.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class DialogDetails extends StatelessWidget {
  final String taskTitle;
  final double paymentAmount;
  final PitchModel? pitch;
  final HireRequest? hireRequest;
  final PaymentType paymentType;
  final bool isFromRequest;
  final Responsive res;
  final ThemeData theme;

  const DialogDetails({
    required this.taskTitle,
    required this.paymentAmount,
    this.pitch,
    this.hireRequest,
    required this.paymentType,
    required this.isFromRequest,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          DetailRow(label: 'Task', value: taskTitle, res: res, theme: theme),
          SizedBox(height: res.hp(1)),
          DetailRow(
            label: 'Amount',
            value: '₹${paymentAmount.toStringAsFixed(2)}',
            res: res,
            theme: theme,
          ),
          if (isFromRequest && paymentType == PaymentType.pitch) ...[
            SizedBox(height: res.hp(1)),
            if (pitch?.paymentRequestNotes != null)
              DetailRow(
                label: 'Notes',
                value: pitch!.paymentRequestNotes!,
                res: res,
                theme: theme,
              ),
          ],
          if (isFromRequest && paymentType == PaymentType.hireRequest) ...[
            SizedBox(height: res.hp(1)),
            if (hireRequest?.paymentRequestNotes != null)
              DetailRow(
                label: 'Notes',
                value: hireRequest!.paymentRequestNotes!,
                res: res,
                theme: theme,
              ),
          ],
        ],
      ),
    );
  }
}
