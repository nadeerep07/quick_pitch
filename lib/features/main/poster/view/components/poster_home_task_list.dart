import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_task_card.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/screen/poster_task_detail_listview_screen.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/screen/poster_task_detail_screen.dart';

class PosterHomeTaskList extends StatelessWidget {
  const PosterHomeTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Tasks',
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () async {
                final state = context.read<PosterHomeCubit>().state;
                if (state is PosterHomeLoaded) {
                  final shouldRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PosterTaskDetailListviewScreen(),
                    ),
                  );

                  if (shouldRefresh == true && context.mounted) {
                    context.read<PosterHomeCubit>().streamPosterHomeData();
                  }
                }
              },

              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: res.sp(13),
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<PosterHomeCubit, PosterHomeState>(
          builder: (context, state) {
            if (state is PosterHomeLoaded && state.tasks.isNotEmpty) {
              final sortedTasks = [...state.tasks];
              sortedTasks.sort((a, b) {
                return b.createdAt.compareTo(a.createdAt);
              });
              final recentTasks = sortedTasks.take(4).toList();
              return SizedBox(
                height: res.hp(26),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentTasks.length,
                  separatorBuilder: (_, __) => SizedBox(width: res.wp(4)),
                  itemBuilder: (context, index) {
                    final task = recentTasks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PosterTaskDetailScreen(taskId: task.id),
                          ),
                        );
                      },

                      child: PosterHomeTaskCard(
                        res: res,
                        title: task.title,
                        status: task.status,
                        imageUrl:
                            task.imagesUrl != null && task.imagesUrl!.isNotEmpty
                                ? task.imagesUrl!.first
                                : 'https://www.trschools.com/templates/imgs/default_placeholder.png',
                        fixerName: task.assignedFixerName ?? 'Not assigned',
                      ),
                    );
                  },
                ),
              );
            } else if (state is PosterHomeLoaded && state.tasks.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: res.hp(1)),
                child: Text(
                  'No tasks posted yet.',
                  style: TextStyle(fontSize: res.sp(14), color: Colors.grey),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
