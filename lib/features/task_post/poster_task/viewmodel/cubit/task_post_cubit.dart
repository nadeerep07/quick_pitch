import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/profile_completion/repository/user_profile_repository.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_post/poster_task/repository/task_post_repository.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'task_post_state.dart';

class TaskPostCubit extends Cubit<TaskPostState> {
  final CloudinaryService service;
  final TaskPostRepository repository;

  TaskPostCubit({required this.service, required this.repository})
    : super(TaskPostInitial());
  final UserProfileRepository rep = UserProfileRepository();

  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final budgetController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  List<String> uploadedImageUrls = [];
  final formKey = GlobalKey<FormState>();

  final List<String> categories = [
    "Cleaning",
    "Repair",
    "Delivery",
    "Tutoring",
    "Plumbing",
  ];
  String? selectedCategory;
  String selectedPriority = "Medium";
  String selectedTimeSlot = "Afternoon";
  String selectedWorkType = "On-site";
  DateTime? selectedDeadline;

  String get deadlineText =>
      selectedDeadline != null
          ? DateFormat('dd MMM yyyy').format(selectedDeadline!)
          : "Select deadline";

  // Pick multiple images
  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 75);
    if (pickedFiles.isNotEmpty) {
      selectedImages = pickedFiles.map((x) => File(x.path)).toList();
      emit(TaskPostUpdated());
    }
  }

  void setCategory(String? value) {
    selectedCategory = value;
    emit(TaskPostUpdated());
  }

  void setPriority(String level) {
    selectedPriority = level;
    emit(TaskPostUpdated());
  }

  void setTimeSlot(String value) {
    selectedTimeSlot = value;
    emit(TaskPostUpdated());
  }

  void setWorkType(String type) {
    selectedWorkType = type;
    emit(TaskPostUpdated());
  }

  Future<void> pickDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDeadline = picked;
      emit(TaskPostUpdated());
    }
  }

  Future<void> submitTask(BuildContext context) async {
    if (_isFormInvalid()) {
      showDialog(
        context: context,
        builder:
            (context) => CustomDialog(
              title: "Invalid Form",
              message: "Please fill all required fields correctly.",
              icon: Icons.error_outline,
              iconColor: Colors.red,
              onConfirm: () => Navigator.of(context).pop(),
            ),
      );
      return;
    }

    emit(TaskPostLoading());
    final uuid = const Uuid();
    final user = FirebaseAuth.instance.currentUser;

    if (selectedImages.isNotEmpty) {
      uploadedImageUrls = await service.uploadImagesToCloudinary(
        selectedImages,
      );
    }

    final task = TaskPostModel(
      id: uuid.v4(),
      posterId: user!.uid,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      budget: budgetController.text.trim(),
      location: locationController.text.trim(),
      category: selectedCategory!,
      priority: selectedPriority,
      preferredTime: selectedWorkType == 'On-site' ? selectedTimeSlot : '',
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      deadline: selectedDeadline!,
      createdAt: DateTime.now(),
      workType: selectedWorkType,
      status: 'pending',
      imagesUrl: uploadedImageUrls,
    );

    try {
      await repository.postTask(task);
      emit(TaskPostSuccess());
      resetForm();
      Navigator.pop(context,true);
    } catch (e) {
      emit(TaskPostError("Failed to post task: ${e.toString()}"));
    }
  }

void setCurrentLocationFromDevice() async {
  print("Setting current location from device");

  final location = await rep.getCurrentLocation(); // should print all [DEBUG] logs
  print("Current location set: $location");

  locationController.text = location;
}


  bool _isFormInvalid() {
    return !formKey.currentState!.validate();
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    return super.close();
  }

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    budgetController.clear();
    locationController.clear();
    phoneController.clear();
    emailController.clear();

    selectedImages.clear();
    uploadedImageUrls.clear();
    selectedCategory = null;
    selectedDeadline = null;
    selectedPriority = "Medium";
    selectedTimeSlot = "Afternoon";
    selectedWorkType = "On-site";

    emit(TaskPostInitial());
  }

  bool hasFormChanged() {
    return titleController.text.trim().isNotEmpty ||
        descriptionController.text.trim().isNotEmpty ||
        budgetController.text.trim().isNotEmpty ||
        locationController.text.trim().isNotEmpty ||
        phoneController.text.trim().isNotEmpty ||
        emailController.text.trim().isNotEmpty ||
        selectedCategory != null ||
        selectedImages.isNotEmpty;
  }
}
