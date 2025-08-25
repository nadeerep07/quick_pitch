import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerProfileHeader extends StatelessWidget {
  final UserProfileModel fixer;
  final String distance;

  const FixerProfileHeader({
    super.key,
    required this.fixer,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          backgroundImage: fixer.profileImageUrl != null
              ? NetworkImage(fixer.profileImageUrl!)
              : null,
          child: fixer.profileImageUrl == null
              ? Text(
                  fixer.name.isNotEmpty ? fixer.name[0].toUpperCase() : 'F',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 16),

        // Name + rating + distance
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fixer.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  const Text(
                    '4.8',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(24 reviews)',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              if (distance.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(distance,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
