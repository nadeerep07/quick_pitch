import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';

class ChatRoles extends StatelessWidget {
  final ChatModel chat;

  const ChatRoles({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${chat.sender.role} → ${chat.receiver.role}',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
