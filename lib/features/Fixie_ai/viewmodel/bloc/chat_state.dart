part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatLoaded({
    required this.messages,
    this.isLoading = false,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
