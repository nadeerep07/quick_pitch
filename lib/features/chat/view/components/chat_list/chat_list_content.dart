import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_list/chat_tile.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/individual_message/chat_empty_state_widget.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/chat_list/chat_navigation_service.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/chat/cubit/chat_list_view_model_cubit.dart';

/// ------------------------
/// Chat List Content
/// ------------------------
class ChatListContent extends StatelessWidget {
  final ChatListLoaded state;
  final ChatListViewModel viewModel;

  const ChatListContent({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (state.chats.isEmpty) {
      return ChatEmptyStateWidget(onRefresh: () => viewModel.refreshChats());
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refreshChats(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.chats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final chat = state.chats[index];
          return ChatTile(
            chat: chat,
            onTap: () => _handleChatTap(context, chat),
          );
        },
      ),
    );
  }

  Future<void> _handleChatTap(BuildContext context, ChatModel chat) async {
    if (chat.unreadCount > 0) {
      await viewModel.markChatAsRead(chat.chatId);
    }

    if (context.mounted) {
      ChatNavigationService.navigateToChat(
        context: context,
        chat: chat,
        onReturn: () => viewModel.refreshChats(),
      );
    }
  }
}
