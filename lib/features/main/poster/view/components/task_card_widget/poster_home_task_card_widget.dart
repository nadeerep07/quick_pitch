import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterHomeTaskCardWidget extends StatelessWidget {
  const PosterHomeTaskCardWidget({
    super.key,
    required this.res,
    required this.imageUrl,
  });

  final Responsive res;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: res.hp(16),
        width: double.infinity,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/image_placeholder.png',
          image: imageUrl,
          fit: BoxFit.cover,
          imageErrorBuilder: (_, __, ___) => Image.asset(
            'assets/images/image_placeholder.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}