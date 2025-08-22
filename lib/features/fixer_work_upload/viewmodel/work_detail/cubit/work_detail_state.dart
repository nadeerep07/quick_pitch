part of 'work_detail_cubit.dart';

abstract class WorkDetailState extends Equatable {
  const WorkDetailState();

  @override
  List<Object?> get props => [];
}

class WorkDetailInitial extends WorkDetailState {}

class WorkDetailImageSelected extends WorkDetailState {
  final int selectedImageIndex;

  const WorkDetailImageSelected({required this.selectedImageIndex});

  @override
  List<Object> get props => [selectedImageIndex];
}

class WorkDetailDeleteConfirmation extends WorkDetailState {}

class WorkDetailImageCarousel extends WorkDetailState {}

class WorkDetailImageFullScreen extends WorkDetailState {
  final int imageIndex;

  const WorkDetailImageFullScreen({required this.imageIndex});

  @override
  List<Object> get props => [imageIndex];
}