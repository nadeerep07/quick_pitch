import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';
import 'earning_card.dart';

class EarningSummary extends StatelessWidget {
  final EarningsLoaded state;
  const EarningSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EarningCard(
            title: 'Total Earnings',
            amount: '₹${state.totalEarnings.toStringAsFixed(2)}',
            icon: Icons.account_balance_wallet,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: EarningCard(
            title: 'This Month',
            amount: '₹${state.thisMonthEarnings.toStringAsFixed(2)}',
            icon: Icons.calendar_month,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
