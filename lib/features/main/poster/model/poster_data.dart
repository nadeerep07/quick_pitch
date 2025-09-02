import 'package:quick_pitch_app/features/review/model/review_model.dart';

class PosterData {
  final List<String>? postIds;
  final String? coverImageUrl;
  final String bio;
  final RatingStats? ratingStats;

  PosterData({
    this.postIds,
    this.coverImageUrl,
    required this.bio,
    this.ratingStats,
  });

  PosterData copyWith({
    List<String>? postIds,
    String? coverImageUrl,
    String? bio,
    RatingStats? ratingStats,
  }) {
    return PosterData(
      bio: bio ?? this.bio,
      postIds: postIds ?? this.postIds,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      ratingStats: ratingStats ?? this.ratingStats,
    );
  }

  Map<String, dynamic> toJson() => {
    if (postIds != null) 'postIds': postIds,
    if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
    'bio': bio,
    if (ratingStats != null) 'ratingStats': ratingStats!.toJson(),
  };

  factory PosterData.fromJson(Map<String, dynamic> json) => PosterData(
    postIds: json['postIds'] != null
        ? List<String>.from(json['postIds'])
        : null,
    coverImageUrl: json['coverImageUrl'],
    bio: json['bio'] ?? '',
    ratingStats: json['ratingStats'] != null 
        ? RatingStats.fromJson(json['ratingStats']) 
        : null,
  );
}