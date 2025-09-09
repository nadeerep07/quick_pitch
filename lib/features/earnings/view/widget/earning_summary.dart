import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/earning_card.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';

class EarningSummary extends StatelessWidget {
  final EarningsLoaded state;

  const EarningSummary({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Total Earnings Card
        EarningCard(
          title: 'Total Earnings',
          amount: '₹${state.totalEarnings.toStringAsFixed(2)}',
          icon: Icons.account_balance_wallet,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        
        // Row with This Month and Earnings Breakdown
        Row(
          children: [
            Expanded(
              child: EarningCard(
                title: 'This Month',
                amount: '₹${state.thisMonthEarnings.toStringAsFixed(2)}',
                icon: Icons.calendar_today,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EarningCard(
                title: 'Completed Jobs',
                amount: '${state.paymentHistory.length}',
                icon: Icons.check_circle,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        
        // Earnings Breakdown
        if (state.pitchEarnings > 0 || state.hireRequestEarnings > 0) ...[
          const SizedBox(height: 16),
          Container(
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
                
                // Pitch Earnings
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pitch Earnings',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Text(
                      '₹${state.pitchEarnings.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Hire Request Earnings
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Direct Hire Earnings',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Text(
                      '₹${state.hireRequestEarnings.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}