// lib/features/settings/view/widgets/settings_sections.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/about_app/view/screen/privacy_policy_screen.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_item.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_section_widget.dart';

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'App Settings'),
        const SizedBox(height: 8),
        SettingsCard(
          children: [
            SettingsItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings coming soon'),
                  ),
                );
              },
            ),
            const SettingsDivider(),
            SettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy',
              subtitle: 'Privacy and data settings',
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyPolicyScreen()));
              },
            ),
            const SettingsDivider(),
            SettingsItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help center coming soon')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
