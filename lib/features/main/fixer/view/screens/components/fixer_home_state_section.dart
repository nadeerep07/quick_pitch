import 'package:flutter/material.dart';
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
    final availableTasks = state.newTasks.length;
    final completedTasks = 0; // You might want to get this from state
    final totalEarnings = 0; // You might want to get this from state

    return Container(
      margin: EdgeInsets.all(res.wp(5)),
      child: Row(
        children: [
          Expanded(
            child: FixerHomeStateCard(res: res, title: 'Available', count: availableTasks.toString(), icon: Icons.work_outline, iconColor: const Color(0xFF3B82F6), bgColor: const Color(0xFFEFF6FF)),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: FixerHomeStateCard(res: res, title: 'Completed', count: completedTasks.toString(), icon: Icons.check_circle_outline, iconColor: const Color(0xFF10B981), bgColor: const Color(0xFFECFDF5)),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: FixerHomeStateCard(res: res, title: 'Earnings', count: '₹$totalEarnings', icon: Icons.account_balance_wallet_outlined, iconColor: const Color(0xFF8B5CF6), bgColor: const Color(0xFFF3E8FF)),
          ),
        ],
      ),
    );
  }
}
