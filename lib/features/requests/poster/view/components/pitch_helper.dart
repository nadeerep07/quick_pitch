import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchHelper {
  static Map<String, List<PitchModel>> groupPitchesByFixer(List<PitchModel> pitches) {
    final Map<String, List<PitchModel>> result = {};
    
    for (final pitch in pitches) {
      if (pitch.fixerId != null) {
        result.putIfAbsent(pitch.fixerId!, () => []).add(pitch);
      }
    }
    
    return result;
  }
}
