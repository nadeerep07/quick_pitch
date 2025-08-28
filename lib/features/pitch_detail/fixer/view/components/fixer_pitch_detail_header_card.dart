import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchHeaderCard extends StatelessWidget {
  final PitchModel currentPitch;
  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool isAssigned;
  final bool isCompleted;

  const FixerPitchHeaderCard({
    super.key,
    required this.currentPitch,
    required this.res,
    required this.theme,
    required this.colorScheme,
    required this.isAssigned,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Row(
          children: [
            Container(
              width: res.sp(50),
              height: res.sp(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child:
                    currentPitch.posterImage != null
                        ? Image.network(
                          currentPitch.posterImage!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Icon(
                                Icons.person,
                                size: res.sp(24),
                                color: colorScheme.primary,
                              ),
                        )
                        : Icon(
                          Icons.person,
                          size: res.sp(24),
                          color: colorScheme.primary,
                        ),
              ),
            ),
            SizedBox(width: res.wp(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPitch.posterName ?? 'Unknown Poster',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: res.hp(0.5)),
                  Text(
                    'Submitted ${_formatDate(currentPitch.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: res.wp(3),
                    vertical: res.hp(0.8),
                  ),
                  decoration: BoxDecoration(
                    color: StatusColorUtil.getStatusColor(currentPitch.status, theme).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: StatusColorUtil.getStatusColor(currentPitch.status, theme),
                      width: 1,
                    )
                  ),
                  child: Text(
                    currentPitch.status.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: StatusColorUtil.getStatusColor(currentPitch.status, theme),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (isAssigned || isCompleted) ...[
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () async {
                      final authService = AuthServices(); // your auth service
                      final currentUserId = authService.currentUser?.uid;

                      if (currentUserId == null) return;

                      // Get fixer profile (current user)
                      final fixerProfile = await ChatRepository()
                          .fetchCurrentUserProfileByRole(
                            currentUserId,
                            role: 'fixer',
                          );

                      // Prevent self-chat (shouldn’t happen, but safe check)
                      if (fixerProfile.uid == currentPitch.posterId) {
                        return;
                      }

                      // Get poster profile from pitch
                      final posterProfile = await ChatRepository()
                          .fetchCurrentUserProfileByRole(
                            currentPitch.posterId,
                            role: 'poster',
                          ); 

                      // Create or get chatId
                      final chatId = await ChatRepository().createOrGetChat(
                        sender: fixerProfile,
                        receiver: posterProfile,
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
                                      currentUserId: fixerProfile.uid,
                                    )..loadMessages(),
                                child: ChatScreen(
                                  chatId: chatId,
                                  currentUser: fixerProfile,
                                  otherUser: posterProfile,
                                ),
                              ),
                        ),
                      );
                    },

                    child: Text(
                      'Message',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }


}
