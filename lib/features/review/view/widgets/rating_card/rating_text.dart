import 'package:flutter/material.dart';

class RatingText extends StatelessWidget {
  final double rating;
  final ThemeData theme;

  const RatingText({
    super.key,
    required this.rating,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _getRatingText(rating),
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: _getRatingColor(rating),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return 'Tap to rate';
    if (rating <= 1) return 'Poor';
    if (rating <= 2) return 'Fair';
    if (rating <= 3) return 'Good';
    if (rating <= 4) return 'Very Good';
    return 'Excellent';
  }

  Color _getRatingColor(double rating) {
    if (rating == 0) return Colors.grey;
    if (rating <= 2) return Colors.red;
    if (rating <= 3) return Colors.orange;
    if (rating <= 4) return Colors.blue;
    return Colors.green;
  }
}