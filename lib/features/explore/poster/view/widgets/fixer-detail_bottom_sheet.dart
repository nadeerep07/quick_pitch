import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/poster_explore_repository.dart';
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
    final theme = Theme.of(context);
    final distance = _calculateDistance();

    return Container(
      padding: EdgeInsets.all(res.wp(5)),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: res.wp(12),
              height: res.hp(0.5),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          SizedBox(height: res.hp(2)),
          
          // Profile Header
          Row(
            children: [
              CircleAvatar(
                radius: res.wp(8),
                backgroundColor: _getCertificateStatusColor(
                  fixer.fixerData?.certificateStatus,
                ),
                child: Text(
                  _getInitials(fixer.name),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: res.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              SizedBox(width: res.wp(4)),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fixer.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    if (distance != null) ...[
                      SizedBox(height: res.hp(0.5)),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: res.sp(14),
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: res.wp(1)),
                          Text(
                            '${distance.toStringAsFixed(1)} km away',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    SizedBox(height: res.hp(0.5)),
                    
                    // Certificate status
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: res.wp(2),
                    //     vertical: res.hp(0.3),
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: _getCertificateStatusColor(
                    //       fixer.fixerData?.certificateStatus,
                    //     ).withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(12),
                    //     border: Border.all(
                    //       color: _getCertificateStatusColor(
                    //         fixer.fixerData?.certificateStatus,
                    //       ),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Text(
                    //     _getStatusText(fixer.fixerData?.certificateStatus),
                    //     style: TextStyle(
                    //       color: _getCertificateStatusColor(
                    //         fixer.fixerData?.certificateStatus,
                    //       ),
                    //       fontSize: res.sp(12),
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: res.hp(2.5)),
          
          // Skills
          if (fixer.fixerData?.skills != null && 
              fixer.fixerData!.skills!.isNotEmpty) ...[
            Text(
              'Skills',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: res.hp(1)),
            
            Wrap(
              spacing: res.wp(2),
              runSpacing: res.hp(1),
              children: fixer.fixerData!.skills!.take(5).map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: res.wp(3),
                    vertical: res.hp(0.5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: res.sp(12),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: res.hp(2)),
          ],
          
          // Bio
          if (fixer.fixerData?.bio != null && 
              fixer.fixerData!.bio.isNotEmpty) ...[
            Text(
              'About',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: res.hp(1)),
            
            Text(
              fixer.fixerData!.bio,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: res.hp(2)),
          ],
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to fixer profile
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('View Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: res.wp(3)),
              
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Initiate contact or hire process
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  double? _calculateDistance() {
    if (posterLocation == null || 
        fixer.fixerData?.latitude == null || 
        fixer.fixerData?.longitude == null) {
      return null;
    }
    
    return PosterExploreRepository.haversineKm(
      posterLocation!.latitude,
      posterLocation!.longitude,
      fixer.fixerData!.latitude,
      fixer.fixerData!.longitude,
    );
  }

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'F';
  }

  Color _getCertificateStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return 'Verified';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Not Verified';
      default:
        return 'Unknown';
    }
  }
}