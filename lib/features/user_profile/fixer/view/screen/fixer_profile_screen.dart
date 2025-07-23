// Section-wise refactored FixerProfileScreen

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_about_section.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_basic_info.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_build_header.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_certification.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_contact_info.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_skills_section.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerProfileScreen extends StatelessWidget {
  const FixerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FixerProfileCubit()..loadFixerProfile(),
      child: const _FixerProfileView(),
    );
  }
}

class _FixerProfileView extends StatelessWidget {
  const _FixerProfileView();

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<FixerProfileCubit, FixerProfileState>(
        listener: (context, state) {
          if (state is FixerProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is FixerProfileInitial || state is FixerProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FixerProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is FixerProfileLoaded) {
            final profile = state.fixerProfile;
            return CustomScrollView(
              slivers: [
                FixerProfileBuildHeader(context: context, res: res, profile: profile, colorScheme: colorScheme),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: res.hp(2)),
                        FixerProfileBasicInfo(profile: profile, theme: theme, res: res),
                        SizedBox(height: res.hp(2)),
                        if (profile.fixerData?.bio.isNotEmpty == true)
                          FixerProfileAboutSection(profile: profile, theme: theme, res: res),
                        if (profile.fixerData?.skills?.isNotEmpty == true)
                          FixerProfileSkillsSection(profile: profile, theme: theme, res: res),
                        FixerProfileContactInfo(profile: profile),
                        if (profile.fixerData?.certification?.isNotEmpty == true)
                          FixerProfileCertification(profile: profile, res: res),
                        SizedBox(height: res.hp(4)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
