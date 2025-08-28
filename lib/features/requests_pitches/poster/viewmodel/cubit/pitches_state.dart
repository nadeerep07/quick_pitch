import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

abstract class PitchesState {}

class PitchesInitial extends PitchesState {}

class PitchesLoading extends PitchesState {}

class PitchesLoaded extends PitchesState {
  final List<Map<String, dynamic>> pending;
  final List<Map<String, dynamic>> assigned;
  final List<Map<String, dynamic>> completed;

  PitchesLoaded({
    required this.pending,
    required this.assigned,
    required this.completed,
  });
}

class PitchesError extends PitchesState {
  final String message;
  PitchesError(this.message);
}

class PitchesCubit extends Cubit<PitchesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _taskSubscription;
  StreamSubscription? _pitchesSubscription;

  PitchesCubit() : super(PitchesInitial());

  void listenToPitches() {
    emit(PitchesLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(PitchesError("User not logged in"));
      return;
    }

    _taskSubscription?.cancel();
    _pitchesSubscription?.cancel();

    _taskSubscription = _firestore
        .collection('poster_tasks')
        .where('posterId', isEqualTo: currentUser.uid)
        .snapshots()
        .listen((tasksSnapshot) {
      final tasks = tasksSnapshot.docs
          .map((doc) => TaskPostModel.fromMap(doc.data()))
          .toList();

      final taskIds = tasks.map((t) => t.id).toList();

      if (taskIds.isEmpty) {
        emit(PitchesLoaded(pending: [], assigned: [], completed: []));
        return;
      }

      // cancel previous pitch subscription before creating a new one
      _pitchesSubscription?.cancel();

      _pitchesSubscription = _firestore
          .collection('pitches')
          .where('taskId', whereIn: taskIds)
          .snapshots()
          .listen((pitchesSnapshot) {
        final allPitches = pitchesSnapshot.docs
            .map((doc) => PitchModel.fromJson(doc.data()))
            .where((pitch) => pitch.status != 'rejected')
            .toList();

        List<Map<String, dynamic>> pending = [];
        List<Map<String, dynamic>> assigned = [];
        List<Map<String, dynamic>> completed = [];

        for (final task in tasks) {
          final taskPitches =
              allPitches.where((p) => p.taskId == task.id).toList();

          if (taskPitches.isNotEmpty) {
            if (task.status == 'pending') {
              pending.add({'task': task, 'pitches': taskPitches});
            } else if (task.status == 'accepted' ||
                task.status == 'assigned') {
              assigned.add({'task': task, 'pitches': taskPitches});
            } else if (task.status == 'completed') {
              completed.add({'task': task, 'pitches': taskPitches});
            }
          }
        }

        if (!isClosed) {
          emit(PitchesLoaded(
            pending: pending,
            assigned: assigned,
            completed: completed,
          ));
        }
      });
    });
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    _pitchesSubscription?.cancel();
    return super.close();
  }

  Future<UserProfileModel?> getFixerDetails(String? fixerId) async {
    if (fixerId == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(fixerId)
          .collection('roles')
          .doc('fixer')
          .get();
      if (doc.exists) {
        return UserProfileModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Map<String, List<PitchModel>> getActiveFixerPitches(
    Map<String, List<PitchModel>> allPitches,
  ) {
    return allPitches
      .map((fixerId, pitches) {
        final validPitches =
            pitches.where((p) => p.status != 'rejected').toList();
        return MapEntry(fixerId, validPitches);
      })
      ..removeWhere((key, value) => value.isEmpty);
  }
}

