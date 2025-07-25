import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'image_slider_state.dart';

class ImageSliderCubit extends Cubit<ImageSliderState> {
 final PageController pageController = PageController();
  Timer? _autoSlideTimer;

  ImageSliderCubit(int imageCount)
      : super(ImageSliderState(currentIndex: 0, imageCount: imageCount)) {
    _startAutoSlide();
  }

  void onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final nextIndex = (pageController.page?.round() ?? 0) + 1;
      final newIndex = nextIndex >= state.imageCount ? 0 : nextIndex;
      pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      emit(state.copyWith(currentIndex: newIndex));
    });
  }

  @override
  Future<void> close() {
    pageController.dispose();
    _autoSlideTimer?.cancel();
    return super.close();
  }
}
