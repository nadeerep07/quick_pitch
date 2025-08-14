part of 'chat_list_view_model_cubit.dart';

abstract class ChatListState {}

class ChatListInitial extends ChatListState {}
class ChatListLoading extends ChatListState {}
class ChatListLoaded extends ChatListState {
  final List<ChatModel> chats;
  final String? currentRole;
  
  ChatListLoaded(this.chats, this.currentRole);
}

class ChatListError extends ChatListState {
  final String message;
  ChatListError(this.message);
}
