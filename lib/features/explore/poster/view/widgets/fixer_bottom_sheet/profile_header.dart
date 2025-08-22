import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;
  final double? distance;

  const ProfileHeader({
    super.key,
    required this.fixer,
    required this.res,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        ClipOval(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/avatar_photo_placeholder.jpg',
            image: fixer.profileImageUrl!,
            width: res.wp(15),
            height: res.wp(15),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: res.wp(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fixer.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (distance != null) SizedBox(height: res.hp(0.5)),
              if (distance != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: res.sp(14),
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: res.wp(1)),
                    Text(
                      '${distance!.toStringAsFixed(1)} km away',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
