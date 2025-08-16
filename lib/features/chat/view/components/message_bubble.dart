import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quick_pitch_app/features/chat/model/message_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool isSameSender;
  final UserProfileModel otherUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isSameSender,
    required this.otherUser,
  });

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(imageUrl: imageUrl),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (message.attachments.isEmpty) return const SizedBox.shrink();
    
    final images = message.attachments.where((att) => att.type == 'image').toList();
    
    if (images.length == 1) {
      return _buildSingleImage(images.first.url);
    } else if (images.length == 2) {
      return _buildTwoImages(images);
    } else if (images.length >= 3) {
      return _buildMultipleImages(images);
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildSingleImage(String imageUrl) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 250,
        maxHeight: 300,
      ),
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
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 150,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoImages(List<AttachmentModel> images) {
    return SizedBox(
      height: 150,
      child: Row(
        children: images.map((image) => 
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () => _showFullScreenImage(navigatorKey.currentContext!, image.url),
                  child: CachedNetworkImage(
                    imageUrl: image.url,
                    fit: BoxFit.cover,
                    height: 150,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildMultipleImages(List<AttachmentModel> images) {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          // First image takes half the width
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () => _showFullScreenImage(navigatorKey.currentContext!, images[0].url),
                child: CachedNetworkImage(
                  imageUrl: images[0].url,
                  fit: BoxFit.cover,
                  height: 150,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          // Other images in a column
          Expanded(
            child: Column(
              children: [
                if (images.length > 1)
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onTap: () => _showFullScreenImage(navigatorKey.currentContext!, images[1].url),
                        child: CachedNetworkImage(
                          imageUrl: images[1].url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 1),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, color: Colors.red, size: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (images.length > 2)
                  const SizedBox(height: 2),
                if (images.length > 2)
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: () => _showImageGallery(navigatorKey.currentContext!),
                            child: CachedNetworkImage(
                              imageUrl: images[2].url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 1),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error, color: Colors.red, size: 16),
                              ),
                            ),
                          ),
                        ),
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
    final hasText = message.text.isNotEmpty;
    final hasImages = message.attachments.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(top: isSameSender ? 2 : 8, bottom: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              padding: EdgeInsets.all(hasImages ? 8 : 16),
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Images
                  if (hasImages) ...[
                    _buildImageGrid(),
                    if (hasText) const SizedBox(height: 8),
                  ],
                  
                  // Text content
                  if (hasText) ...[
                    Padding(
                      padding: hasImages 
                        ? const EdgeInsets.symmetric(horizontal: 8) 
                        : EdgeInsets.zero,
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.grey[800],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  
                  // Timestamp
                  Padding(
                    padding: hasImages 
                      ? const EdgeInsets.symmetric(horizontal: 8) 
                      : EdgeInsets.zero,
                    child: Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: isMe
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

// Full screen image view
class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
     
      ),
      body: Center(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error, color: Colors.white, size: 50),
            ),
          ),
        ),
      ),
    );
  }
}

// Image gallery view for multiple images
class ImageGalleryView extends StatefulWidget {
  final List<AttachmentModel> images;

  const ImageGalleryView({super.key, required this.images});

  @override
  State<ImageGalleryView> createState() => _ImageGalleryViewState();
}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      
        title: Text(
          '${_currentIndex + 1} of ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: widget.images[index].url,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error, color: Colors.white, size: 50),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Global navigator key - add this to your main.dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();