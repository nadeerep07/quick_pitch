import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';

class ChatAvatar extends StatelessWidget {
  final ChatModel chat;

  const ChatAvatar({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: chat.unreadCount > 0
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 2,
                  )
                : null,
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: chat.receiver.profileImageUrl != null
                ? NetworkImage(chat.receiver.profileImageUrl!)
                : null,
            child: chat.receiver.profileImageUrl == null
                ? ClipOval(
                    child: Image.asset(
                      'assets/images/avatar_photo_placeholder.jpg',
                      fit: BoxFit.cover,
                      width: 56,
                      height: 56,
                    ),
                  )
                : null,
          ),
        ),
        if (chat.isOnline)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2.5),
              ),
            ),
          ),
      ],
    );
  }
}
