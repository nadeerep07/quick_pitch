import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final String currentUserId;
  StreamSubscription<List<ChatModel>>? _chatSubscription;
  String? _currentRole;

  ChatCubit({
    required this.chatRepository,
    required this.currentUserId,
  }) : super(ChatLoading());

  Future<void> loadChats() async {
    try {
      emit(ChatLoading());
      
      // Detect current user role
      final userRole = await chatRepository.detectUserRole(currentUserId);
      _currentRole = userRole;
      
      print("🔄 ChatCubit loading chats for user: $currentUserId with role: $userRole");
      
      _chatSubscription?.cancel();
      
      _chatSubscription = chatRepository.getUserChats(currentUserId).listen(
        (chats) {
          print("📨 ChatCubit received ${chats.length} chats for role: $_currentRole");
          if (!isClosed) emit(ChatLoaded(chats));
        },
        onError: (e) {
          print("❌ ChatCubit error: $e");
          if (!isClosed) emit(ChatError(e.toString()));
        },
      );
    } catch (e) {
      print("❌ ChatCubit loadChats error: $e");
      if (!isClosed) emit(ChatError(e.toString()));
    }
  }

  // Call this method when user switches roles
  Future<void> refreshChatsForRoleSwitch() async {
    try {
      final newRole = await chatRepository.detectUserRole(currentUserId);
      
      // Only reload if role actually changed
      if (newRole != _currentRole) {
        print("👤 Role changed from $_currentRole to $newRole - reloading chats");
        _currentRole = newRole;
        await loadChats();
      }
    } catch (e) {
      print("❌ Error refreshing chats for role switch: $e");
    }
  }

  // Get current user's active role
  String? get currentRole => _currentRole;

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}