import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class ImageSection extends StatelessWidget {
  final ThemeData theme;
  final FixerWork work;

  const ImageSection({super.key, 
    required this.theme,
    required this.work,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          work.images.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: work.images.first,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 32,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.work_outline,
                      size: 32,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
          if (work.images.length > 1)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_library, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${work.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
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
}
