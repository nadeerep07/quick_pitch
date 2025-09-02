import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerDetailRatingButton extends StatelessWidget {
  const FixerDetailRatingButton({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.fixer,
  });

  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel fixer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Rating chip
        Container(
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
              Icon(Icons.star_rounded, size: res.sp(16), color: Colors.amber),
              SizedBox(width: res.wp(1)),
              Text(
              fixer.fixerData?.ratingStats?.averageRating.toStringAsFixed(1) ?? '0.0',
                style: TextStyle(
                  fontSize: res.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: res.wp(1)),
              Text(
               "(${fixer.fixerData?.ratingStats?.totalReviews.toString()} ) ?? '0' " ,
                style: TextStyle(fontSize: res.sp(12), color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        Spacer(),

        // Action buttons
        TextButton.icon(
          onPressed: () async {
            final authService = AuthServices(); // Your custom auth service
            final currentUserId = authService.currentUser?.uid;

            if (currentUserId == null) {
              return;
            }

            // Fetch current user's profile (poster in this case)
            final posterProfile = await ChatRepository()
                .fetchCurrentUserProfileByRole(currentUserId, role: 'poster');
            if (posterProfile.uid == fixer.uid) {
              //   print("⚠️ Prevented self-chat in FixerProfileSection");
              return;
            }
            // Create or get chatId
            final chatId = await ChatRepository().createOrGetChat(
              sender: posterProfile,
              receiver: fixer,
            );

            // Navigate to ChatScreen
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
                        otherUser: fixer,
                      ),
                    ),
              ),
            );
          },
          label: Text('Message'),
          icon: Icon(Icons.message_outlined),
          style: TextButton.styleFrom(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(width: res.wp(7)),
      ],
    );
  }
}
