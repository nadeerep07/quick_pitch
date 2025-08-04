// 📂 viewmodel/cubit/pitch_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/repository/pitch_repository.dart';
import 'pitch_state.dart';

class PitchCubit extends Cubit<PitchState> {
  final PitchRepository repository;
  PitchCubit(this.repository) : super(PitchInitial());

  Future<void> submitPitch(PitchModel pitch) async {
    emit(PitchSubmitting());
    try {
      await repository.submitPitch(pitch);
      emit(PitchSuccess(pitch));
    } catch (e) {
      emit(PitchFailure(e.toString()));
    }
  }
    Future<List<PitchModel>> fetchFixerPitches(String fixerId) async {
    emit(PitchSubmitting());
    try {
      final pitches = await repository.fetchFixerPitches(fixerId);
      emit(PitchListSuccess(pitches));
      return pitches;
    } catch (e) {
      emit(PitchFailure(e.toString()));
      throw Exception(e.toString());
    }
  }
}
