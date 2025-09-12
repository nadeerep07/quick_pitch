import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

/// Message Button Widget
class MessageButton extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel fixer;

  const MessageButton({super.key, 
    required this.res,
    required this.colorScheme,
    required this.fixer,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        final authService = AuthServices();
        final currentUserId = authService.currentUser?.uid;
        if (currentUserId == null) return;

        final posterProfile =
            await ChatRepository().fetchCurrentUserProfileByRole(
          currentUserId,
          role: 'poster',
        );

        if (posterProfile.uid == fixer.uid) return;

        final chatId = await ChatRepository().createOrGetChat(
          sender: posterProfile,
          receiver: fixer,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => IndividualChatCubit(
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
      icon: const Icon(Icons.message_outlined),
      label: const Text('Message'),
      style: TextButton.styleFrom(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

