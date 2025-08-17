import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/message_input/cubit/message_input_cubit.dart';

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final MessageInputState state;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const InputBar({super.key, 
    required this.controller,
    required this.state,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Emoji Toggle
          IconButton(
            icon: Icon(
              state.showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
              color: Colors.grey[700],
            ),
            onPressed: () => context.read<MessageInputCubit>().toggleEmojiPicker(),
          ),

          /// Text Field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// Image Picker
          IconButton(
            icon: const Icon(Icons.attach_file),
            color: Colors.grey[700],
            onPressed: onAttach,
          ),

          /// Send Button
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
