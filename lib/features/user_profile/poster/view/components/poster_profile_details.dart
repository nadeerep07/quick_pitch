import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/components/poster_profile_detail_row.dart';

class PosterProfileDetails extends StatelessWidget {
  const PosterProfileDetails({
    super.key,
    required this.res,
    required this.profile,
    required this.theme,
    required this.colorScheme,
  });

  final Responsive res;
  final UserProfileModel profile;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(5)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: res.sp(18), color: colorScheme.primary),
              SizedBox(width: res.wp(2)),
              Text(
                'About',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(2)),
          Text(
            profile.posterData?.bio ?? 'No bio added',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: res.hp(3)),
          Divider(height: 1, color: colorScheme.outline.withOpacity(0.3)),
          SizedBox(height: res.hp(3)),
          Row(
            children: [
              Icon(Icons.contact_page_outlined, size: res.sp(18), color: colorScheme.primary),
              SizedBox(width: res.wp(2)),
              Text(
                'Contact Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(2)),
          PosterProfileDetailRow(res: res, icon: Icons.phone_outlined, text: profile.phone, colorScheme: colorScheme),
          SizedBox(height: res.hp(1.5)),
       //   _buildDetailRow(res, Icons.email_outlined, profile.email ?? 'Not provided', colorScheme),
          SizedBox(height: res.hp(1.5)),
          PosterProfileDetailRow(res: res, icon: Icons.location_on_outlined, text: profile.location, colorScheme: colorScheme),
        ],
      ),
    );
  }
}
