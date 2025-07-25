// image_slider_state.dart
part of 'image_slider_cubit.dart';

class ImageSliderState {
  final int currentIndex;
  final int imageCount;

  ImageSliderState({
    required this.currentIndex,
    required this.imageCount,
  });

  ImageSliderState copyWith({
    int? currentIndex,
    int? imageCount,
  }) {
    return ImageSliderState(
      currentIndex: currentIndex ?? this.currentIndex,
      imageCount: imageCount ?? this.imageCount,
    );
  }
}
