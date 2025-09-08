// hire_requests_state.dart
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

abstract class HireRequestsState extends Equatable {
  const HireRequestsState();

  @override
  List<Object?> get props => [];
}

class HireRequestsInitial extends HireRequestsState {}

class HireRequestsLoading extends HireRequestsState {}

class HireRequestsLoaded extends HireRequestsState {
  final List<HireRequest> allRequests;
  final List<HireRequest> filteredRequests;
  final HireRequestStatus? selectedFilter;
  final bool isProcessing;

  const HireRequestsLoaded({
    required this.allRequests,
    required this.filteredRequests,
    this.selectedFilter,
    this.isProcessing = false,
  });

  HireRequestsLoaded copyWith({
    List<HireRequest>? allRequests,
    List<HireRequest>? filteredRequests,
    HireRequestStatus? selectedFilter,
    bool? isProcessing,
    bool clearFilter = false,
  }) {
    return HireRequestsLoaded(
      allRequests: allRequests ?? this.allRequests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      selectedFilter: clearFilter ? null : selectedFilter ?? this.selectedFilter,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  List<Object?> get props => [allRequests, filteredRequests, selectedFilter, isProcessing];
}

class HireRequestsError extends HireRequestsState {
  final String message;

  const HireRequestsError(this.message);

  @override
  List<Object?> get props => [message];
}

class HireRequestsEmpty extends HireRequestsState {
  final HireRequestStatus? selectedFilter;

  const HireRequestsEmpty({this.selectedFilter});

  @override
  List<Object?> get props => [selectedFilter];
}

class RequestProcessingSuccess extends HireRequestsState {
  final String message;
  final List<HireRequest> allRequests;
  final List<HireRequest> filteredRequests;
  final HireRequestStatus? selectedFilter;

  const RequestProcessingSuccess({
    required this.message,
    required this.allRequests,
    required this.filteredRequests,
    this.selectedFilter,
  });

  @override
  List<Object?> get props => [message, allRequests, filteredRequests, selectedFilter];
}

class RequestProcessingError extends HireRequestsState {
  final String message;
  final List<HireRequest> allRequests;
  final List<HireRequest> filteredRequests;
  final HireRequestStatus? selectedFilter;

  const RequestProcessingError({
    required this.message,
    required this.allRequests,
    required this.filteredRequests,
    this.selectedFilter,
  });

  @override
  List<Object?> get props => [message, allRequests, filteredRequests, selectedFilter];
}