import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/utils/date_utils.dart';
import 'package:quick_pitch_app/features/chat/view/components/message_bubble.dart';
import 'package:quick_pitch_app/features/chat/view/components/date_label.dart';
import 'package:quick_pitch_app/features/chat/model/message_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class MessageListView extends StatelessWidget {
  final List<MessageModel> messages;
  final UserProfileModel currentUser;
  final UserProfileModel otherUser;
  final ScrollController scrollController;

  const MessageListView({
    super.key,
    required this.messages,
    required this.currentUser,
    required this.otherUser,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == currentUser.uid;

        // Same sender check
        final isSameSender =
            index > 0 && messages[index - 1].senderId == message.senderId;

        // Date label check
        bool showDate = false;
        if (index == messages.length - 1) {
          showDate = true;
        } else {
          final nextMessage = messages[index + 1];
          showDate = isDifferentDay(message.timestamp, nextMessage.timestamp);
        }

        return Column(
          children: [
            if (showDate) DateLabel(date: message.timestamp),
            MessageBubble(
              message: message,
              isMe: isMe,
              isSameSender: isSameSender,
              otherUser: otherUser,
            ),
          ],
        );
      },
    );
  }
}
