import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/message_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

part 'individual_chat_state.dart';

class IndividualChatCubit extends Cubit<IndividualChatState> {
  final ChatRepository chatRepository;
  final String chatId;
  final String currentUserId;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  IndividualChatCubit({
    required this.chatRepository,
    required this.chatId,
    required this.currentUserId,
  }) : super(IndividualChatLoading());

  void loadMessages() {
    emit(IndividualChatLoading());
    
    _messagesSubscription?.cancel();
    
    _messagesSubscription = chatRepository.getChatMessages(chatId).listen(
      (messages) {
        if (!isClosed) emit(IndividualChatLoaded(messages));
      },
      onError: (e) {
        if (!isClosed) emit(IndividualChatError(e.toString()));
      },
    );
  }

  Future<void> sendMessage(String text, UserProfileModel sender, UserProfileModel receiver) async {
    try {
      await chatRepository.sendMessage(
        chatId: chatId,
        sender: sender,
        receiver: receiver,
        messageText: text,
      );
    } catch (e) {
      if (!isClosed) emit(IndividualChatError(e.toString()));
    }
  }

  void markAsRead() {
    chatRepository.markMessagesAsRead(chatId, currentUserId);
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
