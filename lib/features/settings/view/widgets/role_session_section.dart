// lib/features/settings/view/widgets/settings_sections.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/auth/view/widgets/custom_dialog.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_item.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_section_widget.dart';

class RoleSessionSection extends StatelessWidget {
  final VoidCallback onSwitchRole;
  final VoidCallback onSignOut;

  const RoleSessionSection({
    super.key,
    required this.onSwitchRole,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Role & Session'),
        const SizedBox(height: 8),
        SettingsCard(
          children: [
            SettingsItem(
              icon: Icons.sync_alt,
              title: 'Switch Role',
              subtitle: 'Switch between poster and fixer',
              onTap: () => _showSwitchRoleDialog(context),
              isHighlighted: true,
            ),
            const SettingsDivider(),
            SettingsItem(
              icon: Icons.logout,
              title: 'Sign Out',
              subtitle: 'Sign out of your account',
              onTap: () => _showLogoutDialog(context),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  void _showSwitchRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: "Switch Role",
        message: "Do you want to switch to the other role?",
        icon: Icons.sync_alt,
        iconColor: AppColors.primaryColor,
        onConfirm: () {
          Navigator.pop(dialogContext);
          onSwitchRole();
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: "Sign Out",
        message: "Are you sure you want to sign out?",
        icon: Icons.logout,
        iconColor: Theme.of(context).colorScheme.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          onSignOut();
        },
      ),
    );
  }
}