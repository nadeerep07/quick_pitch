import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'review_list_item.dart';

class ReviewsList extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final List<ReviewModel> reviews;
  final Map<String, UserProfileModel> reviewerProfiles;
  final UserProfileService userProfileService;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const ReviewsList({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.reviews,
    required this.reviewerProfiles,
    required this.userProfileService,
    required this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.all(res.wp(4)),
      itemCount: reviews.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: res.hp(2)),
      itemBuilder: (context, index) {
        if (index >= reviews.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(res.hp(2)),
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
          );
        }

        final review = reviews[index];
        return ReviewListItem(
          res: res,
          colorScheme: colorScheme,
          review: review,
          reviewerProfiles: reviewerProfiles,
          userProfileService: userProfileService,
        );
      },
    );
  }
}
