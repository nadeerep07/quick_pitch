import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/chat/model/message_model.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/image_grid.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';


class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool isSameSender;
  final UserProfileModel otherUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isSameSender,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = message.text.isNotEmpty;
    final hasImages = message.attachments.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(top: isSameSender ? 2 : 8, bottom: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              padding: EdgeInsets.all(hasImages ? 8 : 16),
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Images
                  if (hasImages) ...[
                    ImageGrid(message: message),
                    if (hasText) const SizedBox(height: 8),
                  ],

                  // Text content
                  if (hasText) ...[
                    Padding(
                      padding: hasImages
                          ? const EdgeInsets.symmetric(horizontal: 8)
                          : EdgeInsets.zero,
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.grey[800],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Timestamp
                  Padding(
                    padding: hasImages
                        ? const EdgeInsets.symmetric(horizontal: 8)
                        : EdgeInsets.zero,
                    child: Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: isMe
                            ? Colors.white.withValues(alpha:0.8)
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
