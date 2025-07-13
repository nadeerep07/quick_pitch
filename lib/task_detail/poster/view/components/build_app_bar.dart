import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/task_post_screen.dart';
import 'package:quick_pitch_app/task_detail/poster/viewmodel/cubit/task_details_cubit.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BuildAppBar({super.key, required this.task, required this.res});

  final TaskPostModel task;
  final Responsive res;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
   
      title: Text(task.title, style: TextStyle(fontSize: res.sp(18))),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'edit') {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskPostScreen(taskToEdit: task),
                ),
              );
              if (result == true) {
                context.read<TaskDetailsCubit>().loadTaskById(task.id);
                context.read<PosterHomeCubit>().fetchPosterHomeData();
              }
            } else if (value == 'delete') {
              // _showDeleteConfirmation(context);
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
        ),
      ],
    );
  }
}
