part of 'message_input_cubit.dart';

class MessageInputState {
  final List<File> selectedImages;
  final bool showEmojiPicker;

  MessageInputState({
    required this.selectedImages,
    required this.showEmojiPicker,
  });

  factory MessageInputState.initial() =>
      MessageInputState(selectedImages: [], showEmojiPicker: false);

  MessageInputState copyWith({
    List<File>? selectedImages,
    bool? showEmojiPicker,
  }) {
    return MessageInputState(
      selectedImages: selectedImages ?? this.selectedImages,
      showEmojiPicker: showEmojiPicker ?? this.showEmojiPicker,
    );
  }
}
