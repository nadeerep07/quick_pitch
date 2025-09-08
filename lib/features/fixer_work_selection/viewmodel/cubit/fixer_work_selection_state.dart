part of 'fixer_work_selection_cubit.dart';

abstract class FixerWorkSelectionState {}

class FixerWorkSelectionInitial extends FixerWorkSelectionState {}

class FixerWorkSelectionLoaded extends FixerWorkSelectionState {
  final List<FixerWork> works;
  final FixerWork? selectedWork;

  FixerWorkSelectionLoaded({
    required this.works,
    this.selectedWork,
  });

  FixerWorkSelectionLoaded copyWith({
    List<FixerWork>? works,
    FixerWork? selectedWork,
  }) {
    return FixerWorkSelectionLoaded(
      works: works ?? this.works,
      selectedWork: selectedWork,
    );
  }
}

class FixerWorkSubmitting extends FixerWorkSelectionState {
  final FixerWork selectedWork;

  FixerWorkSubmitting({required this.selectedWork});
}

class FixerWorkRequestSuccess extends FixerWorkSelectionState {
  final String workTitle;
  final String fixerName;

  FixerWorkRequestSuccess(this.workTitle, this.fixerName);
}

class FixerWorkSelectionError extends FixerWorkSelectionState {
  final String message;

  FixerWorkSelectionError(this.message);
}
