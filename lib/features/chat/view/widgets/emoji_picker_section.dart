import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiPickerSection extends StatelessWidget {
  final Function(Emoji emoji) onEmojiSelected;

  const EmojiPickerSection({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) => onEmojiSelected(emoji),
      ),
    );
  }
}
