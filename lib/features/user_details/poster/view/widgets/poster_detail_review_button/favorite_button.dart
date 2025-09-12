import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FavoriteButton extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;

  const FavoriteButton({
    super.key,
    required this.res,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.favorite_border_outlined),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
