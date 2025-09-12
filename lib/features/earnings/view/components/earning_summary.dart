import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/summary_card/earnings_breakdown.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/summary_card/this_month_and_jobs_row.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/summary_card/total_earnings_card.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';

class EarningSummary extends StatelessWidget {
  final EarningsLoaded state;

  const EarningSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TotalEarningsCard(amount: state.totalEarnings),
        const SizedBox(height: 16),
        ThisMonthAndJobsRow(
          thisMonthEarnings: state.thisMonthEarnings,
          completedJobs: state.paymentHistory.length,
        ),
        if (state.pitchEarnings > 0 || state.hireRequestEarnings > 0) ...[
          const SizedBox(height: 16),
          EarningsBreakdown(
            pitchEarnings: state.pitchEarnings,
            hireRequestEarnings: state.hireRequestEarnings,
          ),
        ],
      ],
    );
  }
}

