import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/cubit/pitch_cubit.dart';
import 'package:uuid/uuid.dart';
import 'pitch_form_state.dart';

enum PaymentType { fixed, hourly }

class PitchFormCubit extends Cubit<PitchFormState> {
  final PitchCubit pitchCubit;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final UserProfileService userProfileService = UserProfileService();

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
    final posterProfile =
        await userProfileService.getProfile(taskData.posterId, 'poster');
        final fixerProfile = await userProfileService.getProfile(currentUser.uid, 'fixer');

    final posterName = posterProfile?.name;
    final posterImage = posterProfile?.profileImageUrl ?? 'No Image Found';
    try {
      final pitch = PitchModel(
        id: const Uuid().v4(),
        taskId: taskData.id,
        pitchText: pitchText,
        paymentType: state.paymentType,
        budget: double.parse(budget),
        hours: hours,
        timeline: state.timeline ?? "Flexible",
        fixerId: currentUser.uid,
        fixerName: fixerProfile?.name ?? "Unknown",
        fixerimageUrl: fixerProfile?.profileImageUrl ?? "no Image Found",
        posterId: taskData.posterId,
        posterName: posterName ?? "Unknown",
        posterImage: posterImage,
        createdAt: DateTime.now(),
      );
      //  print(pitch.id);
      await pitchCubit.submitPitch(pitch);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  Future<void> fetchFixerPitches(String fixerId) async {
    try {
      emit(state.copyWith(isSubmitting: true, error: null));

      final pitches = await pitchCubit.fetchFixerPitches(fixerId);

      emit(state.copyWith(isSubmitting: false, pitches: pitches));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  void changeFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
  }
}
