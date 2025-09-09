import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
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
         'Must provide either pitch or hireRequest based on type'
       );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: _EnhancedPaymentDeclineView(
        type: type,
        pitch: pitch,
        hireRequest: hireRequest,
        onDeclinePayment: onDeclinePayment,
      ),
    );
  }
}

class _EnhancedPaymentDeclineView extends StatelessWidget {
  final DeclineDialogType type;
  final PitchModel? pitch;
  final HireRequest? hireRequest;
  final Function(String reason) onDeclinePayment;
  final _reasonController = TextEditingController();

  _EnhancedPaymentDeclineView({
    required this.type,
    this.pitch,
    this.hireRequest,
    required this.onDeclinePayment,
  });

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
                // Header
                Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red[500], size: res.wp(6)),
                    SizedBox(width: res.wp(3)),
                    Expanded(
                      child: Text(
                        'Decline Payment Request',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: res.hp(1)),

                // Task info
                Container(
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
                ),
                SizedBox(height: res.hp(2)),

                Text(
                  'Please select a reason for declining:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: res.hp(1.5)),

                // Reason selection
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: res.hp(25),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _predefinedReasons.map((reason) => 
                        RadioListTile<String>(
                          title: Text(
                            reason,
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: reason,
                          groupValue: state.selectedReason,
                          onChanged: (value) =>
                              context.read<PaymentCubit>().selectReason(value),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        )
                      ).toList(),
                    ),
                  ),
                ),

                // Custom reason input
                if (state.selectedReason == 'Other (specify below)') ...[
                  SizedBox(height: res.hp(1)),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Please specify the reason...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(res.wp(3)),
                    ),
                  ),
                ],

                SizedBox(height: res.hp(3)),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: res.wp(3)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.selectedReason != null
                            ? () {
                                final reason = state.selectedReason ==
                                        'Other (specify below)'
                                    ? _reasonController.text.trim()
                                    : state.selectedReason!;

                                if (reason.isNotEmpty) {
                                  Navigator.of(context).pop();
                                  onDeclinePayment(reason);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                        ),
                        child: const Text('Decline Payment'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTaskTitle() {
    if (type == DeclineDialogType.pitch) {
      return pitch!.pitchText ?? 'Untitled Task';
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
}