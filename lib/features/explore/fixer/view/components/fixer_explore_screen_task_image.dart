import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerExploreScreenTaskImage extends StatelessWidget {
  const FixerExploreScreenTaskImage({
    super.key,
    required this.imageUrl,
    required this.res,
  });

  final String? imageUrl;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage.assetNetwork(
         image:  imageUrl!,
         placeholder: 'assets/images/image_placeholder.png',
          width: double.infinity,
          height: res.hp(12),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: res.hp(12),
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(Icons.image_not_supported, size: res.sp(24), color: Colors.grey),
      );
    }
  }
}
