import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/backgroun_painter.dart';
import 'package:quick_pitch_app/core/errors/auth_error_mapper.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/multi_select_skill_chips.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/profile_input_text_field.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';

class CompleteProfileScreen extends StatelessWidget {
  final String role;
  const CompleteProfileScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(painter: BackgroundPainter(), size: Size.infinite),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: res.wp(6)),
              child: BlocListener<CompleteProfileCubit, CompleteProfileState>(
                listener: (context, state) {
                  if (state is CompleteProfileSuccess) {
                    if (role == 'poster') {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.posterBottomNav,
                      );
                    } else if (role == 'fixer') {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.fixerBottomNav,
                      );
                    }
                  } else if (state is CompleteProfileError) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => CustomDialog(
                            title: "Signup Failed",
                            message: mapFirebaseError(state.message),
                            icon: Icons.error_outline,
                            iconColor: Colors.red,
                            onConfirm: () => Navigator.of(context).pop(),
                          ),
                    );
                  }
                },
                child: BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                  builder: (context, state) {
                    final cubit = context.read<CompleteProfileCubit>();
                    return Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      cubit.profileImage != null
                                          ? FileImage(cubit.profileImage!)
                                          : const AssetImage(
                                                'assets/images/default_user.png',
                                              )
                                              as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: cubit.pickProfileImage,
                                    child: const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.black,
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(height: res.hp(4)),
                          Text(
                            "Complete Your Profile",
                            style: TextStyle(
                              fontSize: res.sp(22),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: res.hp(2)),
                          ProfileInputField(
                            label: "Full Name",
                            controller: cubit.nameController,
                            isRequired: true,
                          ),
                          SizedBox(height: res.hp(2)),
                          ProfileInputField(
                            label: "Location",
                            controller: cubit.locationController,
                            icon: Icons.my_location,
                            isRequired: true,
                            onLocationTap: cubit.setCurrentLocationFromDevice,
                          ),
                          SizedBox(height: res.hp(2)),
                          ProfileInputField(
                            label: "Phone",
                            controller: cubit.phoneController,
                            isRequired: true,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: res.hp(2)),
                          ProfileInputField(
                            label: "About You",
                            controller: cubit.bioController,
                            isRequired: true,
                            isMultiline: true,
                            dynamicHelperText:
                                "${cubit.remainingBioChars} / ${cubit.maxBioLength} characters remaining",
                          ),
                          SizedBox(height: res.hp(2)),
                          if (role == 'fixer') ...[
                            const Text(
                              "Select Skills *",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            const MultiSelectSkillChips(),
                            SizedBox(height: 16),
                            ProfileInputField(
                              isReadOnly: true,
                              label: "Certification",
                              controller: cubit.certificationController,
                              icon: Icons.upload_file,
                              onLocationTap: cubit.pickCertificationFile,
                            ),
                          ],
                          SizedBox(height: res.hp(4)),
                          AppButton(
                            text: "Save & Continue",
                             isLoading: state is CompleteProfileLoading,
                            onPressed: () => cubit.submitProfile(role),
                            borderRadius: 20,
                          ),
                          SizedBox(height: res.hp(2)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
