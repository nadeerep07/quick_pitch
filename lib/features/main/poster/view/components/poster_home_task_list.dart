import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_task_card.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

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
              onTap: () {
                // TODO: Navigate to "All Tasks" screen
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
              return SizedBox(
                height: res.hp(26),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.tasks.length,
                  separatorBuilder: (_, __) => SizedBox(width: res.wp(4)),
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return PosterHomeTaskCard(
                      res: res,
                      title: task.title,
                      status: task.status,
                      imageUrl: task.imagesUrl != null && task.imagesUrl!.isNotEmpty
                          ? task.imagesUrl!.first
                          : 'https://i.pravatar.cc/150?img=${index + 1}',
                      fixerName: task.assignedFixerName ?? 'Not assigned',
                    );
                  },
                ),
              );
            } else if (state is PosterHomeLoaded && state.tasks.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: res.hp(1)),
                child: Text(
                  'No tasks posted yet.',
                  style: TextStyle(
                    fontSize: res.sp(14),
                    color: Colors.grey,
                  ),
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
