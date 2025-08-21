import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/eplore_fixer_card/fixer_action_buttons.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/eplore_fixer_card/fixer_location_and_distance.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/eplore_fixer_card/fixer_name_and_rating.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/eplore_fixer_card/fixer_profile_image.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/eplore_fixer_card/fixer_skills.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class PosterExploreFixerCard extends StatelessWidget {
  final UserProfileModel fixer;
  final bool showDistance;
  final Position? posterLocation;

  const PosterExploreFixerCard({
    super.key,
    required this.fixer,
    this.showDistance = false,
    this.posterLocation,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Row(
          children: [
            FixerProfileImage(fixer: fixer, res: res, theme: theme),
            SizedBox(width: res.wp(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FixerNameAndRating(fixer: fixer, res: res, theme: theme),
                  SizedBox(height: res.hp(0.5)),
                  FixerSkills(fixer: fixer, res: res, theme: theme),
                  SizedBox(height: res.hp(0.8)),
                  FixerLocationAndDistance(
                    fixer: fixer,
                    posterLocation: posterLocation,
                    showDistance: showDistance,
                    res: res,
                    theme: theme,
                  ),
                ],
              ),
            ),
            SizedBox(width: res.wp(3)),
            FixerActionButtons(fixer: fixer, res: res, theme: theme),
          ],
        ),
      ),
    );
  }
}
