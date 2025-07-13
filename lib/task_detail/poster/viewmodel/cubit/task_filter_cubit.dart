import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_filter_state.dart';

class TaskFilterCubit extends Cubit<TaskFilterState> {
  TaskFilterCubit() : super(const TaskFilterState());

 void updateStatus(String status) {
//  print(" Updating status to: $status");
  emit(state.copyWith(status: status));
}
  void updateAll({required String status, required bool newestFirst}) {
   // print(" Updating filter => status: $status, newestFirst: $newestFirst");
    emit(state.copyWith(status: status, newestFirst: newestFirst));
  }
  void updateSortOrder(bool newestFirst) => emit(state.copyWith(newestFirst: newestFirst));
  void reset() => emit(const TaskFilterState());
}

