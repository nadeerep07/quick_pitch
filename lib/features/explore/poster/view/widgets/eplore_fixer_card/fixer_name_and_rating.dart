import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerNameAndRating extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;
  final ThemeData theme;

  const FixerNameAndRating({
    super.key,
    required this.fixer,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            fixer.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(2),
            vertical: res.hp(0.2),
          ),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: res.sp(12),
                color: Colors.amber[700],
              ),
              SizedBox(width: res.wp(1)),
              Text(
                '4.8', // mock rating
                style: TextStyle(
                  fontSize: res.sp(12),
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
