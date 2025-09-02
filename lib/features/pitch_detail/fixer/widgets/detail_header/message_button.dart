import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// --------------------------
/// Message button
/// --------------------------
class MessageButton extends StatelessWidget {
  final PitchModel pitch;
  final ThemeData theme;

  const MessageButton({super.key, 
    required this.pitch,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () async {
        final authService = AuthServices();
        final currentUserId = authService.currentUser?.uid;
        if (currentUserId == null) return;

        final fixerProfile = await ChatRepository()
            .fetchCurrentUserProfileByRole(currentUserId, role: 'fixer');

        if (fixerProfile.uid == pitch.posterId) return;

        final posterProfile = await ChatRepository()
            .fetchCurrentUserProfileByRole(pitch.posterId, role: 'poster');

        final chatId = await ChatRepository().createOrGetChat(
          sender: fixerProfile,
          receiver: posterProfile,
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
    );
  }
}
