import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/messages/fixer/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/messages/fixer/view/components/chat_tile.dart';
import 'package:quick_pitch_app/features/messages/fixer/viewmodel/chat/cubit/chat_cubit.dart';
import 'package:quick_pitch_app/features/messages/fixer/viewmodel/chat/cubit/chat_state.dart';

class FixerChatListScreen extends StatelessWidget {
  const FixerChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = AuthServices().currentUser?.uid ?? '';

    return BlocProvider(
      create: (_) => ChatCubit(
        chatRepository: ChatRepository(),
        currentUserId: currentUserId,
      )..loadChats(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatLoaded) {
              if (state.chats.isEmpty) {
                return const Center(child: Text("No chats found."));
              }

              return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final chat = state.chats[index]; // Fixed here
                  return ChatTile(chat: chat); // Fixed here
                },
              );
            } else if (state is ChatError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
