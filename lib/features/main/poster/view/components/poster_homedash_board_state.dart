import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_state_card.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/poster_home_screen.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

class PosterHomedashBoardState extends StatelessWidget {
  const PosterHomedashBoardState({
    super.key,
    required this.res,
    required this.state,
  });

  final Responsive res;
  final PosterHomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final pendingTasks =
        state.tasks
            .where((task) => task.status.toLowerCase() == 'pending')
            .length;
    final assignedTasks =
        state.tasks
            .where((task) => task.status.toLowerCase() == 'assigned')
            .length;

    final completedTasks =
        state.tasks
            .where((task) => task.status.toLowerCase() == 'completed')
            .length;

    return Container(
      margin: EdgeInsets.all(res.wp(5)),
      child: Row(
        children: [
          Expanded(
            child: PosterHomeStateCard(res: res, title: 'Pending Tasks', count: pendingTasks.toString(), icon: Icons.pending_actions, iconColor: const Color(0xFF3B82F6), bgColor: const Color(0xFFEFF6FF)),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: PosterHomeStateCard(res: res, title: 'Assigned Tasks', count: assignedTasks.toString(), icon: Icons.assignment_turned_in, iconColor: const Color(0xFF10B981), bgColor: const Color(0xFFECFDF5)),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: PosterHomeStateCard(res: res, title: 'Completed Tasks', count: completedTasks.toString(), icon: Icons.check_circle_outline, iconColor: const Color(0xFF10B981), bgColor: const Color(0xFFECFDF5)),
          ),
        ],
      ),
    );
  }
}
