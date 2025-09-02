import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PaymentSecurityInfo extends StatelessWidget {
  const PaymentSecurityInfo({
    super.key,
    required this.res,
    required this.theme,
  });

  final Responsive res;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(res.wp(3)),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.security, color: Colors.blue[700], size: res.wp(4)),
            SizedBox(width: res.wp(2)),
            Expanded(
              child: Text(
                'Payments are processed securely via Razorpay. Your card details are never stored.',
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
