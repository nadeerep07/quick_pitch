import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit a review
  Future<void> submitReview(ReviewModel review) async {
    try {
      // Add review to reviews collection
      final reviewRef = _firestore.collection('reviews').doc();
      final reviewWithId = review.copyWith(id: reviewRef.id);
      
      print('Submitting review: ${reviewWithId.toJson()}'); // Debug log
      
      // First save the review
      await reviewRef.set(reviewWithId.toJson());
      
      print('Review saved, updating stats...'); // Debug log
      
      // Then update reviewee's rating stats
      await _updateUserRatingStats(
        review.revieweeId, 
        review.reviewerType == 'poster' ? 'fixer' : 'poster'
      );
      
      print('Stats updated successfully'); // Debug log
      
    } catch (e) {
      print('Error in submitReview: $e'); // Debug log
      rethrow;
    }
  }

  // Get reviews for a user
  Stream<List<ReviewModel>> getUserReviews(String userId, {int limit = 10}) {
    return _firestore
        .collection('reviews')
        .where('revieweeId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromJson(doc.data()))
            .toList());
  }

  // Check if user can review (hasn't reviewed this pitch before)
  Future<bool> canUserReview(String reviewerId, String pitchId) async {
    try {
      final existing = await _firestore
          .collection('reviews')
          .where('reviewerId', isEqualTo: reviewerId)
          .where('pitchId', isEqualTo: pitchId)
          .get();
      
      print('Checking if user can review: reviewerId=$reviewerId, pitchId=$pitchId, existing=${existing.docs.length}');
      return existing.docs.isEmpty;
    } catch (e) {
      print('Error checking if user can review: $e');
      return false;
    }
  }

  // Get user's rating statistics
  Future<RatingStats> getUserRatingStats(String userId) async {
    try {
      final reviews = await _firestore
          .collection('reviews')
          .where('revieweeId', isEqualTo: userId)
          .get();

      print('Getting rating stats for user $userId: ${reviews.docs.length} reviews found');

      if (reviews.docs.isEmpty) {
        return RatingStats.empty();
      }

      double totalRating = 0;
      Map<int, int> distribution = {};
      
      for (var doc in reviews.docs) {
        final review = ReviewModel.fromJson(doc.data());
        totalRating += review.rating;
        
        final starRating = review.rating.round();
        distribution[starRating] = (distribution[starRating] ?? 0) + 1;
      }

      final stats = RatingStats(
        averageRating: totalRating / reviews.docs.length,
        totalReviews: reviews.docs.length,
        ratingDistribution: distribution,
      );
      
      print('Calculated stats: ${stats.toJson()}');
      return stats;
    } catch (e) {
      print('Error getting rating stats: $e');
      return RatingStats.empty();
    }
  }

  // FULLY FIXED: Update user's rating stats in their profile
  Future<void> _updateUserRatingStats(String userId, String userType) async {
    try {
      final stats = await getUserRatingStats(userId);
      
      print('Updating stats for user $userId (type: $userType): ${stats.toJson()}');
      
      // FIXED: Use the correct path - users/{userId}/roles/{userType}
      final userRef = _firestore.collection('users').doc(userId).collection('roles').doc(userType);
      
      // CRITICAL FIX: Ensure all nested data is properly typed for Firestore
      final Map<String, dynamic> statsData = <String, dynamic>{
        'averageRating': stats.averageRating,
        'totalReviews': stats.totalReviews,
        'ratingDistribution': <String, dynamic>{},
      };
      
      // Convert ratingDistribution with explicit typing
      final Map<String, dynamic> distributionMap = <String, dynamic>{};
      stats.ratingDistribution.forEach((key, value) {
        distributionMap[key.toString()] = value;
      });
      statsData['ratingDistribution'] = distributionMap;
      
      // Update the appropriate user type data using the correct subcollection path
      final Map<String, dynamic> updateData = <String, dynamic>{};
      if (userType == 'fixer') {
        updateData['fixerData.ratingStats'] = statsData;
      } else {
        updateData['posterData.ratingStats'] = statsData;
      }
      
      await userRef.update(updateData);
      
      print('Successfully updated user stats');
    } catch (e) {
      print('Error updating user rating stats: $e');
      // Don't rethrow here - we don't want to fail the review submission if stats update fails
    }
  }

  // Get review between two users for a specific pitch
  Future<ReviewModel?> getReviewBetweenUsers(String reviewerId, String pitchId) async {
    try {
      final review = await _firestore
          .collection('reviews')
          .where('reviewerId', isEqualTo: reviewerId)
          .where('pitchId', isEqualTo: pitchId)
          .get();

      if (review.docs.isNotEmpty) {
        return ReviewModel.fromJson(review.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting review between users: $e');
      return null;
    }
  }

  // Delete a review
  Future<void> deleteReview(String reviewId, String revieweeId, String userType) async {
    try {
      // Delete review
      await _firestore.collection('reviews').doc(reviewId).delete();
      
      // Update rating stats
      await _updateUserRatingStats(revieweeId, userType);
      
      print('Successfully deleted review and updated stats');
    } catch (e) {
      print('Error deleting review: $e');
      rethrow;
    }
  }

  // Update a review
  Future<void> updateReview(ReviewModel review) async {
    try {
      await _firestore
          .collection('reviews')
          .doc(review.id)
          .update(review.copyWith(updatedAt: DateTime.now()).toJson());
      
      // Update rating stats
      await _updateUserRatingStats(
        review.revieweeId, 
        review.reviewerType == 'poster' ? 'fixer' : 'poster'
      );
      
      print('Successfully updated review and stats');
    } catch (e) {
      print('Error updating review: $e');
      rethrow;
    }
  }
}