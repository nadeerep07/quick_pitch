part of 'fixer_home_cubit.dart';

sealed class FixerHomeState {}

final class FixerHomeInitial extends FixerHomeState {}

final class FixerHomeLoading extends FixerHomeState {}

class FixerHomeLoaded extends FixerHomeState {
  final UserProfileModel userProfile;
  final List<TaskPostModel> newTasks;
  final List<String> selectedFilters;
  final List<TaskPostModel> activeTasks;
  final List<TaskPostModel> completedTasks;
  final double totalEarnings; // Add earnings field

  FixerHomeLoaded({
    required this.userProfile,
    required this.newTasks,
    this.selectedFilters = const [],
    required this.activeTasks,
    this.completedTasks = const [],
    this.totalEarnings = 0.0, // Default to 0
  });

  FixerHomeLoaded copyWith({
    UserProfileModel? userProfile,
    List<TaskPostModel>? newTasks,
    List<String>? selectedFilters,
    List<TaskPostModel>? activeTasks,
    List<TaskPostModel>? completedTasks,
    double? totalEarnings, // Add to copyWith
  }) {
    return FixerHomeLoaded(
      userProfile: userProfile ?? this.userProfile,
      newTasks: newTasks ?? this.newTasks,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      activeTasks: activeTasks ?? this.activeTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      totalEarnings: totalEarnings ?? this.totalEarnings, // Add to copyWith
    );
  }
}

class FixerHomeError extends FixerHomeState {
  final String message;
  FixerHomeError(this.message);
}