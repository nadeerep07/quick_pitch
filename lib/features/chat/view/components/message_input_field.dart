import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/image_preview_section.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/message_input/cubit/message_input_cubit.dart';
import 'dart:io';

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ImagePreviewSection(
                  images: state.selectedImages,
                  onRemove: (index) =>
                      context.read<MessageInputCubit>().removeImage(index),
                ),
              ),

            /// --- Input Bar ---
            Container(
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
                    onPressed: () =>
                        context.read<MessageInputCubit>().toggleEmojiPicker(),
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

                  /// Image Picker Button
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    color: Colors.grey[700],
                    onPressed: () => _showImageSourceDialog(context),
                  ),

                  /// Send Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () => _sendMessage(context, state.selectedImages),
                    ),
                  ),
                ],
              ),
            ),

            /// --- Emoji Picker Section ---
            if (state.showEmojiPicker)
              SizedBox(
                height: 250,
                child: EmojiPickerSection(
                  onEmojiSelected: (emoji) => controller.text += emoji.emoji,
                ),
              ),
          ],
        );
      },
    );
  }

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
            /// Title
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 16),
              child: Text(
                "Choose Option",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// Options Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<MessageInputCubit>().pickImages();
                  },
                ),
                _buildOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<MessageInputCubit>().pickImageFromCamera();
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}

Widget _buildOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.black87, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

}
