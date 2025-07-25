import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';

class SubmitButtonSection extends StatelessWidget {
  final CompleteProfileCubit cubit;
  final String role;
  final bool isEditMode;

  const SubmitButtonSection({
    super.key,
    required this.cubit,
    required this.role,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: isEditMode ? "Edit Profile" : "Complete Your Profile",
          isLoading: cubit.state is CompleteProfileLoading,
          onPressed: () => cubit.submitProfile(role, context),
          borderRadius: 20,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}