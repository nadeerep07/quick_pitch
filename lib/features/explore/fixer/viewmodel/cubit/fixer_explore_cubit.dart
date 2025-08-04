
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/fixer/repository/fixer_explore_repository.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

part 'fixer_explore_state.dart';

class FixerExploreCubit extends Cubit<FixerExploreState> {
  final FixerExploreRepository _repository;

  FixerExploreCubit(this._repository) : super(const FixerExploreState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(status: RequestStatus.loading));
    try {
      final tasks = await _repository.fetchCategoryMatchedTasks();
      final budgets = tasks.map((t) => t.budget).toList();
      final minBudget = budgets.reduce((a, b) => a < b ? a : b);
      final maxBudget = budgets.reduce((a, b) => a > b ? a : b);
      final locationCounts = <String, int>{};
      for (var task in tasks) {
        if (task.location.isNotEmpty) {
          locationCounts[task.location] =
              (locationCounts[task.location] ?? 0) + 1;
        }
      }
      final popularLocations =
          locationCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      final topLocations =
          popularLocations
              .map((e) => e.key)
              .take(4) // only top 4
              .toList();

      final newState = state.copyWith(
        status: RequestStatus.loaded,
        tasks: tasks,
        minBudget: minBudget,
        maxBudget: maxBudget,
        priceRangeStart: minBudget,
        priceRangeEnd: maxBudget,
        popularLocations: topLocations,
      );

      emit(newState.copyWith(filteredTasks: applyFilters(tasks, newState)));
    } catch (e) {
      emit(
        state.copyWith(status: RequestStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void resetFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        selectedFilter: 'All',
        selectedSkills: {},
        selectedLocation: '',
        selectedDeadline: 'Anytime',
        priceRangeStart: state.minBudget,
        priceRangeEnd: state.maxBudget,
        showSearchHistory: false,
        showMoreFilters: false,
      ),
    );
    _applyFiltersToState();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query, showSearchHistory: query.isEmpty));
    _applyFiltersToState();
  }

  void toggleSearchHistory(bool show) {
    emit(state.copyWith(showSearchHistory: show));
  }

  void updateSelectedFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
    _applyFiltersToState();
  }

  void toggleMoreFilters(bool show) {
    emit(state.copyWith(showMoreFilters: show));
  }

  void updatePriceRange(double start, double end) {
    emit(state.copyWith(priceRangeStart: start, priceRangeEnd: end));
    _applyFiltersToState();
  }

  void toggleSkill(String skill) {
    final newSkills = Set<String>.from(state.selectedSkills);
    if (newSkills.contains(skill)) {
      newSkills.remove(skill);
    } else {
      newSkills.add(skill);
    }
    emit(state.copyWith(selectedSkills: newSkills));
    _applyFiltersToState();
  }

  void updateLocation(String? location) {
    emit(state.copyWith(selectedLocation: location));
    _applyFiltersToState();
  }

  void updateDeadline(String deadline) {
    emit(state.copyWith(selectedDeadline: deadline));
    _applyFiltersToState();
  }

  // void clearFilters() {
  //   emit(
  //     state.copyWith(
  //       selectedFilter: 'All',
  //       selectedSkills: const {},
  //       selectedLocation: 'Within 10km',
  //       selectedDeadline: 'Anytime',
  //       priceRangeStart: 50,
  //       priceRangeEnd: 300,
  //     ),
  //   );
  //   _applyFiltersToState();
  // }

  void _applyFiltersToState() {
    // Start with full task list
    final tasks = state.tasks;
    final filteredTasks = applyFilters(tasks, state);

    double minBudget = state.minBudget;
    double maxBudget = state.maxBudget;

    // If skills are selected, compute dynamic min/max from matching tasks
    if (state.selectedSkills.isNotEmpty) {
      final matchingSkillTasks = tasks.where(
        (task) =>
            task.skills.any((skill) => state.selectedSkills.contains(skill)),
      );

      if (matchingSkillTasks.isNotEmpty) {
        minBudget = matchingSkillTasks
            .map((t) => t.budget)
            .reduce((a, b) => a < b ? a : b);
        maxBudget = matchingSkillTasks
            .map((t) => t.budget)
            .reduce((a, b) => a > b ? a : b);
      }
    }

    emit(
      state.copyWith(
        filteredTasks: filteredTasks,
        minBudget: minBudget,
        maxBudget: maxBudget,
        // Optionally clamp slider values if they go out of new dynamic bounds
        priceRangeStart:
            state.priceRangeStart < minBudget
                ? minBudget
                : state.priceRangeStart,
        priceRangeEnd:
            state.priceRangeEnd > maxBudget ? maxBudget : state.priceRangeEnd,
      ),
    );
  }

  List<TaskPostModel> applyFilters(
    List<TaskPostModel> tasks,
    FixerExploreState state,
  ) {
   // debugPrint('Applying filters to ${tasks.length} tasks');

    // Defensive copy
    List<TaskPostModel> filtered = List.from(tasks);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (task) =>
                    task.title.toLowerCase().contains(
                      state.searchQuery.toLowerCase(),
                    ) ||
                    (task.description.toLowerCase().contains(
                          state.searchQuery.toLowerCase(),
                        )),
              )
              .toList();
    //  debugPrint('After search filter: ${filtered.length} tasks');
    }
    // Apply remote/on-site filter
    if (state.selectedFilter == 'Remote') {
      filtered =
          filtered
              .where((task) => task.workType.toLowerCase() == 'remote')
              .toList();
    } else if (state.selectedFilter == 'On-site') {
      filtered =
          filtered
              .where((task) => task.workType.toLowerCase() == 'on-site')
              .toList();
    }

    // 🔹 Adjust dynamic price range based on selected skills
    if (state.selectedSkills.isNotEmpty) {
      // Find all tasks matching selected skills
      final matchingSkillTasks = tasks.where(
        (task) =>
            task.skills.any((skill) => state.selectedSkills.contains(skill)),
      );

      if (matchingSkillTasks.isNotEmpty) {
        final minBudget = matchingSkillTasks
            .map((t) => t.budget)
            .reduce((a, b) => a < b ? a : b);
        final maxBudget = matchingSkillTasks
            .map((t) => t.budget)
            .reduce((a, b) => a > b ? a : b);

        debugPrint(
          'Dynamic price range for ${state.selectedSkills.join(", ")}: $minBudget - $maxBudget',
        );

        // Clamp the user-selected range to this dynamic range
        filtered =
            filtered.where((task) {
              final passes =
                  task.budget >= state.priceRangeStart &&
                  task.budget <= state.priceRangeEnd;
              // if (!passes) {
              //   debugPrint(
              //     'Filtered out ${task.title} due to price (${task.budget})',
              //   );
              // }
              return passes;
            }).toList();
      }
    } else {
      // Fallback to normal price range if no skill selected
      filtered =
          filtered.where((task) {
            final passes =
                task.budget >= state.priceRangeStart &&
                task.budget <= state.priceRangeEnd;
            // if (!passes) {
            //   debugPrint(
            //     'Filtered out ${task.title} due to price (${task.budget})',
            //   );
            // }
            return passes;
          }).toList();
    }
    // Apply location filter
    if (state.selectedLocation != null && state.selectedLocation!.isNotEmpty) {
      filtered =
          filtered.where((task) {
            final taskLocation = task.location.toLowerCase() ;
            final selectedLocation = state.selectedLocation!.toLowerCase();

            final matches = taskLocation.contains(selectedLocation);

            // if (!matches) {
            //   debugPrint(
            //     'Filtered out ${task.title} due to location mismatch: '
            //     '${task.location ?? "Unknown"} vs ${state.selectedLocation}',
            //   );
            // }

            return matches;
          }).toList();
    }

    // Apply skills filter
    if (state.selectedSkills.isNotEmpty) {
      filtered =
          filtered.where((task) {
            final hasMatchingSkill = task.skills.any(
              (skill) => state.selectedSkills.contains(skill),
            );
            // if (!hasMatchingSkill) {
            //   debugPrint('Filtered out ${task.title} due to skills mismatch');
            // }
            return hasMatchingSkill;
          }).toList();
    }
    if (state.selectedDeadline != 'Anytime') {
      final now = DateTime.now();
      filtered =
          filtered.where((task) {
            final daysLeft = task.deadline.difference(now).inDays;

            switch (state.selectedDeadline) {
              case 'Within 1 week':
                return daysLeft <= 7 && daysLeft >= 0;
              case 'Within 2 weeks':
                return daysLeft <= 14 && daysLeft >= 0;
              case 'Urgent':
                return daysLeft <= 3 && daysLeft >= 0;
              default:
                return true;
            }
          }).toList();
    }

 //   debugPrint('Final filtered count: ${filtered.length} tasks');
    return filtered;
  }
}
