import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/settings/view/screen/settings_screen.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/screen/poster_profile_screen.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSwitchTap;

  const DrawerMenu({super.key, required this.onLogout, required this.onSwitchTap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _buildMenuItem(context, Icons.person_outline, 'My Profile', () {Navigator.push(context,  MaterialPageRoute(builder:(_)=>PosterProfileScreen() ));}),
        _buildMenuItem(context, Icons.settings_outlined, 'Settings', () {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppSettings()),
    );
  }),
        _buildMenuItem(context, Icons.help_outline, 'Help Center', () {}),
        _buildMenuItem(context, Icons.info_outline, 'About App', () {}),
        const Divider(height: 20, thickness: 1, indent: 20, endIndent: 20),
        // _buildMenuItem(context, Icons.sync_alt, 'Switch Role', onSwitchTap, true),
        // _buildMenuItem(context, Icons.logout, 'Sign Out', onLogout, true),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      VoidCallback onTap, [bool isHighlighted = false]) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isHighlighted ? theme.colorScheme.primary : theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          color: isHighlighted ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
    );
  }
}