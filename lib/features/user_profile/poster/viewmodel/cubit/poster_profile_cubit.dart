import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_profile/poster/repository/poster_profile_repository.dart';

part 'poster_profile_state.dart';

class PosterProfileCubit extends Cubit<PosterProfileState> {
  PosterProfileCubit() : super(PosterProfileInitial());
   final PosterProfileRepository posterProfileRepository =
      PosterProfileRepository();
 Future<void> uploadCoverImage() async {
  try {
    final url = await posterProfileRepository.pickAndUploadCoverImage();
    if (url == null) return;

    if (isClosed) return; 
    emit(PosterProfileLoading());

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (isClosed) return;
      emit(PosterProfileError(message: "User not logged in"));
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('roles')
        .doc('poster')
        .update({'posterData.coverImageUrl': url});

    if (isClosed) return;
   emit(PosterProfileUpdated(coverImageUrl: url));
Future.delayed(Duration(milliseconds: 200), () {
  loadPosterProfile(); 
});

  } catch (e) {
    if (isClosed) return;
    emit(PosterProfileError(message: "Error: ${e.toString()}"));
  }
}


  Future<void> removeCoverImage() async {
    emit(PosterProfileLoading());
    try {
      await posterProfileRepository.removeCoverImageFromFirestore();
      emit(PosterProfileUpdated(coverImageUrl: ''));
      Future.delayed(Duration(milliseconds: 200), () {
  loadPosterProfile(); 
});
    } catch (e) {
      emit(PosterProfileError(message: 'Failed to remove cover image'));
    }
  }


Future<void> loadPosterProfile() async {
  emit(PosterProfileLoading());

  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(PosterProfileError(message: "User not logged in"));
      return;
    }

  

    final roleDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('roles')
        .doc('poster')
        .get();

    if ( !roleDoc.exists) {
      emit(PosterProfileError(message: "Profile not found"));
      return;
    }

    // final userData = userDoc.data();
    final roleData = roleDoc.data();

    if ( roleData == null) {
      emit(PosterProfileError(message: "Incomplete profile data"));
      return;
    }

   
 

    final profile = UserProfileModel.fromJson(roleData);

    emit(PosterProfileLoaded(profile));
  } catch (e) {
    emit(PosterProfileError(message: 'Failed to load profile: $e'));
  }
}



void updateProfileImageUrl(String newUrl) {
  final currentState = state;
  if (currentState is PosterProfileLoaded) {
    final updatedProfile = currentState.posterProfile.copyWith(
      profileImageUrl: newUrl,
    );
    emit(PosterProfileLoaded(updatedProfile));
  }
}
void clear() {
  emit(PosterProfileInitial());
}


}
