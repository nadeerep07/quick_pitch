import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/explore_shimmer_loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/screen/fixer_side_detail_screen.dart';

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
    final theme = Theme.of(context);
    final responsive = Responsive(context);

    return state.status == RequestStatus.loading && state.filteredTasks.isEmpty
        ? ExploreShimmerLoading(responsive: responsive)
        : state.status == RequestStatus.error
            ? Center(child: Text(state.errorMessage ?? 'Error loading tasks'))
            : state.filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: () async {
                      await context.read<FixerExploreCubit>().loadTasks();
                      _refreshController.refreshCompleted();
                    },
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .73,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 2,
                      ),
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = state.filteredTasks[index];
                        return _buildTaskCard(context, task, index, responsive);
                      },
                    ),
                  );
  }

  Widget _buildTaskCard(
    BuildContext context,
    TaskPostModel task,
    int index,
    Responsive responsive,
  ) {
    final theme = Theme.of(context);
    final maxSkillsToShow = 2;
    final extraSkillsCount = task.skills.length - maxSkillsToShow;
    final accentColor = _getColorForIndex(index);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FixerSideDetailScreen(task: task),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: responsive.hp(15),
                width: double.infinity,
                color: accentColor.withOpacity(0.1),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (task.imagesUrl?.isNotEmpty ?? false)
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/image_placeholder.png',
                        image: task.imagesUrl!.first,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(accentColor),
                      )
                    else
                      _buildImagePlaceholder(accentColor),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '₹${task.budget.toStringAsFixed(0)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...task.skills.take(maxSkillsToShow).map(
                          (skill) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.shade100,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              skill,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        if (extraSkillsCount > 0)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              '+$extraSkillsCount more',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          task.location,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Color accentColor) {
    return Center(
      child: Image.asset('assets/images/image_placeholder.png')
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF4E5AF2),
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFFD79A8),
      const Color(0xFFFDCB6E),
    ];
    return colors[index % colors.length];
  }
}
