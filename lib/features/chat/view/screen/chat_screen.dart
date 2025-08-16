import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_app_bar.dart';
import 'package:quick_pitch_app/features/chat/view/components/message_input_field.dart';
import 'package:quick_pitch_app/features/chat/view/components/message_list.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/message_input/cubit/message_input_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final UserProfileModel currentUser;
  final UserProfileModel otherUser;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUser,
    required this.otherUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text, List<File> images) {
    if (text.trim().isNotEmpty || images.isNotEmpty) {
      context.read<IndividualChatCubit>().sendMessage(
        text,
        widget.currentUser,
        widget.otherUser,
        images: images.isNotEmpty ? images : null,
      );
    }
  }

  void _onImagePicked() {
    // Optionally scroll to bottom when image is picked
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(otherUser: widget.otherUser),
      body: BlocListener<IndividualChatCubit, IndividualChatState>(
        listener: (context, state) {
          if (state is IndividualChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<IndividualChatCubit>().retryLastMessage();
                  },
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                currentUser: widget.currentUser,
                otherUser: widget.otherUser,
                scrollController: _scrollController,
              ),
            ),
            BlocBuilder<IndividualChatCubit, IndividualChatState>(
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    BlocProvider(
                      create: (context) => MessageInputCubit(),
                      child: MessageInputField(
                        controller: _messageController,
                        onSend: _sendMessage,
                      ),
                    ),
                    if (state is IndividualChatSending)
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sending...',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
