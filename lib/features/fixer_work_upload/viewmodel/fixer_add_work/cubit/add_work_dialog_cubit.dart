import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/fixer_add_work/cubit/add_work_dialog_state.dart';


class AddWorkDialogCubit extends Cubit<AddWorkDialogState> {
  AddWorkDialogCubit() : super(const AddWorkDialogState());

  void setSelectedImages(List<XFile> images) {
    emit(state.copyWith(selectedImages: images));
  }

  void addSelectedImages(List<XFile> newImages) {
    final remainingSlots = 5 - state.existingImages.length - state.selectedImages.length;
    final imagesToAdd = newImages.take(remainingSlots).toList();
    emit(state.copyWith(
      selectedImages: [...state.selectedImages, ...imagesToAdd],
    ));
  }

  void removeSelectedImage(XFile image) {
    final updatedImages = List<XFile>.from(state.selectedImages)..remove(image);
    emit(state.copyWith(selectedImages: updatedImages));
  }

  void setExistingImages(List<String> images) {
    emit(state.copyWith(existingImages: images));
  }

  void removeExistingImage(String imageUrl) {
    final updatedImages = List<String>.from(state.existingImages)..remove(imageUrl);
    emit(state.copyWith(existingImages: updatedImages));
  }

  void setSubmitted(bool isSubmitted) {
    emit(state.copyWith(isSubmitted: isSubmitted));
  }

  void reset() {
    emit(const AddWorkDialogState());
  }
}
