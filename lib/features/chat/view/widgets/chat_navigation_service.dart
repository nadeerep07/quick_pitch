import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';

class ChatNavigationService {
  static Future<void> navigateToChat({
    required BuildContext context,
    required ChatModel chat,
    required VoidCallback onReturn,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => IndividualChatCubit(
            chatRepository: ChatRepository(),
            chatId: chat.chatId,
            currentUserId: AuthServices().currentUser?.uid ?? '',
          )..loadMessages(),
          child: ChatScreen(
            chatId: chat.chatId,
            currentUser: chat.sender,
            otherUser: chat.receiver,
          ),
        ),
      ),
    );
    
    onReturn();
  }
}