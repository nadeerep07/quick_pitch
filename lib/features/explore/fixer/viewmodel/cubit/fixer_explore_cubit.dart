
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/explore/fixer/repository/fixer_explore_repository.dart';
import 'package:quick_pitch_app/features/explore/fixer/service/fixer_explore_service.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

part 'fixer_explore_state.dart';

class FixerExploreCubit extends Cubit<FixerExploreState> {
  final FixerExploreRepository _repository;
  final FixerExploreService _service;

  FixerExploreCubit(this._repository, this._service) : super(const FixerExploreState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    if (isClosed) return;
    emit(state.copyWith(status: RequestStatus.loading));

    try {
      final tasks = await _repository.fetchCategoryMatchedTasks();

      final budgetRange = _service.calculateBudgetRange(tasks);
      final topLocations = _service.getTopLocations(tasks);

      final newState = state.copyWith(
        status: RequestStatus.loaded,
        tasks: tasks,
        minBudget: budgetRange["min"]!,
        maxBudget: budgetRange["max"]!,
        priceRangeStart: budgetRange["min"]!,
        priceRangeEnd: budgetRange["max"]!,
        popularLocations: topLocations,
      );

      if (isClosed) return;
      emit(newState.copyWith(filteredTasks: _service.applyFilters(tasks, newState)));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: RequestStatus.error, errorMessage: e.toString()));
    }
  }

  void resetFilters() {
    emit(state.copyWith(
      searchQuery: '',
      selectedFilter: 'All',
      selectedSkills: {},
      selectedLocation: '',
      selectedDeadline: 'Anytime',
      priceRangeStart: state.minBudget,
      priceRangeEnd: state.maxBudget,
      showSearchHistory: false,
      showMoreFilters: false,
    ));
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
    if (isClosed) return;

    double minBudget = state.minBudget;
    double maxBudget = state.maxBudget;

    if (minBudget == maxBudget) maxBudget = minBudget + 1;

    start = start.clamp(minBudget, maxBudget);
    end = end.clamp(minBudget, maxBudget);

    if (start > end) {
      final temp = start;
      start = end;
      end = temp;
    }

    emit(state.copyWith(
      minBudget: minBudget,
      maxBudget: maxBudget,
      priceRangeStart: start,
      priceRangeEnd: end,
    ));

    _applyFiltersToState();
  }

  void toggleSkill(String skill) {
    if (isClosed) return;
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

  void _applyFiltersToState() {
    if (isClosed) return;
    final filteredTasks = _service.applyFilters(state.tasks, state);
    emit(state.copyWith(filteredTasks: filteredTasks));
  }
}
