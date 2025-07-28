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
  final List<Map<String, dynamic>> groupedPitches; 
  PitchesLoaded(this.groupedPitches);
}

class PitchesError extends PitchesState {
  final String message;
  PitchesError(this.message);
}

class PitchesCubit extends Cubit<PitchesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PitchesCubit() : super(PitchesInitial());

  Future<void> loadPitches() async {
    emit(PitchesLoading());
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      // 1️⃣ Get tasks of current poster
      final tasksSnapshot = await _firestore
          .collection('poster_tasks')
          .where('posterId', isEqualTo: currentUser.uid)
          .get();

      final tasks = tasksSnapshot.docs
          .map((doc) => TaskPostModel.fromMap(doc.data()))
          .toList();

      // 2️⃣ For each task, fetch its pitches
      List<Map<String, dynamic>> result = [];
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
          result.add({'task': task, 'pitches': pitches});
        }
      }

      emit(PitchesLoaded(result));
    } catch (e) {
      emit(PitchesError('Failed to load pitches: ${e.toString()}'));
    }
  }

  Future<UserProfileModel?> getFixerDetails(String? fixerId) async {
    if (fixerId == null) return null;
    
    try {
      final doc = await _firestore.collection('users').doc(fixerId).collection('roles').doc('fixer').get();
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