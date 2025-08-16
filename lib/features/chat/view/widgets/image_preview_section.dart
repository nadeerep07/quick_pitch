import 'dart:io';

import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';


class ImagePreviewSection extends StatelessWidget {
  final List<File> images;
  final Function(int index) onRemove;

  const ImagePreviewSection({super.key, 
    required this.images,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    images[index],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: IconButton(
                    icon: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 16),
                    ),
                    onPressed: () => onRemove(index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool showEmojiPicker;
  final VoidCallback onToggleEmoji;
  final VoidCallback onSend;
  final VoidCallback onAddImage;

  const InputBar({super.key, 
    required this.controller,
    required this.showEmojiPicker,
    required this.onToggleEmoji,
    required this.onSend,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
            onPressed: onAddImage,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      showEmojiPicker
                          ? Icons.keyboard
                          : Icons.emoji_emotions_outlined,
                      color: Colors.grey[600],
                    ),
                    onPressed: onToggleEmoji,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}

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
