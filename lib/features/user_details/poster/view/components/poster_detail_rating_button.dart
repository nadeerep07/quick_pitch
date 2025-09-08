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

class PosterDetailRatingButton extends StatefulWidget {
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
  State<PosterDetailRatingButton> createState() =>
      _PosterDetailRatingButtonState();
}

class _PosterDetailRatingButtonState extends State<PosterDetailRatingButton> {
  final ReviewService _reviewService = ReviewService();
  final UserProfileService _userProfileService = UserProfileService(); // Add this
  bool _showReviews = false;
  Map<String, UserProfileModel> _reviewerProfiles = {}; // Cache for reviewer profiles

  Future<UserProfileModel?> _getReviewerProfile(String reviewerId) async {
    // Check if we already have this profile cached
    if (_reviewerProfiles.containsKey(reviewerId)) {
      return _reviewerProfiles[reviewerId];
    }

    try {
      // Try to get the profile - we don't know the role, so try both
      UserProfileModel? profile = await _userProfileService.getProfile(reviewerId, 'poster');
      if (profile == null) {
        profile = await _userProfileService.getProfile(reviewerId, 'fixer');
      }
      
      if (profile != null) {
        _reviewerProfiles[reviewerId] = profile;
      }
      
      return profile;
    } catch (e) {
      print('Error fetching reviewer profile: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Rating chip - now clickable
            GestureDetector(
              onTap: () {
                setState(() {
                  _showReviews = !_showReviews;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.res.wp(3),
                  vertical: widget.res.hp(0.8),
                ),
                decoration: BoxDecoration(
                  color: widget.colorScheme.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: widget.res.sp(16),
                      color: Colors.amber,
                    ),
                    SizedBox(width: widget.res.wp(1)),
                    Text(
                      widget.poster.posterData?.ratingStats?.averageRating
                              .toStringAsFixed(1) ??
                          '0.0',
                      style: TextStyle(
                        fontSize: widget.res.sp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: widget.res.wp(1)),
                    Text(
                      ' (${widget.poster.posterData?.ratingStats?.totalReviews.toString() ?? '0'})',
                      style: TextStyle(
                        fontSize: widget.res.sp(12),
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: widget.res.wp(1)),
                    Icon(
                      _showReviews
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: widget.res.sp(16),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // Action buttons
            IconButton(
              onPressed: () async {
                final authService = AuthServices();
                final currentUserId = authService.currentUser?.uid;

                if (currentUserId == null) return;

                final posterProfile = await ChatRepository()
                    .fetchCurrentUserProfileByRole(
                      currentUserId,
                      role: 'fixer',
                    );
                if (posterProfile.uid == widget.poster.uid) {
                  return;
                }

                final chatId = await ChatRepository().createOrGetChat(
                  sender: posterProfile,
                  receiver: widget.poster,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider(
                          create:
                              (context) => IndividualChatCubit(
                                chatRepository: ChatRepository(),
                                chatId: chatId,
                                currentUserId: posterProfile.uid,
                              )..loadMessages(),
                          child: ChatScreen(
                            chatId: chatId,
                            currentUser: posterProfile,
                            otherUser: widget.poster,
                          ),
                        ),
                  ),
                );
              },
              icon: Icon(Icons.message_outlined),
              style: IconButton.styleFrom(
                backgroundColor: widget.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(width: widget.res.wp(2)),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border_outlined),
              style: IconButton.styleFrom(
                backgroundColor: widget.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),

        // Reviews section
        if (_showReviews)
          Container(
            margin: EdgeInsets.only(top: widget.res.hp(2)),
            child: FutureBuilder<List<ReviewModel>>(
              future: _reviewService.fetchUserReviews(
                widget.poster.uid,
                limit: 4,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: widget.res.hp(10),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    height: widget.res.hp(10),
                    decoration: BoxDecoration(
                      color: widget.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Error loading reviews',
                        style: TextStyle(
                          fontSize: widget.res.sp(14),
                          color: Colors.red[600],
                        ),
                      ),
                    ),
                  );
                }

                // Check if data is null OR empty
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Container(
                    height: widget.res.hp(10),
                    decoration: BoxDecoration(
                      color: widget.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontSize: widget.res.sp(14),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }

                final reviews = snapshot.data!;
                
                return Container(
                  height: widget.res.hp(14), // Increased height to accommodate reviewer info
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return FutureBuilder<UserProfileModel?>(
                        future: _getReviewerProfile(review.reviewerId),
                        builder: (context, profileSnapshot) {
                          final reviewerProfile = profileSnapshot.data;
                          final reviewerName = reviewerProfile?.name ?? 'Unknown User';
                          final reviewerImage = reviewerProfile?.profileImageUrl;
                          
                          return Container(
                            width: widget.res.wp(70),
                            margin: EdgeInsets.only(right: widget.res.wp(3)),
                            padding: EdgeInsets.all(widget.res.wp(3)),
                            decoration: BoxDecoration(
                              color: widget.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reviewer info row
                                Row(
                                  children: [
                                    // Reviewer profile image
                                    Container(
                                      width: widget.res.wp(8),
                                      height: widget.res.wp(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: reviewerImage != null && reviewerImage.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(reviewerImage),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: AssetImage('assets/images/avatar_photo_placeholder.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: widget.res.wp(2)),
                                    // Reviewer name
                                    Expanded(
                                      child: Text(
                                        reviewerName,
                                        style: TextStyle(
                                          fontSize: widget.res.sp(12),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Rating and date
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: List.generate(5, (starIndex) {
                                            return Icon(
                                              starIndex < (review.rating ?? 0)
                                                  ? Icons.star_rounded
                                                  : Icons.star_border_rounded,
                                              size: widget.res.sp(12),
                                              color: Colors.amber,
                                            );
                                          }),
                                        ),
                                        SizedBox(height: widget.res.hp(0.5)),
                                        Text(
                                          review.createdAt != null
                                              ? '${DateTime.now().difference(review.createdAt!).inDays}d ago'
                                              : '',
                                          style: TextStyle(
                                            fontSize: widget.res.sp(10),
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: widget.res.hp(1)),
                                // Review comment
                                Expanded(
                                  child: Text(
                                    review.comment ?? 'No comment provided',
                                    style: TextStyle(
                                      fontSize: widget.res.sp(12),
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
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
  }
}