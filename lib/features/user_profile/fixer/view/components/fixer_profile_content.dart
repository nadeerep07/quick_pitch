import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_about.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_certification.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_contact_section.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_skills.dart';

class FixerProfileContent extends StatelessWidget {
  final dynamic profile;
  final ThemeData theme;
  final VoidCallback? onUpdateCertificate; // Callback when certificate is rejected

  const FixerProfileContent({
    super.key,
    required this.profile,
    required this.theme,
    this.onUpdateCertificate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile.fixerData?.bio?.isNotEmpty == true)
          AboutSection(bio: profile.fixerData!.bio!, theme: theme),
        const SizedBox(height: 16),
        if (profile.fixerData?.skills?.isNotEmpty == true)
          SkillsSection(skills: profile.fixerData!.skills!, theme: theme),
        const SizedBox(height: 16),
        if (profile.fixerData?.certification?.isNotEmpty == true)
          CertificationSection(
            certification: profile.fixerData!.certification!,
            status: profile.fixerData!.certificateStatus,
            onUpdateCertificate: profile.fixerData!.certificateStatus.toLowerCase() == 'rejected'
                ? onUpdateCertificate
                : null,
          ),
        const SizedBox(height: 16),
        ContactSection(
          phone: profile.phone,
          email: '${profile.name.replaceAll(' ', '').toLowerCase()}@example.com',
          theme: theme,
        ),
      ],
    );
  }
}
