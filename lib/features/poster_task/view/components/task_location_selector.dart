import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_text_field.dart';
import 'package:quick_pitch_app/features/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskLocationSelector extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskLocationSelector({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Location"),
        AppTextField(
          controller: cubit.locationController,
           label: "Enter or select task location",
           isRequired: true,
           onLocationTap: cubit.setCurrentLocationFromDevice,
           sufixicon: Icons.location_on_outlined,
           ),
      ],
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
}
