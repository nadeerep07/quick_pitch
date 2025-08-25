import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/bottom_sheet/fixer_action_buttons.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/bottom_sheet/fixer_bio_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/bottom_sheet/fixer_profile_header.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/bottom_sheet/fixer_skills_section.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';



class FixerBottomSheet extends StatelessWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;
  final VoidCallback onViewProfile;

  const FixerBottomSheet({
    super.key,
    required this.fixer,
    required this.posterLocation,
    required this.onViewProfile,
  });

  String _getDistance() {
    if (posterLocation == null ||
        fixer.fixerData?.latitude == null ||
        fixer.fixerData?.longitude == null ||
        fixer.fixerData!.latitude == 0.0 ||
        fixer.fixerData!.longitude == 0.0) {
      return '';
    }

    final distance = PosterExploreRepository.haversineKm(
      posterLocation!.latitude,
      posterLocation!.longitude,
      fixer.fixerData!.latitude,
      fixer.fixerData!.longitude,
    );

    if (distance < 1) {
      return '${(distance * 1000).round()}m away';
    } else {
      return '${distance.toStringAsFixed(1)}km away';
    }
  }

  @override
  Widget build(BuildContext context) {
    final distance = _getDistance();

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FixerProfileHeader(fixer: fixer, distance: distance),
                      const SizedBox(height: 20),

                      if (fixer.fixerData?.skills != null &&
                          fixer.fixerData!.skills!.isNotEmpty) ...[
                        FixerSkillsSection(skills: fixer.fixerData!.skills!),
                        const SizedBox(height: 20),
                      ],

                      if (fixer.fixerData?.bio != null &&
                          fixer.fixerData!.bio.isNotEmpty) ...[
                        FixerBioSection(bio: fixer.fixerData!.bio),
                        const SizedBox(height: 20),
                      ],

                      FixerActionButtons(onViewProfile: onViewProfile),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
