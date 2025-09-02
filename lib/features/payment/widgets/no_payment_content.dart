import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/payment/widgets/payment_detail_row.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// ---------------------- NO PAYMENT CONTENT ----------------------
class NoPaymentContent extends StatelessWidget {
  final PitchModel pitch;
  final Responsive res;
  final ThemeData theme;
  final VoidCallback? onInitiatePayment;

  const NoPaymentContent({
    super.key,
    required this.pitch,
    required this.res,
    required this.theme,
    this.onInitiatePayment,
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
          icon: Icons.account_balance_wallet,
          label: 'Agreed Budget',
          value: '\$${pitch.budget.toStringAsFixed(2)}',
          valueColor: Colors.blue[600],
        ),
        if (onInitiatePayment != null) ...[
          SizedBox(height: res.hp(2)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onInitiatePayment,
              icon: Icon(Icons.payment, size: res.wp(4)),
              label: Text('Pay Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBanner() => Container(
        width: double.infinity,
        padding: EdgeInsets.all(res.wp(3)),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue[600], size: res.wp(4)),
            SizedBox(width: res.wp(2)),
            Expanded(
              child: Text(
                'Task completed! You can pay the fixer or wait for their payment request.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}

