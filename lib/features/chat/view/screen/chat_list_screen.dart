import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_tile.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/chat_empty_state_widget.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/chat_error_widget.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/chat_navigation_service.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/chat/cubit/chat_list_view_model_cubit.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> 
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  
  late ChatListViewModel _viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = context.read<ChatListViewModel>();
    _viewModel.initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _viewModel.onAppResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: BlocBuilder<ChatListViewModel, ChatListState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (state is ChatListLoaded && state.currentRole != null)
                Text(
                  'Active as ${state.currentRole!.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: AppColors.primary),
          onPressed: () => _viewModel.refreshChats(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ChatListViewModel, ChatListState>(
      listener: (context, state) {
        if (state is ChatListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          ChatListLoading() => const Center(child: CircularProgressIndicator()),
          ChatListLoaded() => _buildChatList(state),
          ChatListError() => ChatErrorWidget(
              message: state.message,
              onRetry: () => _viewModel.refreshChats(),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildChatList(ChatListLoaded state) {
    if (state.chats.isEmpty) {
      return ChatEmptyStateWidget(
        onRefresh: () => _viewModel.refreshChats(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _viewModel.refreshChats(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.chats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final chat = state.chats[index];
          return ChatTile(
            chat: chat,
            onTap: () => _handleChatTap(chat),
          );
        },
      ),
    );
  }

  Future<void> _handleChatTap(ChatModel chat) async {
    // Mark as read first
    if (chat.unreadCount > 0) {
      await _viewModel.markChatAsRead(chat.chatId);
    }

    if (mounted) {
      // Navigation logic moved to a separate navigation service
      ChatNavigationService.navigateToChat(
        context: context,
        chat: chat,
        onReturn: () => _viewModel.refreshChats(),
      );
    }
  }
}
