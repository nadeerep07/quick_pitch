import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';

class ReviewRatingState {
  final double rating;
  final String comment;
  final bool isSubmitting;

  ReviewRatingState({
    this.rating = 0.0,
    this.comment = '',
    this.isSubmitting = false,
  });

  ReviewRatingState copyWith({
    double? rating,
    String? comment,
    bool? isSubmitting,
  }) {
    return ReviewRatingState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ReviewRatingCubit extends Cubit<ReviewRatingState> {
  final ReviewService _reviewService;
  final ReviewModel? existingReview;

  ReviewRatingCubit(this._reviewService, {this.existingReview})
      : super(ReviewRatingState(
          rating: existingReview?.rating ?? 0.0,
          comment: existingReview?.comment ?? '',
        ));

  void updateRating(double rating) => emit(state.copyWith(rating: rating));

  void updateComment(String comment) => emit(state.copyWith(comment: comment));

  Future<void> submitReview({
    required String revieweeId,
    required String pitchId,
    required String taskId,
    required String reviewerType,
    VoidCallback? onSuccess,
    BuildContext? context,
  }) async {
    if (state.rating == 0) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (state.comment.trim().isEmpty) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('Please write a comment')),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final review = ReviewModel(
        id: existingReview?.id ?? '',
        reviewerId: currentUser.uid,
        revieweeId: revieweeId,
        pitchId: pitchId,
        taskId: taskId,
        rating: state.rating,
        comment: state.comment.trim(),
        reviewerType: reviewerType,
        createdAt: existingReview?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (existingReview != null) {
        await _reviewService.updateReview(review);
      } else {
        await _reviewService.submitReview(review);
      }

      onSuccess?.call();

      if (context != null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(existingReview != null
                ? 'Review updated successfully!'
                : 'Review submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
