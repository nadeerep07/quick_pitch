// hire_requests_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/repository/hire_request_repository.dart';
import 'package:quick_pitch_app/features/requests_pitches/fixer/viewmodel/bloc/hire_requests_event.dart';
import 'package:quick_pitch_app/features/requests_pitches/fixer/viewmodel/bloc/hire_requests_state.dart'
    show
        HireRequestsState,
        HireRequestsInitial,
        HireRequestsLoaded,
        HireRequestsError,
        HireRequestsEmpty,
        RequestProcessingError,
        RequestProcessingSuccess,
        HireRequestsLoading;

class HireRequestsBloc extends Bloc<HireRequestsEvent, HireRequestsState> {
  final HireRequestRepository _hireRequestRepository;
  StreamSubscription<List<HireRequest>>? _requestsSubscription;
  List<HireRequest> _allRequests = [];
  HireRequestStatus? _currentFilter;

  HireRequestsBloc({required HireRequestRepository hireRequestRepository})
    : _hireRequestRepository = hireRequestRepository,
      super(HireRequestsInitial()) {
    on<LoadHireRequests>(_onLoadHireRequests);
    on<FilterRequests>(_onFilterRequests);
    on<AcceptRequest>(_onAcceptRequest);
    on<DeclineRequest>(_onDeclineRequest);
    on<RefreshRequests>(_onRefreshRequests);
  }

Future<void> _onLoadHireRequests(
  LoadHireRequests event,
  Emitter<HireRequestsState> emit,
) async {
  emit(HireRequestsLoading());

  await emit.forEach<List<HireRequest>>(
    _hireRequestRepository.getFixerHireRequests(event.fixerUserId),
    onData: (requests) {
      _allRequests = requests;
      final filteredRequests = _getFilteredRequests(requests, _currentFilter);

      if (requests.isEmpty) {
        return HireRequestsEmpty(selectedFilter: _currentFilter);
      }

      return HireRequestsLoaded(
        allRequests: requests,
        filteredRequests: filteredRequests,
        selectedFilter: _currentFilter,
      );
    },
    onError: (error, stackTrace) {
      return HireRequestsError(error.toString());
    },
  );
}

  void _onFilterRequests(
    FilterRequests event,
    Emitter<HireRequestsState> emit,
  ) {
    _currentFilter = event.status;
    final filteredRequests = _getFilteredRequests(_allRequests, event.status);

    if (filteredRequests.isEmpty) {
      emit(HireRequestsEmpty(selectedFilter: event.status));
    } else {
      emit(
        HireRequestsLoaded(
          allRequests: _allRequests,
          filteredRequests: filteredRequests,
          selectedFilter: event.status,
        ),
      );
    }
  }

  Future<void> _onAcceptRequest(
    AcceptRequest event,
    Emitter<HireRequestsState> emit,
  ) async {
    final currentState = state;
    if (currentState is HireRequestsLoaded) {
      // Show processing state
      emit(currentState.copyWith(isProcessing: true));

      try {
        await _hireRequestRepository.acceptRequest(event.requestId);

        // Show success message with updated data
        final filteredRequests = _getFilteredRequests(
          _allRequests,
          _currentFilter,
        );
        emit(
          RequestProcessingSuccess(
            message: 'Request accepted successfully!',
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
          ),
        );

        // Return to loaded state
        emit(
          HireRequestsLoaded(
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
            isProcessing: false,
          ),
        );
      } catch (error) {
        // Show error message with current data
        final filteredRequests = _getFilteredRequests(
          _allRequests,
          _currentFilter,
        );
        emit(
          RequestProcessingError(
            message: 'Failed to accept request: ${error.toString()}',
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
          ),
        );

        // Return to loaded state
        emit(
          HireRequestsLoaded(
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
            isProcessing: false,
          ),
        );
      }
    }
  }

  Future<void> _onDeclineRequest(
    DeclineRequest event,
    Emitter<HireRequestsState> emit,
  ) async {
    final currentState = state;
    if (currentState is HireRequestsLoaded) {
      // Show processing state
      emit(currentState.copyWith(isProcessing: true));

      try {
        await _hireRequestRepository.declineRequest(
          event.requestId,
          message: event.message,
        );

        // Show success message with updated data
        final filteredRequests = _getFilteredRequests(
          _allRequests,
          _currentFilter,
        );
        emit(
          RequestProcessingSuccess(
            message: 'Request declined',
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
          ),
        );

        // Return to loaded state
        emit(
          HireRequestsLoaded(
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
            isProcessing: false,
          ),
        );
      } catch (error) {
        // Show error message with current data
        final filteredRequests = _getFilteredRequests(
          _allRequests,
          _currentFilter,
        );
        emit(
          RequestProcessingError(
            message: 'Failed to decline request: ${error.toString()}',
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
          ),
        );

        // Return to loaded state
        emit(
          HireRequestsLoaded(
            allRequests: _allRequests,
            filteredRequests: filteredRequests,
            selectedFilter: _currentFilter,
            isProcessing: false,
          ),
        );
      }
    }
  }

  void _onRefreshRequests(
    RefreshRequests event,
    Emitter<HireRequestsState> emit,
  ) {
    add(LoadHireRequests(event.fixerUserId));
  }

  List<HireRequest> _getFilteredRequests(
    List<HireRequest> requests,
    HireRequestStatus? filter,
  ) {
    if (filter == null) return requests;
    return requests.where((request) => request.status == filter).toList();
  }

  @override
  Future<void> close() {
    _requestsSubscription?.cancel();
    return super.close();
  }
}
