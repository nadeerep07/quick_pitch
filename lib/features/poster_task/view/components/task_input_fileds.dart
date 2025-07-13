import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_text_field.dart';
import 'package:quick_pitch_app/features/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskInputFields extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskInputFields({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("Title"),
          AppTextField(controller: cubit.titleController, label: "Enter task title", isRequired: true),
          _label("Description"),
          AppTextField(controller: cubit.descriptionController, label: "Enter task description", maxLines: 4,isRequired: true,),
          _label("Budget"),
          AppTextField(
            controller: cubit.budgetController,
            label: "Enter budget (e.g., ₹100)",
            keyboardType: TextInputType.number,
            isRequired: true,
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
