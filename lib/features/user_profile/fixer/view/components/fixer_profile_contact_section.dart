import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_prodile_modern.dart';

class ContactSection extends StatelessWidget {
  final String phone;
  final String email;
  final ThemeData theme;

  const ContactSection({
    super.key,
    required this.phone,
    required this.email,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ModernProfileSection(
      title: 'Contact Information',
      child: Column(
        children: [
          _buildContactItem(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: phone,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            icon: Icons.email_outlined,
            title: 'Email',
            value: email,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}