import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/rating/error_box.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/full_review_bottom_sheet.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/rating/review_card.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/reviews_header.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/review/cubit/review_cubit.dart';



class ReviewsSection extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel fixer;

  const ReviewsSection({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.fixer,
  });

  @override
  Widget build(BuildContext context) {
    final reviewService = ReviewService();
    final userProfileService = UserProfileService();
    final reviewerProfiles = <String, UserProfileModel>{};

    Future<UserProfileModel?> getReviewerProfile(String reviewerId) async {
      if (reviewerProfiles.containsKey(reviewerId)) {
        return reviewerProfiles[reviewerId];
      }
      final profile =
          await userProfileService.getProfile(reviewerId, 'poster') ??
          await userProfileService.getProfile(reviewerId, 'fixer');
      if (profile != null) reviewerProfiles[reviewerId] = profile;
      return profile;
    }

    return Container(
      margin: EdgeInsets.only(top: res.hp(2)),
      child: Column(
        children: [
          ReviewsHeader(
            res: res,
            colorScheme: colorScheme,
            onViewAllPressed: () => _showAllReviewsBottomSheet(
              context,

            ),
          ),
          SizedBox(height: res.hp(1)),

          FutureBuilder<List<ReviewModel>>(
            future: reviewService.fetchUserReviews(fixer.uid, limit: 4),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: res.hp(10),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return ErrorBox(
                  res: res,
                  colorScheme: colorScheme,
                  text: 'Error loading reviews',
                );
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return ErrorBox(
                  res: res,
                  colorScheme: colorScheme,
                  text: 'No reviews yet',
                );
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
                      future: getReviewerProfile(review.reviewerId),
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
        ],
      ),
    );
  }

void _showAllReviewsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return BlocProvider(
        create: (_) => ReviewCubit(
          reviewService: ReviewService(),
          fixerUid: fixer.uid,
        )..fetchReviews(limit: 10), // fetch on open
        child: AllReviewsBottomSheet(
          res: res,
          colorScheme: colorScheme,
          fixer: fixer,
          userProfileService: UserProfileService(),
          reviewerProfiles: {},
        ),
      );
    },
  );
}

}
