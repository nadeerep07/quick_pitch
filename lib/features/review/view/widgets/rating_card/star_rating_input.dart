import 'package:flutter/material.dart';

class StarRatingInput extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingSelected;
  final double size;

  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onRatingSelected,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        return GestureDetector(
          onTap: () => onRatingSelected(starValue),
          child: Icon(
            rating >= starValue ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: size,
          ),
        );
      }),
    );
  }
}
