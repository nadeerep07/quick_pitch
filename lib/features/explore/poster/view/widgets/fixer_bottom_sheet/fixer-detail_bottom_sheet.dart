import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_bottom_sheet/action_buttons.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_bottom_sheet/bio_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_bottom_sheet/handle_bar.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_bottom_sheet/profile_header.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_bottom_sheet/skills_section.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerDetailsBottomSheet extends StatelessWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;

  const FixerDetailsBottomSheet({
    super.key,
    required this.fixer,
    this.posterLocation,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final distance = _calculateDistance();

    return Container(
      padding: EdgeInsets.all(res.wp(5)),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HandleBar(res: res),
          SizedBox(height: res.hp(2)),
          ProfileHeader(fixer: fixer, res: res, distance: distance),
          if (fixer.fixerData?.skills != null &&
              fixer.fixerData!.skills!.isNotEmpty)
            SkillsSection(fixer: fixer, res: res),
          if (fixer.fixerData?.bio != null &&
              fixer.fixerData!.bio.isNotEmpty)
            BioSection(fixer: fixer, res: res),
          ActionButtons(res: res),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  double? _calculateDistance() {
    if (posterLocation == null ||
        fixer.fixerData?.latitude == null ||
        fixer.fixerData?.longitude == null) return null;

    return PosterExploreRepository.haversineKm(
      posterLocation!.latitude,
      posterLocation!.longitude,
      fixer.fixerData!.latitude,
      fixer.fixerData!.longitude,
    );
  }
}
