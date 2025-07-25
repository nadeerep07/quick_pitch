import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/profile_completion/repository/user_profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  final UserProfileRepository repository;


  ProfileEditCubit({required this.repository}) : super(ProfileEditInitial());

  UserProfileModel? currentProfile;

 Future<void> loadProfile(String role) async {
  emit(ProfileEditLoading());
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final profile = await repository.getProfile(uid, role);
    currentProfile = profile;
    emit(ProfileEditLoaded(profile!));
  } catch (e) {
    emit(ProfileEditError(e.toString()));
  }
}


  Future<void> updateProfile(UserProfileModel updatedProfile) async {
    emit(ProfileEditLoading());
    try {
      await repository.updateProfile(updatedProfile);
      emit(ProfileEditSuccess());
    } catch (e) {
      emit(ProfileEditError(e.toString()));
    }
  }

  Future<String?> uploadImage(File file) async {
    try {
      final url = await repository.uploadFileToCloudinary(file);
      return url;
    } catch (e) {
      emit(ProfileEditError("Image upload failed"));
      return null;
    }
  }
}
