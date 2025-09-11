// lib/features/fixie_ai/view/fixie_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Fixie_ai/model/chat_message.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/animated_message_bubble.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/message_typing_indicator.dart';

class MessageListWidget extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isLoading;
  final ScrollController scrollController;
  final Responsive responsive;

  const MessageListWidget({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.scrollController,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isLoading) {
          return const TypingIndicator();
        }
        return AnimatedMessageBubble(
          key: ValueKey(messages[index].timestamp.millisecondsSinceEpoch),
          message: messages[index],
          index: index,
        );
      },
    );
  }
}
