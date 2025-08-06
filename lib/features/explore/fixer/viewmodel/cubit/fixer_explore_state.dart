// fixer_explore_state.dart

part of 'fixer_explore_cubit.dart';

class FixerExploreState extends Equatable {
  final String searchQuery;
  final String selectedFilter;
  final bool showSearchHistory;
  final bool showMoreFilters;
  final Set<String> selectedSkills;
  final String? selectedLocation;
  final String selectedDeadline;
  final double priceRangeStart;
  final double priceRangeEnd;
  final List<TaskPostModel> tasks;
  final List<TaskPostModel> filteredTasks;
  final RequestStatus status;
  final String? errorMessage;
   final double minBudget;
  final double maxBudget;
  final List<String> popularLocations;
  

  const FixerExploreState({
    this.searchQuery = '',
    this.selectedFilter = 'All',
    this.showSearchHistory = false,
    this.showMoreFilters = false,
    this.selectedSkills = const {},
    this.selectedLocation,
    this.selectedDeadline = 'Anytime',
    this.priceRangeStart = 0,
    this.priceRangeEnd = 0,
     this.minBudget = 0,
    this.maxBudget = 0,
    this.tasks = const [],
    this.filteredTasks = const [],
    this.status = RequestStatus.initial,
    this.errorMessage,
    this.popularLocations = const [],
  });

  @override
  List<Object?> get props => [
        searchQuery,
        selectedFilter,
        showSearchHistory,
        showMoreFilters,
        selectedSkills,
        selectedLocation,
        selectedDeadline,
        priceRangeStart,
        priceRangeEnd,
        tasks,
        filteredTasks,
        status,
        errorMessage,
        minBudget,maxBudget,popularLocations
      ];

 FixerExploreState copyWith({
  String? searchQuery,
  String? selectedFilter,
  bool? showSearchHistory,
  bool? showMoreFilters,
  Set<String>? selectedSkills,
  String? selectedLocation,
  String? selectedDeadline,
  double? priceRangeStart,
  double? priceRangeEnd,
  List<TaskPostModel>? tasks,
  List<TaskPostModel>? filteredTasks,
  RequestStatus? status,
  String? errorMessage,
  double? minBudget,
  double? maxBudget,
  List<String>? popularLocations,
}) {
  double newMin = minBudget ?? this.minBudget;
  double newMax = maxBudget ?? this.maxBudget;
  double newStart = priceRangeStart ?? this.priceRangeStart;
  double newEnd = priceRangeEnd ?? this.priceRangeEnd;

  // 🛠 Normalize budgets
  if (newMin == newMax) {
    newMax = newMin + 1;
  }
  newStart = newStart.clamp(newMin, newMax);
  newEnd = newEnd.clamp(newMin, newMax);
  if (newStart > newEnd) {
    final temp = newStart;
    newStart = newEnd;
    newEnd = temp;
  }

  return FixerExploreState(
    searchQuery: searchQuery ?? this.searchQuery,
    selectedFilter: selectedFilter ?? this.selectedFilter,
    showSearchHistory: showSearchHistory ?? this.showSearchHistory,
    showMoreFilters: showMoreFilters ?? this.showMoreFilters,
    selectedSkills: selectedSkills ?? this.selectedSkills,
    selectedLocation: selectedLocation ?? this.selectedLocation,
    selectedDeadline: selectedDeadline ?? this.selectedDeadline,
    priceRangeStart: newStart,
    priceRangeEnd: newEnd,
    tasks: tasks ?? this.tasks,
    filteredTasks: filteredTasks ?? this.filteredTasks,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    minBudget: newMin,
    maxBudget: newMax,
    popularLocations: popularLocations ?? this.popularLocations,
  );
}
}

enum RequestStatus {
  initial,
  loading,
  loaded,
  error,
}