import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/view/components/image_preview.dart';
import 'package:quick_pitch_app/features/chat/view/components/option_tile.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/emoji_picker.dart';

import 'package:quick_pitch_app/features/chat/view/widgets/input_bar.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/message_input/cubit/message_input_cubit.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String text, List<File> images) onSend;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  void _sendMessage(BuildContext context, List<File> images) {
    final text = controller.text.trim();
    if (text.isNotEmpty || images.isNotEmpty) {
      onSend(text, images);
      controller.clear();
      context.read<MessageInputCubit>().clearImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageInputCubit, MessageInputState>(
      builder: (context, state) {
        return Column(
          children: [
            /// --- Image Preview Section ---
            if (state.selectedImages.isNotEmpty)
              ImagePreview(images: state.selectedImages),

            /// --- Input Bar ---
            InputBar(
              controller: controller,
              state: state,
              onSend: () => _sendMessage(context, state.selectedImages),
              onAttach: () => _showImageSourceDialog(context),
            ),

            /// --- Emoji Picker Section ---
            if (state.showEmojiPicker)
              EmojiPicker(controller: controller),
          ],
        );
      },
    );
  }

  /// --- Image Source BottomSheet ---
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 16),
                child: Text(
                  "Choose Option",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionTile(
                    icon: Icons.photo_library,
                    label: "Gallery",
                    onTap: () {
                      Navigator.pop(ctx);
                      context.read<MessageInputCubit>().pickImages();
                    },
                  ),
                  OptionTile(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    onTap: () {
                      Navigator.pop(ctx);
                      context.read<MessageInputCubit>().pickImageFromCamera();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
