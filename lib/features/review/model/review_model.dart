class ReviewModel {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final String pitchId;
  final String taskId;
  final double rating;
  final String comment;
  final String reviewerType; // 'poster' or 'fixer'
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.pitchId,
    required this.taskId,
    required this.rating,
    required this.comment,
    required this.reviewerType,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'reviewerId': reviewerId,
    'revieweeId': revieweeId,
    'pitchId': pitchId,
    'taskId': taskId,
    'rating': rating,
    'comment': comment,
    'reviewerType': reviewerType,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json['id'] ?? '',
    reviewerId: json['reviewerId'] ?? '',
    revieweeId: json['revieweeId'] ?? '',
    pitchId: json['pitchId'] ?? '',
    taskId: json['taskId'] ?? '',
    rating: (json['rating'] ?? 0.0).toDouble(),
    comment: json['comment'] ?? '',
    reviewerType: json['reviewerType'] ?? '',
    createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt']) 
        : DateTime.now(),
  );

  ReviewModel copyWith({
    String? id,
    String? reviewerId,
    String? revieweeId,
    String? pitchId,
    String? taskId,
    double? rating,
    String? comment,
    String? reviewerType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      reviewerId: reviewerId ?? this.reviewerId,
      revieweeId: revieweeId ?? this.revieweeId,
      pitchId: pitchId ?? this.pitchId,
      taskId: taskId ?? this.taskId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      reviewerType: reviewerType ?? this.reviewerType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Rating Statistics Model
class RatingStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // star -> count

  RatingStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> distributionMap = <String, dynamic>{};
    ratingDistribution.forEach((key, value) {
      distributionMap[key.toString()] = value;
    });
    
    return <String, dynamic>{
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'ratingDistribution': distributionMap,
    };
  }

  factory RatingStats.fromJson(Map<String, dynamic> json) {
    final Map<int, int> distributionMap = <int, int>{};
    final rawDistribution = json['ratingDistribution'] as Map<String, dynamic>? ?? <String, dynamic>{};
    
    rawDistribution.forEach((key, value) {
      final intKey = int.tryParse(key.toString()) ?? 0;
      final intValue = (value is int) ? value : (int.tryParse(value.toString()) ?? 0);
      if (intKey > 0) {
        distributionMap[intKey] = intValue;
      }
    });
    
    return RatingStats(
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      ratingDistribution: distributionMap,
    );
  }

  static RatingStats empty() => RatingStats(
    averageRating: 0.0,
    totalReviews: 0,
    ratingDistribution: <int, int>{},
  );
}

// Helper class for additional safety (optional)
class RatingStatsHelper {
  static Map<String, dynamic> convertDistributionForFirestore(Map<int, int> distribution) {
    final Map<String, dynamic> result = <String, dynamic>{};
    distribution.forEach((key, value) {
      result[key.toString()] = value;
    });
    return result;
  }
  
  static Map<int, int> convertDistributionFromFirestore(Map<String, dynamic>? data) {
    if (data == null) return <int, int>{};
    
    final Map<int, int> result = <int, int>{};
    data.forEach((key, value) {
      final intKey = int.tryParse(key.toString()) ?? 0;
      final intValue = (value is int) ? value : (int.tryParse(value.toString()) ?? 0);
      if (intKey > 0) {
        result[intKey] = intValue;
      }
    });
    return result;
  }
}