import 'package:image_picker/image_picker.dart';

class AddWorkDialogState {
  final List<XFile> selectedImages;
  final List<String> existingImages;
  final bool isSubmitted;

  const AddWorkDialogState({
    this.selectedImages = const [],
    this.existingImages = const [],
    this.isSubmitted = false,
  });

  AddWorkDialogState copyWith({
    List<XFile>? selectedImages,
    List<String>? existingImages,
    bool? isSubmitted,
  }) {
    return AddWorkDialogState(
      selectedImages: selectedImages ?? this.selectedImages,
      existingImages: existingImages ?? this.existingImages,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  int get totalImages => selectedImages.length + existingImages.length;
}