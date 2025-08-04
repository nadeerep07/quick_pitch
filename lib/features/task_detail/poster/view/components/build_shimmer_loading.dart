import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/task_detail/poster/view/components/poster_home_shimmer_task_card.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6, // Number of shimmer placeholders
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) => const ShimmerTaskCard(),
      ),
    );
  }
