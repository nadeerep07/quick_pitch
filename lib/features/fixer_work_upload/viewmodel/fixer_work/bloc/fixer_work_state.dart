part of 'fixer_work_bloc.dart';

abstract class FixerWorksState {}

class FixerWorksInitial extends FixerWorksState {}

class FixerWorksLoading extends FixerWorksState {}

class FixerWorksLoaded extends FixerWorksState {
  final List<FixerWork> works;
  final List<XFile> selectedImages;

  FixerWorksLoaded(this.works, {this.selectedImages = const []});
}

class FixerWorksError extends FixerWorksState {
  final String message;
  FixerWorksError(this.message);
}

class ImagePickerLoading extends FixerWorksState {}

class ImagesSelected extends FixerWorksState {
  final List<XFile> images;
  ImagesSelected(this.images);
}