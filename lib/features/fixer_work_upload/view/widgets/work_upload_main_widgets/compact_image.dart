import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class CompactImage extends StatelessWidget {
  final ThemeData theme;
  final FixerWork work;

  const CompactImage({super.key, 
    required this.theme,
    required this.work,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: work.images.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: work.images.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : Icon(
                Icons.work_outline,
                size: 24,
                color: theme.colorScheme.onSurfaceVariant,
              ),
      ),
    );
  }
}
