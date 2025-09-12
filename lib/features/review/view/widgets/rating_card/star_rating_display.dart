import 'package:flutter/material.dart';

class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final double starSize;
  final bool showText;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.totalReviews = 0,
    this.starSize = 16,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final filled = rating > index;
          final halfFilled = rating > index && rating < index + 1;

          return Icon(
            halfFilled
                ? Icons.star_half
                : (filled ? Icons.star : Icons.star_border),
            color: Colors.amber,
            size: starSize,
          );
        }),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            '${rating.toStringAsFixed(1)}${totalReviews > 0 ? ' ($totalReviews)' : ''}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}