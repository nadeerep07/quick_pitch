import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class BuildImageCarousel extends StatelessWidget {
  const BuildImageCarousel({
    super.key,
    required PageController pageController,
    required ValueNotifier<int> pageNotifier,
    required this.images,
    required this.res,
  }) : _pageController = pageController, _pageNotifier = pageNotifier;

  final PageController _pageController;
  final ValueNotifier<int> _pageNotifier;
  final List<String> images;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: res.hp(30),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => _pageNotifier.value = i,
            itemCount: images.length,
            itemBuilder: (ctx, i) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: images[i],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) =>  Center(child: Image.asset('assets/images/image_placeholder.png')),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<int>(
          valueListenable: _pageNotifier,
          builder: (_, index, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: index == i ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: index == i ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
