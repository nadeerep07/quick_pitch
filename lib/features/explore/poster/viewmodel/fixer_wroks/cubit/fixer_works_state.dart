import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

abstract class FixerWorksState {}

class FixerWorksInitial extends FixerWorksState {}

class FixerWorksLoading extends FixerWorksState {}

class FixerWorksLoadingMore extends FixerWorksState {
  final List<FixerWork> existingWorks;
  
  FixerWorksLoadingMore(this.existingWorks);
}

class FixerWorksLoaded extends FixerWorksState {
  final List<FixerWork> works;
  final DocumentSnapshot? lastDocument;
  final bool hasMoreData;
  final int totalCount;

  FixerWorksLoaded({
    required this.works,
    this.lastDocument,
    required this.hasMoreData,
    required this.totalCount,
  });

  FixerWorksLoaded copyWith({
    List<FixerWork>? works,
    DocumentSnapshot? lastDocument,
    bool? hasMoreData,
    int? totalCount,
  }) {
    return FixerWorksLoaded(
      works: works ?? this.works,
      lastDocument: lastDocument ?? this.lastDocument,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class FixerWorksError extends FixerWorksState {
  final String message;
  
  FixerWorksError(this.message);
}

class FixerWorksRefreshing extends FixerWorksState {
  final List<FixerWork> existingWorks;
  
  FixerWorksRefreshing(this.existingWorks);
}
