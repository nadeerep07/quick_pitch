import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PaymentPendingCard extends StatelessWidget {
  const PaymentPendingCard();

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.payment, color: Colors.orange[600], size: res.wp(5)),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: Text(
                  'You can review this poster once the payment is completed',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.orange[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
