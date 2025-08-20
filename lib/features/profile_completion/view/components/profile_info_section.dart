import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/location_search_field.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/profile_input_text_field.dart';

class PersonalInfoSection extends StatelessWidget {
  final CompleteProfileCubit cubit;

  const PersonalInfoSection({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileInputField(
          label: "Full Name",
          controller: cubit.nameController,
          isRequired: true,
        ),
        const SizedBox(height: 16),
         LocationSearchField(
          cubit: cubit,
          label: "Location",
          isRequired: true,
        ),
        const SizedBox(height: 16),
        ProfileInputField(
          label: "Phone",
          controller: cubit.phoneController,
          isRequired: true,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        ProfileInputField(
          label: "About You",
          controller: cubit.bioController,
          isRequired: true,
          isMultiline: true,
          dynamicHelperText:
              "${cubit.remainingBioChars} / ${cubit.maxBioLength} characters remaining",
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}