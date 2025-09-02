import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/poster_task/repository/task_post_repository.dart';

class PosterDetailTaskSection extends StatefulWidget {
  final Responsive res;
  final ThemeData theme;
  final String posterId; // Add userId to fetch user-specific tasks

  const PosterDetailTaskSection({
    super.key,
    required this.res,
    required this.theme,
    required this.posterId,
  });

  @override
  State<PosterDetailTaskSection> createState() => _PosterDetailTaskSectionState();
}

class _PosterDetailTaskSectionState extends State<PosterDetailTaskSection> {
  final TaskPostRepository _taskRepository = TaskPostRepository();
  List<TaskPostModel> _tasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserTasks();
  }

  Future<void> _loadUserTasks() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final tasks = await _taskRepository.getUserTasks(widget.posterId);
      
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load tasks: $e';
        _isLoading = false;
      });
    }
  }

  String _formatBudget(double budget) {
    return '\$${budget.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Posted today';
    } else if (difference.inDays == 1) {
      return 'Posted 1 day ago';
    } else if (difference.inDays < 7) {
      return 'Posted ${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Posted ${weeks == 1 ? '1 week' : '$weeks weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'Posted ${months == 1 ? '1 month' : '$months months'} ago';
    }
  }

  Widget _buildTaskCard(TaskPostModel task) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.res.hp(2)),
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: widget.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.res.wp(2),
                    vertical: widget.res.hp(0.5),
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.status.toUpperCase(),
                    style: widget.theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(task.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.res.hp(1)),
            Text(
              task.description,
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (task.skills.isNotEmpty) ...[
              SizedBox(height: widget.res.hp(1)),
              Wrap(
                spacing: widget.res.wp(2),
                runSpacing: widget.res.hp(0.5),
                children: task.skills.take(3).map((skill) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.res.wp(2),
                    vertical: widget.res.hp(0.3),
                  ),
                  decoration: BoxDecoration(
                    color: widget.theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    skill,
                    style: widget.theme.textTheme.bodySmall?.copyWith(
                      color: widget.theme.colorScheme.primary,
                    ),
                  ),
                )).toList(),
              ),
            ],
            SizedBox(height: widget.res.hp(1.5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatBudget(task.budget),
                  style: widget.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.theme.colorScheme.primary,
                  ),
                ),
                Text(
                  _formatDate(task.createdAt),
                  style: widget.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (task.deadline.isAfter(DateTime.now())) ...[
              SizedBox(height: widget.res.hp(0.5)),
              Text(
                'Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                style: widget.theme.textTheme.bodySmall?.copyWith(
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'assigned':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Tasks',
              style: widget.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!_isLoading)
              IconButton(
                onPressed: _loadUserTasks,
                icon: Icon(
                  Icons.refresh,
                  color: widget.theme.colorScheme.primary,
                ),
              ),
          ],
        ),
        SizedBox(height: widget.res.hp(1)),
        
        if (_isLoading)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: widget.res.hp(4)),
              child: CircularProgressIndicator(
                color: widget.theme.colorScheme.primary,
              ),
            ),
          )
        else if (_error != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(widget.res.wp(4)),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[600],
                  size: widget.res.wp(8),
                ),
                SizedBox(height: widget.res.hp(1)),
                Text(
                  _error!,
                  style: widget.theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.red[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: widget.res.hp(1)),
                ElevatedButton(
                  onPressed: _loadUserTasks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        else if (_tasks.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(widget.res.wp(6)),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt_outlined,
                  size: widget.res.wp(12),
                  color: Colors.grey[400],
                ),
                SizedBox(height: widget.res.hp(2)),
                Text(
                  'No Tasks Posted Yet',
                  style: widget.theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: widget.res.hp(1)),
                Text(
                  'Start posting tasks to see them here',
                  style: widget.theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Column(
            children: _tasks.map((task) => _buildTaskCard(task)).toList(),
          ),
      ],
    );
  }
}