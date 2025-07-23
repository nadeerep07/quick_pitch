// Section-wise refactored FixerProfileScreen

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerProfileCertification extends StatelessWidget {
  const FixerProfileCertification({
    super.key,
    required this.profile,
    required this.res,
  });

  final dynamic profile;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Certification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: res.hp(1)),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            profile.fixerData!.certification!,
            width: double.infinity,
            height: res.hp(20),
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                ? child
                : Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error, color: Colors.red)),
          ),
        ),
      ],
    );
  }
}
