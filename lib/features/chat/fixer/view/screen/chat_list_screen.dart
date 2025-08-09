import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/fixer/view/components/chat_tile.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/chat/cubit/chat_cubit.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/chat/cubit/chat_state.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with WidgetsBindingObserver {
  late ChatCubit _chatCubit;
  String? _lastKnownRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final String currentUserId = AuthServices().currentUser?.uid ?? '';
    _chatCubit = ChatCubit(
      chatRepository: ChatRepository(),
      currentUserId: currentUserId,
    );
    _chatCubit.loadChats();

    // Track initial role
    _initializeRole();
  }

  Future<void> _initializeRole() async {
    final currentUserId = AuthServices().currentUser?.uid ?? '';
    if (currentUserId.isNotEmpty) {
      _lastKnownRole = await ChatRepository().detectUserRole(currentUserId);
      print("🎯 Initial role detected: $_lastKnownRole");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Check for role changes when app becomes active
    if (state == AppLifecycleState.resumed) {
      _checkForRoleChange();
    }
  }

  Future<void> _checkForRoleChange() async {
    try {
      final currentUserId = AuthServices().currentUser?.uid ?? '';
      if (currentUserId.isEmpty) return;

      final currentRole = await ChatRepository().detectUserRole(currentUserId);

      if (currentRole != _lastKnownRole) {
        print("🔄 Role change detected: $_lastKnownRole → $currentRole");
        _lastKnownRole = currentRole;

        // Reload chats for the new role
        _chatCubit.refreshChatsForRoleSwitch();
      }
    } catch (e) {
      print("❌ Error checking role change: $e");
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
    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          title: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final role = _chatCubit.currentRole;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Chats"),
                  if (role != null)
                    Text(
                      "as ${role.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                print("🔄 Manual refresh requested");
                _checkForRoleChange();
              },
            ),
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
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: MainBackgroundPainter(),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("No chats found."),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _checkForRoleChange(),
                            child: const Text("Refresh"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: MainBackgroundPainter(),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      await _checkForRoleChange();
                    },
                    child: ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return ChatTile(chat: chat);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ChatError) {
              print("Error loading chats: ${state.message}");
              return Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: MainBackgroundPainter(),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Error: ${state.message}"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _chatCubit.loadChats(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
