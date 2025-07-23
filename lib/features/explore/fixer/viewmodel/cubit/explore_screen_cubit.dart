import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/components/more_filter_sheet_content.dart';
import 'package:quick_pitch_app/features/main/fixer/repository/fixer_repository.dart';

part 'explore_screen_state.dart';

class ExploreScreenCubit extends Cubit<ExploreScreenState> {
  final FixerRepository fixerRepository;

  ExploreScreenCubit({required this.fixerRepository})
      : super(ExploreScreenState()) {
    _initDebouncer();
    fetchCategoryMatchedTasks(); // auto-fetch on init
  }

  final _searchController = BehaviorSubject<String>();
  List<String> fixerSkills = [];

  void _initDebouncer() {
    _searchController
        .debounceTime(const Duration(milliseconds: 300))
        .listen(_filterBySearch);
  }

  Future<void> fetchCategoryMatchedTasks() async {
    emit(state.copyWith(isLoading: true));
    try {
      final tasks = await fixerRepository.fetchCategoryMatchedTasks();
      fixerSkills = tasks.expand((t) => t.skills).toSet().toList(); 

      double maxBudget = 0;
      for (final task in tasks) {
        final budget = double.tryParse(task.budget.toString()) ?? 0;
        if (budget > maxBudget) maxBudget = budget;
      }

      emit(state.copyWith(
        allTasks: tasks,
        filteredTasks: tasks,
        currentBudget: maxBudget,
        maxBudget: maxBudget,
        isLoading: false,
      ));

      _applyFilters();

    } catch (e) {
     // debugPrint(" Error fetching category matched tasks: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _searchController.add(query);
  }

  void updateFilter({
    String? selectedFilter,
    double? currentBudget,
    DateTime? deadline,
    String? preferredTime,
  }) {
    emit(state.copyWith(
      selectedFilter: selectedFilter ?? state.selectedFilter,
      currentBudget: currentBudget ?? state.currentBudget,
      selectedDeadline: deadline ?? state.selectedDeadline,
      preferredTime: preferredTime ?? state.preferredTime,
    ));

    _applyFilters();
  }

  void resetFilters() {
    emit(state.copyWith(
      selectedFilter: 'All',
      currentBudget: state.maxBudget,
      selectedDeadline: null,
      preferredTime: null,
      searchQuery: '',
      filteredTasks: state.allTasks,
    ));

   // debugPrint(" Resetting filters...");
  }

  void _applyFilters() {
    final all = state.allTasks;
    // debugPrint(' Applying filters...');
    // debugPrint(' Search Query: "${state.searchQuery}"');
    // debugPrint(' Total Tasks: ${all.length}');

    final filtered = all.where((task) {
      final matchesFilter = state.selectedFilter == 'All' ||
          task.workType.toLowerCase() ==
              state.selectedFilter.toLowerCase() ||
          task.skills.any((s) =>
              s.toLowerCase().contains(state.selectedFilter.toLowerCase()));

      final matchesBudget =
          (double.tryParse(task.budget.toString()) ?? 0) <= state.currentBudget;

      final matchesDeadline = state.selectedDeadline == null ||
          task.deadline.isBefore(
              state.selectedDeadline!.add(const Duration(days: 1)));

      final matchesPreferredTime = state.preferredTime == null ||
          task.preferredTime.toLowerCase() ==
              state.preferredTime!.toLowerCase();

      return matchesFilter &&
          matchesBudget &&
          matchesDeadline &&
          matchesPreferredTime;
    }).toList();

   // debugPrint(' Tasks after filter match: ${filtered.length}');

  final searchResults = _filterBySearchInternal(
  filtered,
  state.searchQuery.trim().toLowerCase(),
);


   // debugPrint('Tasks after search filtering: ${searchResults.length}');

    emit(state.copyWith(filteredTasks: searchResults, isLoading: false));
  }

void _filterBySearch(String query) {
  final lowercaseQuery = query.toLowerCase().trim();

  // Always reapply all filters first, then apply search
  final filtered = _filterBySearchInternal(
    _getTasksMatchingFilters(), 
    lowercaseQuery,
  );

  emit(state.copyWith(filteredTasks: filtered));
}
List<TaskPostModel> _getTasksMatchingFilters() {
  final all = state.allTasks;

  return all.where((task) {
    final matchesFilter = state.selectedFilter == 'All' ||
        task.workType.toLowerCase() == state.selectedFilter.toLowerCase() ||
        task.skills.any((s) =>
            s.toLowerCase().contains(state.selectedFilter.toLowerCase()));

    final matchesBudget =
        (double.tryParse(task.budget.toString()) ?? 0) <= state.currentBudget;

    final matchesDeadline = state.selectedDeadline == null ||
        task.deadline.isBefore(
            state.selectedDeadline!.add(const Duration(days: 1)));

    final matchesPreferredTime = state.preferredTime == null ||
        task.preferredTime.toLowerCase() ==
            state.preferredTime!.toLowerCase();

    return matchesFilter &&
        matchesBudget &&
        matchesDeadline &&
        matchesPreferredTime;
  }).toList();
}


List<TaskPostModel> _filterBySearchInternal(List<TaskPostModel> tasks, String query) {
  if (query.isEmpty) return tasks;
return tasks.where((task) {
  return task.title.toLowerCase().contains(query) ||
      task.description.toLowerCase().contains(query) ||
      task.skills.any((s) => s.toLowerCase().contains(query)) ||
      task.location.toLowerCase().contains(query);
}).toList();

}



  void openFilterBottomSheet(BuildContext context) {
    final moreFilters = [
      'Plumbing',
      'Electrical',
      'Carpentry',
      'Painting',
      'Installation',
      'Repair',
      'Cleaning',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<ExploreScreenCubit, ExploreScreenState>(
          builder: (context, state) {
            return MoreFilterSheetContent(
              filters: moreFilters,
              state: state,
              onApply: ({
                required String selectedFilter,
                required double currentBudget,
                required String? preferredTime,
                required DateTime? selectedDeadline,
              }) {
                updateFilter(
                  selectedFilter: selectedFilter,
                  currentBudget: currentBudget,
                  preferredTime: preferredTime,
                  deadline: selectedDeadline,
                );
                Navigator.pop(context);
              },
              onClear: () {
                resetFilters();
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    _searchController.close();
    return super.close();
  }
}
