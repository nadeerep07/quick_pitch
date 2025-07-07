import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskWorkTypeSelector extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskWorkTypeSelector({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final types = ["On-site", "Remote"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Work Type"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: types.map((type) {
            final isSelected = cubit.selectedWorkType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => cubit.setWorkType(type),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    type,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.primaryColor : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
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
