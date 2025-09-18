import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:equatable/equatable.dart';

// --- Cubit States ---
abstract class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  final bool hasMoreReviews;

  const ReviewLoaded({
    required this.reviews,
    this.hasMoreReviews = false,
  });

  @override
  List<Object> get props => [reviews, hasMoreReviews];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);
  @override
  List<Object> get props => [message];
}

class ReviewLoadingMore extends ReviewLoaded {
  const ReviewLoadingMore({
    required super.reviews,
    required super.hasMoreReviews,
  });
}

// --- Cubit ---
class ReviewCubit extends Cubit<ReviewState> {
  final ReviewService reviewService;
  final String fixerUid;
  
  ReviewCubit({
    required this.reviewService,
    required this.fixerUid,
  }) : super(ReviewInitial());

  Future<void> fetchReviews({int limit = 10}) async {
    try {
      emit(ReviewLoading());
      final reviews = await reviewService.fetchUserReviews(fixerUid, limit: limit);
      final hasMoreReviews = reviews.length >= limit;
      emit(ReviewLoaded(reviews: reviews, hasMoreReviews: hasMoreReviews));
    } catch (e) {
      emit(const ReviewError('Failed to load reviews.'));
    }
  }

  Future<void> loadMoreReviews() async {
    final currentState = state;
    if (currentState is ReviewLoaded && currentState.hasMoreReviews) {
      try {
        emit(ReviewLoadingMore(reviews: currentState.reviews, hasMoreReviews: true));
        final moreReviews = await reviewService.fetchUserReviews(
          fixerUid,
          limit: 10,
        //  startAfter: currentState.reviews.last,
        );
        final allReviews = List<ReviewModel>.from(currentState.reviews)..addAll(moreReviews);
        final hasMore = moreReviews.length >= 10;
        emit(ReviewLoaded(reviews: allReviews, hasMoreReviews: hasMore));
      } catch (e) {
        // Fallback to the previous state on error
        emit(ReviewLoaded(reviews: currentState.reviews, hasMoreReviews: currentState.hasMoreReviews));
      }
    }
  }
}