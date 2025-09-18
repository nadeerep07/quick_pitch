import 'package:flutter/material.dart';

class ReviewsLoading extends StatelessWidget {
  final ColorScheme colorScheme;

  const ReviewsLoading({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: colorScheme.primary));
  }
}
