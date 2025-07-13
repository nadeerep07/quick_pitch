import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

class PosterHomeSummaryCard extends StatelessWidget {
  const PosterHomeSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return BlocBuilder<PosterHomeCubit, PosterHomeState>(
      builder: (context, state) {
        if (state is PosterHomeLoaded) {
          final activeTasks = state.tasks.where((task) =>
              task.status.toLowerCase() == 'pending' ||
              task.status.toLowerCase() == 'in progress');

          return Container(
            padding: EdgeInsets.all(res.hp(2)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: .2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Tasks',
                      style: TextStyle(
                        fontSize: res.sp(18),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${activeTasks.length} Active Task${activeTasks.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: res.sp(13),
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.assignment_turned_in_rounded,
                  size: res.sp(32),
                  color: Colors.white,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
