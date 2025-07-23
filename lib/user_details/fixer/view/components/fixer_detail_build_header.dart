import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerDetailBuildHeader extends StatelessWidget {
  const FixerDetailBuildHeader({
    super.key,
    required this.fixerData,
    required this.res,
    required this.theme,
  });

  final UserProfileModel fixerData;
  final Responsive res;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fixerData.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: res.hp(0.5)),
        Row(
          children: [
            Icon(Icons.location_on_outlined, 
                size: res.sp(16), color: Colors.grey[600]),
            SizedBox(width: res.wp(1)),
            Text(
              fixerData.location,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: res.hp(0.5)),
        Row(
          children: [
            Icon(Icons.phone_outlined, 
                size: res.sp(16), color: Colors.grey[600]),
            SizedBox(width: res.wp(1)),
            Text(
              fixerData.phone,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
