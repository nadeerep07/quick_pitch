import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileModel fixer;
  final Responsive res;
  final double? distance;

  const ProfileHeader({super.key, 
    required this.fixer,
    required this.res,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: res.wp(8),
          backgroundColor:
              _getCertificateStatusColor(fixer.fixerData?.certificateStatus),
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
              if (distance != null)
                SizedBox(height: res.hp(0.5)),
              if (distance != null)
                Row(
                  children: [
                    Icon(Icons.location_on, size: res.sp(14), color: Colors.grey[600]),
                    SizedBox(width: res.wp(1)),
                    Text(
                      '${distance!.toStringAsFixed(1)} km away',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length >= 2) return '${names[0][0]}${names[1][0]}'.toUpperCase();
    return names.isNotEmpty ? names[0].substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase() : 'F';
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
}
