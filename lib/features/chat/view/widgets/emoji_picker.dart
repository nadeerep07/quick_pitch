import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/emoji_picker_section.dart';

class EmojiPicker extends StatelessWidget {
  final TextEditingController controller;
  const EmojiPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: EmojiPickerSection(
        onEmojiSelected: (emoji) => controller.text += emoji.emoji,
      ),
    );
  }
}
