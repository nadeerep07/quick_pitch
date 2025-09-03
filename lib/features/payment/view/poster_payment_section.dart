import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/widgets/no_payment_content.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_completed_content.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_header.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_requested_content.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// ---------------------- MAIN SECTION ----------------------
class PosterPaymentSection extends StatelessWidget {
  final PitchModel pitch;
  final VoidCallback? onApprovePayment;
  final VoidCallback? onDeclinePayment;
  final VoidCallback? onInitiatePayment;

  const PosterPaymentSection({
    super.key,
    required this.pitch,
    this.onApprovePayment,
    this.onDeclinePayment,
    this.onInitiatePayment,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    // Only show for completed tasks
    if (pitch.status != 'completed') return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: _getBackgroundColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _getBorderColor(), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaymentHeader(pitch: pitch, res: res, theme: theme),
            SizedBox(height: res.hp(2)),
            _buildContent(context, res, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Responsive res, ThemeData theme) {
    switch (pitch.paymentStatus) {
      case 'requested':
        return PaymentRequestedContent(
          pitch: pitch,
          res: res,
          theme: theme,
          onApprovePayment: onApprovePayment,
          onDeclinePayment: onDeclinePayment,
        );
      case 'completed':
        return PaymentCompletedContent(pitch: pitch, res: res, theme: theme);
      default:
        return NoPaymentContent(
          pitch: pitch,
          res: res,
          theme: theme,
          onInitiatePayment: onInitiatePayment,
        );
    }
  }

  Color _getBackgroundColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[50]!;
      case 'completed':
        return Colors.green[50]!;
      case 'declined':
        return Colors.red[50]!;
      default:
        return Colors.blue[50]!;
    }
  }

  Color _getBorderColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[200]!;
      case 'completed':
        return Colors.green[200]!;
      case 'declined':
        return Colors.red[200]!;
      default:
        return Colors.blue[200]!;
    }
  }
}

