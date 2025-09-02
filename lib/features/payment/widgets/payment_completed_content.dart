import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_detail_row.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// ---------------------- COMPLETED CONTENT ----------------------
class PaymentCompletedContent extends StatelessWidget {
  final PitchModel pitch;
  final Responsive res;
  final ThemeData theme;

  const PaymentCompletedContent({
    super.key,
    required this.pitch,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBanner(),
        SizedBox(height: res.hp(2)),
        if (pitch.requestedPaymentAmount != null)
          PaymentDetailRow(
            res: res,
            theme: theme,
            icon: Icons.attach_money,
            label: 'Payment Amount',
            value: '\$${pitch.requestedPaymentAmount!.toStringAsFixed(2)}',
            valueColor: Colors.green[600],
          ),
      ],
    );
  }

  Widget _buildBanner() => Container(
        width: double.infinity,
        padding: EdgeInsets.all(res.wp(3)),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: res.wp(4)),
            SizedBox(width: res.wp(2)),
            Expanded(
              child: Text(
                'Payment has been completed successfully!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}

