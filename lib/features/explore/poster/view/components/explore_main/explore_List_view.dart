import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/list_card/explore_list_fixer_card.dart';

import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';



class PosterExploreListView extends StatelessWidget {
  final List<UserProfileModel> fixers;
  final Position? posterLocation;
  const PosterExploreListView({
    super.key,
    required this.fixers,
    required this.posterLocation,
  });
  @override
  Widget build(BuildContext context) {
    if (fixers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No fixers found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try again later',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: fixers.length,
      itemBuilder: (context, index) {
        return ExploreListFixerCard(
          fixer: fixers[index],
          posterLocation: posterLocation,
        );
      },
    );
  }
}
