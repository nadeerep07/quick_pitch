import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/full_review_card.dart';

class ReviewListItem extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final ReviewModel review;
  final Map<String, UserProfileModel> reviewerProfiles;
  final UserProfileService userProfileService;

  const ReviewListItem({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.review,
    required this.reviewerProfiles,
    required this.userProfileService,
  });

  Future<UserProfileModel?> _getReviewerProfile(String reviewerId) async {
    if (reviewerProfiles.containsKey(reviewerId)) {
      return reviewerProfiles[reviewerId];
    }
    final profile = await userProfileService.getProfile(reviewerId, 'poster') ??
        await userProfileService.getProfile(reviewerId, 'fixer');
    if (profile != null) reviewerProfiles[reviewerId] = profile;
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfileModel?>(
      future: _getReviewerProfile(review.reviewerId),
      builder: (context, snapshot) {
        final reviewerProfile = snapshot.data;
        final reviewerName = reviewerProfile?.name ?? 'Unknown User';
        final reviewerImage = reviewerProfile?.profileImageUrl;

        return FullReviewCard(
          res: res,
          colorScheme: colorScheme,
          review: review,
          reviewerName: reviewerName,
          reviewerImage: reviewerImage,
        );
      },
    );
  }
}
