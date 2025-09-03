import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/model/payment_model.dart';
import 'payment_item.dart';

class PaymentHistory extends StatelessWidget {
  final List<PaymentModel> payments;
  const PaymentHistory({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.history, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('Payment History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                Text('${payments.length} payments', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          if (payments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.payment, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No payments received yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (_, i) => PaymentItem(payment: payments[i]),
            ),
        ],
      ),
    );
  }
}
