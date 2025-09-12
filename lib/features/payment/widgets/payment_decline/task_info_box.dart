import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/payment/components/payment_decline_dialog.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class TaskInfoBox extends StatelessWidget {
  final DeclineDialogType type;
  final PitchModel? pitch;
  final HireRequest? hireRequest;
  final ThemeData theme;
  final Responsive res;

  const TaskInfoBox({super.key, 
    required this.type,
    this.pitch,
    this.hireRequest,
    required this.theme,
    required this.res,
  });

  String _getTaskTitle() {
    if (type == DeclineDialogType.pitch) {
      return pitch!.pitchText ;
    } else {
      return hireRequest!.workTitle;
    }
  }

  double _getRequestedAmount() {
    if (type == DeclineDialogType.pitch) {
      return pitch!.requestedPaymentAmount ?? pitch!.budget;
    } else {
      return hireRequest!.requestedPaymentAmount ?? hireRequest!.workAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task: ${_getTaskTitle()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: res.hp(0.5)),
          Text(
            'Requested Amount: ₹${_getRequestedAmount().toStringAsFixed(0)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
