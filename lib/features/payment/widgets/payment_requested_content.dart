import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_detail_row.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// ---------------------- REQUESTED CONTENT ----------------------
class PaymentRequestedContent extends StatelessWidget {
  final PitchModel pitch;
  final Responsive res;
  final ThemeData theme;
  final VoidCallback? onApprovePayment;
  final VoidCallback? onDeclinePayment;

  const PaymentRequestedContent({
    super.key,
    required this.pitch,
    required this.res,
    required this.theme,
    this.onApprovePayment,
    this.onDeclinePayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBanner(),
        SizedBox(height: res.hp(2)),
        PaymentDetailRow(
          res: res,
          theme: theme,
          icon: Icons.attach_money,
          label: 'Requested Amount',
          value: '\$${pitch.requestedPaymentAmount?.toStringAsFixed(2) ?? pitch.budget.toStringAsFixed(2)}',
          valueColor: Colors.green[600],
        ),
        SizedBox(height: res.hp(1.5)),
        if (pitch.paymentRequestedAt != null) ...[
          PaymentDetailRow(
            res: res,
            theme: theme,
            icon: Icons.schedule,
            label: 'Requested On',
            value: DateFormat('MMM dd, yyyy • hh:mm a').format(pitch.paymentRequestedAt!),
          ),
          SizedBox(height: res.hp(1.5)),
        ],
        if (pitch.paymentRequestNotes?.isNotEmpty == true) ...[
          PaymentDetailRow(
            res: res,
            theme: theme,
            icon: Icons.note_alt_outlined,
            label: 'Request Notes',
            value: pitch.paymentRequestNotes!,
            isMultiline: true,
          ),
          SizedBox(height: res.hp(2)),
        ],
        _buildActions(),
      ],
    );
  }

  Widget _buildBanner() => Container(
        width: double.infinity,
        padding: EdgeInsets.all(res.wp(3)),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.notification_important, color: Colors.orange[600], size: res.wp(4)),
            SizedBox(width: res.wp(2)),
            Expanded(
              child: Text(
                'The fixer has requested payment for this completed task.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildActions() => Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDeclinePayment,
              icon: Icon(Icons.close, size: res.wp(4)),
              label: Text('Decline'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red[600],
                side: BorderSide(color: Colors.red[300]!, width: 1.5),
                padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(width: res.wp(3)),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onApprovePayment,
              icon: Icon(Icons.check, size: res.wp(4)),
              label: Text('Approve & Pay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      );
}

