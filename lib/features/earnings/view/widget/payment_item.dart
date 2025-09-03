import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/model/payment_model.dart';

class PaymentItem extends StatelessWidget {
  final PaymentModel payment;
  const PaymentItem({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: payment.posterImage != null ? NetworkImage(payment.posterImage!) : null,
            child: payment.posterImage == null ? Icon(Icons.person, color: Colors.blue.shade600) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(payment.posterName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(_formatDate(payment.paidAt),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              if (payment.transactionId.isNotEmpty)
                Text('ID: ${payment.transactionId}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${payment.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
                child: Text(payment.status.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.green.shade700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
