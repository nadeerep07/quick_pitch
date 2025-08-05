import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/screen/poster_task_detail_screen.dart';

class DetailTaskCard extends StatelessWidget {
  final TaskPostModel task;
  final int index;

  const DetailTaskCard({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final imageUrl =
        task.imagesUrl?.isNotEmpty == true
            ? task.imagesUrl!.first
            : 'https://i.pravatar.cc/150?img=${index + 1}';

    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/image_placeholder.png',
              image: imageUrl,
              width: res.wp(20),
              height: res.wp(20),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: res.wp(4)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: res.hp(0.5)),
                Text(
                  task.assignedFixerName != null
                      ? 'Fixer: ${task.assignedFixerName}'
                      : 'No fixer assigned',
                  style: TextStyle(
                    fontSize: res.sp(12),
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: res.hp(0.8)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColors(task.status).$2,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: res.sp(10),
                      fontWeight: FontWeight.w600,
                      color: _statusColors(task.status).$1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: res.sp(16),
              color: Colors.blueAccent,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PosterTaskDetailScreen(taskId: task.id),
                ),
              );
              if (result == true && context.mounted) {
                context.read<PosterHomeCubit>().streamPosterHomeData();
              }
            },
          ),
        ],
      ),
    );
  }

  /// Returns a tuple of (statusColor, statusBgColor)
  (Color?, Color?) _statusColors(String status) {
    late Color statusColor;
    late Color statusBgColor;

    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = const Color(0xFFF59E0B);
        statusBgColor = const Color(0xFFFEF3C7);
        break;
      case 'assigned':
        statusColor = const Color(0xFF3B82F6);
        statusBgColor = const Color(0xFFEFF6FF);
        break;
      case 'completed':
        statusColor = const Color(0xFF10B981);
        statusBgColor = const Color(0xFFECFDF5);
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusBgColor = const Color(0xFFF1F5F9);
    }
    return (statusColor, statusBgColor);
  }
}
