import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/repository/fixer_profile_repository.dart';

part 'fixer_profile_state.dart';

class FixerProfileCubit extends Cubit<FixerProfileState> {
  FixerProfileCubit() : super(FixerProfileInitial());
  final FixerProfileRepository fixerProfileRepository =
      FixerProfileRepository();
 Future<void> uploadCoverImage() async {
  try {
    final url = await fixerProfileRepository.pickAndUploadCoverImage();
    if (url == null) return;

    if (isClosed) return; // Check if cubit is still active
    emit(FixerProfileLoading());

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (isClosed) return;
      emit(FixerProfileError(message: "User not logged in"));
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('roles')
        .doc('fixer')
        .update({'fixerData.coverImageUrl': url});

    if (isClosed) return;
   emit(FixerProfileUpdated(coverImageUrl: url));
Future.delayed(Duration(milliseconds: 200), () {
  loadFixerProfile(); 
});

  } catch (e) {
    if (isClosed) return;
    emit(FixerProfileError(message: "Error: ${e.toString()}"));
  }
}


  Future<void> removeCoverImage() async {
    emit(FixerProfileLoading());
    try {
      await fixerProfileRepository.removeCoverImageFromFirestore();
      emit(FixerProfileUpdated(coverImageUrl: ''));
      Future.delayed(Duration(milliseconds: 200), () {
  loadFixerProfile(); 
});
    } catch (e) {
      emit(FixerProfileError(message: 'Failed to remove cover image'));
    }
  }

Future<void> loadFixerProfile() async {
  emit(FixerProfileLoading());

  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(FixerProfileError(message: "User not logged in"));
      return;
    }


    final roleDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('roles')
        .doc('fixer')
        .get();

    if ( !roleDoc.exists) {
      emit(FixerProfileError(message: "Profile not found"));
      return;
    }

    // final userData = userDoc.data();
    final roleData = roleDoc.data();

    if ( roleData == null) {
      emit(FixerProfileError(message: "Incomplete profile data"));
      return;
    }

   
 

    final profile = UserProfileModel.fromJson(roleData);

    emit(FixerProfileLoaded(profile));
  } catch (e) {
    emit(FixerProfileError(message: 'Failed to load profile: $e'));
  }
}



void updateProfileImageUrl(String newUrl) {
  final currentState = state;
  if (currentState is FixerProfileLoaded) {
    final updatedProfile = currentState.fixerProfile.copyWith(
      profileImageUrl: newUrl,
    );
    emit(FixerProfileLoaded(updatedProfile));
  }
}
void clear() {
  emit(FixerProfileInitial());
}
Future<void> updateCertificate() async {
  emit(FixerProfileLoading());
  try {
    final url = await fixerProfileRepository.pickAndUploadCertificate();
    if (url == null) {
      emit(FixerProfileError(message: "No certificate selected"));
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(FixerProfileError(message: "User not logged in"));
      return;
    }

    // Update Firestore with new certificate and reset status to pending
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('roles')
        .doc('fixer')
        .update({
      'fixerData.certification': url,
      'fixerData.certificateStatus': 'Pending',
    });

    emit(FixerProfileUpdated(coverImageUrl: url));
    await loadFixerProfile(); // Reload the profile after update
  } catch (e) {
    emit(FixerProfileError(message: "Failed to update certificate: $e"));
  }
}


}
