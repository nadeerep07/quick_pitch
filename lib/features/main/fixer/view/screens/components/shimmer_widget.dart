import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isCircular;

  const ShimmerWidget.rect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : isCircular = false;

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
  })  : isCircular = true,
        borderRadius = null;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}
