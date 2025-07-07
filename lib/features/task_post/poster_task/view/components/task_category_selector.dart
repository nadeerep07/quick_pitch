import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskCategorySelector extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskCategorySelector({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Category/Task Type"),
        DropdownButtonFormField<String>(
          value: cubit.selectedCategory,
          items: cubit.categories
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
              .toList(),
          onChanged: cubit.setCategory,
          decoration: InputDecoration(
            hintText: "Select task category",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
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
