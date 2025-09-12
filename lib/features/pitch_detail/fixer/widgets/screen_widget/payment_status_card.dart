import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/payment_detail_row.dart';

class PaymentStatusCard extends StatelessWidget {
  final HireRequest request;

  const PaymentStatusCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (request.isPaymentCompleted) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Payment Completed';
    } else if (request.hasPaymentRequest) {
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_empty;
      statusText = 'Payment Requested';
    } else if (request.isPaymentDeclined) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
      statusText = 'Payment Declined';
    } else if (request.canRequestPayment) {
      statusColor = Colors.blue;
      statusIcon = Icons.payment;
      statusText = 'Ready to Request Payment';
    } else {
      statusColor = theme.colorScheme.outline;
      statusIcon = Icons.payment;
      statusText = 'No Payment Activity';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet,
                  color: statusColor, size: res.wp(5)),
              SizedBox(width: res.wp(2)),
              Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: res.wp(3)),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: res.wp(5)),
              SizedBox(width: res.wp(2)),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (request.requestedPaymentAmount != null)
            PaymentDetailRow(
              label: 'Requested Amount',
              value: '₹${request.requestedPaymentAmount!.toStringAsFixed(0)}',
              res: res,
              theme: theme,
            ),
          if (request.paidAmount != null)
            PaymentDetailRow(
              label: 'Paid Amount',
              value: '₹${request.paidAmount!.toStringAsFixed(0)}',
              res: res,
              theme: theme,
              valueColor: Colors.green,
            ),
          if (request.paymentRequestedAt != null)
            PaymentDetailRow(
              label: 'Requested On',
              value: _formatDate(request.paymentRequestedAt!),
              res: res,
              theme: theme,
            ),
          if (request.paymentCompletedAt != null)
            PaymentDetailRow(
              label: 'Completed On',
              value: _formatDate(request.paymentCompletedAt!),
              res: res,
              theme: theme,
              valueColor: Colors.green,
            ),
          if (request.paymentDeclinedAt != null)
            PaymentDetailRow(
              label: 'Declined On',
              value: _formatDate(request.paymentDeclinedAt!),
              res: res,
              theme: theme,
              valueColor: Colors.red,
            ),
          if (request.paymentDeclineReason?.isNotEmpty ?? false)
            PaymentDetailRow(
              label: 'Decline Reason',
              value: request.paymentDeclineReason!,
              res: res,
              theme: theme,
              isMultiline: true,
              valueColor: Colors.red,
            ),
          if (request.paymentRequestNotes?.isNotEmpty ?? false)
            PaymentDetailRow(
              label: 'Request Notes',
              value: request.paymentRequestNotes!,
              res: res,
              theme: theme,
              isMultiline: true,
            ),
          if (request.transactionId?.isNotEmpty ?? false)
            PaymentDetailRow(
              label: 'Transaction ID',
              value: request.transactionId!,
              res: res,
              theme: theme,
            ),
        ],
      ),
    );
  }
}
String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}