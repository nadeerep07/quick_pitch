import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class BioSection extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;

  const BioSection({super.key, required this.fixer, required this.res});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: res.hp(1)),
        Text(
          fixer.fixerData!.bio,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700], height: 1.4),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: res.hp(2)),
      ],
    );
  }
}
