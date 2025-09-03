import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';

class PosterReviewState {
  final bool isLoading;
  final bool canReview;
  final ReviewModel? existingReview;

  PosterReviewState({
    this.isLoading = true,
    this.canReview = false,
    this.existingReview,
  });

  PosterReviewState copyWith({
    bool? isLoading,
    bool? canReview,
    ReviewModel? existingReview,
  }) {
    return PosterReviewState(
      isLoading: isLoading ?? this.isLoading,
      canReview: canReview ?? this.canReview,
      existingReview: existingReview ?? this.existingReview,
    );
  }
}

class PosterReviewCubit extends Cubit<PosterReviewState> {
  final ReviewService _reviewService;

  PosterReviewCubit(this._reviewService) : super(PosterReviewState());

  Future<void> checkReviewStatus(String currentUserId, String pitchId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final canReview = await _reviewService.canUserReview(currentUserId, pitchId);
      final existingReview = await _reviewService.getReviewBetweenUsers(currentUserId, pitchId);
      emit(state.copyWith(isLoading: false, canReview: canReview, existingReview: existingReview));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void updateReview(ReviewModel review) {
    emit(state.copyWith(existingReview: review));
  }
}