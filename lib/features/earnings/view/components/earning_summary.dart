import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/summary_card/earnings_breakdown.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/summary_card/this_month_and_jobs_row.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/summary_card/total_earnings_card.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';

class EarningSummary extends StatelessWidget {
  final EarningsLoaded state;
  final bool isFiltered;

  const EarningSummary({
    super.key, 
    required this.state,
    this.isFiltered = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate values based on filter state
    final totalEarnings = isFiltered 
        ? state.filteredTotalEarnings 
        : state.totalEarnings;
    
    final completedJobs = isFiltered 
        ? state.filteredCompletedJobs 
        : state.paymentHistory.length;
    
    final thisMonthEarnings = isFiltered 
        ? state.filteredTotalEarnings 
        : state.thisMonthEarnings;
    
    final pitchEarnings = isFiltered 
        ? state.filteredPitchEarnings 
        : state.pitchEarnings;
    
    final hireRequestEarnings = isFiltered 
        ? state.filteredHireRequestEarnings 
        : state.hireRequestEarnings;
    
    final showBreakdown = pitchEarnings > 0 || hireRequestEarnings > 0;
    
    return Column(
      children: [
        TotalEarningsCard(amount: totalEarnings),
        const SizedBox(height: 16),
        ThisMonthAndJobsRow(
          thisMonthEarnings: thisMonthEarnings,
          completedJobs: completedJobs,
        ),
        if (showBreakdown) ...[
          const SizedBox(height: 16),
          EarningsBreakdown(
            pitchEarnings: pitchEarnings,
            hireRequestEarnings: hireRequestEarnings,
          ),
        ],
      ],
    );
  }
}