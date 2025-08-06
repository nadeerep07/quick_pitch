import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/poster_task/repository/task_post_repository.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/repository/pitch_repository.dart';

part 'fixer_pitch_detail_state.dart';

class FixerPitchDetailCubit extends Cubit<FixerPitchDetailState> {
  final TaskPostRepository taskRepository;
  final PitchRepository pitchRepository;

  StreamSubscription<PitchModel>? _pitchSubscription;

  FixerPitchDetailCubit({
    required this.taskRepository,
    required this.pitchRepository,
  }) : super(FixerPitchDetailInitial());

  // FIXED: Method signature now matches the call from UI
  Future<void> initialize({
    required String taskId,
    required String pitchId,
  }) async {
    _pitchSubscription?.cancel();
    try {
      emit(FixerPitchDetailLoading());

      final task = await taskRepository.fetchTaskById(taskId);

      if (task == null) {
        emit(FixerPitchDetailError('Task not found'));
        return;
      }

      _pitchSubscription = pitchRepository
          .getPitchStream(pitchId)
          .listen(
            (pitch) {
              if (!isClosed) {
                //  prevents emit after close
                emit(FixerPitchDetailLoaded(task: task, pitch: pitch));
              }
            },
            onError: (error) {
              if (!isClosed) {
                //  guard errors too
                emit(
                  FixerPitchDetailError('Failed to load pitch updates: $error'),
                );
              }
            },
          );
    } catch (e) {
      print("Error initializing: $e");
      emit(FixerPitchDetailError(e.toString()));
    }
  }

  Future<void> updateProgress(String pitchId, int progress) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      // Show processing state
      emit(
        FixerPitchDetailProcessing(
          task: currentState.task,
          pitch: currentState.pitch,
          message: 'Updating progress...',
        ),
      );

      await pitchRepository.updatePitchProgress(pitchId, progress);

      // Stream will automatically emit updated state
    } catch (e) {
      emit(FixerPitchDetailError('Failed to update progress: ${e.toString()}'));
      // Restore previous state
      emit(currentState);
    }
  }

  Future<void> markAsCompleted(String pitchId, String notes) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(
        FixerPitchDetailProcessing(
          task: currentState.task,
          pitch: currentState.pitch,
          message: 'Marking as completed...',
        ),
      );

      await pitchRepository.markPitchAsCompleted(pitchId, notes);

      // Stream will automatically emit updated state
    } catch (e) {
      emit(
        FixerPitchDetailError('Failed to mark as completed: ${e.toString()}'),
      );
      emit(currentState);
    }
  }

  Future<void> addWorkUpdate(String pitchId, String update) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(
        FixerPitchDetailProcessing(
          task: currentState.task,
          pitch: currentState.pitch,
          message: 'Adding update...',
        ),
      );

      await pitchRepository.addPitchUpdate(pitchId, update);

      // Stream will automatically emit updated state
    } catch (e) {
      emit(FixerPitchDetailError('Failed to add update: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> requestPayment(String pitchId) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(
        FixerPitchDetailProcessing(
          task: currentState.task,
          pitch: currentState.pitch,
          message: 'Requesting payment...',
        ),
      );

      await pitchRepository.requestPayment(pitchId);

      // Stream will automatically emit updated state
    } catch (e) {
      emit(FixerPitchDetailError('Failed to request payment: ${e.toString()}'));
      emit(currentState);
    }
  }

  @override
  Future<void> close() {
    _pitchSubscription?.cancel();
    return super.close();
  }
}
