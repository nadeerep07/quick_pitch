import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';

class ChatLastMessage extends StatelessWidget {
  final ChatModel chat;

  const ChatLastMessage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Text(
      chat.lastMessage,
      style: TextStyle(
        fontSize: 15,
        color: chat.unreadCount > 0 ? Colors.black87 : Colors.grey.shade600,
        fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
