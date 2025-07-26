import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FixerProfileShimmer extends StatelessWidget {
  final double height;
  const FixerProfileShimmer({super.key, this.height = 250});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: height, width: double.infinity, color: Colors.white),
          const SizedBox(height: 16),
          CircleAvatar(radius: 40, backgroundColor: Colors.white),
          const SizedBox(height: 16),
          Container(height: 20, width: 150, color: Colors.white),
          const SizedBox(height: 12),
          Container(height: 16, width: 200, color: Colors.white),
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(height: 28, width: 80, color: Colors.white),
            )),
          ),
        ],
      ),
    );
  }
}
