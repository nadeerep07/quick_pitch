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

  const MessageList({
    super.key,
    required this.currentUser,
    required this.otherUser,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndividualChatCubit, IndividualChatState>(
      builder: (context, state) {
        if (state is IndividualChatLoading) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        } else if (state is IndividualChatLoaded || state is IndividualChatSending) {
          final messages = state is IndividualChatLoaded
              ? (state as IndividualChatLoaded).messages
              : (state as IndividualChatSending).messages;

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
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == currentUser.uid;

                      // Check sender continuity
                      final isSameSender =
                          index > 0 &&
                          messages[index - 1].senderId == message.senderId;

                      // Check if we should show date
                      bool showDate = false;
                      if (index == messages.length - 1) {
                        // Last in the reversed list = earliest chronologically
                        showDate = true;
                      } else {
                        final nextMessage = messages[index + 1];
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
          return _buildErrorState(context, state.message);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to start the conversation',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<IndividualChatCubit>().loadMessages();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  bool _isDifferentDay(DateTime a, DateTime b) {
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }
}