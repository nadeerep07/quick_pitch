import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/earning_card.dart';

class ThisMonthAndJobsRow extends StatelessWidget {
  final double thisMonthEarnings;
  final int completedJobs;

  const ThisMonthAndJobsRow({
    required this.thisMonthEarnings,
    required this.completedJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EarningCard(
            title: 'This Month',
            amount: '₹${thisMonthEarnings.toStringAsFixed(2)}',
            icon: Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: EarningCard(
            title: 'Completed Jobs',
            amount: '$completedJobs',
            icon: Icons.check_circle,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

