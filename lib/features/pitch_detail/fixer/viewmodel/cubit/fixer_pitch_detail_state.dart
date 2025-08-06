part of 'fixer_pitch_detail_cubit.dart';

abstract class FixerPitchDetailState extends Equatable {
  const FixerPitchDetailState();

  @override
  List<Object?> get props => [];
}

class FixerPitchDetailInitial extends FixerPitchDetailState {}

class FixerPitchDetailLoading extends FixerPitchDetailState {}

class FixerPitchDetailLoaded extends FixerPitchDetailState {
  final TaskPostModel task;
  final PitchModel pitch;

  const FixerPitchDetailLoaded({
    required this.task,
    required this.pitch,
  });

  @override
  List<Object> get props => [task, pitch];
}

class FixerPitchDetailProcessing extends FixerPitchDetailState {
  final TaskPostModel task;
  final PitchModel pitch;
  final String message;

  const FixerPitchDetailProcessing({
    required this.task,
    required this.pitch,
    required this.message,
  });

  @override
  List<Object> get props => [task, pitch, message];
}

class FixerPitchDetailError extends FixerPitchDetailState {
  final String message;

  const FixerPitchDetailError(this.message);

  @override
  List<Object?> get props => [message];
}