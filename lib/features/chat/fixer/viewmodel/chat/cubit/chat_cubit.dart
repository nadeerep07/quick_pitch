import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final String currentUserId;
  StreamSubscription<List<ChatModel>>? _chatSubscription;
  String? _currentRole;
  Timer? _refreshTimer;

  ChatCubit({
    required this.chatRepository,
    required this.currentUserId,
  }) : super(ChatLoading()) {
    // Initialize with loading chats
    loadChats();
    
    // Setup periodic refresh (every 30 seconds)
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!isClosed) {
        _silentRefresh();
      }
    });
  }

  Future<void> loadChats() async {
    try {
      emit(ChatLoading());
      
      // Detect current user role
      final userRole = await chatRepository.detectUserRole(currentUserId);
      _currentRole = userRole;
      
      debugPrint(" Loading chats for user: $currentUserId as $userRole");
      
      // Cancel any existing subscription
      _chatSubscription?.cancel();
      
      // Subscribe to chat updates
      _chatSubscription = chatRepository.getUserChats(currentUserId).listen(
        (chats) {
          final filteredChats = _filterChatsByRole(chats);
          debugPrint(" Received ${filteredChats.length} filtered chats");
          if (!isClosed) {
            emit(ChatLoaded(filteredChats));
          }
        },
        onError: (e) {
          debugPrint("Chat stream error: $e");
          if (!isClosed) emit(ChatError(e.toString()));
        },
      );
    } catch (e) {
      debugPrint(" Error loading chats: $e");
      if (!isClosed) emit(ChatError(e.toString()));
    }
  }

  List<ChatModel> _filterChatsByRole(List<ChatModel> chats) {
    if (_currentRole == null) return chats;
    
    return chats.where((chat) {
      // Show chats where current user is either sender or receiver with current role
      return (chat.sender.uid == currentUserId && chat.sender.role == _currentRole) ||
             (chat.receiver.uid == currentUserId && chat.receiver.role == _currentRole);
    }).toList();
  }

  Future<void> refreshChats() async {
    debugPrint(" Manual refresh triggered");
    await loadChats();
  }

  Future<void> _silentRefresh() async {
    try {
      debugPrint(" Silent refresh in progress...");
      final currentState = state;
      if (currentState is ChatLoaded) {
        final chats = await chatRepository.getUserChats(currentUserId).first;
        final filteredChats = _filterChatsByRole(chats);
        if (!isClosed) emit(ChatLoaded(filteredChats));
      }
    } catch (e) {
      debugPrint(" Silent refresh error: $e");
    }
  }

  Future<void> refreshChatsForRoleSwitch() async {
    try {
      final newRole = await chatRepository.detectUserRole(currentUserId);
      debugPrint(" Checking role change: $_currentRole → $newRole");
      
      if (newRole != _currentRole) {
        _currentRole = newRole;
        debugPrint(" Role changed to $newRole - reloading chats");
        await loadChats();
      }
    } catch (e) {
      debugPrint(" Error during role switch: $e");
      if (!isClosed) emit(ChatError("Failed to switch roles: ${e.toString()}"));
    }
  }

  Future<void> markAsRead(String chatId) async {
    try {
      debugPrint(" Marking chat $chatId as read");
      await chatRepository.markMessagesAsRead(chatId, currentUserId);
      
      // Update local state immediately
      final currentState = state;
      if (currentState is ChatLoaded) {
        final updatedChats = currentState.chats.map((chat) {
          if (chat.chatId == chatId) {
            return chat.copyWith(unreadCount: 0);
          }
          return chat;
        }).toList();
        
        if (!isClosed) emit(ChatLoaded(updatedChats));
      }
    } catch (e) {
      debugPrint(" Error marking as read: $e");
    }
  }

  String? get currentRole => _currentRole;

  @override
  Future<void> close() {
    debugPrint(" Closing ChatCubit");
    _chatSubscription?.cancel();
    _refreshTimer?.cancel();
    return super.close();
  }
}