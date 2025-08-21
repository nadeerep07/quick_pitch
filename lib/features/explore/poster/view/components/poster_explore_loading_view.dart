import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_shimmer.dart';

class PosterExploreLoadingView extends StatelessWidget {
  const PosterExploreLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: PosterExploreShimmer(),
      ),
    );
  }
}
