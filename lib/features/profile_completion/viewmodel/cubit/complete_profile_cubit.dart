import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/utils/image_picker_helper.dart';
import 'package:quick_pitch_app/features/main/fixer/model/fixer_data.dart';
import 'package:quick_pitch_app/features/main/poster/model/poster_data.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/profile_completion/repository/user_profile_repository.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/repository/fixer_profile_editing_respository.dart';
import 'package:quick_pitch_app/features/user_profile/poster/repository/poster_profile_repository.dart';

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  final UserProfileRepository repository;

  CompleteProfileCubit({required this.repository})
    : super(CompleteProfileInitial()) {
    bioController.addListener(() {
      onBioChanged(bioController.text);
    });
  }

  final FixerProfileEditingRespository fixerRepo =
      FixerProfileEditingRespository();
  final PosterProfileRepository posterRepo = PosterProfileRepository();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final certificationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isEditing = false;

  String? profileImageUrl;
  String? certificateImageUrl;
  File? profileImage;
  File? certificateImage;

  List<String> allSkills = [];
  String? profileUrl;
  String? certificateUrl;

  List<String> selectedSkills = [];
  String searchQuery = '';

  // Cache for improved performance
  UserProfileModel? _cachedProfile;

  Future<void> loadSkillsFromAdmin() async {
    try {
      emit(CompleteProfileLoading());

      // Add timeout to prevent infinite loading
      allSkills = await repository.fetchSkillsFromAdmin().timeout(
        const Duration(seconds: 30),
      );

      emit(SkillSelectionUpdated(selectedSkills));
    } catch (e) {
      print("Error loading skills: $e");
      emit(CompleteProfileError("Failed to load skills: ${e.toString()}"));
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
    emit(SkillSelectionUpdated(selectedSkills));
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);
    emit(SkillSelectionUpdated(selectedSkills));
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    emit(SkillSearchUpdated());
  }

  void setProfileImage(File image) {
    profileImage = image;
    emit(SkillSelectionUpdated(selectedSkills));
  }

  void setCertificateImage(File image) {
    certificateImage = image;
    emit(SkillSelectionUpdated(selectedSkills));
  }

  void pickProfileImage() async {
    try {
      final image = await ImagePickerHelper.pickImageFromGallery();
      if (image != null) setProfileImage(image);
    } catch (e) {
      print("Error picking profile image: $e");
      emit(CompleteProfileError("Failed to pick image"));
    }
  }

  void pickCertificationFile() async {
    try {
      final cert = await ImagePickerHelper.pickImageFromGallery();
      if (cert != null) {
        setCertificateImage(cert);
        certificationController.text = cert.path.split('/').last;
      }
    } catch (e) {
      print("Error picking certification file: $e");
      emit(CompleteProfileError("Failed to pick certification file"));
    }
  }

  void setCurrentLocationFromDevice() async {
    try {
      final location = await repository.getCurrentLocation().timeout(
        const Duration(seconds: 10),
      );
      locationController.text = location;
    } catch (e) {
      print("Error getting location: $e");
      emit(CompleteProfileError("Failed to get current location"));
    }
  }

  final int maxBioLength = 500;
  int remainingBioChars = 500;

  void onBioChanged(String text) {
    remainingBioChars = maxBioLength - text.length;
    emit(SkillSelectionUpdated(selectedSkills));
  }

  Future<void> submitProfile(String role, BuildContext context) async {
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

      if (profileImage != null) {
        profileUrl = await repository
            .uploadFileToCloudinary(profileImage!)
            .timeout(const Duration(seconds: 60));
      } else {
     
        profileUrl = _cachedProfile?.profileImageUrl;
      }

      if (certificateImage != null) {
        certificateUrl = await repository
            .uploadFileToCloudinary(certificateImage!)
            .timeout(const Duration(seconds: 60));
      }else{
        certificateUrl = _cachedProfile?.fixerData?.certification;
      }

      FixerData? fixerData;
      PosterData? posterData;

      if (role == 'fixer') {
        fixerData = FixerData(
          skills: selectedSkills,
          certification: certificateUrl,
          bio: bioController.text.trim(),
        );
      }

      if (role == 'poster') {
        posterData = PosterData(bio: bioController.text.trim());
      }

      final model = UserProfileModel(
        uid: user.uid,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        profileImageUrl: profileUrl,
        role: role,
        location: locationController.text.trim(),
        fixerData: fixerData,
        posterData: posterData,
        createdAt: DateTime.now(),
      );

      // Add timeout for Firebase operations
      if (isEditing) {
        await repository
            .updateProfile(model)
            .timeout(const Duration(seconds: 30));

        // Clear cache after update
        _cachedProfile = null;

        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } else {
        await repository
            .saveProfile(model)
            .timeout(const Duration(seconds: 30));
      }

      //  print("Profile saved successfully: $model");
      emit(CompleteProfileSuccess());
    } catch (e) {
      print("Error saving profile: $e");
      String errorMessage = "Failed to save profile";

      if (e.toString().contains('TimeoutException')) {
        errorMessage =
            "Request timed out. Please check your internet connection and try again.";
      } else if (e.toString().contains('permission-denied')) {
        errorMessage = "Permission denied. Please check your Firebase rules.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error. Please check your internet connection.";
      }

      emit(CompleteProfileError(errorMessage));
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
    _cachedProfile = null; // Clear cache

    emit(CompleteProfileInitial());
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

  Future<void> loadProfileDataForEdit(String role) async {
    try {
      emit(CompleteProfileLoading());

      // Use cached data if available and recent
      if (_cachedProfile != null && _cachedProfile!.role == role) {
        _populateControllersFromCache(_cachedProfile!, role);
        emit(CompleteProfileLoaded());
        return;
      }

      final UserProfileModel user;

      // Add timeout for profile loading
      if (role == 'fixer') {
        user = await fixerRepo.getProfileData().timeout(
          const Duration(seconds: 30),
        );
      } else {
        user = await posterRepo.getProfileData().timeout(
          const Duration(seconds: 30),
        );
      }

      // Cache the loaded profile
      _cachedProfile = user;

      if (user.name.isNotEmpty) isEditing = true;

      _populateControllersFromCache(user, role);

      emit(CompleteProfileLoaded());
    } catch (e) {
      print("Error loading profile data: $e");
      String errorMessage = "Failed to load profile data";

      if (e.toString().contains('TimeoutException')) {
        errorMessage =
            "Request timed out. Please check your internet connection.";
      } else if (e.toString().contains('permission-denied')) {
        errorMessage = "Permission denied. Please check your Firebase rules.";
      }

      emit(CompleteProfileError(errorMessage));
    }
  }

  // Helper method to populate controllers from cached data
  void _populateControllersFromCache(UserProfileModel user, String role) {
    // Common fields
    nameController.text = user.name;
    locationController.text = user.location;
    phoneController.text = user.phone;
    profileImageUrl = user.profileImageUrl;

    // Role-specific fields
    if (role == 'fixer') {
      bioController.text = user.fixerData?.bio ?? "";
      certificationController.text = user.fixerData?.certification ?? "";
      selectedSkills.clear();
      selectedSkills.addAll(user.fixerData?.skills ?? []);
    } else if (role == 'poster') {
      bioController.text = user.posterData?.bio ?? "";
      certificationController.clear();
      selectedSkills.clear();
    }
  }

  Future<void> refreshProfileData(String role) async {
    _cachedProfile = null; // Clear cache first
    await loadProfileDataForEdit(role);
  }
}





