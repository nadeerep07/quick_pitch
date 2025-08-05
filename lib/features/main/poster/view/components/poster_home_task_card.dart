import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/screen/poster_task_detail_screen.dart';

class PosterHomeTaskCard extends StatelessWidget {
  const PosterHomeTaskCard({
    super.key,
    required this.context,
    required this.res,
    required this.task,
  });

  final BuildContext context;
  final Responsive res;
  final dynamic task;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;

    switch (task.status.toLowerCase()) {
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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PosterTaskDetailScreen(taskId: task.id),
          ),
        ).then((shouldRefresh) {
          if (shouldRefresh == true && context.mounted) {
            context.read<PosterHomeCubit>().streamPosterHomeData();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: res.hp(1.5)),
        padding: EdgeInsets.all(res.wp(4)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Task Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  task.imagesUrl != null && task.imagesUrl!.isNotEmpty
                      ? FadeInImage.assetNetwork(
                        image: task.imagesUrl!.first,
                        placeholder: 'assets/images/image_placeholder.png',

                        width: res.wp(12),
                        height: res.wp(12),
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'assets/images/image_placeholder.png',
                        width: res.wp(12),
                        height: res.wp(12),
                        fit: BoxFit.cover,
                      ),
            ),

            SizedBox(width: res.wp(3)),

            // Task Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: res.sp(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: res.hp(0.5)),
                  Text(
                    task.assignedFixerName ?? 'Not assigned',
                    style: TextStyle(
                      fontSize: res.sp(12),
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                task.status.toUpperCase(),
                style: TextStyle(
                  fontSize: res.sp(10),
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
