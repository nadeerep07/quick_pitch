import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/fixer/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// Fixer Profile Section
class FixerProfileSection extends StatelessWidget {
  final PitchModel pitch;
  const FixerProfileSection({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<UserProfileModel?>(
      future: context.read<PitchesCubit>().getFixerDetails(pitch.fixerId),
      builder: (context, snapshot) {
        final fixer = snapshot.data;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(4)),
          ),
          color: colorScheme.surface.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.primary, width: 2),
                  ),
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/avatar_photo_placeholder.jpg',
                      image: fixer?.profileImageUrl ?? '',
                      width: res.wp(12),
                      height: res.wp(12),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          radius: res.wp(6),
                          backgroundImage: AssetImage(
                            'assets/images/avatar_photo_placeholder.jpg', // Placeholder image
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: res.wp(4)),
                // Name, Skills, and Message Icon
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              fixer?.name ?? "Unknown Fixer",
                              style: TextStyle(
                                fontSize: res.sp(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (pitch.status == 'accepted') ...[
                            IconButton(
                              onPressed: () async {
                                final authService =
                                    AuthServices(); // Your custom auth service
                                final currentUserId =
                                    authService.currentUser?.uid;

                                if (currentUserId == null || fixer == null)
                                  return;

                                // Fetch current user's profile (poster in this case)
                                final posterProfile = await ChatRepository()
                                    .fetchCurrentUserProfileByRole(
                                      currentUserId,
                                      role: 'poster',
                                    );
                                if (posterProfile.uid == fixer.uid) {
                                  print(
                                    "⚠️ Prevented self-chat in FixerProfileSection",
                                  );
                                  return;
                                }
                                // Create or get chatId
                                final chatId = await ChatRepository()
                                    .createOrGetChat(
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
                                                chatRepository:
                                                    ChatRepository(),
                                                chatId: chatId,
                                                currentUserId:
                                                    posterProfile.uid,
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
                              icon: Icon(Icons.message),
                              tooltip: 'Message Fixer',
                            ),
                          ],
                        ],
                      ),
                      if (fixer?.fixerData?.skills != null &&
                          fixer!.fixerData!.skills!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: res.hp(0.5)),
                          child: Wrap(
                            spacing: res.wp(1.5),
                            runSpacing: res.wp(1),
                            children:
                                fixer.fixerData!.skills!
                                    .map(
                                      (skill) => Chip(
                                        label: Text(
                                          skill,
                                          style: TextStyle(
                                            fontSize: res.sp(10),
                                          ),
                                        ),
                                        backgroundColor: AppColors.icon1
                                            .withValues(alpha: 0.5),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
