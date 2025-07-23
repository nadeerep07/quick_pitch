import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/poster_task/viewmodel/cubit/task_post_cubit.dart';

class TaskTimeSlotSelector extends StatelessWidget {
  final TaskPostCubit cubit;
  const TaskTimeSlotSelector({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final slots = ["Morning", "Afternoon", "Evening"];
    if (cubit.selectedWorkType != "On-site") return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Preferred Time"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: slots.map((slot) {
            final isSelected = cubit.selectedTimeSlot == slot;
            return Expanded(
              child: GestureDetector(
                onTap: () => cubit.setTimeSlot(slot),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? AppColors.primaryColor.withValues(alpha: .1) : Colors.grey.shade100,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    slot,
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
