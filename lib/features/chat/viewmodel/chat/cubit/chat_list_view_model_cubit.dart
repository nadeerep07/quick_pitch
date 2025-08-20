import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';

part 'chat_list_view_model_state.dart';

class ChatListViewModel extends Cubit<ChatListState> {
  final ChatRepository _chatRepository;
  final AuthServices _authServices;

  StreamSubscription<List<ChatModel>>? _chatSubscription;
  Timer? _refreshTimer;
  Timer? _roleCheckTimer;

  String? _currentUserId;
  String? _lastKnownRole;
  bool _isDisposed = false;

  ChatListViewModel({
    ChatRepository? chatRepository,
    AuthServices? authServices,
  }) : _chatRepository = chatRepository ?? ChatRepository(),
       _authServices = authServices ?? AuthServices(),
       super(ChatListInitial());

  Future<void> initialize() async {
    if (_isDisposed) return;

    _currentUserId = _authServices.currentUser?.uid;
    if (_currentUserId?.isEmpty ?? true) {
      emit(ChatListError('User not authenticated'));
      return;
    }

    await _initializeRole();
    await _loadChats();
    _setupPeriodicRefresh();
    _setupRoleMonitoring();
  }

  Future<void> _initializeRole() async {
    try {
      if (_currentUserId != null) {
        _lastKnownRole = await _chatRepository.detectUserRole(_currentUserId!);
      }
    } catch (e) {
      debugPrint('Error initializing role: $e');
    }
  }

  void _setupPeriodicRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _silentRefresh(),
    );
  }

  void _setupRoleMonitoring() {
    _roleCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkForRoleChange(),
    );
  }

  Future<void> _loadChats() async {
    if (_isDisposed || _currentUserId == null) return;

    try {
      emit(ChatListLoading());

      // Cancel existing subscription
      await _chatSubscription?.cancel();

      // Subscribe to chat updates
      _chatSubscription = _chatRepository
          .getUserChats(_currentUserId!)
          .listen(_onChatsReceived, onError: _onChatsError);
    } catch (e) {
      debugPrint('Error loading chats: $e');
      if (!_isDisposed) emit(ChatListError(e.toString()));
    }
  }

  void _onChatsReceived(List<ChatModel> chats) {
    if (_isDisposed) return;

    final filteredChats = _filterChatsByRole(chats);
    emit(ChatListLoaded(filteredChats, _lastKnownRole));
  }

  void _onChatsError(dynamic error) {
    debugPrint('Chat stream error: $error');
    if (!_isDisposed) emit(ChatListError(error.toString()));
  }

  List<ChatModel> _filterChatsByRole(List<ChatModel> chats) {
    if (_lastKnownRole == null || _currentUserId == null) return chats;

    return chats.where((chat) {
      return (chat.sender.uid == _currentUserId &&
              chat.sender.role == _lastKnownRole) ||
          (chat.receiver.uid == _currentUserId &&
              chat.receiver.role == _lastKnownRole);
    }).toList();
  }

  Future<void> refreshChats() async {
    debugPrint('Manual refresh triggered');
    await _loadChats();
  }

  Future<void> _silentRefresh() async {
    if (_isDisposed || _currentUserId == null) return;

    try {
      final currentState = state;
      if (currentState is ChatListLoaded) {
        final chats = await _chatRepository.getUserChats(_currentUserId!).first;
        final filteredChats = _filterChatsByRole(chats);
        if (!_isDisposed) {
          emit(ChatListLoaded(filteredChats, _lastKnownRole));
        }
      }
    } catch (e) {
      debugPrint('Silent refresh error: $e');
    }
  }

  Future<void> _checkForRoleChange() async {
    if (_isDisposed || _currentUserId == null) return;

    try {
      final currentRole = await _chatRepository.detectUserRole(_currentUserId!);

      if (currentRole != _lastKnownRole) {
        _lastKnownRole = currentRole;
        debugPrint('Role changed to $currentRole - reloading chats');
        await _loadChats();
      }
    } catch (e) {
      debugPrint('Error checking role change: $e');
    }
  }

  Future<void> markChatAsRead(String chatId) async {
    if (_isDisposed || _currentUserId == null) return;

    try {
      await _chatRepository.markMessagesAsRead(chatId, _currentUserId!);

      // Update local state immediately
      final currentState = state;
      if (currentState is ChatListLoaded) {
        final updatedChats =
            currentState.chats.map((chat) {
              return chat.chatId == chatId
                  ? chat.copyWith(unreadCount: 0)
                  : chat;
            }).toList();

        if (!_isDisposed) {
          emit(ChatListLoaded(updatedChats, _lastKnownRole));
        }
      }
    } catch (e) {
      debugPrint('Error marking chat as read: $e');
      if (!_isDisposed) {
        emit(ChatListError('Failed to mark as read: ${e.toString()}'));
      }
    }
  }

  void onAppResumed() {
    _checkForRoleChange();
    refreshChats();
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    _chatSubscription?.cancel();
    _refreshTimer?.cancel();
    _roleCheckTimer?.cancel();
    return super.close();
  }

  String? get currentRole => _lastKnownRole;
  String? get currentUserId => _currentUserId;
}
