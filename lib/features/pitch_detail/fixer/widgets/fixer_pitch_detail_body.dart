import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_assigned_actions.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_completion_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_header_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_progress_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_rejection_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_repitch_button.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_task_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/payemnt_request/payment_request_dialog.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/payemnt_request/payment_status_widget.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_processing_overlay.dart';

Widget buildPitchDetailBody({
  required BuildContext context,
  required Responsive res,
  required FixerPitchDetailState state,
  required PitchModel currentPitch,
  required TaskPostModel? currentTask,
  required ColorScheme colorScheme,
  required ThemeData theme,
  required bool isAssigned,
  required bool isCompleted,
  required bool isRejected,
}) {
  return Stack(
    children: [
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          res.wp(5),
          res.hp(12),
          res.wp(5),
          res.hp(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FixerPitchHeaderCard(
              currentPitch: currentPitch,
              res: res,
              theme: theme,
              colorScheme: colorScheme,
              isAssigned: isAssigned,
              isCompleted: isCompleted,
            ),
            SizedBox(height: res.hp(2)),
            
            // Completion section
            if (isCompleted) ...[
              FixerPitchDetailCompletionSection(
                res: res,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
              SizedBox(height: res.hp(2)),
            ],

            // Payment status section - Add this after completion
            if (isCompleted) ...[
              PaymentStatusSection(
                pitch: currentPitch,
                res: res,
                theme: theme,
                colorScheme: colorScheme,
                onRequestPayment: currentPitch.paymentStatus == null
                    ? () => _showPaymentRequestDialog(context, currentPitch)
                    : null,
                onCancelPaymentRequest: currentPitch.paymentStatus == 'requested'
                    ? () => _showCancelPaymentDialog(context, currentPitch)
                    : null,
              ),
              SizedBox(height: res.hp(2)),
            ],
            
            // Rejection section
            if (isRejected) ...[
              FixerPitchDetailRejectionCard(
                res: res,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
              SizedBox(height: res.hp(2)),
            ],

            // Task details
            FixerPitchDetailTaskCard(
              res: res,
              task: currentTask!,
              theme: theme,
              colorScheme: colorScheme,
            ),
            SizedBox(height: res.hp(2)),

            // Progress section
            if (isAssigned || isCompleted) ...[
              FixerPitchDetailProgressSection(
                res: res,
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
              SizedBox(height: res.hp(2)),
            ],

            // Repitch button for rejected pitches
            if (isRejected) ...[
              FixerPitchDetailRepitchButton(
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                currentPitch: currentPitch,
              ),
              SizedBox(height: res.hp(2)),
            ],

            // Action buttons for assigned pitches
            if (isAssigned) ...[
              FixerPitchDetailAssignedActions(
                context: context,
                res: res,
                currentPitch: currentPitch,
                colorScheme: colorScheme,
                theme: theme,
              ),
              SizedBox(height: res.hp(2)),
            ],
          ],
        ),
      ),
      
      // Processing overlay
      if (state is FixerPitchDetailProcessing)
        FixerPitchProcessingOverlay(
          colorScheme: colorScheme,
          theme: theme,
          message: state.message,
        ),
    ],
  );
}

// Helper functions for payment dialogs
void _showPaymentRequestDialog(BuildContext context, PitchModel pitch) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => PaymentRequestDialog(
      pitch: pitch,
      onRequestPayment: (amount, notes) async {
        try {
          await context.read<FixerPitchDetailCubit>().requestPayment(
            pitchId: pitch.id,
            amount: amount,
            notes: notes,
          );
          
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
                content: Text('Failed to send payment request: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    ),
  );
}

void _showCancelPaymentDialog(BuildContext context, PitchModel pitch) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 8),
          Text('Cancel Payment Request'),
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
              await context.read<FixerPitchDetailCubit>().cancelPaymentRequest(pitch.id);
              
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
                    content: Text('Failed to cancel payment request: ${e.toString()}'),
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
          child: Text('Yes, Cancel'),
        ),
      ],
    ),
  );
}
