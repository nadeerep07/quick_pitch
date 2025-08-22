import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/repository/fixer_works_repository.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/screen/work_upload_screen.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_event.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_about.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_certification.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_contact_section.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_skills.dart';

class FixerProfileContent extends StatelessWidget {
  final UserProfileModel profile;
  final ThemeData theme;
  final VoidCallback? onUpdateCertificate;
  final bool isOwner; // Add this parameter

  const FixerProfileContent({
    super.key,
    required this.profile,
    required this.theme,
    this.onUpdateCertificate,
    this.isOwner = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FixerWorksBloc(FixerWorksRepository())
            ..add(LoadFixerWorks(profile.uid)), // Assuming profile has an ID
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile.fixerData?.bio?.isNotEmpty == true)
            AboutSection(bio: profile.fixerData!.bio!, theme: theme),
          const SizedBox(height: 16),
          if (profile.fixerData?.skills?.isNotEmpty == true)
            SkillsSection(skills: profile.fixerData!.skills!, theme: theme),
          const SizedBox(height: 16),

          // Add the Works Section
          FixerWorksSection(
            fixerId: profile.uid, // Assuming profile has an ID
            theme: theme,
            isOwner: isOwner,
          ),
          const SizedBox(height: 16),

          if (profile.fixerData?.certification?.isNotEmpty == true)
            CertificationSection(
              certification: profile.fixerData!.certification!,
              status: profile.fixerData!.certificateStatus,
              onUpdateCertificate:
                  profile.fixerData!.certificateStatus.toLowerCase() ==
                          'rejected'
                      ? onUpdateCertificate
                      : null,
            ),
          const SizedBox(height: 16),
          ContactSection(
            phone: profile.phone,
            email:
                '${profile.name.replaceAll(' ', '').toLowerCase()}@example.com',
            theme: theme,
          ),
        ],
      ),
    );
  }
}
