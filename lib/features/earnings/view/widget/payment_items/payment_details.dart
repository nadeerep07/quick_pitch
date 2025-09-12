import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/utils/date_formatter.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/payment_items/payment_type_badge.dart';

class PaymentDetails extends StatelessWidget {
  final String posterName;
  final DateTime paidAt;
  final String transactionId;
  final bool isHireRequestPayment;

  const PaymentDetails({super.key, 
    required this.posterName,
    required this.paidAt,
    required this.transactionId,
    required this.isHireRequestPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                posterName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            PaymentTypeBadge(isHireRequest: isHireRequestPayment),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          DateFormatter.formatDate(paidAt),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        if (transactionId.isNotEmpty)
          Text(
            'ID: $transactionId',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
      ],
    );
  }
}

