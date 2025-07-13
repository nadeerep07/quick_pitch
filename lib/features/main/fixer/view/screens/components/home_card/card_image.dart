import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class CardImage extends StatelessWidget {
  const CardImage({
    super.key,
    required this.imageUrls,
    required this.res,
  });

  final List<String>? imageUrls;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrls != null && imageUrls!.isNotEmpty
          ? Image.network(
              imageUrls!.first,
              width: res.wp(25),
              height: res.wp(25),
              fit: BoxFit.cover,
            )
          : Container(
              width: res.wp(25),
              height: res.wp(25),
              color: Colors.grey[200],
              child: Icon(
                Icons.image_not_supported,
                size: res.sp(20),
                color: Colors.grey,
              ),
            ),
    );
  }
}
