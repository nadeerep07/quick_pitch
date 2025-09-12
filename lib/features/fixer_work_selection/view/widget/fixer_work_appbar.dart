import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerWorkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserProfileModel fixerData;

  const FixerWorkAppBar({super.key, required this.fixerData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Work',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Choose work from ${fixerData.name.split(' ').first}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha:0.7),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: colorScheme.outline.withValues(alpha:0.2),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
