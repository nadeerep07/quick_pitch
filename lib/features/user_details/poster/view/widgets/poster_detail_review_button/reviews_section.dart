import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/widgets/poster_detail_review_button/review_card.dart';

class ReviewsSection extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel poster;
  final ReviewService _reviewService = ReviewService();
  final UserProfileService _userProfileService = UserProfileService();

  ReviewsSection({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.poster,
  });

  Future<UserProfileModel?> _getReviewerProfile(
    String reviewerId,
    Map<String, UserProfileModel> cache,
  ) async {
    if (cache.containsKey(reviewerId)) return cache[reviewerId];

    UserProfileModel? profile =
        await _userProfileService.getProfile(reviewerId, 'poster') ??
        await _userProfileService.getProfile(reviewerId, 'fixer');

    if (profile != null) cache[reviewerId] = profile;
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, UserProfileModel> reviewerProfiles = {};

    return Container(
      margin: EdgeInsets.only(top: res.hp(2)),
      child: FutureBuilder<List<ReviewModel>>(
        future: _reviewService.fetchUserReviews(poster.uid, limit: 4),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: res.hp(10),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return _errorBox('Error loading reviews');
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return _errorBox('No reviews yet');
          }

          final reviews = snapshot.data!;
          return SizedBox(
            height: res.hp(14),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return FutureBuilder<UserProfileModel?>(
                  future: _getReviewerProfile(review.reviewerId, reviewerProfiles),
                  builder: (context, profileSnapshot) {
                    final reviewerProfile = profileSnapshot.data;
                    return ReviewCard(
                      res: res,
                      colorScheme: colorScheme,
                      review: review,
                      reviewerName: reviewerProfile?.name ?? 'Unknown User',
                      reviewerImage: reviewerProfile?.profileImageUrl,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _errorBox(String text) {
    return Container(
      height: res.hp(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: res.sp(14), color: Colors.grey[600]),
        ),
      ),
    );
  }
}
