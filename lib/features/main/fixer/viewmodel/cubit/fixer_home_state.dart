part of 'fixer_home_cubit.dart';


sealed class FixerHomeState {}

final class FixerHomeInitial extends FixerHomeState {}

final class FixerHomeLoading extends FixerHomeState {}


class FixerHomeLoaded extends FixerHomeState {
  final UserProfileModel userProfile;
  final List<TaskPostModel> newTasks;
  final List<String> selectedFilters;

  

  FixerHomeLoaded({
    required this.userProfile,
    required this.newTasks,
     this.selectedFilters = const [],
    
    // required this.activeTasks,
  });
   FixerHomeLoaded copyWith({
    UserProfileModel? userProfile,
    List<TaskPostModel>? newTasks,
    List<String>? selectedFilters,
  }) {
    return FixerHomeLoaded(
      userProfile: userProfile ?? this.userProfile,
      newTasks: newTasks ?? this.newTasks,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }
}


class FixerHomeError extends FixerHomeState {
  final String message;
  FixerHomeError(this.message);
}