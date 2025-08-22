import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/fixer_explore_cubit.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class FixerExploreService {
  /// Get min and max budget from tasks
  Map<String, double> calculateBudgetRange(List<TaskPostModel> tasks) {
    if (tasks.isEmpty) return {"min": 0, "max": 0};

    final budgets = tasks.map((t) => t.budget).toList();
    final minBudget = budgets.reduce((a, b) => a < b ? a : b);
    final maxBudget = budgets.reduce((a, b) => a > b ? a : b);

    return {"min": minBudget, "max": maxBudget};
  }

  /// Get top locations by frequency
  List<String> getTopLocations(List<TaskPostModel> tasks, {int limit = 4}) {
    final locationCounts = <String, int>{};

    for (var task in tasks) {
      if (task.location?.isNotEmpty ?? false) {
        locationCounts[task.location!] =
            (locationCounts[task.location] ?? 0) + 1;
      }
    }

    final popularLocations = locationCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return popularLocations.map((e) => e.key).take(limit).toList();
  }

  /// Apply all filters to tasks
  List<TaskPostModel> applyFilters(
    List<TaskPostModel> tasks,
    FixerExploreState state,
  ) {
    List<TaskPostModel> filtered = List.from(tasks);

    // 🔹 Search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where(
        (task) =>
            task.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(state.searchQuery.toLowerCase()),
      ).toList();
    }

    // 🔹 Remote/On-site
    if (state.selectedFilter == 'Remote') {
      filtered = filtered.where((task) => task.workType.toLowerCase() == 'remote').toList();
    } else if (state.selectedFilter == 'On-site') {
      filtered = filtered.where((task) => task.workType.toLowerCase() == 'on-site').toList();
    }

    // 🔹 Price range
    filtered = filtered.where(
      (task) =>
          task.budget >= state.priceRangeStart &&
          task.budget <= state.priceRangeEnd,
    ).toList();

    // 🔹 Location
    if (state.selectedLocation?.isNotEmpty ?? false) {
      filtered = filtered.where((task) {
        final taskLocation = task.location?.toLowerCase();
        final selectedLocation = state.selectedLocation!.toLowerCase();
        return taskLocation?.contains(selectedLocation) ?? false;
      }).toList();
    }

    // 🔹 Skills
    if (state.selectedSkills.isNotEmpty) {
      filtered = filtered.where(
        (task) => task.skills.any((skill) => state.selectedSkills.contains(skill)),
      ).toList();
    }

    // 🔹 Deadline
    if (state.selectedDeadline != 'Anytime') {
      final now = DateTime.now();
      filtered = filtered.where((task) {
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

    return filtered;
  }
}
