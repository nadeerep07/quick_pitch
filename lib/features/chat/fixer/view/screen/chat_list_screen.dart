import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/fixer/view/components/chat_tile.dart';
import 'package:quick_pitch_app/features/chat/fixer/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/chat/cubit/chat_cubit.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/chat/cubit/chat_state.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> 
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late ChatCubit _chatCubit;
  String? _lastKnownRole;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeChatCubit();
    _initializeRole();
  }

  void _initializeChatCubit() {
    final currentUserId = AuthServices().currentUser?.uid ?? '';
    _chatCubit = ChatCubit(
      chatRepository: ChatRepository(),
      currentUserId: currentUserId,
    )..loadChats();
  }

  Future<void> _initializeRole() async {
    final currentUserId = AuthServices().currentUser?.uid ?? '';
    if (currentUserId.isNotEmpty) {
      _lastKnownRole = await ChatRepository().detectUserRole(currentUserId);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForRoleChange();
      _chatCubit.refreshChats();
    }
  }

  Future<void> _checkForRoleChange() async {
    try {
      final currentUserId = AuthServices().currentUser?.uid ?? '';
      if (currentUserId.isEmpty) return;

      final currentRole = await ChatRepository().detectUserRole(currentUserId);

      if (currentRole != _lastKnownRole) {
        _lastKnownRole = currentRole;
        _chatCubit.refreshChatsForRoleSwitch();
      }
    } catch (e) {
      debugPrint("Error checking role change: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _chatCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final role = _chatCubit.currentRole;
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
                  if (role != null)
                    Text(
                      'Active as ${role.toUpperCase()}',
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
              onPressed: () => _chatCubit.refreshChats(),
            ),
          ],
        ),
        body: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChatLoaded) {
              if (state.chats.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async => _chatCubit.refreshChats(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.chats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final chat = state.chats[index];
                    return ChatTile(
                      chat: chat,
                      onTap: () => _markAsReadAndNavigate(context, chat),
                    );
                  },
                ),
              );
            }

            if (state is ChatError) {
              return _buildErrorState(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation to see it here',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _chatCubit.refreshChats(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ChatError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load chats',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            style: TextStyle(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _chatCubit.loadChats(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsReadAndNavigate(BuildContext context, ChatModel chat) async {
    if (chat.unreadCount > 0) {
      await _chatCubit.markAsRead(chat.chatId);
    }
    if (mounted) {
      Navigator.push(
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
      ).then((_) => _chatCubit.refreshChats());
    }
  }
}