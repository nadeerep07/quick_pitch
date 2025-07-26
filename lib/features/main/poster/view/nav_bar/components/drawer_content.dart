import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/main/poster/view/nav_bar/components/custom_drawer_header.dart';
import 'package:quick_pitch_app/features/main/poster/view/nav_bar/components/drawer_footer.dart';
import 'package:quick_pitch_app/features/main/poster/view/nav_bar/components/drawer_menu.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class DrawerContent extends StatelessWidget {
  final UserProfileModel? userData;
  final VoidCallback onLogout;
  final VoidCallback onSwitchTap;

  const DrawerContent({super.key, 
    required this.userData,
    required this.onLogout,
    required this.onSwitchTap,
  });

  @override
  Widget build(BuildContext context) {
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
          CustomDrawerHeader(userData: userData),
          Expanded(child: DrawerMenu(onLogout: onLogout, onSwitchTap: onSwitchTap)),
          DrawerFooter(),
        ],
      ),
    );
  }
}