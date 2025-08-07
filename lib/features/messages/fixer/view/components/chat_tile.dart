import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/messages/fixer/model/chat_model.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;

  const ChatTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: chat.receiver.profileImageUrl != null
            ? NetworkImage(chat.receiver.profileImageUrl!)
            : null,
        child: chat.receiver.profileImageUrl == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(chat.receiver.name),
      subtitle: Text(chat.lastMessage),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chat.lastMessageTime),
            style: const TextStyle(fontSize: 12),
          ),
          if (chat.unreadCount > 0)
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                '${chat.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
        ],
      ),
      onTap: () {
        // Navigate to ChatDetailScreen
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
  }
}
