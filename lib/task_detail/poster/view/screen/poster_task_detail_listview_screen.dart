import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/task_detail/poster/view/components/task_card.dart';
import 'package:quick_pitch_app/task_detail/poster/view/components/task_filter_bottom_sheet.dart';
import 'package:quick_pitch_app/task_detail/poster/viewmodel/cubit/task_filter_cubit.dart';

class PosterTaskDetailListviewScreen extends StatelessWidget {
  const PosterTaskDetailListviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskFilterCubit(),
      child: const PosterTaskDetailBody(),
    );
  }
}

class PosterTaskDetailBody extends StatelessWidget {
  const PosterTaskDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => showTaskFilterBottomSheet(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          BlocBuilder<PosterHomeCubit, PosterHomeState>(
            builder: (context, homeState) {
              if (homeState is! PosterHomeLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return BlocBuilder<TaskFilterCubit, TaskFilterState>(
                builder: (context, filterState) {
                  List<TaskPostModel> filtered = homeState.tasks;

                  if (filterState.status != 'All') {
                    filtered = filtered
                        .where((e) => e.status.toLowerCase() == filterState.status.toLowerCase())
                        .toList();
                  }

                  filtered.sort((a, b) => filterState.newestFirst
                      ? b.createdAt.compareTo(a.createdAt)
                      : a.createdAt.compareTo(b.createdAt));

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No tasks found with current filter"));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      final task = filtered[index];
                      return DetailTaskCard(task: task,index: index,);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
