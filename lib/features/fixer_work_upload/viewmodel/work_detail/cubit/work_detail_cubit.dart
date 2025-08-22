import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'work_detail_state.dart';

class WorkDetailCubit extends Cubit<WorkDetailState> {
  WorkDetailCubit() : super(WorkDetailInitial());

  void selectImage(int index) {
    emit(WorkDetailImageSelected(selectedImageIndex: index));
  }

  void showDeleteConfirmation() {
    emit(WorkDetailDeleteConfirmation());
  }

  void hideDeleteConfirmation() {
    emit(WorkDetailInitial());
  }

  void startImageCarousel() {
    emit(WorkDetailImageCarousel());
  }

  void stopImageCarousel() {
    emit(WorkDetailInitial());
  }

  void showImageFullScreen(int index) {
    emit(WorkDetailImageFullScreen(imageIndex: index));
  }

  void hideImageFullScreen() {
    emit(WorkDetailInitial());
  }
}