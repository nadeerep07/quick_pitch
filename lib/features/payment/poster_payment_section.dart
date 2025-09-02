import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/widgets/no_payment_content.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_completed_content.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_detail_row.dart';
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

/// ---------------------- HEADER ----------------------
class PaymentHeader extends StatelessWidget {
  final PitchModel pitch;
  final Responsive res;
  final ThemeData theme;

  const PaymentHeader({
    super.key,
    required this.pitch,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatusIcon(),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getHeaderText(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(),
                ),
              ),
              if (_getSubHeaderText() != null) ...[
                SizedBox(height: res.hp(0.5)),
                Text(
                  _getSubHeaderText()!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (pitch.paymentStatus == 'completed') _buildPaidChip(),
      ],
    );
  }

  Widget _buildStatusIcon() {
    return Container(
      padding: EdgeInsets.all(res.wp(2)),
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getStatusIcon(),
        color: _getIconColor(),
        size: res.wp(5),
      ),
    );
  }

  Widget _buildPaidChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: res.wp(3), vertical: res.hp(0.8)),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: Colors.green[700], size: res.wp(3.5)),
          SizedBox(width: res.wp(1)),
          Text(
            'PAID',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  IconData _getStatusIcon() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Icons.pending_actions;
      case 'completed':
        return Icons.check_circle;
      case 'declined':
        return Icons.cancel;
      default:
        return Icons.payment;
    }
  }

  Color _getIconColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[600]!;
      case 'completed':
        return Colors.green[600]!;
      case 'declined':
        return Colors.red[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  Color _getIconBackgroundColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[100]!;
      case 'completed':
        return Colors.green[100]!;
      case 'declined':
        return Colors.red[100]!;
      default:
        return Colors.blue[100]!;
    }
  }

  String _getHeaderText() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return 'Payment Request Received';
      case 'completed':
        return 'Payment Completed';
      case 'declined':
        return 'Payment Request Declined';
      default:
        return 'Payment';
    }
  }

  String? _getSubHeaderText() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return 'Review and approve the payment request';
      case 'completed':
        return 'Payment has been processed successfully';
      case 'declined':
        return 'The payment request was declined';
      default:
        return 'Task completed - ready for payment';
    }
  }

  Color _getTextColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[700]!;
      case 'completed':
        return Colors.green[700]!;
      case 'declined':
        return Colors.red[700]!;
      default:
        return Colors.blue[700]!;
    }
  }
}

