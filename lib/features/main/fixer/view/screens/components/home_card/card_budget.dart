import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class CardBudget extends StatelessWidget {
  const CardBudget({
    super.key,
    required this.budget,
    required this.res,
  });

  final String budget;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Text(
      ' - Est. Budget: ₹$budget',
      style: TextStyle(
        fontSize: res.sp(12),
        color: Colors.black87,
      ),
    );
  }
}
