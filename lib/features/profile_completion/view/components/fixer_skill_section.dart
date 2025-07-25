import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/multi_select_skill_chips.dart';

class SkillsSection extends StatelessWidget {
  final CompleteProfileCubit cubit;

  const SkillsSection({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Skills *",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const MultiSelectSkillChips(),
        const SizedBox(height: 24),
      ],
    );
  }
}