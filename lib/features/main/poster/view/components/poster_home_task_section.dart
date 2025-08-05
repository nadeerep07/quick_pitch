import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_empty_state.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_task_card.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/screen/poster_task_detail_listview_screen.dart';

class PosterHomeTaskSection extends StatelessWidget {
  const PosterHomeTaskSection({
    super.key,
    required this.res,
    required this.state,
    required this.context,
  });

  final Responsive res;
  final PosterHomeLoaded state;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    if (state.tasks.isEmpty) {
      return Container(
        margin: EdgeInsets.all(res.wp(5)),
        child: PosterHomeEmptyState(res: res, title: 'No Tasks Yet', subtitle: 'Start by posting your first task', icon: Icons.assignment_outlined),
      );
    }

    final sortedTasks = [...state.tasks];
    sortedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentTasks = sortedTasks.take(3).toList();

    return Container(
      margin: EdgeInsets.fromLTRB(res.wp(5), res.hp(3), res.wp(5), 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Tasks',
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PosterTaskDetailListviewScreen(),
                    ),
                  ).then((shouldRefresh) {
                    if (shouldRefresh == true && context.mounted) {
                      context.read<PosterHomeCubit>().streamPosterHomeData();
                    }
                  });
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: res.sp(12),
                    color: const Color(0xFF3B82F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(1)),
          ...recentTasks.map((task) => PosterHomeTaskCard(context: context, res: res, task: task)),
        ],
      ),
    );
  }
}
