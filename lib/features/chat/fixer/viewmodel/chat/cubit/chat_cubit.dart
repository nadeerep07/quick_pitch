import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final String currentUserId;
  StreamSubscription<List<ChatModel>>? _chatSubscription;

  ChatCubit({
    required this.chatRepository,
    required this.currentUserId,
  }) : super(ChatLoading());

  Future<void> loadChats() async {
    try {
      emit(ChatLoading());
      
      _chatSubscription?.cancel();
      
      _chatSubscription = chatRepository.getUserChats(currentUserId).listen(
        (chats) {
          if (!isClosed) emit(ChatLoaded(chats));
        },
        onError: (e) {
          if (!isClosed) emit(ChatError(e.toString()));
        },
      );
    } catch (e) {
      if (!isClosed) emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}