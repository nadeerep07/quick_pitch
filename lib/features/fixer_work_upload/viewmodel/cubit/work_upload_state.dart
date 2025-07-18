part of 'work_upload_cubit.dart';

sealed class WorkUploadState extends Equatable {
  const WorkUploadState();

  @override
  List<Object> get props => [];
}

final class WorkUploadInitial extends WorkUploadState {}
