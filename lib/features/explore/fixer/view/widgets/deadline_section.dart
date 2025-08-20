import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';

class DeadlineSection extends StatelessWidget {
  const DeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FixerExploreCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deadline',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: state.selectedDeadline,
          items: ['Anytime', 'Within 1 week', 'Within 2 weeks', 'Urgent']
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              context.read<FixerExploreCubit>().updateDeadline(newValue);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
