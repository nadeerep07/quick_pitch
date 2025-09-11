import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/model/payment_model.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/payment_items/payment_amount_and_status.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/payment_items/payment_avatar.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/payment_items/payment_details.dart';

class PaymentItem extends StatelessWidget {
  final PaymentModel payment;
  const PaymentItem({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          PaymentAvatar(posterImage: payment.posterImage),
          const SizedBox(width: 16),
          Expanded(
            child: PaymentDetails(
              posterName: payment.posterName,
              paidAt: payment.paidAt,
              transactionId: payment.transactionId,
              isHireRequestPayment: payment.isHireRequestPayment,
            ),
          ),
          const SizedBox(width: 12),
          PaymentAmountAndStatus(
            amount: payment.amount,
            status: payment.status,
          ),
        ],
      ),
    );
  }
}

