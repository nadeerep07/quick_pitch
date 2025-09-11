import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/earning_card.dart';

/// ----------------------------
/// Section: Total Earnings
/// ----------------------------
class TotalEarningsCard extends StatelessWidget {
  final double amount;
  const TotalEarningsCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    return EarningCard(
      title: 'Total Earnings',
      amount: '₹${amount.toStringAsFixed(2)}',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
    );
  }
}
