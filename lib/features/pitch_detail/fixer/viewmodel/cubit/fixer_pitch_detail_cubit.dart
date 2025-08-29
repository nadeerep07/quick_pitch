import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/core/services/pitch/pitch_status_services.dart';
import 'package:quick_pitch_app/core/services/pitch/pitch_update_services.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/service/payment_request_service.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/poster_task/repository/task_post_repository.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/repository/pitch_repository.dart';

part 'fixer_pitch_detail_state.dart';

class FixerPitchDetailCubit extends Cubit<FixerPitchDetailState> {
  final TaskPostRepository taskRepository;
  final PitchRepository pitchRepository;
  final PitchStatusService pitchStatusService;
  final PitchUpdateService pitchUpdateService;
  final PaymentRequestService paymentRequestService; // Add this

  StreamSubscription<PitchModel>? _pitchSubscription;

  FixerPitchDetailCubit({
    required this.taskRepository,
    required this.pitchRepository,
    required this.pitchStatusService,
    required this.pitchUpdateService,
    required this.paymentRequestService, // Add this
  }) : super(FixerPitchDetailInitial());

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

      _pitchSubscription = pitchRepository.getPitchStream(pitchId).listen(
        (pitch) {
          if (!isClosed) {
            emit(FixerPitchDetailLoaded(task: task, pitch: pitch));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(FixerPitchDetailError('Failed to load pitch updates: $error'));
          }
        },
      );
    } catch (e) {
      emit(FixerPitchDetailError(e.toString()));
    }
  }

  Future<void> updateProgress(String pitchId, int progress) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(FixerPitchDetailProcessing(
        task: currentState.task,
        pitch: currentState.pitch,
        message: 'Updating progress...',
      ));

      await pitchStatusService.updatePitchProgress(pitchId, progress);
    } catch (e) {
      emit(FixerPitchDetailError('Failed to update progress: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> markAsCompleted(String pitchId, String notes) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(FixerPitchDetailProcessing(
        task: currentState.task,
        pitch: currentState.pitch,
        message: 'Marking as completed...',
      ));

      await pitchStatusService.markPitchAsCompleted(
        pitchId: pitchId,
        taskId: currentState.task.id,
        notes: notes,
      );
    } catch (e) {
      emit(FixerPitchDetailError('Failed to mark as completed: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> addWorkUpdate(String pitchId, String update) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(FixerPitchDetailProcessing(
        task: currentState.task,
        pitch: currentState.pitch,
        message: 'Adding update...',
      ));

      await pitchUpdateService.addPitchUpdate(pitchId, update);
    } catch (e) {
      emit(FixerPitchDetailError('Failed to add update: ${e.toString()}'));
      emit(currentState);
    }
  }

  // Add payment request methods
  Future<void> requestPayment({
    required String pitchId,
    required double amount,
    required String notes,
  }) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(FixerPitchDetailProcessing(
        task: currentState.task,
        pitch: currentState.pitch,
        message: 'Requesting payment...',
      ));

      await paymentRequestService.requestPayment(
        pitchId: pitchId,
        taskId: currentState.task.id,
        requestedAmount: amount,
        notes: notes,
      );

      // Success state will be automatically updated through the stream
    } catch (e) {
      emit(FixerPitchDetailError('Failed to request payment: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> cancelPaymentRequest(String pitchId) async {
    final currentState = state;
    if (currentState is! FixerPitchDetailLoaded) return;

    try {
      emit(FixerPitchDetailProcessing(
        task: currentState.task,
        pitch: currentState.pitch,
        message: 'Canceling payment request...',
      ));

      await paymentRequestService.cancelPaymentRequest(
        pitchId: pitchId,
        taskId: currentState.task.id,
      );

      // Success state will be automatically updated through the stream
    } catch (e) {
      emit(FixerPitchDetailError('Failed to cancel payment request: ${e.toString()}'));
      emit(currentState);
    }
  }
  

  @override
  Future<void> close() {
    _pitchSubscription?.cancel();
    return super.close();
  }
}