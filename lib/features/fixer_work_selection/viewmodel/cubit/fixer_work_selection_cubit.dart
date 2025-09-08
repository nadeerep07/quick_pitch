import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/repository/hire_request_repository.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

part 'fixer_work_selection_state.dart';

class FixerWorkSelectionCubit extends Cubit<FixerWorkSelectionState> {
  final HireRequestRepository hireRequestRepository;
  final UserProfileService userProfileService;

  FixerWorkSelectionCubit({
    required this.hireRequestRepository,
    required this.userProfileService,
  }) : super(FixerWorkSelectionInitial());

  void selectWork(FixerWork work) {
    if (state is FixerWorkSelectionLoaded) {
      final currentState = state as FixerWorkSelectionLoaded;
      emit(currentState.copyWith(
        selectedWork: currentState.selectedWork?.id == work.id ? null : work,
      ));
    }
  }

  Future<void> submitRequest({
    required FixerWork work,
    required UserProfileModel fixer,
    required String? message,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(FixerWorkSelectionError("Please login to send request"));
      return;
    }

    emit(FixerWorkSubmitting(selectedWork: work));

    try {
      final hasExisting = await hireRequestRepository.hasExistingRequest(
        workId: work.id,
        posterId: currentUser.uid,
      );

      if (hasExisting) {
        emit(FixerWorkSelectionError("You already sent a request for this work"));
        return;
      }

      final posterProfile = await userProfileService.getProfile(
        currentUser.uid,
        "poster",
      );

      if (posterProfile == null) {
        emit(FixerWorkSelectionError("Complete your profile first"));
        return;
      }

      await hireRequestRepository.createHireRequest(
        work: work,
        fixer: fixer,
        poster: posterProfile,
        message: message?.trim().isEmpty ?? true ? null : message!.trim(),
      );

      emit(FixerWorkRequestSuccess(work.title, fixer.name));
    } catch (e) {
      emit(FixerWorkSelectionError("Failed to send request: $e"));
    }
  }
}
