part of 'individual_chat_cubit.dart';

abstract class IndividualChatState {}

class IndividualChatLoading extends IndividualChatState {}

class IndividualChatLoaded extends IndividualChatState {
  final List<MessageModel> messages;
  IndividualChatLoaded(this.messages);
}

class IndividualChatError extends IndividualChatState {
  final String message;
  IndividualChatError(this.message);
}
