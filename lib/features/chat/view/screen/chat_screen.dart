import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_app_bar.dart';
import 'package:quick_pitch_app/features/chat/view/components/message_input_field.dart';
import 'package:quick_pitch_app/features/chat/view/components/message_list.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
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
//  bool _isListViewInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
   //   _isListViewInitialized = true;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<IndividualChatCubit>().sendMessage(
            text,
            widget.currentUser,
            widget.otherUser,
          );
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(otherUser: widget.otherUser),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              currentUser: widget.currentUser,
              otherUser: widget.otherUser,
              scrollController: _scrollController,
            ),
          ),
          MessageInputField(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
