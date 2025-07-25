import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExploreTasksShimmer extends StatelessWidget {
  const ExploreTasksShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 6, // Number of shimmer cards
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
                // Title
                Container(height: 16, width: 80, color: Colors.grey[400]),
                const SizedBox(height: 6),
                // Subtitle
                Container(height: 12, width: 60, color: Colors.grey[300]),
                const Spacer(),
                // Price & Date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 12, width: 40, color: Colors.grey[300]),
                    Container(height: 12, width: 30, color: Colors.grey[300]),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
