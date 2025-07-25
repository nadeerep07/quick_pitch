import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerProfileHeader extends StatelessWidget {
  final dynamic profile;
  final ThemeData theme;
  final Responsive res;

  const FixerProfileHeader({
    super.key,
    required this.profile,
    required this.theme,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildName(),
        const SizedBox(height: 4),
        _buildRoleAndLocation(),
        const SizedBox(height: 16),
        _buildRating(),
      ],
    );
  }

  Widget _buildName() {
    return Text(
      profile.name,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildRoleAndLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          'Professional Fixer',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          profile.location,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(
          '4.8 (128 reviews)',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}