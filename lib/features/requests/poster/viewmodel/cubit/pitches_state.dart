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
  StreamSubscription? _subscription;

  PitchesCubit() : super(PitchesInitial());

  void listenToPitches() {
    emit(PitchesLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(PitchesError("User not logged in"));
      return;
    }

    // Cancel old subscription if exists
    _subscription?.cancel();

    _subscription = _firestore
        .collection('poster_tasks')
        .where('posterId', isEqualTo: currentUser.uid)
        .snapshots()
        .listen((tasksSnapshot) async {
      try {
        final tasks = tasksSnapshot.docs
            .map((doc) => TaskPostModel.fromMap(doc.data()))
            .toList();

        List<Map<String, dynamic>> pending = [];
        List<Map<String, dynamic>> assigned = [];
        List<Map<String, dynamic>> completed = [];

        for (final task in tasks) {
          final pitchesSnapshot = await _firestore
              .collection('pitches')
              .where('taskId', isEqualTo: task.id)
              .orderBy('createdAt', descending: true)
              .get();

          final pitches = pitchesSnapshot.docs
              .map((doc) => PitchModel.fromJson(doc.data()))
              .toList();

          if (pitches.isNotEmpty) {
            if (task.status == 'pending') {
              pending.add({'task': task, 'pitches': pitches});
            } else if (task.status == 'assigned') {
              assigned.add({'task': task, 'pitches': pitches});
            } else if (task.status == 'completed') {
              completed.add({'task': task, 'pitches': pitches});
            }
          }
        }

        emit(PitchesLoaded(
            pending: pending, assigned: assigned, completed: completed));
      } catch (e) {
        emit(PitchesError('Failed to load pitches: ${e.toString()}'));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
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
      print("Error fetching fixer details: $e");
      return null;
    }
  }
}
