import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/summary_card/breakdown_row.dart';

/// ----------------------------
/// Section: Earnings Breakdown
/// ----------------------------
class EarningsBreakdown extends StatelessWidget {
  final double pitchEarnings;
  final double hireRequestEarnings;

  const EarningsBreakdown({
    required this.pitchEarnings,
    required this.hireRequestEarnings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pie_chart, color: Colors.purple),
              SizedBox(width: 8),
              Text(
                'Earnings Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BreakdownRow(
            label: 'Pitch Earnings',
            amount: pitchEarnings,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          BreakdownRow(
            label: 'Direct Hire Earnings',
            amount: hireRequestEarnings,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

