import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_prodile_modern.dart';

class AboutSection extends StatelessWidget {
  final String bio;
  final ThemeData theme;

  const AboutSection({
    super.key,
    required this.bio,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ModernProfileSection(
      title: 'About Me',
      child: Text(
        bio,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey[800],
          height: 1.6,
        ),
      ),
    );
  }
}