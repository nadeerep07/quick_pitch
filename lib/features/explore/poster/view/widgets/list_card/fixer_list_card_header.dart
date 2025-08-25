import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/list_card/fixer_card_rating_distance.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerCardHeader extends StatelessWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;

  const FixerCardHeader({
    super.key,
    required this.fixer,
    required this.posterLocation,
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

    if (distance < 1) return '${(distance * 1000).round()}m';
    return '${distance.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final distance = _getDistance();

    return Row(
      children: [
        // Profile Image
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: CircleAvatar(
            radius: res.wp(7),
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: fixer.profileImageUrl != null
                ? NetworkImage(fixer.profileImageUrl!)
                : null,
            child: fixer.profileImageUrl == null
                ? Text(
                    fixer.name.isNotEmpty ? fixer.name[0].toUpperCase() : 'F',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: res.sp(22),
                    ),
                  )
                : null,
          ),
        ),
        SizedBox(width: res.wp(3.5)),

        // Name, rating, distance
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fixer.name,
                style: TextStyle(
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: res.hp(0.8)),
              FixerCardRatingDistance(distance: distance),
            ],
          ),
        ),

        // Message Button
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[600]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(res.wp(3)),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: implement message action
              },
              borderRadius: BorderRadius.circular(res.wp(3)),
              child: Container(
                padding: EdgeInsets.all(res.wp(3.5)),
                child: Icon(
                  Icons.account_box,
                  color: Colors.white,
                  size: res.sp(18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
