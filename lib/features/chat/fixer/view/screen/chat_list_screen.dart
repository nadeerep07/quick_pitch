import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/fixer/view/components/chat_tile.dart';
import 'package:quick_pitch_app/features/chat/fixer/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/chat/cubit/chat_cubit.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/chat/cubit/chat_state.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = AuthServices().currentUser?.uid ?? '';

    return BlocProvider(
      create:
          (_) => ChatCubit(
            chatRepository: ChatRepository(),
            currentUserId: currentUserId,
          )..loadChats(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          title: const Text("Chats"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Implement search functionality if needed
              },
            ),
          ],
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatLoaded) {
              if (state.chats.isEmpty) {
                return const Center(child: Text("No chats found."));
              }

              return Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: MainBackgroundPainter(),
                  ),
                  ListView.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];
                      return ChatTile(chat: chat);
                    },
                  ),
                ],
              );
            } else if (state is ChatError) {
              print("Error loading chats: ${state.message}");
              return Center(child: Text("Error: ${state.message}"));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
