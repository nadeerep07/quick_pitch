import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerProfileHeader extends StatelessWidget {
  final UserProfileModel profile;
  final ThemeData theme;
  final Responsive res;

  const FixerProfileHeader({
    super.key,
    required this.profile,
    required this.theme,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildName(),
        const SizedBox(height: 4),
        _buildRoleAndLocation(),
        const SizedBox(height: 16),
        _buildRating(),
      ],
    );
  }

  Widget _buildName() {
    return Text(
      profile.name,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildRoleAndLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          'Professional Fixer',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          profile.location,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(2.5),
            vertical: res.hp(0.4),
          ),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(res.wp(2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: res.sp(14), color: Colors.amber[600]),
              SizedBox(width: res.wp(1)),
              Text(
                _formatRating(),
                style: TextStyle(
                  fontSize: res.sp(13),
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
              if (profile.fixerData?.ratingStats?.totalReviews != null && profile.fixerData!.ratingStats!.totalReviews > 0) ...[
                SizedBox(width: res.wp(1)),
                Text(
                  '(${profile.fixerData?.ratingStats?.totalReviews})',
                  style: TextStyle(
                    fontSize: res.sp(11),
                    fontWeight: FontWeight.w500,
                    color: Colors.amber[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
    String _formatRating() {
    if (profile.fixerData?.ratingStats?.averageRating == null || profile.fixerData?.ratingStats?.averageRating == 0.0) {
      return 'New';
    }
    
    // Round to 1 decimal place
    return profile.fixerData!.ratingStats!.averageRating.toStringAsFixed(1);
  }
}