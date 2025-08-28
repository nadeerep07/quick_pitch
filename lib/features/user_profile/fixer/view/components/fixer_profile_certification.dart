import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_prodile_modern.dart';

class CertificationSection extends StatelessWidget {
  final String certification;
  final String status;
  final VoidCallback? onUpdateCertificate;

  const CertificationSection({
    super.key,
    required this.certification,
    required this.status,
    this.onUpdateCertificate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ModernProfileSection(
      title: 'Certifications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    certification,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[100], child: const Icon(Icons.error_outline)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:  StatusColorUtil.getStatusColor(
                                status, theme),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          if (status.toLowerCase() == 'rejected' && onUpdateCertificate != null)
            TextButton.icon(
              onPressed: onUpdateCertificate,
              icon: const Icon(Icons.upload_file),
              label: const Text("Update Certificate"),
            ),
        ],
      ),
    );
  }

}
