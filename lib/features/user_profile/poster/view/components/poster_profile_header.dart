import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterProfileHeader extends StatelessWidget {
  const PosterProfileHeader({
    super.key,
    required this.res,
    required this.profile,
    required this.colorScheme,
  });

  final Responsive res;
  final UserProfileModel profile;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: res.wp(18),
            backgroundColor: AppColors.primaryText,
            backgroundImage: profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : const AssetImage('assets/images/avatar_photo_placeholder.jpg') as ImageProvider,
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        Text(
          profile.name,
          style: TextStyle(
            fontSize: res.sp(22),
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: res.hp(0.5)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(4),
            vertical: res.hp(0.5),
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
      
        
          child: Text(
            profile.role,
            style: TextStyle(
              fontSize: res.sp(14),
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    
      ],
    );
  }
}
