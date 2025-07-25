import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/profile_input_text_field.dart';

class CertificationSection extends StatelessWidget {
  final CompleteProfileCubit cubit;

  const CertificationSection({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileInputField(
          isReadOnly: true,
          label: "Certification",
          controller: cubit.certificationController,
          icon: Icons.upload_file,
          onLocationTap: cubit.pickCertificationFile,
        ),
        if (cubit.certificateImage != null) ...[
          const SizedBox(height: 12),
          _buildCertificatePreview(),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCertificatePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Certificate Preview",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: cubit.certificateImage != null
              ? Image.file(
                  cubit.certificateImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : cubit.certificationController.text.isNotEmpty
                  ? Image.network(
                      cubit.certificationController.text,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text("Failed to load image"));
                      },
                    )
                  : Image.asset(
                      'assets/images/placeholder_certificate.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
        ),
      ],
    );
  }
}