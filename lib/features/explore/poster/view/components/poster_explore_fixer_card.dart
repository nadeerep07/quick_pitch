import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: res.wp(16),
              height: res.wp(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withOpacity(0.1),
              ),
              child:
                  fixer.profileImageUrl?.isNotEmpty == true
                      ? ClipOval(
                        child: Image.network(
                          fixer.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: res.sp(24),
                              color: theme.primaryColor,
                            );
                          },
                        ),
                      )
                      : Icon(
                        Icons.person,
                        size: res.sp(24),
                        color: theme.primaryColor,
                      ),
            ),

            SizedBox(width: res.wp(4)),

            // Fixer Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
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
                      // Mock rating - replace with actual rating system
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: res.wp(2),
                          vertical: res.hp(0.2),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
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
                              '4.8', // Mock rating
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
                  ),

                  SizedBox(height: res.hp(0.5)),

                  // Skills
                  if (fixer.fixerData?.skills?.isNotEmpty == true)
                    Wrap(
                      spacing: res.wp(1),
                      runSpacing: res.hp(0.5),
                      children:
                          fixer.fixerData!.skills!.take(3).map((skill) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: res.wp(2),
                                vertical: res.hp(0.3),
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: res.sp(10),
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                  SizedBox(height: res.hp(0.8)),

                  // Location and distance
                  Row(
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
                            color: Colors.green.withOpacity(0.1),
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
                  ),
                ],
              ),
            ),

            SizedBox(width: res.wp(3)),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: res.wp(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to fixer profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: res.hp(1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('View', style: TextStyle(fontSize: res.sp(12))),
                  ),
                ),
                SizedBox(height: res.hp(1)),
                SizedBox(
                  width: res.wp(20),
                  child: OutlinedButton(
                    onPressed: () {
                      // Start chat with fixer
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: res.hp(1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: theme.primaryColor),
                    ),
                    child: Text(
                      'Message',
                      style: TextStyle(fontSize: res.sp(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
}
