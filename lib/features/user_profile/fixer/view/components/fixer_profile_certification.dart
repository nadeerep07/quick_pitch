import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_prodile_modern.dart';

class CertificationSection extends StatelessWidget {
  final String certification;

  const CertificationSection({
    super.key,
    required this.certification,
  });

  @override
  Widget build(BuildContext context) {
    return ModernProfileSection(
      title: 'Certifications',
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                certification,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
                    child: const Center(child: Icon(Icons.error_outline, color: Colors.grey)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}