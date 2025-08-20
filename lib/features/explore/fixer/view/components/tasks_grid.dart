import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/explore_shimmer_loading.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/empty_task_view.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/widgets/task_card.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';


class TasksGrid extends StatefulWidget {
  const TasksGrid({super.key});

  @override
  State<TasksGrid> createState() => _TasksGridState();
}

class _TasksGridState extends State<TasksGrid> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FixerExploreCubit>().state;
    final responsive = Responsive(context);

    if (state.status == RequestStatus.loading && state.filteredTasks.isEmpty) {
      return ExploreShimmerLoading(responsive: responsive);
    }

    if (state.status == RequestStatus.error) {
      return Center(child: Text(state.errorMessage ?? 'Error loading tasks'));
    }

    if (state.filteredTasks.isEmpty) {
      return const EmptyTaskView();
    }

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: () async {
        await context.read<FixerExploreCubit>().loadTasks();
        _refreshController.refreshCompleted();
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .73,
          crossAxisSpacing: 4,
          mainAxisSpacing: 2,
        ),
        itemCount: state.filteredTasks.length,
        itemBuilder: (context, index) {
          final task = state.filteredTasks[index];
          return TaskCard(task: task, index: index, responsive: responsive);
        },
      ),
    );
  }
}
