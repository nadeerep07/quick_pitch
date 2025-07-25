
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/main/fixer/view/bottom_nav/components/fixer_drawer_build_header.dart';
import 'package:quick_pitch_app/features/main/fixer/view/bottom_nav/components/fixer_drawer_footer.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/screen/fixer_profile_screen.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerCustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSwitchTap;

  const FixerCustomDrawer({
    super.key,
    required this.onLogout,
    required this.onSwitchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      elevation: 10,
      child: BlocBuilder<FixerProfileCubit, FixerProfileState>(
        builder: (context, state) {
          final userData = state is FixerProfileLoaded ? state.fixerProfile : null;
          final theme = Theme.of(context);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: .1),
                  theme.colorScheme.secondary.withValues(alpha: .05),
                ],
              ),
            ),
            child: Column(
              children: [
                FixerDrawerBuildHeader(context: context, userData: userData, theme: theme),
                Expanded(child: _buildMenuList(context)),
                FixerDrawerFooter(theme: theme),
              ],
            ),
          );
        },
      ),
    );
  }

  
  Widget _buildMenuList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _buildMenuItem(
          context,
          icon: Icons.person_outline,
          title: 'My Profile',
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, animation, secondaryAnimation) => const FixerProfileScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(position: animation.drive(tween), child: child);
                },
              ),
            );
          },
        ),
        _buildMenuItem(context, icon: Icons.settings_outlined, title: 'Settings', onTap: () {}),
        _buildMenuItem(context, icon: Icons.help_outline, title: 'Help Center', onTap: () {}),
        _buildMenuItem(context, icon: Icons.info_outline, title: 'About App', onTap: () {}),
        const Divider(height: 20, thickness: 1, indent: 20, endIndent: 20),
        _buildMenuItem(
          context,
          icon: Icons.sync_alt,
          title: 'Switch Role',
          isHighlighted: true,
          onTap: onSwitchTap,
        ),
        _buildMenuItem(
          context,
          icon: Icons.logout,
          title: 'Sign Out',
          isHighlighted: true,
          onTap: onLogout,
        ),
      ],
    );
  }


  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isHighlighted ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
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
