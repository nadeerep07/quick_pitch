// task_post_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/repository/task_post_repository.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/view/task_post_screen.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/viewmodel/cubit/task_post_cubit.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';

class TaskPostWrapper extends StatelessWidget {
  const TaskPostWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskPostCubit(
        service: CloudinaryService(),
        repository: TaskPostRepository(),
      ),
      child: const TaskPostScreen(),
    );
  }
}
