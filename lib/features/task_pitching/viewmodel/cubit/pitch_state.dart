import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

abstract class PitchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PitchInitial extends PitchState {}

class PitchSubmitting extends PitchState {}

class PitchSuccess extends PitchState {
  final PitchModel pitch;
  PitchSuccess(this.pitch);

  @override
  List<Object?> get props => [pitch];
}

class PitchFailure extends PitchState {
  final String error;
  PitchFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PitchListSuccess extends PitchState {
  final List<PitchModel> pitches;
  PitchListSuccess(this.pitches);

  @override
  List<Object?> get props => [pitches];
}
