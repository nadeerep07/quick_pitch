import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'work_upload_state.dart';

class WorkUploadCubit extends Cubit<WorkUploadState> {
  WorkUploadCubit() : super(WorkUploadInitial());
}
