part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;
  SendMessage(this.message);
}

class ClearChat extends ChatEvent {}

class InitializeChat extends ChatEvent {}

class SendQuickAction extends ChatEvent {
  final String action;
  SendQuickAction(this.action);
}