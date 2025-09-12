import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class MessageButton extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel poster;

  const MessageButton({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final authService = AuthServices();
        final currentUserId = authService.currentUser?.uid;

        if (currentUserId == null) return;

        final fixerProfile = await ChatRepository().fetchCurrentUserProfileByRole(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
