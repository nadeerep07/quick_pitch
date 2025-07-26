import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/components/poster_profile_divider.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/components/poster_profile_state_item.dart';

class PosterProfileStatsSection extends StatelessWidget {
  const PosterProfileStatsSection({
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
              Icon(Icons.insights_outlined, size: res.sp(18), color: colorScheme.primary),
              SizedBox(width: res.wp(2)),
              Text(
                'Performance Stats',
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PosterProfileStateItem(res: res, label: 'Completed', value: '12', icon: Icons.check_circle_outline, colorScheme: colorScheme),
              PosterProfileDivider(res: res, colorScheme: colorScheme),
              PosterProfileStateItem(res: res, label: 'Rating', value: '4.8', icon: Icons.star_outline, colorScheme: colorScheme),
              PosterProfileDivider(res: res, colorScheme: colorScheme),
              PosterProfileStateItem(res: res, label: 'Active', value: '5', icon: Icons.trending_up_outlined, colorScheme: colorScheme),
            ],
          ),
        ],
      ),
    );
  }
}
