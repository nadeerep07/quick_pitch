import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentBuildDetails extends StatelessWidget {
  final bool isFromRequest;
  final PitchModel pitch;
  final Responsive res;
  final ThemeData theme;
  final double paymentAmount;

  const PaymentBuildDetails({
    super.key,
    required this.isFromRequest,
    required this.pitch,
    required this.res,
    required this.theme,
    required this.paymentAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            'Amount:',
            '₹${paymentAmount.toStringAsFixed(2)}',
            theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[600],
            ),
          ),
          SizedBox(height: res.hp(1)),
          _buildDetailRow(
            'Gateway:',
            'Secure Payment',
            theme.textTheme.bodySmall!.copyWith(
              color: Colors.green[600],
              fontWeight: FontWeight.w500,
            ),
            icon: Image.asset(
              'assets/images/razorpay_logo.png',
              height: res.hp(2),
              errorBuilder: (context, _, __) =>
                  Text('Razorpay', style: theme.textTheme.bodySmall),
            ),
          ),
          if (isFromRequest &&
              pitch.paymentRequestNotes != null &&
              pitch.paymentRequestNotes!.isNotEmpty) ...[
            SizedBox(height: res.hp(1.5)),
            Divider(color: Colors.grey[300]),
            SizedBox(height: res.hp(1)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Notes: ${pitch.paymentRequestNotes!}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, TextStyle style,
      {Widget? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style.copyWith(fontWeight: FontWeight.w500)),
        Row(
          children: [
            if (icon != null) ...[icon, SizedBox(width: 6)],
            Text(value, style: style),
          ],
        ),
      ],
    );
  }
}
