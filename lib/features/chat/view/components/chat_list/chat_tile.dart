import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_list/chat_avatar.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_list/chat_header.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_list/chat_last_message.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_list/chat_roles.dart';


class ChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatTile({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ChatAvatar(chat: chat),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatHeader(chat: chat),
                    const SizedBox(height: 4),
                    ChatLastMessage(chat: chat),
                    const SizedBox(height: 3),
                    ChatRoles(chat: chat),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
