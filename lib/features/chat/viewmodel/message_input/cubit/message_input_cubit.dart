import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'message_input_state.dart';

class MessageInputCubit extends Cubit<MessageInputState> {
  final ImagePicker _picker = ImagePicker();

  MessageInputCubit() : super(MessageInputState.initial());

  void toggleEmojiPicker() {
    emit(state.copyWith(showEmojiPicker: !state.showEmojiPicker));
  }

  Future<void> pickImages() async {
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        emit(state.copyWith(
          selectedImages: [...state.selectedImages, ...images.map((e) => File(e.path))]
        ));
      }
    } catch (e) {
      // log error or emit error state if needed
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        emit(state.copyWith(
          selectedImages: [...state.selectedImages, File(image.path)]
        ));
      }
    } catch (e) {
      // log error or emit error state if needed
    }
  }

  void removeImage(int index) {
    final updated = [...state.selectedImages]..removeAt(index);
    emit(state.copyWith(selectedImages: updated));
  }

  void clearImages() {
    emit(state.copyWith(selectedImages: []));
  }
}
