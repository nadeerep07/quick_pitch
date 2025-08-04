import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';
import 'package:quick_pitch_app/core/services/firebase/skill/skills_service.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/profile_completion/repository/user_profile_repository.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/poster_task/repository/task_post_repository.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'task_post_state.dart';

class TaskPostCubit extends Cubit<TaskPostState> {
  final CloudinaryService service;
  final TaskPostRepository repository;
  final skillService = SkillService();
  bool isInitialized = false;
  TaskPostModel? existingTask;

  TaskPostCubit({required this.service, required this.repository})
    : super(TaskPostInitial()) {
    _loadSkills();
  }
  final UserProfileRepository rep = UserProfileRepository();

  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final budgetController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final searchController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  List<String> uploadedImageUrls = [];
  final formKey = GlobalKey<FormState>();

  List<String> skills = [];
  List<String> selectedSkills = [];
  List<String> suggestedSkills = [];
  String selectedPriority = "Medium";
  String selectedTimeSlot = "Afternoon";
  String selectedWorkType = "On-site";
  DateTime? selectedDeadline;

  String get deadlineText =>
      selectedDeadline != null
          ? DateFormat('dd MMM yyyy').format(selectedDeadline!)
          : "Select deadline";

  void _loadSkills() async {
    skills = await skillService.fetchAllSkills();
    suggestedSkills = skills.take(3).toList();
    emit(TaskPostUpdated());
  }

  // Pick multiple images
  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 75);
    if (pickedFiles.isNotEmpty) {
      selectedImages = pickedFiles.map((x) => File(x.path)).toList();
      emit(TaskPostUpdated());
    }
  }

  void updateSkillSuggestions(String query) {
    if (query.isEmpty) {
      suggestedSkills = skills;
    } else {
      suggestedSkills =
          skills
              .where((s) => s.toLowerCase().contains(query.toLowerCase()))
              .toList();
    }
    emit(TaskPostUpdated());
  }

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
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

    final user = FirebaseAuth.instance.currentUser;
    final taskId = existingTask?.id ?? const Uuid().v4();
    final posterId = existingTask?.posterId ?? user!.uid;
    final createdAt = existingTask?.createdAt ?? DateTime.now();

    // Upload new images only if user picked new ones
    if (selectedImages.isNotEmpty) {
      final newImageUrls = await service.uploadImagesToCloudinary(
        selectedImages,
      );
      uploadedImageUrls = [...uploadedImageUrls, ...newImageUrls];
      selectedImages.clear();
    } else {
      uploadedImageUrls = existingTask?.imagesUrl ?? [];
    }

    final task = TaskPostModel(
      id: taskId,
      posterId: posterId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
     budget: double.tryParse(budgetController.text.trim()) ?? 0.0,
      location: locationController.text.trim(),
      skills: selectedSkills.isNotEmpty ? selectedSkills : ["General"],
      priority: selectedPriority,
      preferredTime: selectedWorkType == 'On-site' ? selectedTimeSlot : '',
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      deadline: selectedDeadline!,
      createdAt: createdAt,
      workType: selectedWorkType,
      status: existingTask?.status ?? 'pending',
      imagesUrl: uploadedImageUrls,
      assignedFixerId: existingTask?.assignedFixerId,
      assignedFixerName: existingTask?.assignedFixerName,
    );

    try {
      if (existingTask != null) {
        await repository.updateTask(task);
      } else {
     //   print('task posted ${task.posterId}');
        await repository.postTask(task);
      }

      emit(TaskPostSuccess());
      resetForm();
      Navigator.pop(context, true);
    } catch (e) {
      emit(
        TaskPostError(
          "Failed to ${existingTask != null ? 'update' : 'post'} task: ${e.toString()}",
        ),
      );
    }
  }

  void removeUploadedImageAt(int index) {
    if (index >= 0 && index < uploadedImageUrls.length) {
      uploadedImageUrls.removeAt(index);
      emit(TaskPostUpdated());
    }
  }

  void removeSelectedImageAt(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      emit(TaskPostUpdated());
    }
  }

  void setCurrentLocationFromDevice() async {
  //  print("Setting current location from device");

    final location =
        await rep.getCurrentLocation(); // should print all [DEBUG] logs
 //   print("Current location set: $location");

    locationController.text = location;
  }

  void initializeWithTask(TaskPostModel task) {
    existingTask = task;
    titleController.text = task.title;
    descriptionController.text = task.description;
    budgetController.text = task.budget.toString();
    phoneController.text = task.phone;
    emailController.text = task.email;
    selectedDeadline = task.deadline;
    selectedSkills = List.from(task.skills);
    selectedPriority = task.priority;
    selectedWorkType = task.workType;
    locationController.text = task.location;
    selectedTimeSlot = task.preferredTime;
    uploadedImageUrls = List.from(task.imagesUrl ?? []);
    selectedImages = [];
    isInitialized = true;
    emit(TaskPostInitial());
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
    selectedSkills.clear();
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
        selectedSkills.isNotEmpty ||
        selectedImages.isNotEmpty;
  }
}
