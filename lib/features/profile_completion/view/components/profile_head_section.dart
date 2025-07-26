import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/profile_header.dart';

class ProfileHeaderSection extends StatelessWidget {
  final CompleteProfileCubit cubit;
  final bool isEditMode;

  const ProfileHeaderSection({
    super.key,
    required this.cubit,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(
          profileImage: cubit.profileImage,
          profileImageUrl: cubit.profileImageUrl,
          onEditTap: cubit.pickProfileImage,
        ),
        const SizedBox(height: 32),
        Text(
          isEditMode ? 'Edit Your Profile' : "Complete Your Profile",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}