// lib/features/settings/view/widgets/settings_sections.dart
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_item.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_section_widget.dart';

class AccountManagementSection extends StatelessWidget {
  final VoidCallback onChangeEmail;
  final VoidCallback onChangePassword;
  final VoidCallback onDeleteAccount;

  const AccountManagementSection({
    super.key,
    required this.onChangeEmail,
    required this.onChangePassword,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Account Management'),
        const SizedBox(height: 8),
        SettingsCard(
          children: [
            SettingsItem(
              icon: Icons.email_outlined,
              title: 'Change Email',
              subtitle: 'Update your email address',
              onTap: onChangeEmail,
            ),
            const SettingsDivider(),
            SettingsItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: onChangePassword,
            ),
            const SettingsDivider(),
            SettingsItem(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              onTap: onDeleteAccount,
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }
}
