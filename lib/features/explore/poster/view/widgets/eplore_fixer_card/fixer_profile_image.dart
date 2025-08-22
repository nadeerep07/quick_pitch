import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerProfileImage extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;
  final ThemeData theme;

  const FixerProfileImage({
    super.key,
    required this.fixer,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.wp(16),
      height: res.wp(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primaryColor.withValues(alpha: 0.1),
      ),
      child: fixer.profileImageUrl?.isNotEmpty == true
          ? ClipOval(
              child: Image.network(
                fixer.profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: res.sp(24),
                    color: theme.primaryColor,
                  );
                },
              ),
            )
          : Icon(
              Icons.person,
              size: res.sp(24),
              color: theme.primaryColor,
            ),
    );
  }
}
