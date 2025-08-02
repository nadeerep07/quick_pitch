import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/main/poster/repository/poster_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

part 'poster_home_state.dart';

class PosterHomeCubit extends Cubit<PosterHomeState> {
  final PosterRepository repository;
  StreamSubscription? _profileSub;
  StreamSubscription? _tasksSub;

  PosterHomeCubit(this.repository) : super(PosterHomeInitial());

  UserProfileModel? _profile;
  List<TaskPostModel>? _tasks;
  bool _isLoading = false;
  bool _hasProfile = false;
  bool _hasTasks = false;

  void streamPosterHomeData() {
  //   print('streamPosterHomeData called, current state: $state');
    
    // Cancel existing subscriptions first
    _profileSub?.cancel();
    _tasksSub?.cancel();
    
    emit(PosterHomeLoading());
    
    // Reset flags when starting new stream
    _isLoading = false;
    _hasProfile = false;
    _hasTasks = false;
    _profile = null;
    _tasks = null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(PosterHomeError("User not authenticated"));
      return;
    }
//print(' Profile received: ${user.uid}');
    _profileSub = repository.streamUserProfile(user.uid).listen((profile) {
    //   print(' Profile received: $profile');
      if (profile == null) {
        emit(PosterHomeError("User profile not found"));
        return;
      }

      _profile = profile;
      _hasProfile = true;
      
      // Only try to emit if we're not already processing
      if (!_isLoading) {
        _tryEmitLoaded(user.uid);
      } else {
       //  print('Skipping _tryEmitLoaded - already loading');
      }
    });

    _tasksSub = repository.streamTasksByUser(user.uid).listen((tasks) {
     //  print(' Tasks received: ${tasks.length}');
      _tasks = tasks;
      _hasTasks = true;
      
      // Only try to emit if we're not already processing
      if (!_isLoading) {
        _tryEmitLoaded(user.uid);
      } else {
       //  print(' Skipping _tryEmitLoaded - already loading');
      }
    });
  }

  Future<void> _tryEmitLoaded(String uid) async {
   //  print('Attempting _tryEmitLoaded...');
   //  print('_hasProfile: $_hasProfile, _hasTasks: $_hasTasks, _isLoading: $_isLoading');

    if (_hasProfile && _hasTasks && !_isLoading) {
      _isLoading = true;

     //  print('Ready to emit PosterHomeLoaded');
     //  print('Profile: $_profile');
     //  print(' Tasks: $_tasks');

      final postIds = _tasks!.map((task) => task.id).toList();
      _profile!.copyWith(
        posterData: _profile!.posterData?.copyWith(postIds: postIds),
      );

      try {
       //  print(' Fetching recommended fixers...');
        final fixers = await repository.fetchRecommendedFixers().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Fixers fetch timed out after 10 seconds');
          },
        );
      //   print('Fixers fetched: ${fixers.length}');

       //  print(' Emitting PosterHomeLoaded...');
        emit(PosterHomeLoaded(
          userProfile: _profile!, // Use original profile instead of updated one
          tasks: _tasks!,
          fixers: fixers,
        ));
       //  print(' PosterHomeLoaded emitted successfully');
      } catch (e) {
       //  print(' Error in _tryEmitLoaded: $e');
      //   print(' Error type: ${e.runtimeType}');
        emit(PosterHomeError("Failed to load poster home: $e"));
      } finally {
        _isLoading = false; // Reset here
       //  print(' _isLoading reset to false');
      }
    }
  }

  @override
  Future<void> close() {
    _profileSub?.cancel();
    _tasksSub?.cancel();
    return super.close();
  }
}