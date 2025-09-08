import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/cubit/review_visibility_cubit.dart';

class PosterDetailRatingButton extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel poster;

  const PosterDetailRatingButton({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewVisibilityCubit(),
      child: _PosterDetailRatingContent(
        res: res,
        colorScheme: colorScheme,
        poster: poster,
      ),
    );
  }
}
class _PosterDetailRatingContent extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel poster;
  final ReviewService _reviewService = ReviewService();
  final UserProfileService _userProfileService = UserProfileService();

  _PosterDetailRatingContent({
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

    return BlocBuilder<ReviewVisibilityCubit, bool>(
      builder: (context, showReviews) {
        return Column(
          children: [
            Row(
              children: [
                // Rating chip - now handled by cubit
                GestureDetector(
                  onTap: () => context.read<ReviewVisibilityCubit>().toggle(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: res.wp(3),
                      vertical: res.hp(0.8),
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            size: res.sp(16), color: Colors.amber),
                        SizedBox(width: res.wp(1)),
                        Text(
                          poster.posterData?.ratingStats?.averageRating
                                  .toStringAsFixed(1) ??
                              '0.0',
                          style: TextStyle(
                            fontSize: res.sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: res.wp(1)),
                        Text(
                          ' (${poster.posterData?.ratingStats?.totalReviews.toString() ?? '0'})',
                          style: TextStyle(
                            fontSize: res.sp(12),
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: res.wp(1)),
                        Icon(
                          showReviews
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: res.sp(16),
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Action buttons
                IconButton(
                  onPressed: () async {
                    final authService = AuthServices();
                    final currentUserId = authService.currentUser?.uid;

                    if (currentUserId == null) return;

                    final fixerProfile =
                        await ChatRepository().fetchCurrentUserProfileByRole(
                      currentUserId,
                      role: 'fixer',
                    );

                    if (fixerProfile.uid == poster.uid) return;

                    final chatId = await ChatRepository().createOrGetChat(
                      sender: fixerProfile,
                      receiver: poster,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => IndividualChatCubit(
                            chatRepository: ChatRepository(),
                            chatId: chatId,
                            currentUserId: fixerProfile.uid,
                          )..loadMessages(),
                          child: ChatScreen(
                            chatId: chatId,
                            currentUser: fixerProfile,
                            otherUser: poster,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.message_outlined),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(width: res.wp(2)),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_outlined),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            // Reviews Section
            if (showReviews)
              Container(
                margin: EdgeInsets.only(top: res.hp(2)),
                child: FutureBuilder<List<ReviewModel>>(
                  future: _reviewService.fetchUserReviews(
                    poster.uid,
                    limit: 4,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: res.hp(10),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
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
                            future: _getReviewerProfile(
                                review.reviewerId, reviewerProfiles),
                            builder: (context, profileSnapshot) {
                              final reviewerProfile = profileSnapshot.data;
                              final reviewerName =
                                  reviewerProfile?.name ?? 'Unknown User';
                              final reviewerImage =
                                  reviewerProfile?.profileImageUrl;

                              return _reviewCard(
                                review,
                                reviewerName,
                                reviewerImage,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
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
          style: TextStyle(
            fontSize: res.sp(14),
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _reviewCard(
    ReviewModel review,
    String reviewerName,
    String? reviewerImage,
  ) {
    return Container(
      width: res.wp(70),
      margin: EdgeInsets.only(right: res.wp(3)),
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Reviewer image
              Container(
                width: res.wp(8),
                height: res.wp(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: reviewerImage != null && reviewerImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(reviewerImage),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage(
                            'assets/images/avatar_photo_placeholder.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: res.wp(2)),
              // Reviewer name
              Expanded(
                child: Text(
                  reviewerName,
                  style: TextStyle(
                    fontSize: res.sp(12),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Stars + Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < (review.rating ?? 0)
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: res.sp(12),
                        color: Colors.amber,
                      );
                    }),
                  ),
                  SizedBox(height: res.hp(0.5)),
                  Text(
                    review.createdAt != null
                        ? '${DateTime.now().difference(review.createdAt!).inDays}d ago'
                        : '',
                    style: TextStyle(
                      fontSize: res.sp(10),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: res.hp(1)),
          // Review text
          Expanded(
            child: Text(
              review.comment ?? 'No comment provided',
              style: TextStyle(
                fontSize: res.sp(12),
                color: Colors.grey[700],
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
