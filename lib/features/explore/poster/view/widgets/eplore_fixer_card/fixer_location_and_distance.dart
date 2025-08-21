import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerLocationAndDistance extends StatelessWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;
  final bool showDistance;
  final Responsive res;
  final ThemeData theme;

  const FixerLocationAndDistance({
    super.key,
    required this.fixer,
    required this.posterLocation,
    required this.showDistance,
    required this.res,
    required this.theme,
  });

  double _calculateDistance() {
    if (posterLocation == null ||
        fixer.fixerData?.latitude == null ||
        fixer.fixerData?.longitude == null) {
      return 0.0;
    }

    return PosterExploreRepository.haversineKm(
      posterLocation!.latitude,
      posterLocation!.longitude,
      fixer.fixerData!.latitude,
      fixer.fixerData!.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: res.sp(14),
          color: Colors.grey[500],
        ),
        SizedBox(width: res.wp(1)),
        Expanded(
          child: Text(
            fixer.location,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showDistance && posterLocation != null) ...[
          SizedBox(width: res.wp(2)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(2),
              vertical: res.hp(0.2),
            ),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${_calculateDistance().toStringAsFixed(1)} km',
              style: TextStyle(
                fontSize: res.sp(10),
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
