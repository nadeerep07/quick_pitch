import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/viewmodel/fixer_detail_image_slider/cubit/image_slider_cubit.dart';

class FixerDetailImageHeader extends StatelessWidget {
  const FixerDetailImageHeader({
    super.key,
    required this.imageUrls,
    required this.res,
    required this.priorityLabel,
  });

  final List<String>? imageUrls;
  final Responsive res;
  final String priorityLabel;

  @override
  Widget build(BuildContext context) {
    final images = imageUrls ?? [];

    return BlocProvider(
      create: (_) => ImageSliderCubit(images.length),
      child: Builder(
        builder: (context) {
          final cubit = context.read<ImageSliderCubit>();
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: res.hp(25),
                  width: double.infinity,
                  child: PageView.builder(
                    controller: cubit.pageController,
                    itemCount: images.length,
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, index) {
                      final img = images[index];
                      return Container(
                        color: Colors.grey[300],
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/image_placeholder.png',
                          image: img,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: res.hp(25),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black45],
                    ),
                  ),
                ),
              ),

              // Priority label
              Positioned(
                top: res.hp(1.5),
                right: res.wp(3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    priorityLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Dots indicator
              Positioned(
                bottom: res.hp(1),
                left: 0,
                right: 0,
                child: BlocBuilder<ImageSliderCubit, ImageSliderState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        final isActive = index == state.currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 10 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.white54,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

