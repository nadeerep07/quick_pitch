import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/task_detail/poster/view/screen/poster_task_detail_screen.dart';

class DetailTaskCard extends StatelessWidget {
  final TaskPostModel task;
  final int index;

  const DetailTaskCard({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final imageUrl = task.imagesUrl?.isNotEmpty == true
        ? task.imagesUrl!.first
        : 'https://i.pravatar.cc/150?img=${index + 1}';

    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, width: res.wp(20), height: res.wp(20), fit: BoxFit.cover),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: TextStyle(fontSize: res.sp(14), fontWeight: FontWeight.bold)),
                SizedBox(height: res.hp(0.5)),
                Text(
                  task.assignedFixerName != null ? 'Fixer: ${task.assignedFixerName}' : 'No fixer assigned',
                  style: TextStyle(fontSize: res.sp(12), color: Colors.grey[700]),
                ),
                SizedBox(height: res.hp(0.8)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(task.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.status.toUpperCase(),
                    style: TextStyle(fontSize: res.sp(11), fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: res.sp(16), color: Colors.blueAccent),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PosterTaskDetailScreen(taskId: task.id)),
              );
              if (result == true && context.mounted) {
                context.read<PosterHomeCubit>().fetchPosterHomeData();
              }
            },
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}
