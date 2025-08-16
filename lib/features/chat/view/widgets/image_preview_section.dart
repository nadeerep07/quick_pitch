import 'dart:io';

import 'package:flutter/material.dart';


class ImagePreviewSection extends StatelessWidget {
  final List<File> images;
  final Function(int index) onRemove;

  const ImagePreviewSection({
    super.key,
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
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
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
