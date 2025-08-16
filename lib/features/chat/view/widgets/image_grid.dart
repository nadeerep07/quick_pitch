import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quick_pitch_app/features/chat/model/message_model.dart';
import 'package:quick_pitch_app/features/chat/view/screen/full_screen_image_view.dart';
import 'package:quick_pitch_app/features/chat/view/screen/image_gallery_view.dart';
import 'package:quick_pitch_app/main.dart';


class ImageGrid extends StatelessWidget {
  final MessageModel message;

  const ImageGrid({super.key, required this.message});

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(imageUrl: imageUrl),
      ),
    );
  }

  void _showImageGallery(BuildContext context) {
    final images = message.attachments.where((att) => att.type == 'image').toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageGalleryView(images: images),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = message.attachments.where((att) => att.type == 'image').toList();

    if (images.isEmpty) return const SizedBox.shrink();
    if (images.length == 1) return _buildSingleImage(images.first.url);
    if (images.length == 2) return _buildTwoImages(images);
    return _buildMultipleImages(images);
  }

  Widget _buildSingleImage(String imageUrl) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250, maxHeight: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () => _showFullScreenImage(navigatorKey.currentContext!, imageUrl),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 150,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoImages(List<AttachmentModel> images) {
    return SizedBox(
      height: 150,
      child: Row(
        children: images.map((image) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 2),
              child: _buildCachedImage(image.url),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultipleImages(List<AttachmentModel> images) {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          Expanded(child: _buildCachedImage(images[0].url)),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              children: [
                if (images.length > 1)
                  Expanded(child: _buildCachedImage(images[1].url)),
                if (images.length > 2) const SizedBox(height: 2),
                if (images.length > 2)
                  Expanded(
                    child: Stack(
                      children: [
                        _buildCachedImage(images[2].url, onTap: () => _showImageGallery(navigatorKey.currentContext!)),
                        if (images.length > 3)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '+${images.length - 3}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCachedImage(String url, {VoidCallback? onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: onTap ?? () => _showFullScreenImage(navigatorKey.currentContext!, url),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 1)),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red, size: 16),
        ),
      ),
    );
  }
}
