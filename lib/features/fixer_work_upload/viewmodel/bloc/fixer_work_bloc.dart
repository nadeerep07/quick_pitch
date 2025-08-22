import 'dart:async' ;

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/repository/fixer_works_repository.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/bloc/fixer_work_event.dart';

part 'fixer_work_state.dart';

class FixerWorksBloc extends Bloc<FixerWorksEvent, FixerWorksState> {
  final FixerWorksRepository _repository;
  StreamSubscription<List<FixerWork>>? _worksSubscription;

  FixerWorksBloc(this._repository) : super(FixerWorksInitial()) {
    on<LoadFixerWorks>(_onLoadFixerWorks);
    on<AddFixerWork>(_onAddFixerWork);
    on<UpdateFixerWork>(_onUpdateFixerWork);
    on<DeleteFixerWork>(_onDeleteFixerWork);
    on<PickImages>(_onPickImages);
  }

  void _onLoadFixerWorks(
    LoadFixerWorks event,
    Emitter<FixerWorksState> emit,
  ) async {
    emit(FixerWorksLoading());

    await _worksSubscription?.cancel();

    await emit.forEach<List<FixerWork>>(
      _repository.getFixerWorks(event.fixerId),
      onData: (works) => FixerWorksLoaded(works),
      onError:
          (error, stackTrace) =>
              FixerWorksError('Failed to load works: $error'),
    );
  }

  Future<void> _onAddFixerWork(
    AddFixerWork event,
    Emitter<FixerWorksState> emit,
  ) async {
    try {
      emit(FixerWorksLoading());

      List<String> imageUrls = [];
      if (event.imageFiles != null && event.imageFiles!.isNotEmpty) {
        imageUrls = await _repository.uploadImages(event.imageFiles!);
      }

      final workWithImages = event.work.copyWith(images: imageUrls);
      await _repository.addWork(workWithImages);

      // Don't emit here - let the stream from _onLoadFixerWorks handle it
      // The stream will automatically emit the updated list
    } catch (error) {
      if (!emit.isDone) {
        emit(FixerWorksError('Failed to add work: $error'));
      }
    }
  }

  Future<void> _onUpdateFixerWork(
    UpdateFixerWork event,
    Emitter<FixerWorksState> emit,
  ) async {
    try {
      emit(FixerWorksLoading());

      List<String> imageUrls = List<String>.from(event.work.images);

      // Delete old images if specified
      if (event.imagesToDelete != null && event.imagesToDelete!.isNotEmpty) {
        await _repository.deleteImages(event.imagesToDelete!);
        imageUrls.removeWhere((url) => event.imagesToDelete!.contains(url));
      }

      // Upload new images if any
      if (event.newImageFiles != null && event.newImageFiles!.isNotEmpty) {
        final newUrls = await _repository.uploadImages(event.newImageFiles!);
        imageUrls.addAll(newUrls);
      }

      final updatedWork = event.work.copyWith(images: imageUrls);
      await _repository.updateWork(updatedWork);

      // Don't emit here - let the stream handle it
    } catch (error) {
      if (!emit.isDone) {
        emit(FixerWorksError('Failed to update work: $error'));
      }
    }
  }

  Future<void> _onDeleteFixerWork(
    DeleteFixerWork event,
    Emitter<FixerWorksState> emit,
  ) async {
    try {
      emit(FixerWorksLoading());

      // Delete images from storage
      if (event.work.images.isNotEmpty) {
        await _repository.deleteImages(event.work.images);
      }

      // Delete work from Firestore
      await _repository.deleteWork(event.work.id);

      // Don't emit here - let the stream handle it
    } catch (error) {
      if (!emit.isDone) {
        emit(FixerWorksError('Failed to delete work: $error'));
      }
    }
  }

  Future<void> _onPickImages(
    PickImages event,
    Emitter<FixerWorksState> emit,
  ) async {
    try {
      emit(ImagePickerLoading());
      final images = await _repository.pickImages();
      if (!emit.isDone) {
        emit(ImagesSelected(images));
      }
    } catch (error) {
      if (!emit.isDone) {
        emit(FixerWorksError('Failed to pick images: $error'));
      }
    }
  }

  @override
  Future<void> close() {
    _worksSubscription?.cancel();
    return super.close();
  }
}

