// hire_requests_event.dart
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

abstract class HireRequestsEvent extends Equatable {
  const HireRequestsEvent();

  @override
  List<Object?> get props => [];
}

class LoadHireRequests extends HireRequestsEvent {
  final String fixerUserId;

  const LoadHireRequests(this.fixerUserId);

  @override
  List<Object?> get props => [fixerUserId];
}

class FilterRequests extends HireRequestsEvent {
  final HireRequestStatus? status;

  const FilterRequests(this.status);

  @override
  List<Object?> get props => [status];
}

class AcceptRequest extends HireRequestsEvent {
  final String requestId;

  const AcceptRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class DeclineRequest extends HireRequestsEvent {
  final String requestId;
  final String? message;

  const DeclineRequest(this.requestId, {this.message});

  @override
  List<Object?> get props => [requestId, message];
}

class RefreshRequests extends HireRequestsEvent {
  final String fixerUserId;

  const RefreshRequests(this.fixerUserId);

  @override
  List<Object?> get props => [fixerUserId];
}
// Add this to your existing hire_requests_event.dart file

class CompleteRequest extends HireRequestsEvent {
  final String requestId;

  const CompleteRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}