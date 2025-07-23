// Section-wise refactored FixerProfileScreen

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_contact_item.dart';

class FixerProfileContactInfo extends StatelessWidget {
  const FixerProfileContactInfo({
    super.key,
    required this.profile,
  });

  final dynamic profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FixerProfileContactItem(icon: Icons.phone, title: 'Phone', value: profile.phone),
          ),
        ),
      ],
    );
  }
}
