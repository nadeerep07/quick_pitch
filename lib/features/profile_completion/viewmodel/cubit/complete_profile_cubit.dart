import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:quick_pitch_app/core/utils/image_picker_helper.dart';
import 'package:quick_pitch_app/features/main/fixer/model/fixer_data.dart';
import 'package:quick_pitch_app/features/main/poster/model/poster_data.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/profile_completion/repository/user_profile_repository.dart';

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  final UserProfileRepository repository;

  CompleteProfileCubit({required this.repository})
    : super(CompleteProfileInitial()) {
    bioController.addListener(() {
      onBioChanged(bioController.text);
    });
  }

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final certificationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? profileImage;
  File? certificateImage;

   List<String> allSkills = [];
  String? profileUrl;
  String? certificateUrl;

  List<String> selectedSkills = [];
  String searchQuery = '';
  
    Future<void> loadSkillsFromAdmin() async {
    try {
      emit(CompleteProfileLoading());
      allSkills = await repository.fetchSkillsFromAdmin();
      emit(SkillSelectionUpdated());
    } catch (e) {
      emit(CompleteProfileError("Failed to load skills"));
    }
  }

  List<String> get filteredSkills =>
      allSkills
          .where(
            (skill) => skill.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();

  void toggleSkillSelection(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
    emit(SkillSelectionUpdated());
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);
    emit(SkillSelectionUpdated());
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    emit(SkillSearchUpdated());
  }

  void setProfileImage(File image) {
    profileImage = image;
    emit(SkillSelectionUpdated());
  }

  void setCertificateImage(File image) {
    certificateImage = image;
    emit(SkillSelectionUpdated());
  }

  void pickProfileImage() async {
    final image = await ImagePickerHelper.pickImageFromGallery();
    if (image != null) setProfileImage(image);
  }

  void pickCertificationFile() async {
    final cert = await ImagePickerHelper.pickImageFromGallery();
    if (cert != null) {
      setCertificateImage(cert);
      certificationController.text = cert.path.split('/').last;
    }
  }

  void setCurrentLocationFromDevice() async {
    final location = await repository.getCurrentLocation();
    locationController.text = location;
  }

  final int maxBioLength = 500;
  int remainingBioChars = 500;

  void onBioChanged(String text) {
    remainingBioChars = maxBioLength - text.length;
    emit(SkillSelectionUpdated());
  }

  Future<void> submitProfile(String role) async {
    if (!formKey.currentState!.validate()) {
      emit(CompleteProfileError("Please fill all required fields"));
      return;
    }
    emit(CompleteProfileLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(CompleteProfileError("User not logged in"));
        return;
      }
      print("Firebase UID: ${user.uid}");

      if (profileImage != null) {
        profileUrl = await repository.uploadFileToCloudinary(profileImage!);
      }

      if (certificateImage != null) {
        certificateUrl = await repository.uploadFileToCloudinary(
          certificateImage!,
        );
      }
      FixerData? fixerData;
      PosterData? posterData;

      if (role == 'fixer') {
        fixerData = FixerData(
          skills: selectedSkills,
          certification: certificateUrl,
        );
      }

      if (role == 'poster') {
        posterData = PosterData(totalPosts: 0);
      }

      final model = UserProfileModel(
        uid: user.uid,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        bio: bioController.text.trim(),
        profileImageUrl: profileUrl,
        role: role,
        location: locationController.text.trim(),
        fixerData: fixerData,
        posterData: posterData,
        createdAt: DateTime.now()
      );

      await repository.saveProfile(model);
      print("Profile saved: $model");
      emit(CompleteProfileSuccess());
    } catch (e) {
      print("Error saving profile: $e");
      emit(CompleteProfileError(e.toString()));
    }
  }
  void resetProfileData() {
  nameController.clear();
  phoneController.clear();
  locationController.clear();
  bioController.clear();
  certificationController.clear();

  profileImage = null;
  certificateImage = null;
  profileUrl = null;
  certificateUrl = null;
  selectedSkills.clear();
  searchQuery = '';
  remainingBioChars = maxBioLength;

  emit(CompleteProfileInitial()); // or a custom ResetState if you want
}


  @override
  Future<void> close() {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    bioController.dispose();
    certificationController.dispose();
    return super.close();
  }
}
