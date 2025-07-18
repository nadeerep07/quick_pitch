part of 'explore_screen_cubit.dart';

class ExploreScreenState {
  final List<TaskPostModel> allTasks;
  final List<TaskPostModel> filteredTasks;
  final String selectedFilter;
  final double maxBudget;
  final double currentBudget;
  final DateTime? selectedDeadline;
  final String? preferredTime;
  final bool isLoading;
  final String searchQuery;

  ExploreScreenState({
    this.allTasks = const [],
    this.filteredTasks = const [],
    this.selectedFilter = 'All',
    this.maxBudget = 10000,
    this.currentBudget = 10000,
    this.selectedDeadline,
    this.preferredTime,
    this.isLoading = false,
    this.searchQuery ='',

  });

  ExploreScreenState copyWith({
    List<TaskPostModel>? allTasks,
    List<TaskPostModel>? filteredTasks,
    String? selectedFilter,
    double? maxBudget,
    double? currentBudget,
    DateTime? selectedDeadline,
    String? preferredTime,
    bool? isLoading,
    String? searchQuery, 
  }) {
    return ExploreScreenState(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      maxBudget: maxBudget ?? this.maxBudget,
      currentBudget: currentBudget ?? this.currentBudget,
      selectedDeadline: selectedDeadline ?? this.selectedDeadline,
      preferredTime: preferredTime ?? this.preferredTime,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery
    );
  }
}
