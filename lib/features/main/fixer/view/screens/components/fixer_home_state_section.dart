import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/fixer_home_state_card.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart';

class FixerHomeStateSection extends StatelessWidget {
  const FixerHomeStateSection({
    super.key,
    required this.res,
    required this.state,
  });

  final Responsive res;
  final FixerHomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final activeTasks = state.activeTasks.length;
    final completedTasks = state.completedTasks.length;
    final totalEarnings = state.totalEarnings; // Now available from state

    return Container(
      margin: EdgeInsets.all(res.wp(5)),
      child: Row(
        children: [
          Expanded(
            child: FixerHomeStateCard(
              res: res, 
              title: 'Active Tasks',
              count: activeTasks.toString(),
              icon: Icons.task_rounded, 
              iconColor: AppColors.icon1, 
              bgColor: AppColors.iconbg1,
            ),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: FixerHomeStateCard(
              res: res, 
              title: 'Completed', 
              count: completedTasks.toString(),
              icon: Icons.check_circle_outline,
              iconColor: AppColors.icon2, 
              bgColor: AppColors.iconbg1, // Fixed: should be iconbg2
            ),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: FixerHomeStateCard(
              res: res, 
              title: 'Earnings', 
              count: '₹${totalEarnings.toStringAsFixed(0)}', // Use actual earnings
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.icon3,
              bgColor: AppColors.iconbg3,
            ),
          ),
        ],
      ),
    );
  }
}