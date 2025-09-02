import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// ---------------------------
/// 🔹 IMAGE CAROUSEL
/// ---------------------------
class PortfolioImageCarousel extends StatelessWidget {
  final List<String> images;
  final Responsive res;
  final ThemeData theme;

  const PortfolioImageCarousel({
    super.key,
    required this.images,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: SizedBox(
        height: res.hp(20),
        child: PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Image.network(
                  images[index],
                  height: res.hp(20),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: res.hp(20),
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: res.hp(20),
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image,
                            size: res.hp(4), color: Colors.grey[400]),
                        SizedBox(height: res.hp(1)),
                        Text(
                          'Image failed to load',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    top: res.hp(1),
                    right: res.wp(4),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: res.wp(2),
                        vertical: res.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}/${images.length}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

