import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';

class FixerBioSection extends StatelessWidget {
  final String bio;

  const FixerBioSection({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          bio,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
