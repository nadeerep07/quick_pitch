import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/viewmodel/cubit/payment_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentDeclineDialog extends StatelessWidget {
  final PitchModel pitch;
  final Function(String reason) onDeclinePayment;

  const PaymentDeclineDialog({
    super.key,
    required this.pitch,
    required this.onDeclinePayment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: _PaymentDeclineView(pitch: pitch, onDeclinePayment: onDeclinePayment),
    );
  }
}

class _PaymentDeclineView extends StatelessWidget {
  final PitchModel pitch;
  final Function(String reason) onDeclinePayment;
  final _reasonController = TextEditingController();

  _PaymentDeclineView({required this.pitch, required this.onDeclinePayment});

  final List<String> _predefinedReasons = [
    'Amount is higher than agreed budget',
    'Task was not completed as specified',
    'Work quality does not meet requirements',
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
                SizedBox(height: res.hp(2)),

                Text(
                  'Please select a reason for declining:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: res.hp(1.5)),

                ..._predefinedReasons.map((reason) => RadioListTile<String>(
                      title: Text(reason, style: theme.textTheme.bodyMedium),
                      value: reason,
                      groupValue: state.selectedReason,
                      onChanged: (value) =>
                          context.read<PaymentCubit>().selectReason(value),
                      contentPadding: EdgeInsets.zero,
                    )),

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
                    ),
                  ),
                ],

                SizedBox(height: res.hp(3)),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
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
                        ),
                        child: const Text('Decline'),
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
}
