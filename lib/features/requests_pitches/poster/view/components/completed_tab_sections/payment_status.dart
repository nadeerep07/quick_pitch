import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// Payment status widget
class PaymentStatus extends StatelessWidget {
  final PitchModel pitch;
  const PaymentStatus({required this.pitch});

  @override
  Widget build(BuildContext context) {
    final isPaid = pitch.paymentStatus == 'paid';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: isPaid ? Colors.green.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isPaid ? Colors.green.shade200 : Colors.orange.shade200)),
      child: Row(children: [
        Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color:
                    isPaid ? Colors.green.shade100 : Colors.orange.shade100,
                shape: BoxShape.circle),
            child: Icon(isPaid ? Icons.check_circle : Icons.schedule,
                size: 16,
                color: isPaid
                    ? Colors.green.shade700
                    : Colors.orange.shade700)),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('Payment Status',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isPaid
                          ? Colors.green.shade600
                          : Colors.orange.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              Text(isPaid ? 'Payment Completed' : 'Payment Pending',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isPaid
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.w600)),
            ])),
        if (!isPaid)
          Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8)),
              child: Text('Action Required',
                  style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
