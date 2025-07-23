part of 'task_filter_cubit.dart';

class TaskFilterState extends Equatable {
  final String status;
  final bool newestFirst;

  const TaskFilterState({
    this.status = 'All',
    this.newestFirst = true,
  });

  TaskFilterState copyWith({
    String? status,
    bool? newestFirst,
  }) {
    return TaskFilterState(
      status: status ?? this.status,
      newestFirst: newestFirst ?? this.newestFirst,
    );
  }

  @override
  List<Object?> get props => [status, newestFirst];
}
