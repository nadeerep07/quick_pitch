import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';

class RatingDisplayService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Cache to avoid repeated API calls for the same user
  static final Map<String, RatingStats> _cache = {};
  static final Map<String, DateTime> _cacheTimestamp = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  // Get user rating with caching
  Future<RatingStats> getUserRatingStats(String userId) async {
    try {
      // Check cache first
      if (_cache.containsKey(userId) && _cacheTimestamp.containsKey(userId)) {
        final cacheTime = _cacheTimestamp[userId]!;
        if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
          return _cache[userId]!;
        }
      }

      // Fetch from Firestore
      final reviews = await _firestore
          .collection('reviews')
          .where('revieweeId', isEqualTo: userId)
          .get();

      if (reviews.docs.isEmpty) {
        final emptyStats = RatingStats.empty();
        _cache[userId] = emptyStats;
        _cacheTimestamp[userId] = DateTime.now();
        return emptyStats;
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
      
      // Cache the result
      _cache[userId] = stats;
      _cacheTimestamp[userId] = DateTime.now();
      
      return stats;
    } catch (e) {
      print('Error getting rating stats: $e');
      return RatingStats.empty();
    }
  }

  // Clear cache for a specific user (call this after a new review is submitted)
  static void clearCacheForUser(String userId) {
    _cache.remove(userId);
    _cacheTimestamp.remove(userId);
  }

  // Clear all cache
  static void clearAllCache() {
    _cache.clear();
    _cacheTimestamp.clear();
  }
}
