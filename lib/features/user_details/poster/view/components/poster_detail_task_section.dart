import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/poster_task/repository/task_post_repository.dart';


class PosterTasksState {
  final List<TaskPostModel> tasks;
  final bool isLoading;
  final String? error;

  PosterTasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  PosterTasksState copyWith({
    List<TaskPostModel>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return PosterTasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PosterTasksCubit extends Cubit<PosterTasksState> {
  final TaskPostRepository _taskRepository;
  final String posterId;

  PosterTasksCubit(this._taskRepository, {required this.posterId})
      : super(PosterTasksState(isLoading: true)) {
    loadUserTasks();
  }

  Future<void> loadUserTasks() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final tasks = await _taskRepository.getUserTasks(posterId);
      emit(state.copyWith(tasks: tasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to load tasks: $e',
        isLoading: false,
      ));
    }
  }
}

/// ------------------------
/// Widget
/// ------------------------
class PosterDetailTaskSection extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;
  final String posterId;

  const PosterDetailTaskSection({
    super.key,
    required this.res,
    required this.theme,
    required this.posterId,
  });

  @override
  Widget build(BuildContext context) {
          String formatDate(DateTime date) {
            final now = DateTime.now();
            final difference = now.difference(date);
            if (difference.inDays == 0) return 'Posted today';
            if (difference.inDays == 1) return 'Posted 1 day ago';
            if (difference.inDays < 7) return 'Posted ${difference.inDays} days ago';
            if (difference.inDays < 30) {
              final weeks = (difference.inDays / 7).floor();
              return 'Posted ${weeks == 1 ? '1 week' : '$weeks weeks'} ago';
            } else {
              final months = (difference.inDays / 30).floor();
              return 'Posted ${months == 1 ? '1 month' : '$months months'} ago';
            }
          }

    return BlocProvider(
      create: (_) => PosterTasksCubit(TaskPostRepository(), posterId: posterId),
      child: BlocBuilder<PosterTasksCubit, PosterTasksState>(
        builder: (context, state) {
          final cubit = context.read<PosterTasksCubit>();

          Widget _buildTaskCard(TaskPostModel task) {
            return Container(
              margin: EdgeInsets.only(bottom: res.hp(2)),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(res.wp(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: res.wp(2),
                            vertical: res.hp(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: StatusColorUtil.getStatusColor(task.status, theme).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.status.toUpperCase(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: StatusColorUtil.getStatusColor(task.status, theme),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: res.hp(1)),
                    Text(
                      task.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.skills.isNotEmpty) ...[
                      SizedBox(height: res.hp(1)),
                      Wrap(
                        spacing: res.wp(2),
                        runSpacing: res.hp(0.5),
                        children: task.skills.take(3).map((skill) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: res.wp(2),
                            vertical: res.hp(0.3),
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            skill,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                    SizedBox(height: res.hp(1.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${task.budget.toStringAsFixed(0)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          formatDate(task.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    if (task.deadline.isAfter(DateTime.now())) ...[
                      SizedBox(height: res.hp(0.5)),
                      Text(
                        'Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }


    
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Tasks',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!state.isLoading)
                    IconButton(
                      onPressed: cubit.loadUserTasks,
                      icon: Icon(
                        Icons.refresh,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
              SizedBox(height: res.hp(1)),

              if (state.isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: res.hp(4)),
                    child: CircularProgressIndicator(color: theme.colorScheme.primary),
                  ),
                )
              else if (state.error != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(res.wp(4)),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600], size: res.wp(8)),
                      SizedBox(height: res.hp(1)),
                      Text(
                        state.error!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: res.hp(1)),
                      ElevatedButton(
                        onPressed: cubit.loadUserTasks,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (state.tasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(res.wp(6)),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt_outlined, size: res.wp(12), color: Colors.grey[400]),
                      SizedBox(height: res.hp(2)),
                      Text(
                        'No Tasks Posted Yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: res.hp(1)),
                      Text(
                        'Start posting tasks to see them here',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: state.tasks.map((task) => _buildTaskCard(task)).toList(),
                ),
            ],
          );
        },
      ),
    );
  }
//  String _formatDate(DateTime date) { final now = DateTime.now(); final difference = now.difference(date); if (difference.inDays == 0) { return 'Posted today'; } else if (difference.inDays == 1) { return 'Posted 1 day ago'; } else if (difference.inDays < 7) { return 'Posted ${difference.inDays} days ago'; } else if (difference.inDays < 30) { final weeks = (difference.inDays / 7).floor(); return 'Posted ${weeks == 1 ? '1 week' : '$weeks weeks'} ago'; } else { final months = (difference.inDays / 30).floor(); return 'Posted ${months == 1 ? '1 month' : '$months months'} ago'; } }
}
