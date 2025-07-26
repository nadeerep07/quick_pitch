import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PosterProfileShimmer extends StatelessWidget {
  const PosterProfileShimmer({super.key});

  Widget _shimmerBox({double height = 16, double width = double.infinity, BorderRadius? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _shimmerBox(width: 120, height: 20), // Name
          const SizedBox(height: 8),
          _shimmerBox(width: 100, height: 16), // Location
          const SizedBox(height: 16),
          _shimmerBox(width: 140, height: 16), // Rating
          const SizedBox(height: 24),

          // About Me
          Align(
            alignment: Alignment.centerLeft,
            child: _shimmerBox(width: 100, height: 16),
          ),
          const SizedBox(height: 8),
          _shimmerBox(height: 60),

          const SizedBox(height: 24),

          // Skills
          Align(
            alignment: Alignment.centerLeft,
            child: _shimmerBox(width: 140, height: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _shimmerBox(width: 80, height: 30, borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Contact Info
          Align(
            alignment: Alignment.centerLeft,
            child: _shimmerBox(width: 160, height: 16),
          ),
          const SizedBox(height: 8),
          _shimmerBox(height: 80),
        ],
      ),
    );
  }
}
