import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PitchNotFoundView extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const PitchNotFoundView({
    super.key,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: res.wp(12), color: Colors.red),
          SizedBox(height: res.hp(2)),
          Text(
            "Pitch not found",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            "The pitch you're looking for doesn't exist.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: res.hp(3)),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
            label: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
