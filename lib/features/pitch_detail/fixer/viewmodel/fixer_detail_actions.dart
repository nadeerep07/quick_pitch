import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/payemnt_request/payment_request_dialog.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

extension FixerPitchDetailActions on FixerPitchDetailCubit {
  /// When user clicks request payment button
  void onRequestPaymentClicked(BuildContext context, PitchModel pitch) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PaymentRequestDialog(
        pitch: pitch,
        onRequestPayment: (amount, notes) async {
          try {
            await requestPayment(pitchId: pitch.id, amount: amount, notes: notes);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment request sent successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to send payment request: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  /// When user clicks cancel payment button
  void onCancelPaymentClicked(BuildContext context, PitchModel pitch) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Cancel Request'),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel the payment request? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Keep Request'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await cancelPaymentRequest(pitch.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Payment request cancelled successfully'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to cancel payment request: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
