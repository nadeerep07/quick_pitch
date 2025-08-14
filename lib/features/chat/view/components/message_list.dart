import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'message_bubble.dart';
import 'date_label.dart';

class MessageList extends StatelessWidget {
  final UserProfileModel currentUser;
  final UserProfileModel otherUser;
  final ScrollController scrollController;
//  final VoidCallback scrollToBottom;

  const MessageList({
    super.key,
    required this.currentUser,
    required this.otherUser,
    required this.scrollController,
  //  required this.scrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndividualChatCubit, IndividualChatState>(
      builder: (context, state) {
        if (state is IndividualChatLoading) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        } else if (state is IndividualChatLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(0); // Always stay at bottom
            }
          });

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/chat_bg.jpeg'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: ListView.builder(
              controller: scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                final isMe = message.senderId == currentUser.uid;

                // Check sender continuity
                final isSameSender =
                    index > 0 &&
                    state.messages[index - 1].senderId == message.senderId;

                // Check if we should show date
                bool showDate = false;
                if (index == state.messages.length - 1) {
                  // Last in the reversed list = earliest chronologically
                  showDate = true;
                } else {
                  final nextMessage = state.messages[index + 1];
                  showDate = _isDifferentDay(
                    message.timestamp,
                    nextMessage.timestamp,
                  );
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
            ),
          );
        } else if (state is IndividualChatError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }

  bool _isDifferentDay(DateTime a, DateTime b) {
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }
}
