import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/messages/fixer/repository/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final String currentUserId;

  ChatCubit({
    required this.chatRepository,
    required this.currentUserId,
  }) : super(ChatInitial());

void loadChats() {
  emit(ChatLoading());

  try {
    chatRepository.getChatsFromPosterTasks(currentUserId).listen((chatList) {
      emit(ChatLoaded(chatList));
    });
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}

}
