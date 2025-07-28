import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/cubit/pitch_cubit.dart';
import 'pitch_form_state.dart';

enum PaymentType { fixed, hourly }

class PitchFormCubit extends Cubit<PitchFormState> {
  final PitchCubit pitchCubit;

  PitchFormCubit({required this.pitchCubit}) : super(const PitchFormState());

  void changePaymentType(PaymentType type) {
    emit(state.copyWith(paymentType: type));
  }

  void changeTimeline(String? timeline) {
    emit(state.copyWith(timeline: timeline));
  }

  Future<void> submitPitch({
    required TaskPostModel taskData,
    required String pitchText,
    required String budget,
    String? hours,
  }) async {
    if (pitchText.isEmpty || budget.isEmpty) {
      emit(state.copyWith(error: "Pitch and budget are required"));
      return;
    }

    emit(state.copyWith(isSubmitting: true, success: false, error: null));
final currentUser = FirebaseAuth.instance.currentUser;
if (currentUser == null) {
  emit(state.copyWith(isSubmitting: false, error: "User not logged in"));
  return;
}
    try {
      final pitch = PitchModel(
        taskId: taskData.id,
        pitchText: pitchText,
        paymentType: state.paymentType,
        budget: double.parse(budget),
        timeline: state.timeline ?? "Flexible",
        fixerId: currentUser.uid, 
        createdAt: DateTime.now(),
      );

      await pitchCubit.submitPitch(pitch);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
